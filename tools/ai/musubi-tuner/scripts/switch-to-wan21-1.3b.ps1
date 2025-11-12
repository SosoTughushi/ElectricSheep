# Switch to WAN 2.1 1.3B Model for Faster Training
# This script helps you switch from WAN 2.2 14B to WAN 2.1 1.3B (~10x faster)
# Usage: .\switch-to-wan21-1.3b.ps1 -TaskType "i2v" -DatasetConfig "path\to\dataset.toml"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("i2v", "t2v")]
    [string]$TaskType,  # "i2v" for image-to-video, "t2v" for text-to-video
    
    [Parameter(Mandatory=$true)]
    [string]$DatasetConfig,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputDir,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputName
)

$ErrorActionPreference = "Continue"

Write-Host "=== WAN 2.1 1.3B Model Discovery ===" -ForegroundColor Cyan
Write-Host "Searching for WAN 2.1 1.3B models..." -ForegroundColor Yellow

# Search paths for models
$SearchPaths = @(
    "E:/path/to/ComfyUI/models/diffusion_models",
    "E:/path/to/ComfyUI/models/diffusion_models",
    "E:/path/to/models/diffusion_models",
    "E:/path/to/models",
    "E:/path/to/models"
)

# Find WAN 2.1 1.3B models
$DitModel = $null
$VaeModel = $null
$T5Model = $null
$ClipModel = $null

# Search for DiT model (1.3B) - try multiple patterns
foreach ($Path in $SearchPaths) {
    if (Test-Path $Path) {
        # Try multiple search patterns
        $Filters = @(
            if ($TaskType -eq "i2v") { "*wan2.1*i2v*1.3B*" } else { "*wan2.1*t2v*1.3B*" },
            if ($TaskType -eq "i2v") { "*wan2.1*i2v*1_3B*" } else { "*wan2.1*t2v*1_3B*" },
            if ($TaskType -eq "i2v") { "*wan*i2v*1.3*" } else { "*wan*t2v*1.3*" },
            "*wan2.1*1.3*",
            "*wan*1.3B*"
        )
        
        foreach ($Filter in $Filters) {
            $Files = Get-ChildItem $Path -Recurse -Filter $Filter -ErrorAction SilentlyContinue | 
                Where-Object { 
                    $_.Name -match "1\.3|1_3" -and 
                    $_.Name -match "wan" -and
                    ($TaskType -eq "t2v" -or $_.Name -match "i2v" -or $TaskType -eq "i2v")
                } | 
                Select-Object -First 1
            
            if ($Files -and -not $DitModel) {
                $DitModel = $Files.FullName
                Write-Host "Found WAN 2.1 1.3B DiT model: $DitModel" -ForegroundColor Green
                break
            }
        }
        
        if ($DitModel) { break }
    }
}

# Search for VAE (WAN 2.1 or WAN 2.2 VAE works - they're compatible)
# Also check common VAE directories
$VaeSearchPaths = $SearchPaths + @(
    "E:/path/to/ComfyUI/models/vae",
    "E:/path/to/ComfyUI/models/vae",
    "E:/path/to/models/vae"
)

foreach ($Path in $VaeSearchPaths) {
    if (Test-Path $Path) {
        $VaeFiles = Get-ChildItem $Path -Recurse -Filter "*wan*vae*.safetensors" -ErrorAction SilentlyContinue | 
            Where-Object { $_.Name -match "wan.*vae|vae.*wan" } | 
            Select-Object -First 1
        
        if ($VaeFiles -and -not $VaeModel) {
            $VaeModel = $VaeFiles.FullName
            Write-Host "Found VAE model: $VaeModel" -ForegroundColor Green
            break
        }
        
        # Also try .pth files
        if (-not $VaeModel) {
            $VaePthFiles = Get-ChildItem $Path -Recurse -Filter "*wan*vae*.pth" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Name -match "wan.*vae|vae.*wan" } | 
                Select-Object -First 1
            
            if ($VaePthFiles) {
                $VaeModel = $VaePthFiles.FullName
                Write-Host "Found VAE model (pth): $VaeModel" -ForegroundColor Green
                break
            }
        }
    }
}

