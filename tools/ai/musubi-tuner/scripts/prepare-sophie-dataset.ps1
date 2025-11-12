# Prepare Dataset for WAN 2.2 Training (Recursive)
# This script copies images from source recursively (including all subfolders), generates captions, and ensures trigger word is included
# Generic dataset preparation script - works for any dataset name
# Usage: When user says "prepare dataset for <path>", extract dataset name from path and use it as trigger word

param(
    [Parameter(Mandatory=$false)]
    [string]$SourceImageDir = "E:\Stable Diffusion\Inputs\df\lib\female\sophie",  # Path to source images
    
    [Parameter(Mandatory=$false)]
    [string]$QwenModelPath = "Qwen/Qwen2.5-VL-7B-Instruct",  # Path to Qwen2.5-VL model (default: HuggingFace model ID)
    
    [Parameter(Mandatory=$false)]
    [string]$TargetDir = "E:\Stable Diffusion\TrainingDataSet\sophie",  # Target directory for processed dataset
    
    [Parameter(Mandatory=$false)]
    [string]$TriggerWord = "sophie",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipCaptioning = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8Vl = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipCopy = $false  # If images are already copied, skip copying
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

# Try alternative script first (supports HuggingFace model IDs), then fall back to main script
$CaptionScriptAlt = Join-Path $PSScriptRoot "generate_captions_qwen.py"
$CaptionScript = Join-Path $MusubiTunerPath "caption_images_by_qwen_vl.py"

if (Test-Path $CaptionScriptAlt) {
    $CaptionScript = $CaptionScriptAlt
    $UseAltScript = $true
} elseif (Test-Path $CaptionScript) {
    $UseAltScript = $false
} else {
    Write-Host "Error: Caption script not found at $CaptionScript or $CaptionScriptAlt" -ForegroundColor Red
    exit 1
}

Write-Host "=== Preparing Sophie Dataset ===" -ForegroundColor Cyan
Write-Host "Source Directory: $SourceImageDir" -ForegroundColor Yellow
Write-Host "Target Directory: $TargetDir" -ForegroundColor Yellow
Write-Host "Trigger Word: $TriggerWord" -ForegroundColor Yellow
Write-Host ""

# Step 1: Copy images from source to target directory (recursively from subfolders)
if (-not $SkipCopy) {
    Write-Host "Step 1: Copying images from source to target directory (including subfolders)..." -ForegroundColor Cyan
    
    if (-not (Test-Path $SourceImageDir)) {
        Write-Host "Error: Source directory not found: $SourceImageDir" -ForegroundColor Red
        exit 1
    }
    
    # Create target directory if it doesn't exist
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "Created target directory: $TargetDir" -ForegroundColor Green
    }
    
    # Copy image files (jpg, jpeg, png, webp, avif) recursively from subfolders
    $ImageExtensions = @("*.jpg", "*.jpeg", "*.png", "*.webp", "*.avif")
    $CopyCount = 0
    $ErrorCount = 0
    
    # Get all image files recursively first
    $AllSourceFiles = @()
    foreach ($Ext in $ImageExtensions) {
        $SourceFiles = Get-ChildItem -Path $SourceImageDir -Filter $Ext -File -Recurse -ErrorAction SilentlyContinue
        $AllSourceFiles += $SourceFiles
    }
    
    Write-Host "  Found $($AllSourceFiles.Count) images in source directory (including subfolders)" -ForegroundColor Cyan
    
    foreach ($File in $AllSourceFiles) {
        $DestPath = Join-Path $TargetDir $File.Name
        
        # Handle duplicate filenames by adding a number suffix
        $BaseName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
        $Extension = $File.Extension
        $Counter = 1
        while (Test-Path -LiteralPath $DestPath) {
            $NewName = "$BaseName`_$Counter$Extension"
            $DestPath = Join-Path $TargetDir $NewName
            $Counter++
        }
        
        try {
            # Use -LiteralPath for files with special characters in names
            Copy-Item -LiteralPath $File.FullName -Destination $DestPath -Force -ErrorAction Stop
            # Verify the file was actually copied
            if (Test-Path -LiteralPath $DestPath) {
                $CopyCount++
            } else {
                Write-Host "  Warning: Copy reported success but file not found: $($File.Name)" -ForegroundColor Yellow
                $ErrorCount++
            }
        } catch {
            Write-Host "  Warning: Failed to copy $($File.Name): $_" -ForegroundColor Yellow
            $ErrorCount++
        }
    }
    
    Write-Host "  Copied $CopyCount images to target directory" -ForegroundColor Green
    if ($ErrorCount -gt 0) {
        Write-Host "  Failed to copy $ErrorCount images" -ForegroundColor Red
    }
    Write-Host ""
} else {
    Write-Host "Skipping image copy (images already in target directory)" -ForegroundColor Yellow
    Write-Host ""
}

# Step 2: Generate captions
if (-not $SkipCaptioning) {
    Write-Host "Step 2: Generating captions with Qwen2.5-VL..." -ForegroundColor Cyan
    
    if ($UseAltScript) {
        # Use alternative script that supports HuggingFace model IDs
        $CaptionArgs = @(
            $CaptionScript
            "--image_dir", $TargetDir
            "--model_name", $QwenModelPath
            "--trigger_word", $TriggerWord
            "--max_new_tokens", "256"
        )
    } else {
        # Use main script that requires local model path
        $CaptionArgs = @(
            $CaptionScript
            "--image_dir", $TargetDir
            "--model_path", $QwenModelPath
            "--output_format", "text"
            "--max_new_tokens", "256"
        )
        
        if ($Fp8Vl) {
            $CaptionArgs += "--fp8_vl"
        }
    }
    
    & $PythonExe $CaptionArgs
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Caption generation failed" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    
    Write-Host "Caption generation completed!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "Skipping caption generation (using existing captions)" -ForegroundColor Yellow
    Write-Host ""
}

# Step 3: Ensure trigger word is in each caption
Write-Host "Step 3: Ensuring trigger word '$TriggerWord' is in all captions..." -ForegroundColor Cyan

$ImageFiles = Get-ChildItem -Path $TargetDir -File | Where-Object { 
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
Write-Host "Dataset location: $TargetDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Create a dataset config TOML file (see tools/ai/musubi-tuner/datasets/sophie-wan22.toml)" -ForegroundColor White
Write-Host "2. Cache latents using wan_cache_latents.py" -ForegroundColor White
Write-Host "3. Cache text encoder outputs using wan_cache_text_encoder_outputs.py" -ForegroundColor White
Write-Host "4. Train using wan_train_network.py with --dit_high_noise for high/low training" -ForegroundColor White

