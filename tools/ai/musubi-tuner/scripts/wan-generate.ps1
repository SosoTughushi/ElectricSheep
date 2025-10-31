# Generate Video with Wan 2.1/2.2
# Usage: .\tools\ai\musubi-tuner\scripts\wan-generate.ps1 -Task "t2v-14B" -Prompt "your prompt" -DitPath "path/to/dit.safetensors" -VaePath "path/to/vae.safetensors" -T5Path "path/to/t5.pth" -SavePath "path/to/output.mp4"

param(
    [Parameter(Mandatory=$true)]
    [string]$Task,
    
    [Parameter(Mandatory=$true)]
    [string]$Prompt,
    
    [Parameter(Mandatory=$true)]
    [string]$DitPath,
    
    [Parameter(Mandatory=$true)]
    [string]$VaePath,
    
    [Parameter(Mandatory=$true)]
    [string]$T5Path,
    
    [Parameter(Mandatory=$true)]
    [string]$SavePath,
    
    [Parameter(Mandatory=$false)]
    [string]$DitHighNoise,
    
    [Parameter(Mandatory=$false)]
    [string]$ClipPath,
    
    [Parameter(Mandatory=$false)]
    [string]$ImagePath,
    
    [Parameter(Mandatory=$false)]
    [int]$VideoWidth = 832,
    
    [Parameter(Mandatory=$false)]
    [int]$VideoHeight = 480,
    
    [Parameter(Mandatory=$false)]
    [int]$VideoLength = 81,
    
    [Parameter(Mandatory=$false)]
    [int]$InferSteps = 20,
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8,
    
    [Parameter(Mandatory=$false)]
    [string]$NegativePrompt,
    
    [Parameter(Mandatory=$false)]
    [double]$GuidanceScale = 5.0,
    
    [Parameter(Mandatory=$false)]
    [string]$FromFile,
    
    [Parameter(Mandatory=$false)]
    [switch]$Interactive
)

$MusubiTunerPath = "C:/path/to/musubi-tuner"
$PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
$ScriptPath = Join-Path $MusubiTunerPath "wan_generate_video.py"

if (-not (Test-Path $PythonExe)) {
    Write-Host "Error: Python executable not found at $PythonExe" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ScriptPath)) {
    Write-Host "Error: Script not found at $ScriptPath" -ForegroundColor Red
    exit 1
}

$Arguments = @(
    $ScriptPath
    "--task", $Task
    "--video_size", $VideoWidth, $VideoHeight
    "--video_length", $VideoLength
    "--infer_steps", $InferSteps
    "--save_path", $SavePath
    "--output_type", "both"
    "--dit", $DitPath
    "--vae", $VaePath
    "--t5", $T5Path
    "--attn_mode", "torch"
)

if ($Fp8) {
    $Arguments += "--fp8"
}

if ($DitHighNoise) {
    $Arguments += "--dit_high_noise", $DitHighNoise
}

if ($ClipPath) {
    $Arguments += "--clip", $ClipPath
}

if ($ImagePath) {
    $Arguments += "--image_path", $ImagePath
}

if ($NegativePrompt) {
    $Arguments += "--negative_prompt", $NegativePrompt
}

if ($GuidanceScale -ne 5.0) {
    $Arguments += "--guidance_scale", $GuidanceScale
}

if ($FromFile) {
    $Arguments += "--from_file", $FromFile
} elseif ($Interactive) {
    $Arguments += "--interactive"
} else {
    $Arguments += "--prompt", $Prompt
}

Write-Host "Generating video..." -ForegroundColor Cyan
Write-Host "Task: $Task" -ForegroundColor Yellow
Write-Host "Command: $PythonExe $($Arguments -join ' ')" -ForegroundColor Gray

& $PythonExe $Arguments

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Generation failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Video generation completed!" -ForegroundColor Green

