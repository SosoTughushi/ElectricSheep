# Cache Text Encoder Outputs for Wan 2.1/2.2 Training
# Usage: .\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1 -DatasetConfig "path/to/dataset.toml" -T5Path "path/to/t5.pth" [-BatchSize 16] [-Fp8T5]

param(
    [Parameter(Mandatory=$true)]
    [string]$DatasetConfig,
    
    [Parameter(Mandatory=$true)]
    [string]$T5Path,
    
    [Parameter(Mandatory=$false)]
    [int]$BatchSize = 16,
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8T5
)

# Load configuration
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
    $MusubiTunerPath = $Config.paths.musubi_tuner.installation_path
    $PythonExe = $Config.paths.musubi_tuner.python_exe
    if (-not $PythonExe -or -not (Test-Path $PythonExe)) {
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
    }
} else {
    Write-Warning ".local/config.json not found. Using default paths."
    $MusubiTunerPath = "E:\Stable Diffusion\musubi-tuner"
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
}

$ScriptPath = Join-Path $MusubiTunerPath "wan_cache_text_encoder_outputs.py"

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
    "--dataset_config", $DatasetConfig
    "--t5", $T5Path
    "--batch_size", $BatchSize
)

if ($Fp8T5) {
    $Arguments += "--fp8_t5"
}

Write-Host "Running text encoder caching..." -ForegroundColor Cyan
Write-Host "Command: $PythonExe $($Arguments -join ' ')" -ForegroundColor Gray

& $PythonExe $Arguments

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Caching failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Text encoder caching completed!" -ForegroundColor Green

