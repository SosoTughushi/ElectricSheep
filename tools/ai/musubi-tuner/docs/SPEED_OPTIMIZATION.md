# WAN Training Speed Optimization Guide

## Problem: Training 14B Models is Too Slow

If you're experiencing very slow training times (5-6 minutes per step) with WAN 2.2 14B models on RTX 3090, this guide provides alternatives and optimizations.

## Current Situation

**With WAN 2.2 14B models:**
- **Expected speed**: 5-6 minutes per step is **normal** for 14B models with batch_size=1
- **With 126 images, 10 epochs**: ~5 days total training time
- **Fundamental limit**: Cannot increase batch size (hardcoded to 1 in DataLoader)

## Solutions

### Option 1: Switch to WAN 2.1 1.3B Model (RECOMMENDED)

**Speed improvement**: ~10x faster (30-60 seconds per step vs 5-6 minutes)

**Requirements:**
- WAN 2.1 model files (download from HuggingFace)
- Compatible with same dataset and workflow
- Quality: Still produces good LoRA models, though slightly lower than 14B

**Model Downloads:**
- DiT weights: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/diffusion_models
- Look for files matching: `wan2.1_*_1.3B_*.safetensors`
- VAE: Same as WAN 2.1 (or WAN 2.2 uses same VAE)
- T5: Same as WAN 2.2
- CLIP: Required for I2V models

**Training Command:**
```powershell
# For T2V (text-to-video)
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-1.3B" `
    -DitPath "E:\path\to\wan2.1_t2v_1.3B_fp16.safetensors" `
    -DatasetConfig "path\to\dataset.toml" `
    -OutputDir "path\to\output" `
    -OutputName "my-lora-1.3B" `
    -MixedPrecision "fp16" `
    -MaxTrainEpochs 10 `
    -DataLoaderWorkers 8 `
    -Fp8Base

# For I2V (image-to-video) - still uses 1.3B DiT
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "i2v-14B" `
    -DitPath "E:\path\to\wan2.1_i2v_1.3B_fp16.safetensors" `
    -DatasetConfig "path\to\dataset.toml" `
    -OutputDir "path\to\output" `
    -OutputName "my-lora-1.3B" `
    -MixedPrecision "fp16" `
    -MaxTrainEpochs 10 `
    -DataLoaderWorkers 8 `
    -Fp8Base `
    -ClipPath "E:\path\to\models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth"
```

**Task Names for WAN 2.1:**
- `t2v-1.3B` - Text-to-video, 1.3B parameters
- `i2v-14B` - Image-to-video (uses 1.3B DiT, note: task name is misleading)
- `t2v-14B` - Text-to-video, 14B parameters (slower)
- `i2v-14B` - Image-to-video, 14B parameters (slower)

**Expected Training Time:**
- With 126 images, 10 epochs: ~12-15 hours (vs 5 days for 14B)
- Per step: 30-60 seconds (vs 5-6 minutes for 14B)

### Option 2: Optimize Current 14B Training

**A. Reduce Epochs:**
```powershell
-MaxTrainEpochs 6  # Cuts total time to ~3 days
```

**B. Lower Network Dimension (LoRA rank):**
```powershell
-NetworkDim 16  # Default is 32, lower = faster but less capacity
```

**C. Use FP8 Base (if using fp16/bf16 models):**
```powershell
-Fp8Base  # Reduces memory and may speed up slightly
```

**D. Ensure DataLoader Workers:**
```powershell
-DataLoaderWorkers 8  # Already set, but verify
```

**Combined Example:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "i2v-A14B" `
    -DitPath "path\to\wan2.2_i2v_low_noise_14B_fp16.safetensors" `
    -DatasetConfig "path\to\dataset.toml" `
    -OutputDir "path\to\output" `
    -OutputName "my-lora" `
    -MaxTrainEpochs 6 `
    -NetworkDim 16 `
    -DataLoaderWorkers 8 `
    -Fp8Base `
    -MixedPrecision "fp16"
```

**Expected Improvement:**
- Time per step: Still 5-6 minutes (fundamental limit)
- Total time: ~3 days (vs 5 days) with 6 epochs

### Option 3: Continue as-is

If you need the best quality and can wait:
- Continue with 10 epochs (~5 days)
- Accept 5-6 minutes per step as expected behavior
- Monitor GPU utilization (should be 90-100%)

## Why 5B Model Isn't Available

**Note**: WAN 2.2 5B model (`ti2v-5B`) exists but is **NOT supported for training** in musubi-tuner:
- It's listed in `SUPPORTED_SIZES` but not in `WAN_CONFIGS`
- The training script only accepts tasks from `WAN_CONFIGS.keys()`
- Currently only available for inference, not training

## Model Comparison

| Model | Parameters | Speed (per step) | Quality | Best For |
|-------|-----------|------------------|---------|----------|
| WAN 2.1 1.3B | 1.3B | 30-60 sec | Good | Fast training, experiments |
| WAN 2.2 14B | 14B | 5-6 min | Excellent | Best quality, patience required |
| WAN 2.2 5B | 5B | N/A (inference only) | Good | Not available for training |

## Recommendations

**For your situation (126 images, RTX 3090):**

1. **Best choice**: Switch to WAN 2.1 1.3B
   - ~10x faster training
   - Good quality results
   - Manageable time (~12-15 hours)

2. **Second choice**: Continue with 14B, reduce to 6 epochs
   - ~3 days total
   - Best quality (14B model)
   - Still slow but acceptable

3. **Last resort**: Continue with 10 epochs
   - ~5 days total
   - Maximum quality
   - Requires patience

## Quick Switch Guide

If you want to switch to 1.3B model:

1. **Download WAN 2.1 1.3B model:**
   ```powershell
   # Check if you already have it:
   Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models" -Filter "*wan2.1*1.3B*"
   ```

2. **Determine task type:**
   - I2V: Use `i2v-14B` task (despite name, uses 1.3B DiT)
   - T2V: Use `t2v-1.3B` task

3. **Use same dataset config** (no changes needed)

4. **Update training command** with new task and model path

5. **Note**: For I2V, you'll need CLIP model (WAN 2.1 requirement):
   - Download from: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main
   - File: `models_clip_open-clip-xlm-roberta-large-vit-huge-14.pth`
   - Add `-ClipPath` parameter to training command

