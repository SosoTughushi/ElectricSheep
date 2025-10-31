# Remote MCP Access Manager

Easy setup for remote MCP server access via SSH tunneling. Includes installer generation, credential management, and AI-friendly setup instructions.

## Quick Start

### As Server (Host Machine)

```powershell
.\scripts\setup-remote-access.ps1 -Mode server
```

This generates an installer package you can share.

### As Client (Remote Machine)

```powershell
.\scripts\setup-remote-access.ps1 -Mode client -SshHost myserver.com -SshUser myuser
```

Or use the generated installer package.

## Features

- ✅ Automated SSH tunnel setup
- ✅ Secure credential storage (encrypted)
- ✅ Installer package generation
- ✅ AI-friendly setup instructions
- ✅ Auto-download from GitHub
- ✅ Self-configuring installation

## Workflow

1. **Server side**: Generate installer package
2. **Client side**: Run installer with SSH credentials
3. **Installer**: Downloads repo, configures tunnel, stores credentials
4. **Client**: Connects via SSH tunnel to access MCP server

## Security

- Credentials stored encrypted locally
- SSH key-based authentication
- Automatic cleanup of sensitive data
- Secure configuration management

