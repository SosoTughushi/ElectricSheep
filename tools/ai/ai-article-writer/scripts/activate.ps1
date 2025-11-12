# Activate AI Article Writer Virtual Environment
# This script activates the virtual environment for AI Article Writer tools

# Get script directory
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ToolRoot = Split-Path -Parent $ScriptRoot

# Default virtual environment path (relative to tool root)
$VenvPath = Join-Path $ToolRoot ".venv"

# Try to load configuration from .local/config.json
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptRoot)
$ConfigScript = Join-Path $RepoRoot ".toolset\load_config.ps1"

if (Test-Path $ConfigScript) {
    . $ConfigScript
    $config = Get-LocalConfig
    
    if ($config -and $config.paths -and $config.paths."ai-article-writer") {
        $VenvPath = $config.paths."ai-article-writer".venv_path
        Write-Host "Using configured venv path: $VenvPath" -ForegroundColor Cyan
    }
}

$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"

if (Test-Path $ActivateScript) {
    Write-Host "Activating AI Article Writer virtual environment..." -ForegroundColor Cyan
    & $ActivateScript
    Write-Host "Virtual environment activated!" -ForegroundColor Green
    Write-Host "Python location: $(Get-Command python | Select-Object -ExpandProperty Source)" -ForegroundColor Yellow
} else {
    Write-Host "Error: Virtual environment not found at $ActivateScript" -ForegroundColor Red
    Write-Host "Please run setup-environment.ps1 first to create the virtual environment" -ForegroundColor Yellow
    exit 1
}

