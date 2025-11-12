# Install Ollama on Windows
# Downloads and installs Ollama framework for running local LLMs

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\Programs\Ollama"
)

Write-Host "=== Ollama Installation Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if Ollama is already installed
if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Ollama is already installed!" -ForegroundColor Green
    $version = ollama --version
    Write-Host "  Version: $version" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To reinstall, uninstall Ollama first or use: ollama uninstall" -ForegroundColor Yellow
    exit 0
}

Write-Host "Checking for existing Ollama installation..." -ForegroundColor Yellow

# Check common installation locations
$ollamaExe = @(
    "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe",
    "$env:ProgramFiles\Ollama\ollama.exe",
    "$env:ProgramFiles(x86)\Ollama\ollama.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($ollamaExe) {
    Write-Host "[OK] Found Ollama at: $ollamaExe" -ForegroundColor Green
    Write-Host "  Adding to PATH if not already present..." -ForegroundColor Yellow
    
    $ollamaDir = Split-Path $ollamaExe -Parent
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($currentPath -notlike "*$ollamaDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$ollamaDir", "User")
        Write-Host "[OK] Added Ollama to PATH" -ForegroundColor Green
        Write-Host "  Please restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    }
    
    exit 0
}

Write-Host "Ollama not found. Proceeding with installation..." -ForegroundColor Yellow
Write-Host ""

# Download Ollama installer
$installerUrl = "https://ollama.com/download/OllamaSetup.exe"
$installerPath = "$env:TEMP\OllamaSetup.exe"

Write-Host "Downloading Ollama installer..." -ForegroundColor Yellow
Write-Host "  URL: $installerUrl" -ForegroundColor Gray
Write-Host "  Destination: $installerPath" -ForegroundColor Gray

try {
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    Write-Host "[OK] Download complete" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Download failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "You can manually download Ollama from: https://ollama.com/download" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting Ollama installer..." -ForegroundColor Yellow
Write-Host "  Please follow the installation wizard." -ForegroundColor Gray
Write-Host "  The installer will add Ollama to your PATH automatically." -ForegroundColor Gray
Write-Host ""

# Run installer
Start-Process -FilePath $installerPath -Wait

# Clean up installer
if (Test-Path $installerPath) {
    Remove-Item $installerPath -Force
    Write-Host "[OK] Cleaned up installer file" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Yellow

# Refresh PATH in current session
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$machinePath;$userPath"

Start-Sleep -Seconds 2

# Check if ollama is now available
if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Ollama installed successfully!" -ForegroundColor Green
    $version = ollama --version
    Write-Host "  Version: $version" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Run: .\scripts\setup-nsfw-model.ps1" -ForegroundColor White
    Write-Host "  2. Follow: .\docs\CURSOR_SETUP.md" -ForegroundColor White
} else {
    Write-Host "[WARNING] Ollama may need a terminal restart to be available." -ForegroundColor Yellow
    Write-Host "  Please close and reopen your terminal, then run:" -ForegroundColor Yellow
    Write-Host "  ollama --version" -ForegroundColor White
    Write-Host ""
    Write-Host "If Ollama still isn't found, you may need to restart your computer." -ForegroundColor Yellow
}

Write-Host ""

