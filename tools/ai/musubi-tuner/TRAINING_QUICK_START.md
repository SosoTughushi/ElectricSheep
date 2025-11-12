# WAN 2.2 Training Quick Start Guide

**For AI Agents**: This guide provides step-by-step instructions for training WAN 2.2 LoRA models with minimal human intervention.

## Quick Command: Train WAN 2.2 LoRA

When user says: *"Train WAN 2.2 on dataset at E:\Stable Diffusion\TrainingDataSet\Angeline Jolie"*

### Step 1: Discover Models

```powershell
# Find WAN 2.2 models in ComfyUI directory
$ModelDir = "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models"
$Models = Get-ChildItem $ModelDir -Filter "*wan2.2*low*" | Select-Object Name, FullName

# Determine task type and precision from filename
$ModelName = $Models[0].Name
$Task = if ($ModelName -match "i2v") { "i2v-A14B" } else { "t2v-A14B" }
$MixedPrecision = if ($ModelName -match "fp16") { "fp16" } else { "bf16" }
$DitPath = $Models[0].FullName
```

### Step 2: Check/Create Dataset Config

```powershell
# Check if dataset config exists
$DatasetConfig = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\angelina-jolie-wan22.toml"
if (-not (Test-Path $DatasetConfig)) {
    # Copy example and update paths
    Copy-Item "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\dataset-wan22.example.toml" $DatasetConfig
    # Update image_directory and cache_directory in TOML file
}
```

### Step 3: Check for Existing Checkpoints

```powershell
# Determine output directory (usually dataset_folder/output)
$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angeline Jolie\output"
$OutputName = "angelina_jolie_wan22_low"

# Check for existing checkpoints
$Checkpoints = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
$ResumePath = if ($Checkpoints) { $Checkpoints[0].FullName } else { $null }
```

### Step 4: Launch Training

**IMPORTANT: Use proper quoting for paths with spaces!**

PowerShell requires proper quoting when paths contain spaces. Use the `&` call operator with quoted paths:

```powershell
# Build training command
$TrainingArgs = @{
    Task = $Task
    DitPath = $DitPath
    DatasetConfig = $DatasetConfig
    OutputDir = $OutputDir
    OutputName = $OutputName
    MixedPrecision = $MixedPrecision
    MinTimestep = 0
    MaxTimestep = if ($Task -match "i2v") { 900 } else { 875 }
    PreserveDistributionShape = $true
}

# Add resume if checkpoint found
if ($ResumePath) {
    $TrainingArgs['Resume'] = $ResumePath
    Write-Host "Resuming from checkpoint: $ResumePath" -ForegroundColor Cyan
} else {
    Write-Host "Starting fresh training" -ForegroundColor Green
}

# Launch training with proper quoting (CRITICAL for paths with spaces)
# Add performance optimizations for small datasets
$TrainingArgs['DataLoaderWorkers'] = 8  # Increase from default 2 for faster data loading
if ($Task -match "i2v" -or $Task -match "t2v") {
    # For small datasets (<50 images), reduce epochs
    $TrainingArgs['MaxTrainEpochs'] = 10
    $TrainingArgs['SaveEveryNSteps'] = 100  # Save checkpoints every 100 steps
}

cd "E:\Soso\Projects\electric-sheep"
& ".\tools\ai\musubi-tuner\scripts\wan-train.ps1" @TrainingArgs
```

**Alternative: Launch in new window for monitoring:**

```powershell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'E:\Soso\Projects\electric-sheep'; & '.\tools\ai\musubi-tuner\scripts\wan-train.ps1' -Task '$Task' -DitPath '$DitPath' -DatasetConfig '$DatasetConfig' -OutputDir '$OutputDir' -OutputName '$OutputName' -MixedPrecision '$MixedPrecision' -MinTimestep 0 -MaxTimestep $(if ($Task -match 'i2v') { 900 } else { 875 }) -PreserveDistributionShape"
```

## Complete Automated Script

