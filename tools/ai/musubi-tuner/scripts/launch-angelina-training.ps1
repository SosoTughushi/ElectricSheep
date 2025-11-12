# Launch Angelina Training with All Prerequisites
# This script ensures caching is done before training

$ErrorActionPreference = "Continue"

# Known model paths
$LowModel = "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\wan2.2_i2v_low_noise_14B_fp16.safetensors"
$HighModel = "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models\wan2.2_i2v_high_noise_14B_fp16.safetensors"
$VaeModel = "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\vae\wan2.2_vae.safetensors"
$DatasetConfig = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\angelina-wan22.toml"
$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angelina Jolie\output"
$OutputName = "angelina_jolie_wan22"
$CacheDir = "E:\Stable Diffusion\TrainingDataSet\Angelina Jolie\cache"
$LogDir = "E:\Soso\Projects\electric-sheep\logs"

$LogFile = Join-Path $LogDir "angelina-final-launch-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

function Write-Log {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Angelina Training Launch ==="

# Find T5 model - search comprehensively
Write-Log "Searching for T5 model..."
$T5SearchPaths = @(
    "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models",
    "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\text_encoders",
    "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\clip",
    "E:\Stable Diffusion\models",
    "E:\models",
    "E:\Stable Diffusion"
)

$T5Model = $null
foreach ($Path in $T5SearchPaths) {
    if (Test-Path $Path) {
        Write-Log "Checking: $Path"
        # Look for .pth files that might be T5
        $T5Files = Get-ChildItem $Path -Recurse -Filter "*.pth" -ErrorAction SilentlyContinue | 
            Where-Object { 
                ($_.Name -match "umt5|t5|models_t5") -and 
                $_.Name -notmatch "detection|face|clip|control" -and
                $_.Length -gt 100MB  # T5 models are typically 1-5GB
            } | 
            Sort-Object Length -Descending
        
        if ($T5Files) {
            # Prefer files with "t5" or "umt5" in name, otherwise take largest
            $Preferred = $T5Files | Where-Object { $_.Name -match "t5|umt5" } | Select-Object -First 1
            if ($Preferred) {
                $T5Model = $Preferred.FullName
            } else {
                $T5Model = $T5Files[0].FullName
            }
            Write-Log "Found T5 model: $T5Model (Size: $([math]::Round((Get-Item $T5Model).Length/1GB,2))GB)"
            break
        }
    }
}

# If still not found, try .safetensors files
if (-not $T5Model) {
    Write-Log "T5 .pth not found, checking .safetensors files..."
    foreach ($Path in $T5SearchPaths) {
        if (Test-Path $Path) {
            $T5Safetensors = Get-ChildItem $Path -Recurse -Filter "*t5*.safetensors" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Length -gt 500MB } | 
                Sort-Object Length -Descending | 
                Select-Object -First 1
            
            if ($T5Safetensors) {
                $T5Model = $T5Safetensors.FullName
                Write-Log "Found T5 model (safetensors): $T5Model"
                break
            }
        }
    }
}

if (-not $T5Model) {
    Write-Log "ERROR: T5 model not found automatically."
    Write-Log "Please check if T5 model exists or update the script with the correct path."
    Write-Log "Common locations:"
    Write-Log "  - E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\text_encoders\"
    Write-Log "  - E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\clip\"
    Write-Log "  - Or search for files matching: *umt5*.pth, *t5*.pth (usually >500MB)"
    exit 1
}

# Verify all models exist
if (-not (Test-Path $LowModel)) { Write-Log "ERROR: Low model not found: $LowModel"; exit 1 }
if (-not (Test-Path $HighModel)) { Write-Log "ERROR: High model not found: $HighModel"; exit 1 }
if (-not (Test-Path $VaeModel)) { Write-Log "ERROR: VAE model not found: $VaeModel"; exit 1 }
if (-not (Test-Path $T5Model)) { Write-Log "ERROR: T5 model not found: $T5Model"; exit 1 }

Write-Log "All models found!"

# Check if cache exists
$CacheExists = Test-Path $CacheDir

if (-not $CacheExists) {
    Write-Log "Cache directory not found. Starting caching process..."
    
    # Cache latents
    Write-Log "Step 1: Caching latents (this may take a while)..."
    $CacheLatentsScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1"
    
    & $CacheLatentsScript `
        -DatasetConfig $DatasetConfig `
        -VaePath $VaeModel `
        -T5Path $T5Model `
        -I2V
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Latent caching failed with exit code $LASTEXITCODE"
        exit 1
    }
    
    Write-Log "Latent caching completed!"
    
    # Cache text encoder outputs
    Write-Log "Step 2: Caching text encoder outputs..."
    $CacheTextScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1"
    
    & $CacheTextScript `
        -DatasetConfig $DatasetConfig `
        -T5Path $T5Model `
        -BatchSize 16
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Text encoder caching failed with exit code $LASTEXITCODE"
        exit 1
    }
    
    Write-Log "Text encoder caching completed!"
} else {
    Write-Log "Cache directory exists. Skipping caching."
}

# Start training
Write-Log "Step 3: Starting training..."
Write-Log "This will run for up to 16 epochs. Check $OutputDir for checkpoints."

$TrainScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-train-angelina-high-low.ps1"

& $TrainScript `
    -Task "i2v-A14B" `
    -DitLowNoise $LowModel `
    -DitHighNoise $HighModel `
    -DatasetConfig $DatasetConfig `
    -OutputDir $OutputDir `
    -OutputName $OutputName

if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: Training failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Log "Training completed successfully!"
Write-Log "Check output directory: $OutputDir"

