# Complete MemCP Setup Script
# Sets up everything possible automatically

Write-Host "=== Complete MemCP Setup ===" -ForegroundColor Cyan
Write-Host ""

# 1. Create configuration directory
$configDir = "$env:USERPROFILE\.memcp"
Write-Host "Creating configuration directory: $configDir" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

# 2. Create .env file with placeholders
Write-Host "Creating .env file with placeholders..." -ForegroundColor Yellow
$envContent = @"
# MemCP Environment Configuration
# Replace PLACEHOLDER values with your actual credentials

# Neo4j Database Configuration
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=PLACEHOLDER_REPLACE_WITH_YOUR_NEO4J_PASSWORD

# API Keys
OPENAI_API_KEY=PLACEHOLDER_REPLACE_WITH_YOUR_OPENAI_API_KEY
ANTHROPIC_API_KEY=PLACEHOLDER_REPLACE_WITH_YOUR_ANTHROPIC_API_KEY

# Server Configuration
MEMCP_PORT=8000
MEMCP_HOST=localhost
"@

$envFile = Join-Path $configDir ".env"
$envContent | Out-File -FilePath $envFile -Encoding UTF8
Write-Host "Created: $envFile" -ForegroundColor Green

# 3. Check for Docker and set up Neo4j if available
Write-Host ""
Write-Host "Checking for Docker..." -ForegroundColor Yellow
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker found! Setting up Neo4j..." -ForegroundColor Green
    
    # Check if Neo4j container already exists
    $existingContainer = docker ps -a --filter "name=neo4j-memcp" --format "{{.Names}}" 2>&1
    if ($existingContainer -eq "neo4j-memcp") {
        Write-Host "Neo4j container already exists. Starting it..." -ForegroundColor Yellow
        docker start neo4j-memcp 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Neo4j container started!" -ForegroundColor Green
        } else {
            Write-Host "Warning: Could not start existing container. You may need to recreate it." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Creating Neo4j container..." -ForegroundColor Yellow
        Write-Host "Note: You'll need to set a password. Using default 'memcp123' for now." -ForegroundColor Yellow
        Write-Host "You can change this later by editing the .env file and recreating the container." -ForegroundColor Yellow
        
        docker run -d `
            --name neo4j-memcp `
            -p 7474:7474 -p 7687:7687 `
            -e NEO4J_AUTH=neo4j/memcp123 `
            neo4j:latest 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Neo4j container created and started!" -ForegroundColor Green
            Write-Host "Default password: memcp123 (change in .env file)" -ForegroundColor Yellow
            
            # Update .env with default password
            (Get-Content $envFile) -replace "NEO4J_PASSWORD=PLACEHOLDER_REPLACE_WITH_YOUR_NEO4J_PASSWORD", "NEO4J_PASSWORD=memcp123" | Set-Content $envFile
        } else {
            Write-Host "Warning: Could not create Neo4j container. You may need Docker Desktop running." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Docker not found. Skipping Neo4j setup." -ForegroundColor Yellow
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  1. Install Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    Write-Host "  2. Install Neo4j Desktop: https://neo4j.com/download/" -ForegroundColor White
    Write-Host "  3. Use Neo4j Cloud: https://neo4j.com/cloud/" -ForegroundColor White
}

# 4. Check for existing Neo4j Desktop installation
Write-Host ""
Write-Host "Checking for Neo4j Desktop..." -ForegroundColor Yellow
$neo4jDesktopPaths = @(
    "$env:LOCALAPPDATA\Programs\Neo4j Desktop",
    "$env:PROGRAMFILES\Neo4j Desktop",
    "$env:PROGRAMFILES(X86)\Neo4j Desktop"
)

$neo4jFound = $false
foreach ($path in $neo4jDesktopPaths) {
    if (Test-Path $path) {
        Write-Host "Found Neo4j Desktop at: $path" -ForegroundColor Green
        Write-Host "Please start Neo4j Desktop and create a database, then update .env with your password." -ForegroundColor Yellow
        $neo4jFound = $true
        break
    }
}

if (-not $neo4jFound) {
    Write-Host "Neo4j Desktop not found in standard locations." -ForegroundColor Yellow
}

# 5. Update Cursor MCP configuration
Write-Host ""
Write-Host "Updating Cursor MCP configuration..." -ForegroundColor Yellow
$mcpConfigPath = "$env:APPDATA\Cursor\mcp.json"
$mcpConfigDir = Split-Path $mcpConfigPath -Parent

# Create directory if it doesn't exist
if (-not (Test-Path $mcpConfigDir)) {
    New-Item -ItemType Directory -Force -Path $mcpConfigDir | Out-Null
}

# Read existing config or create new
if (Test-Path $mcpConfigPath) {
    try {
        $mcpConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
        Write-Host "Found existing MCP configuration" -ForegroundColor Green
    } catch {
        Write-Host "Warning: Could not parse existing MCP config. Creating new one." -ForegroundColor Yellow
        $mcpConfig = @{
            mcpServers = @{}
        } | ConvertTo-Json | ConvertFrom-Json
    }
} else {
    Write-Host "Creating new MCP configuration" -ForegroundColor Yellow
    $mcpConfig = @{
        mcpServers = @{}
    } | ConvertTo-Json | ConvertFrom-Json
}

# Ensure mcpServers exists
if (-not $mcpConfig.mcpServers) {
    $mcpConfig | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value @{} -Force
}

# Add Electric Sheep if not present
if (-not $mcpConfig.mcpServers.'electric-sheep') {
    $mcpConfig.mcpServers | Add-Member -MemberType NoteProperty -Name "electric-sheep" -Value @{
        command = "python"
        args = @("-m", "mcp.server.server")
        cwd = (Get-Location).Path
    } -Force
    Write-Host "Added electric-sheep to MCP config" -ForegroundColor Green
}

# Add MemCP
if (-not $mcpConfig.mcpServers.MemCP) {
    $mcpConfig.mcpServers | Add-Member -MemberType NoteProperty -Name "MemCP" -Value @{
        transport = "sse"
        url = "http://localhost:8000/sse"
    } -Force
    Write-Host "Added MemCP to MCP config" -ForegroundColor Green
} else {
    Write-Host "MemCP already in MCP config" -ForegroundColor Yellow
}

# Save config
$mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
Write-Host "MCP configuration saved to: $mcpConfigPath" -ForegroundColor Green

# 6. Summary
Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Edit $envFile and replace PLACEHOLDER values:" -ForegroundColor White
Write-Host "   - NEO4J_PASSWORD: Your Neo4j password" -ForegroundColor White
Write-Host "   - OPENAI_API_KEY: Your OpenAI API key" -ForegroundColor White
Write-Host ""
Write-Host "2. Start MemCP server:" -ForegroundColor Yellow
Write-Host "   cd $configDir" -ForegroundColor White
Write-Host "   memcp" -ForegroundColor White
Write-Host ""
Write-Host "3. Restart Cursor IDE to load MemCP" -ForegroundColor Yellow
Write-Host ""
Write-Host "Configuration files:" -ForegroundColor Cyan
Write-Host "  - Environment: $envFile" -ForegroundColor White
Write-Host "  - MCP Config: $mcpConfigPath" -ForegroundColor White
Write-Host ""

