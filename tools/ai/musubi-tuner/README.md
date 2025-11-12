# Musubi Tuner - LoRA Training Toolkit

Musubi Tuner CLI toolkit for training LoRA models with Wan 2.1/2.2, HunyuanVideo, FramePack, FLUX.1 Kontext, and Qwen-Image architectures.

## Installation Location

**Installed at:** `C:/path/to/musubi-tuner`

- Virtual environment: `C:/path/to/musubi-tuner/venv`
- Python scripts: `C:/path/to/musubi-tuner/wan_*.py` (root level)
- Source modules: `C:/path/to/musubi-tuner/src/musubi_tuner/`

## Quick Start - Using from Cursor Environment

### 1. Activate Environment

From the workspace root, activate the virtual environment:

```powershell
# Activate the virtual environment
& "C:/path/to/musubi-tuner/venv/Scripts/Activate.ps1"
```

Or use the wrapper script:
```powershell
.\tools\ai\musubi-tuner\activate.ps1
```

### 2. Common Workflows

#### Creating Training Datasets with Captions

Before training, you need to prepare your dataset with captions. Captions are text files (`.txt`) that describe each image and include a trigger word.

**Process Overview:**

1. **Copy images** from source to training dataset directory
2. **Generate captions** using Qwen2.5-VL vision-language model
3. **Ensure trigger word** is included in all captions

**Quick Command Pattern:**

When you say "prepare dataset for `<path>`", the AI will automatically:
1. Extract dataset name from the path (last folder name)
2. Copy images recursively from source (including all subfolders)
3. Set target to `E:\Stable Diffusion\TrainingDataSet\<dataset_name>`
4. Extract trigger word from dataset name (lowercase)
5. Generate captions with Qwen2.5-VL

**Example:**
- User: "prepare dataset for E:\Stable Diffusion\Inputs\df\lib\female\dani"
- AI executes: Copies from `E:\Stable Diffusion\Inputs\df\lib\female\dani` (recursively) to `E:\Stable Diffusion\TrainingDataSet\dani`
- Trigger word: `dani`
- Captions: Generated automatically with "dani" included

**Manual Usage:**

For recursive search (including subfolders) - **Recommended**:
```powershell
.\tools\ai\musubi-tuner\scripts\prepare-dani-dataset.ps1 `
    -SourceImageDir "E:\Stable Diffusion\Inputs\df\lib\female\dani" `
    -TargetDir "E:\Stable Diffusion\TrainingDataSet\dani" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "dani" `
    -Fp8Vl  # Optional: use fp8 for lower VRAM
```

For flat directory only (no subfolders):
```powershell
.\tools\ai\musubi-tuner\scripts\prepare-angelina-dataset-new.ps1 `
    -SourceImageDir "C:\path\to\source\images" `
    -TargetDir "C:\path\to\TrainingDataSet\dataset_name" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "trigger_word" `
    -Fp8Vl  # Optional: use fp8 for lower VRAM
```

Both scripts will:
- Copy images from source to target directory (recursive for `prepare-dani-dataset.ps1`)
- Generate detailed captions using Qwen2.5-VL for each image
- Ensure the trigger word is prepended to all captions
- Create `.txt` caption files alongside each image

**Default Values:**
- Target directory: `E:\Stable Diffusion\TrainingDataSet\<dataset_name>` (extracted from source path)
- Trigger word: Extracted from dataset name (lowercase)
- Qwen model: `Qwen/Qwen2.5-VL-7B-Instruct` (HuggingFace model ID)

**Caption Format:**
- Each image should have a corresponding `.txt` file with the same name
- Captions should start with the trigger word: `"trigger_word, [description]"`
- Example: `"angelina, a portrait with a serene expression"`

**Trigger Words:**
A trigger word is a special keyword you include in captions during training. When you use this word in prompts during inference, it activates the LoRA's learned features. Every caption should start with your trigger word.

**Alternative: Manual Caption Generation**

If you prefer to generate captions manually or use existing captions:

```powershell
# Skip copying (images already in place)
.\tools\ai\musubi-tuner\scripts\prepare-angelina-dataset-new.ps1 `
    -SourceImageDir "C:\path\to\TrainingDataSet\dataset_name" `
    -TargetDir "C:\path\to\TrainingDataSet\dataset_name" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "trigger_word" `
    -SkipCopy

