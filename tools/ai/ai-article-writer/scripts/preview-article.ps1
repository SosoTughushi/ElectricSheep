# Preview Article Script
# Opens generated HTML article in browser for local preview

param(
    [Parameter(Mandatory=$false)]
    [string]$ArticlePath = "../../../docs/ai-first-repository-guide.html",
    
    [switch]$Regenerate,
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

Write-Host "=== Article Preview ===" -ForegroundColor Cyan

# Get script directory and resolve paths
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ToolRoot = Split-Path -Parent $ScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ToolRoot))

# Resolve article path relative to repo root
if (-not [System.IO.Path]::IsPathRooted($ArticlePath)) {
    $ArticlePath = Join-Path $RepoRoot $ArticlePath
}

# Regenerate HTML if requested
if ($Regenerate) {
    Write-Host "`nRegenerating HTML..." -ForegroundColor Cyan
    
    # Find corresponding markdown file
    $MarkdownPath = $ArticlePath -replace '\.html$', '.md'
    
    if (-not (Test-Path $MarkdownPath)) {
        Write-Error "Markdown file not found: $MarkdownPath"
        exit 1
    }
    
    # Run article viewer generator
    Push-Location $ToolRoot
    node src/article-viewer.js --markdown $MarkdownPath --output $ArticlePath
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    if ($exitCode -ne 0) {
        Write-Error "Failed to regenerate HTML"
        exit $exitCode
    }
    
    Write-Host "HTML regenerated successfully!" -ForegroundColor Green
}

# Check if HTML file exists
if (-not (Test-Path $ArticlePath)) {
    Write-Error "HTML file not found: $ArticlePath"
    Write-Host "`nTip: Use -Regenerate to generate HTML from markdown" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nArticle: $ArticlePath" -ForegroundColor Yellow

# Check for Python (for simple HTTP server)
$hasPython = Get-Command python -ErrorAction SilentlyContinue
$hasPython3 = Get-Command python3 -ErrorAction SilentlyContinue

# Check for Node.js (for http-server)
$hasNode = Get-Command node -ErrorAction SilentlyContinue

# Determine which server to use
$useServer = $true
$serverCmd = $null

if ($hasPython3) {
    $serverCmd = "python3"
} elseif ($hasPython) {
    $serverCmd = "python"
} elseif ($hasNode) {
    # Check if http-server is available
    $hasHttpServer = Get-Command http-server -ErrorAction SilentlyContinue
    if ($hasHttpServer) {
        $serverCmd = "http-server"
    } else {
        Write-Host "`nInstalling http-server for preview..." -ForegroundColor Cyan
        npm install -g http-server
        $serverCmd = "http-server"
    }
} else {
    Write-Warning "No HTTP server found. Opening file directly (some features may not work)."
    $useServer = $false
}

if ($useServer) {
    # Get directory containing the HTML file
    $ArticleDir = Split-Path -Parent $ArticlePath
    $ArticleFile = Split-Path -Leaf $ArticlePath
    
    Write-Host "`nStarting local server..." -ForegroundColor Cyan
    Write-Host "Server will be available at: http://localhost:$Port/$ArticleFile" -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    
    # Start server in background
    Push-Location $ArticleDir
    
    if ($serverCmd -eq "python3" -or $serverCmd -eq "python") {
        # Python HTTP server
        Start-Process $serverCmd -ArgumentList "-m", "http.server", $Port.ToString() -NoNewWindow
        Start-Sleep -Seconds 2
        Start-Process "http://localhost:$Port/$ArticleFile"
    } else {
        # Node.js http-server
        Start-Process $serverCmd -ArgumentList "-p", $Port.ToString(), "-o", "/$ArticleFile" -NoNewWindow
    }
    
    Write-Host "`nServer started! Browser should open automatically." -ForegroundColor Green
    Write-Host "To stop the server, close this window or press Ctrl+C" -ForegroundColor Yellow
    
    Pop-Location
} else {
    # Open file directly
    Write-Host "`nOpening file in browser..." -ForegroundColor Cyan
    Start-Process $ArticlePath
    Write-Host "File opened! Note: Some features may not work when opening file directly." -ForegroundColor Yellow
}

Write-Host "`n=== Preview Started ===" -ForegroundColor Cyan

