# Prepare Example Celebrity Dataset for WAN 2.2 Training
# This script generates captions and ensures trigger word is included

param(
    [Parameter(Mandatory=$true)]
    [string]$ImageDir,  # Path to directory containing images (e.g., "E:\Stable Diffusion\Inputs\df\lib\celeb\example-celebrity")
    
    [Parameter(Mandatory=$true)]
    [string]$QwenModelPath,
    
    [Parameter(Mandatory=$false)]
    [string]$TriggerWord = "example_celebrity",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipCaptioning = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8Vl = $false
)

# Get musubi-tuner path from config or use default
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
    $MusubiTunerPath = $Config.paths.musubi_tuner.installation_path
    $PythonExe = $Config.paths.musubi_tuner.python_exe
} else {
    Write-Host "Error: .local/config.json not found." -ForegroundColor Red
    Write-Host "Please create .local/config.json from .local/config.example.json" -ForegroundColor Red
    Write-Host "and configure musubi_tuner.installation_path and musubi_tuner.python_exe" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $PythonExe)) {
    Write-Host "Error: Python executable not found at $PythonExe" -ForegroundColor Red
    Write-Host "Please set up musubi-tuner or update .local/config.json" -ForegroundColor Red
    exit 1
}

$CaptionScript = Join-Path $MusubiTunerPath "caption_images_by_qwen_vl.py"

if (-not (Test-Path $CaptionScript)) {
    Write-Host "Error: Caption script not found at $CaptionScript" -ForegroundColor Red
    exit 1
}

Write-Host "=== Preparing Example Celebrity Dataset ===" -ForegroundColor Cyan
Write-Host "Image Directory: $ImageDir" -ForegroundColor Yellow
Write-Host "Trigger Word: $TriggerWord" -ForegroundColor Yellow
Write-Host ""

# Step 1: Generate captions
if (-not $SkipCaptioning) {
    Write-Host "Step 1: Generating captions with Qwen2.5-VL..." -ForegroundColor Cyan
    
    $CaptionArgs = @(
        $CaptionScript
        "--image_dir", $ImageDir
        "--model_path", $QwenModelPath
        "--output_format", "text"
        "--max_new_tokens", "256"
    )
    
    if ($Fp8Vl) {
        $CaptionArgs += "--fp8_vl"
    }
    
    & $PythonExe $CaptionArgs
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Caption generation failed" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    
    Write-Host "Caption generation completed!" -ForegroundColor Green
} else {
    Write-Host "Skipping caption generation (using existing captions)" -ForegroundColor Yellow
}

# Step 2: Ensure trigger word is in each caption
Write-Host ""
Write-Host "Step 2: Ensuring trigger word '$TriggerWord' is in all captions..." -ForegroundColor Cyan

$ImageFiles = Get-ChildItem -Path $ImageDir -File | Where-Object { 
    $_.Extension -match '\.(jpg|jpeg|png|webp|avif)$' -and 
    $_.Extension -notmatch '\.txt$' 
}

$ModifiedCount = 0
$CreatedCount = 0

foreach ($ImageFile in $ImageFiles) {
    $CaptionFile = $ImageFile.FullName -replace '\.[^.]+$', '.txt'
    
    if (Test-Path -LiteralPath $CaptionFile) {
        # Read existing caption using .NET method to handle special characters
        try {
            $Caption = [System.IO.File]::ReadAllText($CaptionFile, [System.Text.Encoding]::UTF8)
            
            # Check if trigger word is already present (case-insensitive)
            if ($Caption -notmatch [regex]::Escape($TriggerWord)) {
                # Prepend trigger word if not present
                $Caption = "$TriggerWord, $Caption".Trim()
                [System.IO.File]::WriteAllText($CaptionFile, $Caption, [System.Text.Encoding]::UTF8)
                $ModifiedCount++
            }
        } catch {
            Write-Host "  Warning: Failed to read caption file $($CaptionFile): $_" -ForegroundColor Yellow
            # Create caption file with just trigger word if read fails
            [System.IO.File]::WriteAllText($CaptionFile, "$TriggerWord", [System.Text.Encoding]::UTF8)
            $CreatedCount++
        }
    } else {
        # Create caption file with just trigger word if missing
        [System.IO.File]::WriteAllText($CaptionFile, "$TriggerWord", [System.Text.Encoding]::UTF8)
        $CreatedCount++
    }
}

Write-Host "  Modified: $ModifiedCount captions" -ForegroundColor Green
Write-Host "  Created: $CreatedCount new captions" -ForegroundColor Green
Write-Host ""
Write-Host "=== Dataset Preparation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Create a dataset config TOML file" -ForegroundColor White
Write-Host "2. Cache latents using wan_cache_latents.py" -ForegroundColor White
Write-Host "3. Cache text encoder outputs using wan_cache_text_encoder_outputs.py" -ForegroundColor White
Write-Host "4. Train using wan_train_network.py with --dit_high_noise for high/low training" -ForegroundColor White
