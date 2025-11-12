# Setup AI Article Writer Environment
# Installs Node.js dependencies

$ErrorActionPreference = "Stop"

Write-Host "=== AI Article Writer Environment Setup ===" -ForegroundColor Cyan

# Get script directory
# $PSScriptRoot is the scripts directory, so its parent is the tool root
$ToolRoot = Split-Path -Parent $PSScriptRoot
$PackageJson = Join-Path $ToolRoot "package.json"

Write-Host "Tool root: $ToolRoot" -ForegroundColor Yellow
Write-Host "Package file: $PackageJson" -ForegroundColor Yellow

# Check Node.js
Write-Host "`nChecking Node.js installation..." -ForegroundColor Cyan
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js is not installed. Please install Node.js 18+ from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

$nodeVersion = node --version
Write-Host "Found: Node.js $nodeVersion" -ForegroundColor Green

# Check Node.js version (should be 18+)
$versionMatch = $nodeVersion -match "v(\d+)\.(\d+)\.(\d+)"
if ($versionMatch) {
    $major = [int]$matches[1]
    if ($major -lt 18) {
        Write-Host "Warning: Node.js 18+ recommended. Found: $nodeVersion" -ForegroundColor Yellow
    }
}

# Check npm
Write-Host "`nChecking npm installation..." -ForegroundColor Cyan
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npm is not installed. npm should come with Node.js." -ForegroundColor Red
    exit 1
}

$npmVersion = npm --version
Write-Host "Found: npm $npmVersion" -ForegroundColor Green

# Check package.json
if (-not (Test-Path $PackageJson)) {
    Write-Host "Error: package.json not found at $PackageJson" -ForegroundColor Red
    Write-Host "Please ensure package.json exists in the tool directory." -ForegroundColor Yellow
    exit 1
}

# Install dependencies
Write-Host "`nInstalling dependencies..." -ForegroundColor Cyan
Push-Location $ToolRoot
npm install
$exitCode = $LASTEXITCODE
Pop-Location

if ($exitCode -ne 0) {
    Write-Host "Error: Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "Dependencies installed successfully" -ForegroundColor Green

# Verify installation
Write-Host "`nVerifying installation..." -ForegroundColor Cyan
$NodeModules = Join-Path $ToolRoot "node_modules"
if (Test-Path $NodeModules) {
    Write-Host "Node modules directory: $NodeModules" -ForegroundColor Green
    $moduleCount = (Get-ChildItem $NodeModules -Directory).Count
    Write-Host "Installed $moduleCount packages" -ForegroundColor Green
} else {
    Write-Host "Warning: node_modules directory not found" -ForegroundColor Yellow
}

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "You can now use the article writer:" -ForegroundColor Yellow
Write-Host "  .\tools\ai\ai-article-writer\scripts\generate-article.ps1 -Topic `"Your Topic`"" -ForegroundColor White
