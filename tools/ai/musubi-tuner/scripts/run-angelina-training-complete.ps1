# Complete Angelina Jolie Training Workflow
# This script handles caching and training automatically

param(
    [string]$DatasetConfig = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\datasets\angelina-wan22.toml",
    [string]$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angelina Jolie\output",
    [string]$OutputName = "angelina_jolie_wan22",
    [string]$LogDir = "E:\Soso\Projects\electric-sheep\logs"
)

$ErrorActionPreference = "Continue"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    $LogFile = Join-Path $LogDir "angelina-full-workflow-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Starting Complete Angelina Training Workflow ==="

# Find models
Write-Log "Searching for WAN 2.2 models..."
$SearchPaths = @(
    "E:\Stable Diffusion\ComfyUi Portable\ComfyUI\models\diffusion_models",
    "E:\Stable Diffusion\ComfyUI\models\diffusion_models"
)

$LowModel = $null
$HighModel = $null
$VaeModel = $null
$T5Model = $null

foreach ($Path in $SearchPaths) {
    if (Test-Path $Path) {
        $LowFiles = Get-ChildItem $Path -Filter "*wan2.2*low*" -ErrorAction SilentlyContinue | Select-Object -First 1
        $HighFiles = Get-ChildItem $Path -Filter "*wan2.2*high*" -ErrorAction SilentlyContinue | Select-Object -First 1
        
        if ($LowFiles -and -not $LowModel) { $LowModel = $LowFiles.FullName }
        if ($HighFiles -and -not $HighModel) { $HighModel = $HighFiles.FullName }
        
        # Search for VAE and T5 in parent directories
        $ParentPath = Split-Path $Path -Parent
        $VaeFiles = Get-ChildItem $ParentPath -Recurse -Filter "*wan*vae*.safetensors" -ErrorAction SilentlyContinue | Select-Object -First 1
        $T5Files = Get-ChildItem $ParentPath -Recurse -Filter "*t5*.pth" -ErrorAction SilentlyContinue | 
            Where-Object { $_.Name -match "umt5|t5" -and $_.Name -notmatch "detection|face" } | 
            Select-Object -First 1
        
        if ($VaeFiles -and -not $VaeModel) { $VaeModel = $VaeFiles.FullName }
        if ($T5Files -and -not $T5Model) { $T5Model = $T5Files.FullName }
    }
}

# Search more broadly
if (-not $VaeModel -or -not $T5Model) {
    Write-Log "Searching more broadly for VAE and T5 models..."
    $BroadPaths = @(
        "E:\Stable Diffusion",
        "E:\models"
    )
    
    foreach ($Path in $BroadPaths) {
        if (Test-Path $Path) {
            if (-not $VaeModel) {
                $VaeFiles = Get-ChildItem $Path -Recurse -Filter "*wan*vae*.safetensors" -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($VaeFiles) { $VaeModel = $VaeFiles.FullName }
            }
            if (-not $T5Model) {
                $T5Files = Get-ChildItem $Path -Recurse -Filter "*t5*.pth" -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Name -match "umt5|t5" -and $_.Name -notmatch "detection|face" } | 
                    Select-Object -First 1
                if ($T5Files) { $T5Model = $T5Files.FullName }
            }
        }
    }
}

if (-not $LowModel -or -not $HighModel) {
    Write-Log "ERROR: Could not find WAN 2.2 models" "ERROR"
    exit 1
}

if (-not $VaeModel) {
    Write-Log "ERROR: Could not find VAE model" "ERROR"
    exit 1
}

if (-not $T5Model) {
    Write-Log "ERROR: Could not find T5 model" "ERROR"
    exit 1
}

Write-Log "Found models:"
Write-Log "  Low: $LowModel"
Write-Log "  High: $HighModel"
Write-Log "  VAE: $VaeModel"
Write-Log "  T5: $T5Model"

# Determine task and precision
$Task = if ($LowModel -match "i2v") { "i2v-A14B" } else { "t2v-A14B" }
$MixedPrecision = if ($LowModel -match "fp16") { "fp16" } else { "bf16" }

Write-Log "Task: $Task, Precision: $MixedPrecision"

# Check if cache exists
$CacheDir = "E:\Stable Diffusion\TrainingDataSet\Angelina Jolie\cache"
$CacheExists = Test-Path $CacheDir

if (-not $CacheExists) {
    Write-Log "Cache directory not found. Starting caching process..."
    
    # Cache latents
    Write-Log "Caching latents..."
    $CacheLatentsScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1"
    
    $CacheArgs = @{
        DatasetConfig = $DatasetConfig
        VaePath = $VaeModel
        T5Path = $T5Model
    }
    
    if ($Task -match "i2v") {
        $CacheArgs["I2V"] = $true
    }
    
    & $CacheLatentsScript @CacheArgs
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Latent caching failed" "ERROR"
        exit 1
    }
    
    # Cache text encoder outputs
    Write-Log "Caching text encoder outputs..."
    $CacheTextScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1"
    
    & $CacheTextScript -DatasetConfig $DatasetConfig -T5Path $T5Model -BatchSize 16
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Text encoder caching failed" "ERROR"
        exit 1
    }
    
    Write-Log "Caching completed!"
} else {
    Write-Log "Cache directory exists. Skipping caching."
}

# Start training
Write-Log "Starting training..."
$TrainScript = "E:\Soso\Projects\electric-sheep\tools\ai\musubi-tuner\scripts\wan-train-angelina-high-low.ps1"

& $TrainScript `
    -Task $Task `
    -DitLowNoise $LowModel `
    -DitHighNoise $HighModel `
    -DatasetConfig $DatasetConfig `
    -OutputDir $OutputDir `
    -OutputName $OutputName

if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: Training failed with exit code $LASTEXITCODE" "ERROR"
    exit $LASTEXITCODE
}

Write-Log "Training workflow completed successfully!"

