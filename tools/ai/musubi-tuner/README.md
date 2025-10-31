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

#### Wan 2.1/2.2 Training Workflow

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

For Wan 2.2:
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
