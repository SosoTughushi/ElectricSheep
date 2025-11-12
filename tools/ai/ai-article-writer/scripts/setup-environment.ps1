# Setup AI Article Writer Environment
# Creates Python virtual environment and installs dependencies

param(
    [string]$PythonVersion = "python",
    [string]$VenvPath = ".venv"
)

$ErrorActionPreference = "Stop"

Write-Host "=== AI Article Writer Environment Setup ===" -ForegroundColor Cyan

# Get script directory
# $PSScriptRoot is the scripts directory, so its parent is the tool root
$ToolRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ToolRoot)

# Set paths
$RequirementsFile = Join-Path $ToolRoot "requirements.txt"
$VenvFullPath = Join-Path $ToolRoot $VenvPath

Write-Host "Tool root: $ToolRoot" -ForegroundColor Yellow
Write-Host "Virtual environment: $VenvFullPath" -ForegroundColor Yellow
Write-Host "Requirements file: $RequirementsFile" -ForegroundColor Yellow

# Check Python
Write-Host "`nChecking Python installation..." -ForegroundColor Cyan
try {
    $versionOutput = & $PythonVersion --version 2>&1
    Write-Host "Found: $versionOutput" -ForegroundColor Green
    
    # Check Python version
    if ($versionOutput -match "Python (\d+)\.(\d+)") {
        $major = [int]$matches[1]
        $minor = [int]$matches[2]
        if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
            Write-Host "Error: Python 3.10 or later required. Found: $versionOutput" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Warning: Could not parse Python version from: $versionOutput" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error: Python not found. Please install Python 3.10 or later." -ForegroundColor Red
    exit 1
}

# Create virtual environment
Write-Host "`nCreating virtual environment..." -ForegroundColor Cyan
if (Test-Path $VenvFullPath) {
    Write-Host "Virtual environment already exists at $VenvFullPath" -ForegroundColor Yellow
    $response = Read-Host "Remove and recreate? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Remove-Item -Path $VenvFullPath -Recurse -Force
        Write-Host "Removed existing virtual environment" -ForegroundColor Yellow
    } else {
        Write-Host "Using existing virtual environment" -ForegroundColor Green
        $skipCreate = $true
    }
}

if (-not $skipCreate) {
    & $PythonVersion -m venv $VenvFullPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to create virtual environment" -ForegroundColor Red
        exit 1
    }
    Write-Host "Virtual environment created successfully" -ForegroundColor Green
}

# Activate virtual environment
Write-Host "`nActivating virtual environment..." -ForegroundColor Cyan
$ActivateScript = Join-Path $VenvFullPath "Scripts\Activate.ps1"
if (-not (Test-Path $ActivateScript)) {
    Write-Host "Error: Activation script not found at $ActivateScript" -ForegroundColor Red
    exit 1
}

& $ActivateScript
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to activate virtual environment" -ForegroundColor Red
    exit 1
}

# Upgrade pip
Write-Host "`nUpgrading pip..." -ForegroundColor Cyan
& python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Failed to upgrade pip" -ForegroundColor Yellow
}

# Install requirements
if (Test-Path $RequirementsFile) {
    Write-Host "`nInstalling dependencies from requirements.txt..." -ForegroundColor Cyan
    & python -m pip install -r $RequirementsFile
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
    Write-Host "Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "Warning: requirements.txt not found at $RequirementsFile" -ForegroundColor Yellow
}

# Verify installation
Write-Host "`nVerifying installation..." -ForegroundColor Cyan
$pythonExe = Join-Path $VenvFullPath "Scripts\python.exe"
if (Test-Path $pythonExe) {
    Write-Host "Python executable: $pythonExe" -ForegroundColor Green
    & $pythonExe --version
} else {
    Write-Host "Warning: Python executable not found" -ForegroundColor Yellow
}

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "To activate the environment, run:" -ForegroundColor Yellow
Write-Host "  & `"$ActivateScript`"" -ForegroundColor White
Write-Host "Or use the activation script:" -ForegroundColor Yellow
Write-Host "  .\tools\ai\ai-article-writer\scripts\activate.ps1" -ForegroundColor White

