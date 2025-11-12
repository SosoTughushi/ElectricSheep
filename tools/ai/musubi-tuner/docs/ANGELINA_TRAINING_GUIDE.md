# WAN 2.2 Angelina Jolie Training Workflow

This guide walks through preparing and training high/low LoRA models for WAN 2.2 using the available CLI tools.

## Prerequisites

1. **Configure local config**: Ensure `.local/config.json` has paths set up:
   - `paths.musubi_tuner.installation_path`
   - `paths.musubi_tuner.python_exe`
   - `models.wan` paths (VAE, T5, DiT models)

2. **Locate WAN Models**: Find your WAN 2.2 model files:
   ```powershell
   # Common locations:
   # - ComfyUI: E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\
   # - Check .local/config.json models.wan section
   
   # Search for models:
   Get-ChildItem "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models" -Filter "*wan2.2*low*" | Select-Object Name
   
   # Determine task type from filename:
   # - Contains "i2v" → Use task "i2v-A14B"
   # - Contains "t2v" → Use task "t2v-A14B"
   # - Contains "fp16" → Use MixedPrecision "fp16"
   # - Contains "bf16" → Use MixedPrecision "bf16"
   ```

3. **Prepare dataset config**: Copy the example and edit with your paths:
   ```powershell
   Copy-Item tools\ai\musubi-tuner\datasets\angelina-jolie-wan22.example.toml C:\path\to\your\angelina-jolie-wan22.toml
   # Edit with your actual image directory and cache paths
   ```

## Step 1: Prepare Dataset with Images and Captions

You have two options for dataset preparation:

### Option A: New Dataset Preparation Script (Recommended)

Use the enhanced dataset preparation script that handles copying images and generating captions:

```powershell
.\tools\ai\musubi-tuner\scripts\prepare-angelina-dataset-new.ps1 `
    -SourceImageDir "C:\path\to\source\images" `
    -TargetDir "C:\path\to\TrainingDataSet\dataset_name" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "trigger_word" `
    -Fp8Vl  # Optional: use fp8 for lower VRAM
```

This script will:
- Copy images from source to target directory
- Generate detailed captions using Qwen2.5-VL for each image
- Ensure the trigger word is prepended to all captions
- Create `.txt` caption files alongside each image

**Note**: If you already have captions, use `-SkipCaptioning` to only add the trigger word. If images are already copied, use `-SkipCopy`.

### Option B: Original Dataset Preparation Script

Use the original dataset preparation script for images already in the target directory:

```powershell
.\tools\ai\musubi-tuner\scripts\prepare-angelina-dataset.ps1 `
    -ImageDir "C:\path\to\your\images\angelina" `
    -QwenModelPath "C:\path\to\qwen2.5-vl-7b-instruct" `
    -TriggerWord "angelina jolie" `
    -Fp8Vl  # Optional: use fp8 for lower VRAM
```

This script:
- Generates captions using Qwen2.5-VL for each image
- Ensures "angelina jolie" trigger word is prepended to all captions
- Creates `.txt` files alongside each image

**Note**: If you already have captions, use `-SkipCaptioning` to only add the trigger word.

## Step 2: Cache Latents

Use the registered `musubi-tuner:wan:cache-latents` operation:

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:\path\to\your\angelina-jolie-wan22.toml" `
    -VaePath "C:\path\to\wan_2.1_vae.safetensors" `
    -T5Path "C:\path\to\models_t5_umt5-xxl-enc-bf16.pth"
```

**Note**: For WAN 2.2, CLIP model is not needed (unlike WAN 2.1).

Optional flags:
- `-VaeCacheCpu` - Use CPU for VAE cache (saves VRAM)
- `-I2V` - If training I2V model instead of T2V

## Step 3: Cache Text Encoder Outputs

Use the registered `musubi-tuner:wan:cache-text-encoder` operation:

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1 `
    -DatasetConfig "C:\path\to\your\angelina-jolie-wan22.toml" `
    -T5Path "C:\path\to\models_t5_umt5-xxl-enc-bf16.pth" `
    -BatchSize 16 `
    -Fp8T5  # Optional: use fp8 for T5 (saves VRAM)
```

## Step 4: Train High/Low LoRA Models

### Step 4.1: Check for Existing Checkpoints (IMPORTANT)

**Before starting training, always check for existing checkpoints:**

```powershell
# Check output directory for existing checkpoints
$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angeline Jolie\output"
if (Test-Path $OutputDir) {
    $Checkpoints = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" | Sort-Object LastWriteTime -Descending
    if ($Checkpoints) {
        Write-Host "Found existing checkpoints:" -ForegroundColor Yellow
        $Checkpoints | Select-Object Name, LastWriteTime | Format-Table
        Write-Host "Latest checkpoint: $($Checkpoints[0].FullName)" -ForegroundColor Green
        Write-Host "Use -Resume parameter to continue training from this checkpoint." -ForegroundColor Cyan
    } else {
        Write-Host "No existing checkpoints found. Starting fresh training." -ForegroundColor Green
    }
}
```

**If checkpoints exist, use Option C (Resume Training) instead of starting fresh.**

### Option A: Train Both Models Simultaneously (Recommended)

Use the high/low training script:

```powershell
.\tools\ai\musubi-tuner\scripts\wan-train-angelina-high-low.ps1 `
    -Task "t2v-A14B" `
    -DitLowNoise "C:\path\to\wan2.2_t2v_low_noise_fp16.safetensors" `
    -DitHighNoise "C:\path\to\wan2.2_t2v_high_noise_fp16.safetensors" `
    -DatasetConfig "C:\path\to\your\angelina-jolie-wan22.toml" `
    -OutputDir "C:\path\to\output" `
    -OutputName "angelina_jolie_wan22" `
    -NetworkDim 32 `
    -LearningRate 2e-4 `
    -MaxTrainEpochs 16 `
    -Fp8Base `
    -PreserveDistributionShape
```

