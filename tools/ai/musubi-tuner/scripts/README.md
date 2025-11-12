# Musubi Tuner Helper Scripts

PowerShell wrapper scripts for easy access to Musubi Tuner from the Cursor workspace.

## Usage

All scripts can be run from the workspace root:

### Prepare Dataset

Prepare a new training dataset by copying images (recursively from subfolders) and generating captions:

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
    -SourceImageDir "C:/path/to/source/images" `
    -TargetDir "C:/path/to/TrainingDataSet/dataset_name" `
    -QwenModelPath "Qwen/Qwen2.5-VL-7B-Instruct" `
    -TriggerWord "trigger_word" `
    -Fp8Vl  # Optional: use fp8 for lower VRAM
```

Both scripts will:
- Copy images from source to target directory (recursive for `prepare-dani-dataset.ps1`)
- Generate detailed captions using Qwen2.5-VL for each image
- Ensure the trigger word is prepended to all captions
- Create `.txt` caption files alongside each image

**Important: Handling Files with Special Characters**
- Scripts use `Test-Path -LiteralPath` and `[System.IO.File]::ReadAllText()` to properly handle filenames with special characters (e.g., `[image] - 123.jpg`)
- PowerShell's `Get-Content` cmdlet can fail silently on files with brackets or other special characters
- Always use `.NET` methods (`[System.IO.File]::ReadAllText/WriteAllText`) instead of PowerShell cmdlets when reading/writing caption files

**Options:**
- `-SkipCopy` - Skip copying images (already in target directory)
- `-SkipCaptioning` - Skip caption generation (only add trigger word to existing captions)

**Default Values:**
- Target directory: `E:\Stable Diffusion\TrainingDataSet\<dataset_name>` (extracted from source path)
- Trigger word: Extracted from dataset name (lowercase)
- Qwen model: `Qwen/Qwen2.5-VL-7B-Instruct` (HuggingFace model ID)

**Note**: After preparing the dataset, create a TOML configuration file (see main README for details).

### Activate Environment

```powershell
.\tools\ai\musubi-tuner\scripts\activate.ps1
```

### Cache Latents

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -VaeCacheCpu
```

For Wan 2.2 (no CLIP):
```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth"
```

For I2V:
```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -I2V
```

### Cache Text Encoder Outputs

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -T5Path "C:/path/to/t5.pth" `
    -BatchSize 16 `
    -Fp8T5
```

### Train LoRA

**Before training, check for existing checkpoints:**

```powershell
# Look for existing checkpoints in output directory
Get-ChildItem "E:/path/to/output" -Directory -Filter "*epoch-*" | Sort-Object LastWriteTime -Descending
```

**Start new training:**

```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-14B" `
    -DitPath "C:/path/to/dit.safetensors" `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -OutputDir "C:/path/to/output" `
    -OutputName "my-lora" `
    -NetworkDim 32 `
    -LearningRate 2e-4 `
    -MaxTrainEpochs 16 `
    -Fp8Base
```

**Resume from checkpoint:**

```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-14B" `
    -DitPath "C:/path/to/dit.safetensors" `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -OutputDir "C:/path/to/output" `
    -OutputName "my-lora" `
    -Resume "C:/path/to/output/my-lora-epoch-5" `
    # ... (all other parameters remain the same)
```

**Key Training Parameters:**

- **Task selection**: 
  - `i2v-A14B` for I2V models (image-to-video)
  - `t2v-A14B` for T2V models (text-to-video)
  - Determine from model filename (`*i2v*` vs `*t2v*`)

- **Mixed precision**:
  - `fp16` for fp16 models (check filename)
  - `bf16` for bf16 models (check filename)

- **Timestep limits for WAN 2.2 low-only training**:
  - I2V low: `-MinTimestep 0 -MaxTimestep 900`
  - T2V low: `-MinTimestep 0 -MaxTimestep 875`
  - High noise: Use `-DitHighNoise` parameter instead

**IMPORTANT: Always use `&` call operator when paths contain spaces!**

Example with proper quoting and performance optimizations:
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
    -PreserveDistributionShape `
    -DataLoaderWorkers 8 `
    -MaxTrainEpochs 10 `
    -SaveEveryNSteps 100
```

**Performance Parameters:**
- `-DataLoaderWorkers 8`: Increases data loading speed (default: 2). Use 8-16 for strong CPUs
- `-MaxTrainEpochs 10`: Reduces epochs for small datasets (<50 images). Default is 16
- `-SaveEveryNSteps 100`: Saves checkpoints every 100 steps (useful for long training runs)

For Wan 2.2 (with high-noise model):
```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-A14B" `
    -DitPath "C:/path/to/low_noise.safetensors" `
    -DitHighNoise "C:/path/to/high_noise.safetensors" `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -OutputDir "C:/path/to/output" `
    -OutputName "my-lora" `
    -Fp8Base
```

### Generate Video

**T2V:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output.mp4" `
    -VideoWidth 832 `
    -VideoHeight 480 `
    -VideoLength 81 `
    -InferSteps 20 `
    -Fp8
```

**I2V:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "i2v-14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -ImagePath "C:/path/to/start_image.jpg" `
    -SavePath "C:/path/to/output.mp4" `
    -Fp8
```

**Wan 2.2:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-A14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/low_noise.safetensors" `
    -DitHighNoise "C:/path/to/high_noise.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output.mp4" `
    -Fp8
```

**Batch Mode:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -FromFile "C:/path/to/prompts.txt" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output_directory"
```

**Interactive Mode:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -Interactive `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output_directory"
```

## Pausing and Resuming Training

**To pause training:**
- Press `Ctrl+C` once in the terminal
- Wait for current step to complete
- Training will save checkpoint at end of current epoch

**To resume training:**
- Check output directory for checkpoint directories: `Get-ChildItem "E:/path/to/output" -Directory -Filter "*epoch-*"`
- Use `-Resume` parameter pointing to the checkpoint directory (not the `.safetensors` file)
- Use the same parameters as original training

**Example:**
```powershell
# Find latest checkpoint
$LatestCheckpoint = Get-ChildItem "E:/path/to/output" -Directory -Filter "*epoch-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Resume training
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "i2v-A14B" `
    -DitPath "E:/path/to/model.safetensors" `
    -DatasetConfig "E:/path/to/dataset.toml" `
    -OutputDir "E:/path/to/output" `
    -OutputName "my-lora" `
    -Resume $LatestCheckpoint.FullName `
    # ... (all other parameters same as original)
```

## Notes

- All paths should use forward slashes `/` or be properly quoted
- Scripts automatically activate the virtual environment when needed
- Check script output for any errors or warnings
- For advanced options, use the Python scripts directly with `--help`
- **Always check for checkpoints before starting new training** - saves time and preserves progress