# Skip captioning (use existing captions, only add trigger word)
.\tools\ai\musubi-tuner\scripts\prepare-angelina-dataset-new.ps1 `
    -SourceImageDir "C:\path\to\TrainingDataSet\dataset_name" `
    -TargetDir "C:\path\to\TrainingDataSet\dataset_name" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "trigger_word" `
    -SkipCopy `
    -SkipCaptioning
```

**Dataset Configuration:**

After preparing your dataset, create a TOML configuration file:

```powershell
# Copy the example template
Copy-Item tools\ai\musubi-tuner\datasets\dataset-wan22.example.toml C:\path\to\your\dataset-config.toml

# Edit the file with your actual paths:
# - image_directory: Path to your prepared dataset folder
# - cache_directory: Path for cached latents (usually dataset_folder/cache)
```

Example TOML structure:
```toml
[general]
resolution = [960, 544]
caption_extension = ".txt"
batch_size = 1
enable_bucket = true

[[datasets]]
image_directory = "C:/path/to/TrainingDataSet/dataset_name"
cache_directory = "C:/path/to/TrainingDataSet/dataset_name/cache"
```

For detailed workflow examples, see:
- `tools/ai/musubi-tuner/TRAINING_QUICK_START.md` - **Quick reference for AI agents** - Auto-discover models, checkpoints, and train
- `tools/ai/musubi-tuner/docs/ANGELINA_TRAINING_GUIDE.md` - Complete training workflow with examples
- `tools/ai/musubi-tuner/datasets/dataset-wan22.example.toml` - Example dataset configuration template
- `tools/ai/musubi-tuner/datasets/angelina-jolie-wan22.example.toml` - Another example configuration

#### Wan 2.1/2.2 Training Workflow

**Step 0: Finding WAN Models**

Before training, you need to locate your WAN model files. Models are typically stored in:

1. **ComfyUI installation** (most common):
   - `E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\`
   - Look for files matching: `wan2.2_*_low_noise_*.safetensors` or `wan2.2_*_high_noise_*.safetensors`

2. **Check `.local/config.json`**:
   - Model paths may be configured in `models.wan` section
   - Check entries like `dit_2_2_i2v_low`, `dit_2_2_t2v_low`, etc.

3. **Determine model type**:
   - **I2V models**: Filename contains `i2v` → Use task `i2v-A14B`
   - **T2V models**: Filename contains `t2v` → Use task `t2v-A14B`
   - **Model dtype**: Check filename for `fp16` or `bf16` → Use matching mixed precision

**Example discovery:**
```powershell
# Search for WAN 2.2 models in ComfyUI directory
Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models" -Filter "*wan2.2*"

# Check config.json for model paths
Get-Content .local\config.json | ConvertFrom-Json | Select-Object -ExpandProperty models | Select-Object -ExpandProperty wan
```

**Step 1: Prepare Dataset Configuration (TOML)**

Create a dataset TOML file (e.g., `dataset.toml`):

```toml
[general]
resolution = [960, 544]
caption_extension = ".txt"
batch_size = 1
enable_bucket = true

[[datasets]]
image_directory = "C:/path/to/images"
cache_directory = "C:/path/to/cache"
num_repeats = 1
```

**Step 2: Cache Latents**

For Wan 2.1 T2V:
```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_cache_latents.py `
    --dataset_config C:/path/to/dataset.toml `
    --vae C:/path/to/wan_2.1_vae.safetensors `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth `
    --clip C:/path/to/models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth
```

For Wan 2.2 (no CLIP needed):
```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_cache_latents.py `
    --dataset_config C:/path/to/dataset.toml `
    --vae C:/path/to/wan_2.1_vae.safetensors `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth
```

**Step 3: Cache Text Encoder Outputs**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_cache_text_encoder_outputs.py `
    --dataset_config C:/path/to/dataset.toml `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth `
    --batch_size 16
```

