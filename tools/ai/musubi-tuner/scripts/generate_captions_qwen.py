#!/usr/bin/env python3
"""
Generate detailed captions for images using Qwen2.5-VL model via transformers library.
This script works with the HuggingFace cache format.
"""

import argparse
import sys
from pathlib import Path
from PIL import Image
import torch
try:
    from transformers import Qwen2_5_VLForConditionalGeneration, AutoProcessor
except ImportError:
    # Fallback for older transformers versions
    from transformers import AutoModelForCausalLM, AutoProcessor
    Qwen2_5_VLForConditionalGeneration = None
from tqdm import tqdm

def generate_caption(image_path: str, model, processor, device, trigger_word: str = "example_celebrity"):
    """Generate a caption for a single image."""
    try:
        # Load and process image
        image = Image.open(image_path).convert("RGB")
        
        # Prepare messages
        messages = [
            {
                "role": "user",
                "content": [
                    {"type": "image", "image": image},
                    {
                        "type": "text",
                        "text": """# Image Annotator
You are a professional image annotator. Please complete the following task based on the input image.
## Create Image Caption
1. Write the caption using natural, descriptive text without structured formats or rich text.
2. Enrich caption details by including: object attributes, vision relations between objects, and environmental details.
3. Identify the text visible in the image, without translation or explanation, and highlight it in the caption with quotation marks.
4. Maintain authenticity and accuracy, avoid generalizations."""
                    },
                ],
            }
        ]
        
        # Prepare inputs - use the same approach as the working caption script
        text = processor.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
        # Process images directly without process_vision_info (for compatibility)
        inputs = processor(
            text=[text],
            images=[image],
            padding=True,
            return_tensors="pt"
        ).to(device)
        
        # Generate caption
        with torch.no_grad():
            generated_ids = model.generate(
                **inputs,
                max_new_tokens=256,
                pad_token_id=processor.tokenizer.eos_token_id
            )
        
        generated_ids_trimmed = [out_ids[len(in_ids):] for in_ids, out_ids in zip(inputs.input_ids, generated_ids)]
        caption = processor.batch_decode(generated_ids_trimmed, skip_special_tokens=True, clean_up_tokenization_spaces=False)
        
        # Clean up caption
        caption_text = caption[0] if caption else ""
        caption_text = caption_text.strip()
        
        # Ensure trigger word is present
        if trigger_word.lower() not in caption_text.lower():
            caption_text = f"{trigger_word}, {caption_text}".strip()
        
        return caption_text
        
    except Exception as e:
        print(f"Error processing {image_path}: {e}", file=sys.stderr)
        return trigger_word


def main():
    parser = argparse.ArgumentParser(description="Generate captions for images using Qwen2.5-VL")
    parser.add_argument("--image_dir", type=str, required=True, help="Directory containing images")
    parser.add_argument("--model_name", type=str, default="Qwen/Qwen2.5-VL-7B-Instruct", help="Model name or path")
    parser.add_argument("--trigger_word", type=str, default="example_celebrity", help="Trigger word to include in captions")
    parser.add_argument("--max_new_tokens", type=int, default=256, help="Maximum tokens to generate")
    
    args = parser.parse_args()
    
    # Find images first
    image_dir = Path(args.image_dir)
    image_extensions = {'.jpg', '.jpeg', '.png', '.webp', '.avif'}
    image_files = [f for f in image_dir.iterdir() if f.suffix.lower() in image_extensions]
    
    print(f"Found {len(image_files)} images", file=sys.stderr)
    
    if len(image_files) == 0:
        print("Error: No images found in directory", file=sys.stderr)
        sys.exit(1)
    
    # Set device
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}", file=sys.stderr)
    
    # Load model and processor
    print(f"Loading model: {args.model_name}")
    print("This may take a few minutes (downloading ~14GB if not cached)...", flush=True)
    sys.stdout.flush()
    try:
        print("Loading processor...", flush=True)
        processor = AutoProcessor.from_pretrained(args.model_name)
        print("[OK] Processor loaded. Loading model weights (~14GB)...", flush=True)
        print("This can take 5-10 minutes on first run...", flush=True)
        sys.stdout.flush()
        
        # Use trust_remote_code for Qwen models
        if Qwen2_5_VLForConditionalGeneration is not None:
            model = Qwen2_5_VLForConditionalGeneration.from_pretrained(
                args.model_name,
                torch_dtype=torch.bfloat16 if device.type == "cuda" else torch.float32,
                device_map="auto" if device.type == "cuda" else None,
                trust_remote_code=True
            )
        else:
            # Fallback for older transformers versions
            model = AutoModelForCausalLM.from_pretrained(
                args.model_name,
                torch_dtype=torch.bfloat16 if device.type == "cuda" else torch.float32,
                device_map="auto" if device.type == "cuda" else None,
                trust_remote_code=True
            )
        if device.type == "cpu":
            model = model.to(device)
        model.eval()
        print("[OK] Model loaded successfully!")
        print(f"Starting to process {len(image_files)} images...\n", flush=True)
        sys.stdout.flush()
    except Exception as e:
        print(f"Error loading model: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Process each image with progress bar
    print(f"\nProcessing {len(image_files)} images...\n")
    with tqdm(total=len(image_files), desc="Generating captions", unit="image") as pbar:
        for i, image_path in enumerate(image_files, 1):
            pbar.set_description(f"Processing {image_path.name[:40]}...")
            
            caption = generate_caption(str(image_path), model, processor, device, args.trigger_word)
            
            # Save caption
            caption_file = image_path.with_suffix('.txt')
            with open(caption_file, 'w', encoding='utf-8') as f:
                f.write(caption)
            
            pbar.set_postfix({"last": caption[:50].replace('\n', ' ')})
            pbar.update(1)
    
    
    print(f"\n{'='*60}")
    print("[OK] Caption generation completed!")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()

