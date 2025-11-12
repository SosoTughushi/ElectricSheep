# Verify AI Article Writer Environment
# Checks Node.js installation and dependencies (Node.js doesn't use virtual environments)

# Get script directory
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ToolRoot = Split-Path -Parent $ScriptRoot

Write-Host "=== AI Article Writer Environment Check ===" -ForegroundColor Cyan

# Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js is not installed. Please install Node.js 18+ from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

$nodeVersion = node --version
Write-Host "Node.js: $nodeVersion" -ForegroundColor Green

# Check npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npm is not installed. npm should come with Node.js." -ForegroundColor Red
    exit 1
}

$npmVersion = npm --version
Write-Host "npm: $npmVersion" -ForegroundColor Green

# Check dependencies
$NodeModules = Join-Path $ToolRoot "node_modules"
if (Test-Path $NodeModules) {
    Write-Host "Dependencies: Installed" -ForegroundColor Green
} else {
    Write-Host "Warning: Dependencies not installed. Run 'npm install' or setup-environment.ps1" -ForegroundColor Yellow
}

Write-Host "`nEnvironment ready!" -ForegroundColor Green
Write-Host "Note: Node.js doesn't use virtual environments like Python." -ForegroundColor Cyan
Write-Host "Dependencies are installed locally in node_modules/ directory." -ForegroundColor Cyan
