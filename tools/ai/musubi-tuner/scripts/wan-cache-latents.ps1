# Cache Latents for Wan 2.1/2.2 Training
# Usage: .\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 -DatasetConfig "path/to/dataset.toml" -VaePath "path/to/vae.safetensors" -T5Path "path/to/t5.pth" [-ClipPath "path/to/clip.pth"] [-I2V]

param(
    [Parameter(Mandatory=$true)]
    [string]$DatasetConfig,
    
    [Parameter(Mandatory=$true)]
    [string]$VaePath,
    
    [Parameter(Mandatory=$true)]
    [string]$T5Path,
    
    [Parameter(Mandatory=$false)]
    [string]$ClipPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$I2V,
    
    [Parameter(Mandatory=$false)]
    [switch]$VaeCacheCpu
)

# Load configuration
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptRoot)
$ConfigScript = Join-Path $RepoRoot ".toolset\load_config.ps1"

if (Test-Path $ConfigScript) {
    . $ConfigScript
    $config = Get-LocalConfig
    
    if ($config -and $config.paths.musubi_tuner) {
        $MusubiTunerPath = $config.paths.musubi_tuner.installation_path
        $PythonExe = $config.paths.musubi_tuner.python_exe
    } else {
        Write-Warning "Musubi Tuner path not found in config. Using default."
        $MusubiTunerPath = "C:/path/to/musubi-tuner"
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
    }
} else {
    Write-Warning "Config loader not found. Using default path."
    $MusubiTunerPath = "C:/path/to/musubi-tuner"
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
}

$ScriptPath = Join-Path $MusubiTunerPath "wan_cache_latents.py"

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
    "--vae", $VaePath
    "--t5", $T5Path
)

if ($ClipPath) {
    $Arguments += "--clip", $ClipPath
}

if ($I2V) {
    $Arguments += "--i2v"
}

if ($VaeCacheCpu) {
    $Arguments += "--vae_cache_cpu"
}

Write-Host "Running latent caching..." -ForegroundColor Cyan
Write-Host "Command: $PythonExe $($Arguments -join ' ')" -ForegroundColor Gray

& $PythonExe $Arguments

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Caching failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Latent caching completed!" -ForegroundColor Green

