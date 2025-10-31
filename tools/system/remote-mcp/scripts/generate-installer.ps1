<#
.SYNOPSIS
    Generate installer package for remote MCP access

.DESCRIPTION
    Creates a distributable installer package. Requires GitHub repository URL.
    Run this AFTER pushing to GitHub.

.PARAMETER GitHubUrl
    GitHub repository URL (e.g., https://github.com/username/electric-sheep)

.EXAMPLE
    .\generate-installer.ps1 -GitHubUrl https://github.com/myuser/electric-sheep
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUrl
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$toolsDir = Split-Path -Parent $scriptDir
$projectRoot = Split-Path -Parent (Split-Path -Parent $toolsDir)

Write-Host "`n=== Electric Sheep Remote Installer Generator ===`n" -ForegroundColor Cyan

# Validate GitHub URL
if ($GitHubUrl -notmatch '^https://github\.com/') {
    Write-Host "ERROR: Invalid GitHub URL. Use format: https://github.com/username/repo" -ForegroundColor Red
    exit 1
}

Write-Host "GitHub URL: $GitHubUrl" -ForegroundColor Gray
Write-Host "Project root: $projectRoot`n" -ForegroundColor Gray

# Create output directory
$installerDir = Join-Path $projectRoot "installers"
if (-not (Test-Path $installerDir)) {
    New-Item -ItemType Directory -Path $installerDir | Out-Null
    Write-Host "Created installer directory: $installerDir" -ForegroundColor Green
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$installerName = "electric-sheep-remote-installer-$timestamp"
$installerPath = Join-Path $installerDir $installerName

# Create temporary directory for installer contents
$tempDir = Join-Path $env:TEMP "electric-sheep-installer-$timestamp"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
    Write-Host "Collecting files..." -ForegroundColor Cyan
    
    # Copy essential files
    $filesToCopy = @(
        @{Source="tools\system\remote-mcp"; Dest="tools\system\remote-mcp"},
        @{Source="mcp\server"; Dest="mcp\server"},
        @{Source="mcp\requirements.txt"; Dest="mcp\requirements.txt"},
        @{Source=".toolset\registry.json"; Dest=".toolset\registry.json"},
        @{Source="README.md"; Dest="README.md"}
    )
    
    foreach ($item in $filesToCopy) {
        $source = Join-Path $projectRoot $item.Source
        $dest = Join-Path $tempDir $item.Dest
        
        if (Test-Path $source) {
            $destDir = Split-Path -Parent $dest
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            if (Test-Path $source -PathType Container) {
                Copy-Item -Path $source -Destination $dest -Recurse -Force
            } else {
                Copy-Item -Path $source -Destination $dest -Force
            }
            
            Write-Host "  ✓ $($item.Source)" -ForegroundColor Gray
        } else {
            Write-Host "  ⚠ Missing: $($item.Source)" -ForegroundColor Yellow
        }
    }
    
    # Create setup instructions
    Write-Host "`nCreating setup instructions..." -ForegroundColor Cyan
    
    $instructions = @"
# Electric Sheep Remote MCP Installer

## Quick Setup (AI-Friendly Instructions)

### Step 1: Extract
Extract this package to any directory (e.g., `C:\electric-sheep`)

### Step 2: Run Setup
Open PowerShell in the extracted directory and run:

```powershell
.\tools\system\remote-mcp\scripts\setup-remote-access.ps1 -Mode client -SshHost YOUR_SERVER -SshUser YOUR_USERNAME -GitHubUrl $GitHubUrl
```

**Replace:**
- `YOUR_SERVER` with your SSH server hostname/IP
- `YOUR_USERNAME` with your SSH username

### Step 3: Installer Will:
1. Clone/download repository from GitHub: $GitHubUrl
2. Install Python dependencies
3. Configure SSH tunnel
4. Store credentials securely (encrypted)
5. Configure Cursor MCP client automatically

### Step 4: Start Tunnel
```powershell
.\tools\system\remote-mcp\scripts\start-tunnel.ps1
```

### Step 5: Restart Cursor
The installer configures Cursor automatically. Just restart Cursor.

## What Gets Installed

- SSH tunnel configuration (encrypted credentials)
- MCP server connection
- Cursor MCP client configuration
- Python dependencies

## Security

- Credentials encrypted using Windows DPAPI
- Configuration stored in: `%USERPROFILE%\.electric-sheep\`
- SSH key-based authentication recommended

## Repository

$GitHubUrl

## Generated

$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## After Installation

Once installed and configured, this installer package can be safely deleted.
The installed files remain in the target directory.

## Troubleshooting

- If SSH connection fails, check your SSH credentials
- If MCP doesn't connect, verify tunnel is running
- Check Cursor MCP config: `%APPDATA%\Cursor\mcp.json`
"@
    
    $instructionsPath = Join-Path $tempDir "SETUP_INSTRUCTIONS.txt"
    $instructions | Out-File -FilePath $instructionsPath -Encoding UTF8
    
    # Create AI-friendly README for installer
    $installerReadme = @"
# Electric Sheep Remote MCP Installer

This installer sets up remote access to Electric Sheep MCP server via SSH tunneling.

## For AI Assistants

When helping users install this:

1. **Extract the package** to a directory
2. **Run setup script** with SSH credentials:
   ```powershell
   .\tools\system\remote-mcp\scripts\setup-remote-access.ps1 -Mode client -SshHost HOST -SshUser USER -GitHubUrl $GitHubUrl
   ```
3. **Start tunnel**: `.\tools\system\remote-mcp\scripts\start-tunnel.ps1`
4. **Restart Cursor**

The installer handles:
- Repository download/clone
- Dependency installation
- SSH tunnel configuration
- Credential encryption
- Cursor MCP setup

## Repository

$GitHubUrl

## Installation Date

$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@
    
    $installerReadme | Out-File -FilePath (Join-Path $tempDir "INSTALLER_README.md") -Encoding UTF8
    
    # Create zip file
    Write-Host "`nCreating archive..." -ForegroundColor Cyan
    $zipPath = "$installerPath.zip"
    
    # Use .NET compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $zipPath)
    
    Write-Host "`n✅ Installer created successfully!`n" -ForegroundColor Green
    Write-Host "Location: $zipPath" -ForegroundColor Cyan
    Write-Host "Size: $([math]::Round((Get-Item $zipPath).Length / 1KB, 2)) KB`n" -ForegroundColor Gray
    
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Share this installer file with remote users"
    Write-Host "2. They extract and run setup-remote-access.ps1"
    Write-Host "3. Installer will download from: $GitHubUrl`n"
    
    # Cleanup
    Remove-Item -Recurse -Force $tempDir
    
    Write-Host "Done! Installer ready for distribution." -ForegroundColor Green
}
catch {
    Write-Host "`n❌ Error: $_" -ForegroundColor Red
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    exit 1
}
