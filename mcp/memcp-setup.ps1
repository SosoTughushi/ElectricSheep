# MemCP Setup Script for Electric Sheep
# Installs and configures MemCP MCP server for conversation memory

param(
    [string]$InstallPath = "$PSScriptRoot\..\tools\mcp\memcp",
    [switch]$SkipNeo4j,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
MemCP Setup Script

Installs MemCP (Memory Context Protocol) server for persistent AI conversation memory.

Requirements:
- Python 3.10 or higher
- Neo4j database (or use Docker)
- OpenAI API key

Usage:
    .\memcp-setup.ps1 [-InstallPath <path>] [-SkipNeo4j] [-Help]

Parameters:
    -InstallPath    Where to install MemCP (default: tools/mcp/memcp)
    -SkipNeo4j     Skip Neo4j setup instructions
    -Help          Show this help message

Examples:
    .\memcp-setup.ps1
    .\memcp-setup.ps1 -InstallPath "C:\memcp"
"@
    exit 0
}

Write-Host "=== MemCP Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check Python version
Write-Host "Checking Python installation..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python not found. Please install Python 3.10 or higher." -ForegroundColor Red
    exit 1
}

Write-Host "Found: $pythonVersion" -ForegroundColor Green

# Check if Python 3.10+
$versionMatch = $pythonVersion -match "Python (\d+)\.(\d+)"
if ($versionMatch) {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
        Write-Host "ERROR: Python 3.10+ required. Found: $pythonVersion" -ForegroundColor Red
        exit 1
    }
}

# Create install directory
Write-Host ""
Write-Host "Creating installation directory: $InstallPath" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

# Clone or install MemCP
Write-Host ""
Write-Host "Installing MemCP..." -ForegroundColor Yellow

$originalLocation = Get-Location
Set-Location $InstallPath

# Try pip install first (simpler)
Write-Host "Attempting pip install..." -ForegroundColor Yellow
pip install memcp 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "MemCP installed via pip" -ForegroundColor Green
} else {
    Write-Host "pip install failed, trying git clone..." -ForegroundColor Yellow
    # Fallback to git clone
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone https://github.com/evanmschultz/memcp.git . 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Cloned MemCP repository" -ForegroundColor Green
            pip install -r requirements.txt 2>&1 | Out-Null
        } else {
            Write-Host "ERROR: Failed to clone repository" -ForegroundColor Red
            Set-Location $originalLocation
            exit 1
        }
    } else {
        Write-Host "ERROR: git not found. Please install git or use pip install memcp manually." -ForegroundColor Red
        Set-Location $originalLocation
        exit 1
    }
}

Set-Location $originalLocation

# Create .env template
Write-Host ""
Write-Host "Creating environment configuration template..." -ForegroundColor Yellow
$envTemplate = @"
# MemCP Environment Configuration
# Copy this file to .env and fill in your actual values

# Neo4j Database Configuration
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_neo4j_password_here

# API Keys
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here  # Optional

# Server Configuration
MEMCP_PORT=8000
MEMCP_HOST=localhost
"@

$envTemplatePath = Join-Path $InstallPath ".env.example"
$envTemplate | Out-File -FilePath $envTemplatePath -Encoding UTF8
Write-Host "Created: $envTemplatePath" -ForegroundColor Green

# Create configuration guide
Write-Host ""
Write-Host "Creating setup guide..." -ForegroundColor Yellow
$guidePath = Join-Path $InstallPath "SETUP_GUIDE.md"
$guideContent = @"
# MemCP Setup Guide

## Installation Complete!

MemCP has been installed to: $InstallPath

## Next Steps

### 1. Set Up Neo4j Database

MemCP requires a Neo4j database. You have two options:

#### Option A: Docker (Recommended)
```powershell
docker run -d `
    --name neo4j-memcp `
    -p 7474:7474 -p 7687:7687 `
    -e NEO4J_AUTH=neo4j/your_password_here `
    neo4j:latest
```

#### Option B: Install Neo4j Desktop
1. Download from https://neo4j.com/download/
2. Install and create a new database
3. Note your password

### 2. Configure Environment Variables

1. Copy `.env.example` to `.env`:
   ```powershell
   Copy-Item .env.example .env
   ```

2. Edit `.env` and fill in:
   - `NEO4J_PASSWORD`: Your Neo4j password
   - `OPENAI_API_KEY`: Your OpenAI API key
   - `ANTHROPIC_API_KEY`: (Optional) Your Anthropic API key

### 3. Start MemCP Server

```powershell
cd $InstallPath
memcp
```

Or if installed via git:
```powershell
cd $InstallPath
python memcp.py
```

The server will start on http://localhost:8000

### 4. Configure MCP Client

Add to your Cursor MCP configuration (`%APPDATA%\Cursor\mcp.json`):

```json
{
  "mcpServers": {
    "electric-sheep": {
      "command": "python",
      "args": ["-m", "mcp.server.server"],
      "cwd": "YOUR_WORKSPACE_ROOT"
    },
    "MemCP": {
      "transport": "sse",
      "url": "http://localhost:8000/sse"
    }
  }
}
```

### 5. Restart Cursor

Restart Cursor IDE to load the new MCP server configuration.

## Usage

Once configured, you can:

- **Explicit memory**: "Remember that this conversation was about installing MemCP"
- **Automatic memory**: MemCP will automatically capture context from conversations
- **Retrieve memories**: "What did we discuss about MCP servers?"

## Troubleshooting

### Server won't start
- Check Neo4j is running: `docker ps` or check Neo4j Desktop
- Verify `.env` file exists and has correct values
- Check port 8000 is not in use

### Connection errors
- Ensure MemCP server is running before starting Cursor
- Check firewall settings for port 8000
- Verify SSE transport is supported by your MCP client

### Memory not working
- Check MemCP server logs for errors
- Verify Neo4j connection in `.env`
- Ensure OpenAI API key is valid

## More Information

- GitHub: https://github.com/evanmschultz/memcp
- Documentation: https://mcp.altinors.com
"@

$guideContent | Out-File -FilePath $guidePath -Encoding UTF8
Write-Host "Created: $guidePath" -ForegroundColor Green

# Neo4j setup instructions
if (-not $SkipNeo4j) {
    Write-Host ""
    Write-Host "=== Neo4j Setup Required ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "MemCP requires a Neo4j database. Choose one:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1: Docker (Recommended)" -ForegroundColor Green
    Write-Host "  docker run -d --name neo4j-memcp -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/your_password neo4j:latest"
    Write-Host ""
    Write-Host "Option 2: Neo4j Desktop" -ForegroundColor Green
    Write-Host "  Download from https://neo4j.com/download/"
    Write-Host ""
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Set up Neo4j database (see $guidePath)" -ForegroundColor White
Write-Host "2. Configure .env file (copy .env.example to .env)" -ForegroundColor White
Write-Host "3. Start MemCP server: cd $InstallPath; memcp" -ForegroundColor White
Write-Host "4. Add MemCP to MCP client configuration" -ForegroundColor White
Write-Host "5. See $guidePath for detailed instructions" -ForegroundColor White
Write-Host ""

