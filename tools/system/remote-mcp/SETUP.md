# AI-Friendly Setup Instructions for Remote MCP Access

## Overview

This package sets up remote access to the Electric Sheep MCP server via SSH tunneling. It can be installed on a remote machine (like your work laptop) to connect to your home MCP server.

## Installation Instructions

### Step 1: Download and Extract

```powershell
# Clone or download the repository
git clone https://github.com/YOUR_USERNAME/electric-sheep.git
cd electric-sheep
```

### Step 2: Run Setup

```powershell
# Run the remote access setup
.\tools\system\remote-mcp\scripts\setup-remote-access.ps1 -Mode client -SshHost YOUR_SERVER.com -SshUser YOUR_USERNAME
```

### Step 3: Configure Cursor

The installer will create a configuration file. Add to your Cursor MCP config:

```json
{
  "mcpServers": {
    "electric-sheep-remote": {
      "command": "python",
      "args": ["-m", "mcp.server.server"],
      "cwd": "C:/path/to/electric-sheep"
    }
  }
}
```

### Step 4: Start Tunnel

```powershell
.\tools\system\remote-mcp\scripts\start-tunnel.ps1
```

## What Gets Installed

- SSH tunnel configuration
- Encrypted credentials storage
- MCP server connection setup
- Cursor configuration updates

## Security Notes

- Credentials are encrypted and stored locally
- SSH keys are used for authentication
- Sensitive data is automatically cleaned up after setup
- No credentials are transmitted in plain text

## Troubleshooting

See `SETUP.md` for detailed troubleshooting steps.