# Search for T5 model
$T5SearchPaths = @(
    "E:/path/to/ComfyUI/models",
    "E:/path/to/ComfyUI/models/text_encoders",
    "E:/path/to/ComfyUI/models/clip",
    "E:/path/to/models",
    "E:/path/to/models"
)

foreach ($Path in $T5SearchPaths) {
    if (Test-Path $Path) {
        $T5Files = Get-ChildItem $Path -Recurse -Filter "*.pth" -ErrorAction SilentlyContinue | 
            Where-Object { 
                ($_.Name -match "umt5|t5|models_t5") -and 
                $_.Name -notmatch "detection|face|clip|control" -and
                $_.Length -gt 100MB
            } | 
            Sort-Object Length -Descending | 
            Select-Object -First 1
        
        if ($T5Files -and -not $T5Model) {
            $T5Model = $T5Files.FullName
            Write-Host "Found T5 model: $T5Model" -ForegroundColor Green
            break
        }
    }
}

# For I2V, we need CLIP model (WAN 2.1 requirement)
if ($TaskType -eq "i2v") {
    foreach ($Path in $T5SearchPaths) {
        if (Test-Path $Path) {
            $ClipFiles = Get-ChildItem $Path -Recurse -Filter "*.pth" -ErrorAction SilentlyContinue | 
                Where-Object { 
                    ($_.Name -match "clip|xlm-roberta|vit-huge") -and
                    $_.Length -gt 500MB
                } | 
                Sort-Object Length -Descending | 
                Select-Object -First 1
            
            if ($ClipFiles -and -not $ClipModel) {
                $ClipModel = $ClipFiles.FullName
                Write-Host "Found CLIP model: $ClipModel" -ForegroundColor Green
                break
            }
        }
    }
}

# Check what's missing
$Missing = @()
if (-not $DitModel) { $Missing += "WAN 2.1 1.3B DiT model" }
if (-not $VaeModel) { $Missing += "VAE model" }
if (-not $T5Model) { $Missing += "T5 model" }
if ($TaskType -eq "i2v" -and -not $ClipModel) { $Missing += "CLIP model (required for I2V)" }

if ($Missing.Count -gt 0) {
    Write-Host "`nERROR: Missing required models:" -ForegroundColor Red
    foreach ($Item in $Missing) {
        Write-Host "  - $Item" -ForegroundColor Red
    }
    Write-Host "`nDownload links:" -ForegroundColor Yellow
    Write-Host "  DiT 1.3B: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/diffusion_models" -ForegroundColor Cyan
    Write-Host "  T5 & CLIP: https://huggingface.co/Wan-AI/Wan2.1-I2V-14B-720P/tree/main" -ForegroundColor Cyan
    Write-Host "  VAE: https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/tree/main/split_files/vae" -ForegroundColor Cyan
    exit 1
}

Write-Host "`nAll required models found!" -ForegroundColor Green

# Determine task name and mixed precision
$Task = if ($TaskType -eq "i2v") { "i2v-14B" } else { "t2v-1.3B" }
$MixedPrecision = if ($DitModel -match "fp16") { "fp16" } else { "bf16" }

Write-Host "`nConfiguration:" -ForegroundColor Cyan
Write-Host "  Task: $Task" -ForegroundColor Yellow
Write-Host "  Mixed Precision: $MixedPrecision" -ForegroundColor Yellow
Write-Host "  DiT Model: $DitModel" -ForegroundColor Yellow
Write-Host "  VAE Model: $VaeModel" -ForegroundColor Yellow
Write-Host "  T5 Model: $T5Model" -ForegroundColor Yellow
if ($ClipModel) {
    Write-Host "  CLIP Model: $ClipModel" -ForegroundColor Yellow
}

# Check dataset config
if (-not (Test-Path $DatasetConfig)) {
    Write-Host "`nERROR: Dataset config not found: $DatasetConfig" -ForegroundColor Red
    exit 1
}

# Determine output directory and name if not provided
if (-not $OutputDir) {
    $DatasetDir = Split-Path (Get-Content $DatasetConfig | Select-String "image_directory" | Select-Object -First 1 | ForEach-Object { ($_ -split '"')[1] }) -Parent
    $OutputDir = Join-Path $DatasetDir "output"
}

if (-not $OutputName) {
    $DatasetName = Split-Path $DatasetDir -Leaf
    $OutputName = "$($DatasetName.ToLower().Replace(' ','_'))_wan21_1.3b"
}

