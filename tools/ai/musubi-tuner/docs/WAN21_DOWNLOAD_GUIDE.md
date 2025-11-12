# WAN 2.1 1.3B Model Download Guide

## Quick Summary

To switch from WAN 2.2 14B to WAN 2.1 1.3B for ~10x faster training, you need to download the WAN 2.1 1.3B DiT model. You likely already have T5 and VAE (they're shared with WAN 2.2).

## What You Need

### Required Downloads

1. **WAN 2.1 1.3B DiT Model** (NEW - you need this)
   - **For I2V**: `wan2.1_i2v_1.3B_*.safetensors`
   - **For T2V**: `wan2.1_t2v_1.3B_*.safetensors`
   - **Download from**: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/diffusion_models
   - **Size**: ~2-3GB (much smaller than 14B!)

2. **CLIP Model** (Only if doing I2V - NEW - you need this)
   - **File**: `models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth`
   - **Download from**: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main
   - **Size**: ~1.5GB
   - **Note**: WAN 2.2 doesn't need CLIP, but WAN 2.1 I2V does

### Already Have (from WAN 2.2)

3. **T5 Model** (You already have this)
   - Same as WAN 2.2 uses
   - File: `models_t5_umt5-xxl-enc-bf16.pth`
   - No need to re-download

4. **VAE Model** (You already have this)
   - Same as WAN 2.2 uses
   - File: `Wan2.1_VAE.pth` or `wan_2.1_vae.safetensors`
   - No need to re-download

## Download Steps

### Step 1: Download DiT 1.3B Model

1. Go to: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/diffusion_models
2. Look for files matching:
   - **For I2V**: `wan2.1_i2v_1.3B_*.safetensors` (or `.pth` if safetensors not available)
   - **For T2V**: `wan2.1_t2v_1.3B_*.safetensors`
3. Download the file (prefer `fp16` or `bf16` format)
4. Place it in: `E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\`

### Step 2: Download CLIP Model (I2V only)

**Only needed if training I2V (image-to-video)**

1. Go to: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main
2. Download: `models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth`
3. Place it in: `E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\clip\` or `models\text_encoders\`

### Step 3: Verify You Have T5 and VAE

Run this to check:
```powershell
# Check T5
Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models" -Recurse -Filter "*t5*.pth" | Where-Object { $_.Name -match "umt5|t5" -and $_.Length -gt 100MB }

# Check VAE  
Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models" -Recurse -Filter "*wan*vae*" | Select-Object Name, FullName
```

If found, you're good! If not, download:
- **T5**: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main (file: `models_t5_umt5-xxl-enc-bf16.pth`)
- **VAE**: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/vae

## After Download

Once you have all models, run the switch script:

```powershell
cd "E:\Soso\Projects\electric-sheep"
.\tools\ai\musubi-tuner\scripts\switch-to-wan21-1.3b.ps1 `
    -TaskType "i2v" `
    -DatasetConfig "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\angelina-wan22.toml"
```

The script will:
1. Verify all models are found
2. Check/run caching (if needed)
3. Start training with WAN 2.1 1.3B

## Expected Results

**Training Speed:**
- **WAN 2.2 14B**: 5-6 minutes per step
- **WAN 2.1 1.3B**: 30-60 seconds per step (~10x faster!)

**Total Training Time (126 images, 10 epochs):**
- **WAN 2.2 14B**: ~5 days
- **WAN 2.1 1.3B**: ~12-15 hours

**Quality:**
- WAN 2.1 1.3B produces good quality LoRA models
- Slightly lower than 14B, but much faster for experimentation
- Often sufficient for most use cases

## Troubleshooting

**"Model not found" errors:**
- Check file names match exactly (case-sensitive)
- Verify files are in the search paths (ComfyUI models directory)
- Run the switch script again after downloading

**"CLIP model required" error:**
- This only happens for I2V training
- Download CLIP model from the link above
- Place in ComfyUI models directory

**Existing cache issues:**
- WAN 2.1 may need different cache than WAN 2.2
- The script will re-cache if needed
- Cache directory is typically: `{dataset_path}/cache`

## Model File Patterns

**WAN 2.1 1.3B DiT models:**
- `wan2.1_i2v_1.3B_fp16.safetensors`
- `wan2.1_t2v_1.3B_bf16.safetensors`
- `wan2.1_i2v_1_3B_fp16.safetensors` (alternative naming)

**WAN 2.1 14B DiT models** (slower, not recommended):
- `wan2.1_i2v_14B_fp16.safetensors`
- `wan2.1_t2v_14B_bf16.safetensors`

Make sure you download the **1.3B** version, not 14B!