**Step 4: Configure Accelerate**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\accelerate.exe config
```

Answer the prompts:
- Compute environment: `This machine`
- Machine type: `No distributed training`
- CPU only: `NO`
- torch dynamo: `NO`
- DeepSpeed: `NO`
- GPU(s): `all` (or `0` for single GPU)
- NUMA efficiency: `NO`
- Mixed precision: `bf16`

**Step 5: Train LoRA**

**Important: Check for Existing Checkpoints Before Training**

Before starting new training, check if there are existing checkpoints to resume from:

```powershell
# Check for existing checkpoints in output directory
$OutputDir = "E:/path/to/output"
Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# If checkpoints exist, resume training instead of starting fresh
```

**Resuming Training:**

If checkpoints are found, use the `-Resume` parameter:

```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "i2v-A14B" `
    -DitPath "E:/path/to/model.safetensors" `
    -DatasetConfig "E:/path/to/dataset.toml" `
    -OutputDir "E:/path/to/output" `
    -OutputName "my-lora" `
    -Resume "E:/path/to/output/my-lora-epoch-5" `
    # ... (all other parameters same as original training)
```

**Starting Fresh Training:**

For Wan 2.1 T2V:
```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\accelerate.exe launch --num_cpu_threads_per_process 1 --mixed_precision bf16 `
    wan_train_network.py `
    --task t2v-14B `
    --dit C:/path/to/wan2.1_t2v_14B_bf16.safetensors `
    --dataset_config C:/path/to/dataset.toml `
    --sdpa --mixed_precision bf16 --fp8_base `
    --optimizer_type adamw8bit --learning_rate 2e-4 --gradient_checkpointing `
    --max_data_loader_n_workers 2 --persistent_data_loader_workers `
    --network_module networks.lora_wan --network_dim 32 `
    --timestep_sampling shift --discrete_flow_shift 3.0 `
    --max_train_epochs 16 --save_every_n_epochs 1 --seed 42 `
    --output_dir C:/path/to/output --output_name my-lora
```

For Wan 2.2 (Low Noise I2V Training):

**IMPORTANT: Always use proper quoting when paths contain spaces!**

```powershell
cd "E:\Soso\Projects\electric-sheep"
& ".\tools\ai\musubi-tuner\scripts\wan-train.ps1" `
    -Task "i2v-A14B" `
    -DitPath "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\wan2.2_i2v_low_noise_14B_fp16.safetensors" `
    -DatasetConfig "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\angelina-wan22.toml" `
    -OutputDir "E:\Stable Diffusion\TrainingDataSet\Angeline Jolie\output" `
    -OutputName "angeline_jolie_wan22_low" `
    -MixedPrecision "fp16" `
    -MinTimestep 0 `
    -MaxTimestep 900 `
    -PreserveDistributionShape
```

**Key Parameters for WAN 2.2:**
- **I2V Low Noise**: `-MinTimestep 0 -MaxTimestep 900`
- **I2V High Noise**: `-MinTimestep 900 -MaxTimestep 1000`
- **T2V Low Noise**: `-MinTimestep 0 -MaxTimestep 875`
- **T2V High Noise**: `-MinTimestep 875 -MaxTimestep 1000`

For Wan 2.2 (using wrapper script):
```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\accelerate.exe launch --num_cpu_threads_per_process 1 --mixed_precision bf16 `
    wan_train_network.py `
    --task t2v-A14B `
    --dit C:/path/to/wan2.2_t2v_low_noise_fp16.safetensors `
    --dit_high_noise C:/path/to/wan2.2_t2v_high_noise_fp16.safetensors `
    --dataset_config C:/path/to/dataset.toml `
    --sdpa --mixed_precision bf16 --fp8_base `
    --optimizer_type adamw8bit --learning_rate 2e-4 --gradient_checkpointing `
    --max_data_loader_n_workers 2 --persistent_data_loader_workers `
    --network_module networks.lora_wan --network_dim 32 `
    --timestep_sampling shift --discrete_flow_shift 12.0 `
    --max_train_epochs 16 --save_every_n_epochs 1 --seed 42 `
    --output_dir C:/path/to/output --output_name my-lora
```

#### Inference Workflow

**T2V Inference:**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_generate_video.py `
    --fp8 --task t2v-14B `
    --video_size 832 480 --video_length 81 --infer_steps 20 `
    --prompt "A beautiful sunset over mountains" `
    --save_path C:/path/to/output.mp4 --output_type both `
    --dit C:/path/to/wan2.1_t2v_14B_bf16.safetensors `
    --vae C:/path/to/wan_2.1_vae.safetensors `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth `
    --attn_mode torch
```

