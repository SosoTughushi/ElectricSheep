# Configure Cursor for Local LLM
# Provides instructions and opens Cursor settings

Write-Host "=== Cursor Configuration Helper ===" -ForegroundColor Cyan
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
Write-Host ""

# Check if Ollama is running
Write-Host "Checking if Ollama is running..." -ForegroundColor Yellow
try {
    $models = ollama list 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Ollama is running" -ForegroundColor Green
        Write-Host ""
        Write-Host "Available models:" -ForegroundColor Cyan
        $models | Select-Object -Skip 1 | ForEach-Object {
            if ($_ -match "^\s+(\S+)") {
                Write-Host "  - $($matches[1])" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "⚠ Ollama may not be running properly" -ForegroundColor Yellow
        Write-Host "  Try: ollama list" -ForegroundColor Gray
    }
} catch {
    Write-Host "⚠ Could not check Ollama status" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Configuration Instructions ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "To configure Cursor to use your local Ollama model:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Option 1: Direct Ollama Connection (Recommended)" -ForegroundColor Cyan
Write-Host "  1. Open Cursor Settings (Ctrl+,)" -ForegroundColor White
Write-Host "  2. Go to 'Models' section" -ForegroundColor White
Write-Host "  3. Set OpenAI API Key to: sk-ollama" -ForegroundColor White
Write-Host "  4. Enable 'Custom API Mode'" -ForegroundColor White
Write-Host "  5. Set Base URL to: http://localhost:11434/v1" -ForegroundColor White
Write-Host "  6. Select your model from the dropdown" -ForegroundColor White
Write-Host ""
Write-Host "Option 2: Using Proxy Server" -ForegroundColor Cyan
Write-Host "  1. Start proxy server:" -ForegroundColor Yellow
Write-Host "     .\scripts\start-proxy-server.ps1" -ForegroundColor White
Write-Host "  2. In Cursor Settings > Models:" -ForegroundColor White
Write-Host "     - Set OpenAI API Key: sk-proxy" -ForegroundColor White
Write-Host "     - Enable Custom API Mode" -ForegroundColor White
Write-Host "     - Set Base URL: http://localhost:8000" -ForegroundColor White
Write-Host ""

# Try to find Cursor installation
$cursorPaths = @(
    "$env:APPDATA\Cursor",
    "$env:LOCALAPPDATA\Programs\Cursor",
    "$env:ProgramFiles\Cursor",
    "$env:ProgramFiles(x86)\Cursor"
)

$cursorFound = $false
foreach ($path in $cursorPaths) {
    if (Test-Path $path) {
        Write-Host "✓ Found Cursor installation at: $path" -ForegroundColor Green
        $cursorFound = $true
        break
    }
}

if (-not $cursorFound) {
    Write-Host "⚠ Could not find Cursor installation automatically" -ForegroundColor Yellow
    Write-Host "  Please configure Cursor manually using the instructions above." -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Quick Test ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "After configuring Cursor, test your model:" -ForegroundColor Yellow
Write-Host "  1. Open Cursor" -ForegroundColor White
Write-Host "  2. Start a new chat" -ForegroundColor White
Write-Host "  3. Select your local model from the model selector" -ForegroundColor White
Write-Host "  4. Send a test message" -ForegroundColor White
Write-Host ""

Write-Host "For detailed documentation, see:" -ForegroundColor Cyan
Write-Host "  .\docs\CURSOR_SETUP.md" -ForegroundColor White
Write-Host ""

# Ask if user wants to open Cursor settings
$response = Read-Host "Would you like to open Cursor settings now? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host ""
    Write-Host "Opening Cursor..." -ForegroundColor Yellow
    try {
        Start-Process "cursor" -ErrorAction SilentlyContinue
        Write-Host "✓ Cursor should be opening. Use Ctrl+, to open settings." -ForegroundColor Green
    } catch {
        Write-Host "⚠ Could not open Cursor automatically. Please open it manually." -ForegroundColor Yellow
    }
}

Write-Host ""

