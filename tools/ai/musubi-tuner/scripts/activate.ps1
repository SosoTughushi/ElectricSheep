# Activate Musubi Tuner Virtual Environment
# This script activates the virtual environment for Musubi Tuner
# Loads configuration from .local/config.json

# Load configuration
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptRoot)
$ConfigScript = Join-Path $RepoRoot ".toolset\load_config.ps1"

if (Test-Path $ConfigScript) {
    . $ConfigScript
    $config = Get-LocalConfig
    
    if ($config -and $config.paths.musubi_tuner) {
        $MusubiTunerPath = $config.paths.musubi_tuner.installation_path
        $VenvPath = $config.paths.musubi_tuner.venv_path
    } else {
        Write-Warning "Musubi Tuner path not found in config. Using default."
        $MusubiTunerPath = "C:/path/to/musubi-tuner"
        $VenvPath = Join-Path $MusubiTunerPath "venv"
    }
} else {
    Write-Warning "Config loader not found. Using default path."
    $MusubiTunerPath = "C:/path/to/musubi-tuner"
    $VenvPath = Join-Path $MusubiTunerPath "venv"
}

$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"

if (Test-Path $ActivateScript) {
    Write-Host "Activating Musubi Tuner virtual environment..." -ForegroundColor Cyan
    & $ActivateScript
    Write-Host "Virtual environment activated!" -ForegroundColor Green
    Write-Host "Python location: $(Get-Command python | Select-Object -ExpandProperty Source)" -ForegroundColor Yellow
} else {
    Write-Host "Error: Virtual environment not found at $ActivateScript" -ForegroundColor Red
    Write-Host "Please ensure Musubi Tuner is installed and configured in .local/config.json" -ForegroundColor Yellow
    exit 1
}