**I2V Inference (Wan 2.1):**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_generate_video.py `
    --fp8 --task i2v-14B `
    --video_size 832 480 --video_length 81 --infer_steps 20 `
    --prompt "A beautiful sunset over mountains" `
    --save_path C:/path/to/output.mp4 --output_type both `
    --dit C:/path/to/wan2.1_i2v_480p_14B_bf16.safetensors `
    --vae C:/path/to/wan_2.1_vae.safetensors `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth `
    --clip C:/path/to/models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth `
    --attn_mode torch `
    --image_path C:/path/to/start_image.jpg
```

**I2V Inference (Wan 2.2 - no CLIP):**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_generate_video.py `
    --fp8 --task i2v-A14B `
    --video_size 832 480 --video_length 81 --infer_steps 20 `
    --prompt "A beautiful sunset over mountains" `
    --save_path C:/path/to/output.mp4 --output_type both `
    --dit C:/path/to/wan2.2_i2v_low_noise_fp16.safetensors `
    --dit_high_noise C:/path/to/wan2.2_i2v_high_noise_fp16.safetensors `
    --vae C:/path/to/wan_2.1_vae.safetensors `
    --t5 C:/path/to/models_t5_umt5-xxl-enc-bf16.pth `
    --attn_mode torch `
    --image_path C:/path/to/start_image.jpg
```

**Batch Mode from File:**

Create `prompts.txt`:
```
A beautiful sunset over mountains --w 832 --h 480 --f 81 --d 42 --s 20
A busy city street at night --w 480 --h 832 --g 7.5 --n low quality, blurry
```

Then run:
```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_generate_video.py `
    --from_file C:/path/to/prompts.txt `
    --task t2v-14B `
    --dit C:/path/to/model.safetensors `
    --vae C:/path/to/vae.safetensors `
    --t5 C:/path/to/t5_model.pth `
    --save_path C:/path/to/output_directory
```

**Interactive Mode:**

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_generate_video.py `
    --interactive --task t2v-14B `
    --dit C:/path/to/model.safetensors `
    --vae C:/path/to/vae.safetensors `
    --t5 C:/path/to/t5_model.pth `
    --save_path C:/path/to/output_directory
```

## Helper Scripts

See `scripts/` directory for PowerShell wrapper scripts that can be called from the workspace root.

## Memory Optimization for RTX 3090 (24GB VRAM)

For training with limited VRAM:

```powershell
# Add these flags to training command:
--fp8_base                    # Use FP8 precision
--blocks_to_swap 20           # Swap blocks to CPU (adjust based on VRAM)
--vae_cache_cpu               # Cache VAE in CPU memory
--gradient_checkpointing      # Enable gradient checkpointing
--gradient_checkpointing_cpu_offload  # Offload gradients to CPU
```

For inference:
```powershell
--fp8                         # Use FP8 for inference
--blocks_to_swap 20           # Swap blocks during inference
--vae_cache_cpu               # Cache VAE in CPU memory
```

## Available Scripts

All scripts are located in your Musubi Tuner installation directory (configured via `.local/config.json`):

### Wan 2.1/2.2 Scripts:
- `wan_cache_latents.py` - Cache VAE latents
- `wan_cache_text_encoder_outputs.py` - Cache text encoder outputs
- `wan_train_network.py` - Train LoRA models
- `wan_generate_video.py` - Generate videos

### Other Architectures:
- `hv_train_network.py` - HunyuanVideo training
- `hv_generate_video.py` - HunyuanVideo inference
- `fpack_train_network.py` - FramePack training
- `fpack_generate_video.py` - FramePack inference
- `flux_kontext_train_network.py` - FLUX.1 Kontext training
- `qwen_image_train_network.py` - Qwen-Image training

### Utility Scripts:
- `merge_lora.py` - Merge LoRA weights
- `convert_lora.py` - Convert LoRA formats
- `lora_post_hoc_ema.py` - Apply EMA to LoRA

## Documentation

Full documentation available at:
- **Main README**: Configured via `.local/config.json`
- **Wan Documentation**: Configured via `.local/config.json`
- **Dataset Config**: Configured via `.local/config.json`
- **Advanced Config**: Configured via `.local/config.json`

## Model Download Locations

### Wan 2.1 Models:
- **T5 & CLIP**: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main
- **VAE**: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/vae
- **DiT Weights**: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/diffusion_models

