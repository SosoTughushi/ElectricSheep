# Setup NSFW Model in Ollama
# Downloads and configures an NSFW-capable model for use with Cursor

param(
    [string]$ModelName = "nsfw-3b"
)

Write-Host "=== NSFW Model Setup Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if Ollama is installed
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Ollama is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Ollama first:" -ForegroundColor Yellow
    Write-Host "  .\scripts\install-ollama.ps1" -ForegroundColor White
    exit 1
}

Write-Host "✓ Ollama is installed" -ForegroundColor Green
$version = ollama --version
Write-Host "  Version: $version" -ForegroundColor Gray
Write-Host ""

# Model mapping
$modelMap = @{
    "nsfw-3b" = "ysn-rfd/NSFW-3B-GGUF"
    "dolphin-2.2.1-mistral-7b" = "dolphin-2.2.1-mistral-7b"
    "llama3-uncensored" = "llama3-uncensored"
}

# Check if model name is valid
if (-not $modelMap.ContainsKey($ModelName)) {
    Write-Host "✗ Unknown model: $ModelName" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available models:" -ForegroundColor Yellow
    foreach ($key in $modelMap.Keys) {
        Write-Host "  - $key" -ForegroundColor White
    }
    exit 1
}

$modelTag = $modelMap[$ModelName]

Write-Host "Selected model: $ModelName" -ForegroundColor Cyan
Write-Host "  Tag: $modelTag" -ForegroundColor Gray
Write-Host ""

# Check if model is already installed
Write-Host "Checking for existing model..." -ForegroundColor Yellow
$existingModels = ollama list 2>&1

if ($existingModels -match $ModelName) {
    Write-Host "✓ Model '$ModelName' is already installed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To reinstall, remove it first:" -ForegroundColor Yellow
    Write-Host "  ollama rm $ModelName" -ForegroundColor White
    Write-Host ""
    Write-Host "To use the model:" -ForegroundColor Cyan
    Write-Host "  ollama run $ModelName" -ForegroundColor White
    exit 0
}

Write-Host "Model not found. Downloading..." -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠ Note: Model download may take several minutes depending on size and internet speed." -ForegroundColor Yellow
Write-Host "   Models are typically 2-14GB in size." -ForegroundColor Gray
Write-Host ""

# Pull the model
Write-Host "Pulling model: $modelTag" -ForegroundColor Cyan
Write-Host "  This may take a while..." -ForegroundColor Gray
Write-Host ""

try {
    ollama pull $modelTag
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "✓ Model '$ModelName' installed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "  1. Test the model:" -ForegroundColor Yellow
        Write-Host "     ollama run $ModelName" -ForegroundColor White
        Write-Host ""
        Write-Host "  2. Configure Cursor:" -ForegroundColor Yellow
        Write-Host "     See: .\docs\CURSOR_SETUP.md" -ForegroundColor White
        Write-Host ""
        Write-Host "  3. Or start proxy server:" -ForegroundColor Yellow
        Write-Host "     .\scripts\start-proxy-server.ps1" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "✗ Model download failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Troubleshooting:" -ForegroundColor Yellow
        Write-Host "  - Check your internet connection" -ForegroundColor Gray
        Write-Host "  - Verify model name: $modelTag" -ForegroundColor Gray
        Write-Host "  - Try pulling manually: ollama pull $modelTag" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Ensure Ollama is running: ollama list" -ForegroundColor Gray
    Write-Host "  - Check Ollama version: ollama --version" -ForegroundColor Gray
    exit 1
}

Write-Host ""