### Option B: Train Separately (Low Noise First)

**IMPORTANT: Use proper quoting for paths with spaces!**

```powershell
# For I2V models (low noise, timestep 0-900)
# Optimized for small datasets (<50 images) with faster data loading
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
    -PreserveDistributionShape `
    -DataLoaderWorkers 8 `
    -MaxTrainEpochs 10 `
    -SaveEveryNSteps 100

# For T2V models (low noise, timestep 0-875)
cd "E:\Soso\Projects\electric-sheep"
& ".\tools\ai\musubi-tuner\scripts\wan-train.ps1" `
    -Task "t2v-A14B" `
    -DitPath "C:\path\to\wan2.2_t2v_low_noise_fp16.safetensors" `
    -DatasetConfig "C:\path\to\your\angelina-jolie-wan22.toml" `
    -OutputDir "C:\path\to\output" `
    -OutputName "angelina_jolie_wan22_low" `
    -MixedPrecision "fp16" `
    -MinTimestep 0 `
    -MaxTimestep 875 `
    -PreserveDistributionShape
```

**Note**: Always use `&` call operator when calling PowerShell scripts with paths containing spaces. This prevents parameter binding errors.

Then train high noise with:
```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-A14B" `
    -DitPath "C:\path\to\wan2.2_t2v_high_noise_fp16.safetensors" `
    -DatasetConfig "C:\path\to\your\angelina-jolie-wan22.toml" `
    -OutputDir "C:\path\to\output" `
    -OutputName "angelina_jolie_wan22_high" `
    -NetworkDim 32 `
    -LearningRate 2e-4 `
    -MaxTrainEpochs 16 `
    -Fp8Base `
    -MinTimestep 875 `
    -MaxTimestep 1000 `
    -PreserveDistributionShape
```

### Option C: Resume Training from Checkpoint

**If training was interrupted or you want to continue from a previous checkpoint:**

```powershell
# First, find the latest checkpoint
$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angeline Jolie\output"
$LatestCheckpoint = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Resume training with same parameters as original training
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
    -PreserveDistributionShape `
    -Resume $LatestCheckpoint.FullName
```

**Important Notes:**
- Use the **same parameters** as original training (checkpoint contains optimizer state)
- Resume preserves: optimizer state, learning rate scheduler, current epoch/step
- Checkpoint directories are named: `{output_name}-epoch-{N}/`
- Use the checkpoint **directory** path, not the `.safetensors` file

## Understanding Trigger Words

**What is a trigger word?**
A trigger word is a special keyword you include in captions during training. When you use this word in prompts during inference, it activates the LoRA's learned features.

**For this training:**
- Trigger word: `"angelina jolie"`
- Every caption will start with: `"angelina jolie, [description]"`
- During inference, use `"angelina jolie"` in your prompt to activate the LoRA

**Example captions:**
- `"angelina jolie, a portrait with a serene expression"`
- `"angelina jolie, attending a red carpet event"`
- `"angelina jolie, in a black dress with elegant pose"`

## Training Tips

1. **Resolution**: The dataset config uses `[960, 544]` by default. Adjust based on your images.

2. **Bucketing**: Enabled by default (`enable_bucket = true`) - handles varied aspect ratios efficiently.

3. **Batch Size**: Start with `batch_size = 1` and increase if you have VRAM headroom.

4. **Network Dimension**: `network_dim = 32` is a good starting point. Higher values (64, 128) may capture more detail but require more VRAM.

5. **Learning Rate**: `2e-4` is standard. Lower values (1e-4) for more stable training, higher (5e-4) for faster convergence.

6. **Epochs**: Start with 16 epochs. Monitor loss and adjust if needed.

7. **Memory Saving**: Use `-Fp8Base` flag if you're running low on VRAM.

## Troubleshooting

**Out of Memory errors:**
- Use `-Fp8Base` flag
- Reduce `batch_size` in dataset config
- Use `-VaeCacheCpu` during latent caching
- Use `-Fp8T5` during text encoder caching

**Training too slow:**
- **Increase data loader workers**: Use `-DataLoaderWorkers 8` (or higher) - this is the #1 optimization for slow training
  - Default is 2 workers, which causes severe bottleneck with small datasets
  - For strong CPUs, 8-16 workers can reduce training time by 2-4x
- Reduce epochs: Use `-MaxTrainEpochs 10` instead of 16 for datasets <50 images
- Use step-based checkpointing: `-SaveEveryNSteps 100` to save progress frequently
- Ensure caching steps completed successfully
- Check GPU utilization - should be 80-100% continuously, not spiky

**Poor quality results:**
- Check that trigger word is in all captions
- Verify dataset config paths are correct
- Try increasing `network_dim` or `num_repeats`
- Adjust `learning_rate` or `max_train_epochs`

## Next Steps After Training

Once training completes, use the trained LoRA with `musubi-tuner:wan:generate`:

```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-A14B" `
    -Prompt "angelina jolie, [your description]" `
    -DitPath "C:\path\to\wan2.2_t2v_low_noise_fp16.safetensors" `
    -DitHighNoise "C:\path\to\wan2.2_t2v_high_noise_fp16.safetensors" `
    -VaePath "C:\path\to\wan_2.1_vae.safetensors" `
    -T5Path "C:\path\to\models_t5_umt5-xxl-enc-bf16.pth" `
    -SavePath "C:\path\to\output\video.mp4" `
    -LoraPath "C:\path\to\output\angelina_jolie_wan22.safetensors"
```