Write-Host "`nOutput Settings:" -ForegroundColor Cyan
Write-Host "  Output Dir: $OutputDir" -ForegroundColor Yellow
Write-Host "  Output Name: $OutputName" -ForegroundColor Yellow

# Check cache directory
$CacheDir = Join-Path (Split-Path $DatasetConfig -Parent) "cache"
if (-not (Test-Path $CacheDir)) {
    $CacheDir = Join-Path (Split-Path $OutputDir -Parent) "cache"
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Cache latents (if not already done for WAN 2.1):" -ForegroundColor Yellow
Write-Host "   .\wan-cache-latents.ps1 -DatasetConfig `"$DatasetConfig`" -VaePath `"$VaeModel`" -T5Path `"$T5Model`" $(if ($TaskType -eq 'i2v') { '-I2V -ClipPath "' + $ClipModel + '"' })" -ForegroundColor Gray

Write-Host "`n2. Cache text encoder outputs:" -ForegroundColor Yellow
Write-Host "   .\wan-cache-text-encoder.ps1 -DatasetConfig `"$DatasetConfig`" -T5Path `"$T5Model`" -BatchSize 16" -ForegroundColor Gray

Write-Host "`n3. Start training:" -ForegroundColor Yellow
$TrainCmd = ".\wan-train.ps1 -Task `"$Task`" -DitPath `"$DitModel`" -DatasetConfig `"$DatasetConfig`" -OutputDir `"$OutputDir`" -OutputName `"$OutputName`" -MixedPrecision `"$MixedPrecision`" -MaxTrainEpochs 10 -DataLoaderWorkers 8 -Fp8Base"
Write-Host "   $TrainCmd" -ForegroundColor Gray

Write-Host "`n=== Expected Performance ===" -ForegroundColor Cyan
Write-Host "  Speed: ~30-60 seconds per step (vs 5-6 minutes with 14B)" -ForegroundColor Green
Write-Host "  Total time (126 images, 10 epochs): ~12-15 hours (vs ~5 days)" -ForegroundColor Green

Write-Host "`nWould you like to:" -ForegroundColor Cyan
Write-Host "  [1] Run caching now"
Write-Host "  [2] Start training directly (assumes cache exists)"
Write-Host "  [3] Just show the commands (manual execution)"
$Choice = Read-Host "Enter choice (1-3)"

if ($Choice -eq "1") {
    Write-Host "`nStarting latent caching..." -ForegroundColor Cyan
    $CacheLatentsScript = Join-Path $PSScriptRoot "wan-cache-latents.ps1"
    $CacheArgs = @(
        "-DatasetConfig", $DatasetConfig,
        "-VaePath", $VaeModel,
        "-T5Path", $T5Model
    )
    if ($TaskType -eq "i2v") {
        $CacheArgs += "-I2V"
        $CacheArgs += "-ClipPath"
        $CacheArgs += $ClipModel
    }
    & $CacheLatentsScript @CacheArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nStarting text encoder caching..." -ForegroundColor Cyan
        $CacheTextScript = Join-Path $PSScriptRoot "wan-cache-text-encoder.ps1"
        & $CacheTextScript -DatasetConfig $DatasetConfig -T5Path $T5Model -BatchSize 16
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nStarting training..." -ForegroundColor Cyan
            $TrainScript = Join-Path $PSScriptRoot "wan-train.ps1"
            & $TrainScript -Task $Task -DitPath $DitModel -DatasetConfig $DatasetConfig -OutputDir $OutputDir -OutputName $OutputName -MixedPrecision $MixedPrecision -MaxTrainEpochs 10 -DataLoaderWorkers 8 -Fp8Base
        }
    }
} elseif ($Choice -eq "2") {
    Write-Host "`nStarting training..." -ForegroundColor Cyan
    $TrainScript = Join-Path $PSScriptRoot "wan-train.ps1"
    & $TrainScript -Task $Task -DitPath $DitModel -DatasetConfig $DatasetConfig -OutputDir $OutputDir -OutputName $OutputName -MixedPrecision $MixedPrecision -MaxTrainEpochs 10 -DataLoaderWorkers 8 -Fp8Base
} else {
    Write-Host "`nCommands ready. Run them manually when ready." -ForegroundColor Green
}