### Wan 2.2 Models:
- **T5**: Same as Wan 2.1 (CLIP not needed)
- **VAE**: Same as Wan 2.1 (use `Wan2.1_VAE.pth`)
- **DiT Weights**: https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/tree/main/split_files/diffusion_models
  - Download both low-noise and high-noise models

## System Requirements

- **GPU**: RTX 3090 (24GB VRAM) - verified compatible
- **Python**: 3.10+ (3.12.4 installed)
- **PyTorch**: 2.5.1+ (2.6.0+cu124 installed)
- **CUDA**: 12.4
- **RAM**: 64GB+ recommended (32GB + swap may work)

## Troubleshooting

### Common Issues

**1. Parameter Binding Error with Spaces in Paths**

**Problem**: PowerShell throws `ParameterBindingArgumentTransformationException` when paths contain spaces (e.g., "ComfyUi Portable").

**Error Example**:
```
Cannot convert value "Portable\ComfyUI\models\..." to type "System.Int32"
```

**Solution**: Always use the `&` call operator with quoted script path:
```powershell
# CORRECT
cd "E:\Soso\Projects\electric-sheep"
& ".\tools\ai\musubi-tuner\scripts\wan-train.ps1" -DitPath "E:\Path With Spaces\model.safetensors"

# INCORRECT (will fail with spaces)
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 -DitPath "E:\Path With Spaces\model.safetensors"
```

**2. Dataset Config Path Mismatch**

**Problem**: Dataset TOML file has incorrect directory name (e.g., "Angelina" vs "Angeline").

**Solution**: Verify paths in TOML match actual directory names exactly:
```powershell
# Check dataset config
Get-Content "tools\ai\musubi-tuner\datasets\angelina-wan22.toml" | Select-String "image_directory"

# Verify directory exists
Test-Path "E:\Stable Diffusion\TrainingDataSet\Angeline Jolie"
```

**3. No Checkpoints Found**

**Problem**: Training appears to start but no checkpoints are created.

**Solution**: 
- Check if training is actually running: `Get-Process python | Where-Object { $_.WorkingSet -gt 100MB }`
- Verify output directory exists and is writable
- Check logs in output directory for errors
- Ensure GPU has sufficient VRAM (18GB+ for WAN 2.2)
- Use `-SaveEveryNSteps 100` to save checkpoints during training (not just at epoch end)

**4. Training Too Slow**

**Problem**: Training takes too long (e.g., 4+ minutes per step, 100+ hours total).

**Solution**:
- **Increase data loader workers**: Use `-DataLoaderWorkers 8` (or higher if CPU allows)
  - Default is 2, which can bottleneck training with small datasets
  - For strong CPUs, 8-16 workers significantly speeds up data loading
- **Reduce epochs for small datasets**: Use `-MaxTrainEpochs 10` instead of 16 for datasets <50 images
- **Check GPU utilization**: Should be 80-100% during training. Spiky/low utilization indicates data loading bottleneck
- **Verify caching completed**: Ensure latents and text encoder outputs are cached before training

**5. Model Not Found**

**Problem**: Script can't find WAN 2.2 model files.

**Solution**:
```powershell
# Search for models
Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models" -Filter "*wan2.2*"

# Check config.json
Get-Content ".local\config.json" | ConvertFrom-Json | Select-Object -ExpandProperty models | Select-Object -ExpandProperty wan
```

**6. Task/Precision Mismatch**

**Problem**: Wrong task type or mixed precision specified.

**Solution**: Verify from model filename:
- `*i2v*` → Use task `i2v-A14B`
- `*t2v*` → Use task `t2v-A14B`
- `*fp16*` → Use `-MixedPrecision "fp16"`
- `*bf16*` → Use `-MixedPrecision "bf16"`

## Getting Help

Run any script with `--help` for detailed options:

```powershell
cd "C:/path/to/musubi-tuner"
.\venv\Scripts\python.exe wan_train_network.py --help
```

## Notes

- All paths should use forward slashes `/` or escaped backslashes `` ` `` in PowerShell
- When running from Cursor, ensure you're in the correct directory or use full paths
- The virtual environment must be activated before running scripts
- For RTX 3090, use `--fp8_base` and `--blocks_to_swap` to manage VRAM usage