```powershell
# Auto-detect and train WAN 2.2 LoRA
param(
    [Parameter(Mandatory=$true)]
    [string]$DatasetPath
)

# Step 1: Find models
$ModelDir = "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models"
$LowModel = Get-ChildItem $ModelDir -Filter "*wan2.2*low*" | Select-Object -First 1

if (-not $LowModel) {
    Write-Host "Error: WAN 2.2 low noise model not found!" -ForegroundColor Red
    exit 1
}

# Determine task and precision
$Task = if ($LowModel.Name -match "i2v") { "i2v-A14B" } else { "t2v-A14B" }
$MixedPrecision = if ($LowModel.Name -match "fp16") { "fp16" } else { "bf16" }

# Step 2: Setup dataset config
$DatasetName = Split-Path $DatasetPath -Leaf
$ConfigPath = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\$($DatasetName.ToLower().Replace(' ','-'))-wan22.toml"

if (-not (Test-Path $ConfigPath)) {
    Copy-Item "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\dataset-wan22.example.toml" $ConfigPath
    # Update paths in TOML (use sed or manual edit)
}

# Step 3: Check for checkpoints
$OutputDir = Join-Path $DatasetPath "output"
$OutputName = "$($DatasetName.ToLower().Replace(' ','_'))_wan22_low"
$LatestCheckpoint = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Step 4: Train
$TrainingArgs = @{
    Task = $Task
    DitPath = $LowModel.FullName
    DatasetConfig = $ConfigPath
    OutputDir = $OutputDir
    OutputName = $OutputName
    MixedPrecision = $MixedPrecision
    MinTimestep = 0
    MaxTimestep = if ($Task -match "i2v") { 900 } else { 875 }
    PreserveDistributionShape = $true
    Fp8Base = $true
}

if ($LatestCheckpoint) {
    $TrainingArgs['Resume'] = $LatestCheckpoint.FullName
}

.\tools\ai\musubi-tuner\scripts\wan-train.ps1 @TrainingArgs
```

## Model Discovery Rules

1. **Check ComfyUI first**: `E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\`
2. **Check config.json**: `.local/config.json` → `models.wan` section
3. **Filename patterns**:
   - `*wan2.2*i2v*low*` → Task: `i2v-A14B`
   - `*wan2.2*t2v*low*` → Task: `t2v-A14B`
   - `*fp16*` → MixedPrecision: `fp16`
   - `*bf16*` → MixedPrecision: `bf16`

## Checkpoint Detection Rules

1. **Check output directory**: `{dataset_path}/output/`
2. **Look for directories**: Pattern `*epoch-*`
3. **Sort by timestamp**: Use most recent checkpoint
4. **Resume if found**: Add `-Resume` parameter with checkpoint directory path

## Common Issues

- **Model not found**: Check ComfyUI directory or config.json
- **Task mismatch**: Verify model filename contains `i2v` or `t2v`
- **Precision mismatch**: Verify model filename contains `fp16` or `bf16`
- **No checkpoint found**: Start fresh training (normal for first run)
- **Parameter binding error with spaces in paths**: 
  - **Problem**: PowerShell may misinterpret arguments when paths contain spaces (e.g., "ComfyUi Portable")
  - **Solution**: Always use `&` call operator with quoted script path: `& ".\path\to\script.ps1" -Param "value"`
  - **Example**: `& ".\tools\ai\musubi-tuner\scripts\wan-train.ps1" -DitPath "E:\Path With Spaces\model.safetensors"`
- **Dataset config path mismatch**: 
  - **Problem**: Dataset config TOML file may have incorrect directory name (e.g., "Angelina" vs "Angeline")
  - **Solution**: Verify `image_directory` and `cache_directory` in TOML match actual directory names exactly
  - **Check**: `Get-Content dataset.toml | Select-String "image_directory"`
- **Training extremely slow (4+ minutes per step)**:
  - **Problem**: Data loading bottleneck with default 2 workers
  - **Solution**: Use `-DataLoaderWorkers 8` (or higher) for faster data loading
  - **For small datasets**: Use `-MaxTrainEpochs 10` instead of 16
  - **Check GPU utilization**: Should be 80-100% continuously, not spiky 30-70%
  - **Expected speed**: With 8 workers, should be 1-2 minutes per step, not 4+ minutes
- **Training too slow even with optimizations (5+ minutes per step with 14B model)**:
  - **Problem**: 14B parameter model is inherently slow on RTX 3090 (~5-6 min/step is expected)
  - **Solution 1 (Recommended)**: Switch to WAN 2.1 1.3B model for ~10x faster training
    - Task: `t2v-1.3B` (for T2V) or `i2v-14B` (for I2V - note: still uses 1.3B DiT)
    - Requires WAN 2.1 model files (not WAN 2.2)
    - Much faster: ~30-60 seconds per step instead of 5-6 minutes
    - Still produces good quality LoRA models
  - **Solution 2**: Continue with 14B but reduce epochs to 6-8 (cuts total time to ~3-4 days)
  - **Solution 3**: Further optimize with `-NetworkDim 16` (lower rank) and `-Fp8Base` (if using fp16/bf16 model)
  - **Note**: WAN 2.2 5B model (`ti2v-5B`) exists but is NOT supported for training in musubi-tuner (only inference)

