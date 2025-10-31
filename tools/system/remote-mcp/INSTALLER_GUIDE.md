# Quick Installer Generation Guide

## Before Generating Installer

1. **Push to GitHub first:**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/electric-sheep.git
   git push -u origin main
   ```

2. **Get your GitHub URL:**
   ```
   https://github.com/YOUR_USERNAME/electric-sheep
   ```

3. **Generate installer:**
   ```powershell
   .\tools\system\remote-mcp\scripts\generate-installer.ps1 -GitHubUrl https://github.com/YOUR_USERNAME/electric-sheep
   ```

## What Gets Created

- `installers/electric-sheep-remote-installer-YYYYMMDD-HHMMSS.zip`
- Contains: remote-mcp scripts, MCP server, setup instructions
- AI-friendly instructions included

## After Generation

Share the installer zip file. Users extract and run:
```powershell
.\tools\system\remote-mcp\scripts\setup-remote-access.ps1 -Mode client -SshHost SERVER -SshUser USER -GitHubUrl YOUR_GITHUB_URL
```

The installer will:
- Clone repo from GitHub
- Install dependencies
- Configure SSH tunnel
- Set up Cursor MCP

