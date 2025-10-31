# MCP Server Setup Guide

This guide explains how to set up and use the MCP server for the Electric Sheep toolset.

## Quick Start

1. **Install dependencies:**
   ```bash
   pip install -r mcp/requirements.txt
   ```

2. **Test the server locally:**
   ```bash
   python -m mcp.server.server
   ```

3. **Configure Cursor/Claude Desktop:**
   Add to your MCP configuration file (see below).

## Configuration

### For Cursor IDE

Create or edit `~/.cursor/mcp.json` (on Windows: `%APPDATA%\Cursor\mcp.json`):

```json
{
  "mcpServers": {
    "electric-sheep": {
      "command": "python",
      "args": [
        "-m",
        "mcp.server.server"
      ],
      "cwd": "YOUR_WORKSPACE_ROOT"
    }
  }
}
```

**Note:** Update the `cwd` path to your actual project root.

### For Claude Desktop

Edit `%APPDATA%\Claude\claude_desktop_config.json` (Windows) or `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS):

```json
{
  "mcpServers": {
    "electric-sheep": {
      "command": "python",
      "args": [
        "-m",
        "mcp.server.server"
      ],
      "cwd": "YOUR_WORKSPACE_ROOT"
    }
  }
}
```

### For Custom MCP Clients

The server uses stdio transport (standard input/output). Configure your client to:

1. Start the server process: `python -m mcp.server.server`
2. Communicate via JSON-RPC 2.0 messages over stdio
3. Use the workspace root as the current working directory

## Available Operations

Once connected, you can call these operations:

### System Operations

- **bambu-lab:launch** - Launch Bambu Lab with automatic CPU affinity fix
  - Parameters: `BambuLabPath` (optional), `AffinityCores` (optional), `WaitForProcess` (optional)

- **bambu-lab:set-affinity** - Set CPU affinity for running Bambu Lab process
  - Parameters: `WaitForProcess` (optional)

- **bambu-lab:find-installation** - Find Bambu Studio installation path
  - No parameters

- **cpu-affinity:check** - Check CPU affinity for processes
  - Parameters: `ProcessName` (optional), `ProcessId` (optional)

### AI Operations

- **musubi-tuner:wan:cache-latents** - Cache VAE latents for Wan training
- **musubi-tuner:wan:cache-text-encoder** - Cache text encoder outputs
- **musubi-tuner:wan:train** - Train LoRA model using Wan architecture
- **musubi-tuner:wan:generate** - Generate video with Wan model

## Testing

### Test Tool Discovery

```python
from mcp.server.tool_registry import ToolRegistry

registry = ToolRegistry()
operations = registry.get_operations()

for op in operations:
    print(f"{op['code']}: {op.get('name', '')}")
```

### Test Server Startup

```bash
# Should start without errors
python -m mcp.server.server

# Or with explicit workspace root
python -m mcp.server.server YOUR_WORKSPACE_ROOT
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'mcp'"

Install the MCP package:
```bash
pip install mcp
```

### "Registry not found"

Ensure you're running from the project root, or provide the workspace root as an argument:
```bash
python -m mcp.server.server /path/to/electric-sheep
```

### "Script not found"

Check that:
1. Tool manifests exist in `tools/*/MANIFEST.json`
2. Script paths in manifests are correct
3. Scripts exist at the specified paths

### PowerShell Execution Errors

The server uses `-ExecutionPolicy Bypass` to run PowerShell scripts. If you encounter issues:

1. Check PowerShell execution policy: `Get-ExecutionPolicy`
2. Ensure scripts are valid PowerShell
3. Check script paths are correct

## Architecture

```
┌─────────────────┐
│  MCP Client     │
│  (Cursor/Claude)│
└────────┬────────┘
         │ stdio (JSON-RPC)
         │
┌────────▼────────┐
│  MCP Server     │
│  (server.py)    │
└────────┬────────┘
         │
┌────────▼────────┐
│ Tool Registry   │
│ (tool_registry) │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼─────┐
│ .toolset│ │MANIFEST│
│registry │ │  files │
└─────────┘ └────────┘
         │
┌────────▼────────┐
│ PowerShell      │
│ Scripts         │
└─────────────────┘
```

## Security Considerations

⚠️ **Important**: The MCP server executes PowerShell scripts with your user permissions.

- Operations run with the same privileges as the user running the server
- No authentication is enabled by default
- For production use, consider:
  - Adding authentication
  - Restricting accessible operations
  - Running in a sandboxed environment
  - Auditing script execution

## Development

### Adding New Operations

1. Add tool to `.toolset/registry.json`
2. Create `MANIFEST.json` in tool directory
3. Update `tool_registry.py` if custom operation mapping needed
4. Restart server

### Modifying Operation Execution

Edit `execute_operation_sync()` in `server.py` to change how operations are executed.

### Debugging

Enable verbose logging by setting environment variable:
```bash
set MCP_LOG_LEVEL=DEBUG
python -m mcp.server.server
```

## Next Steps

- [ ] Add authentication support
- [ ] Add operation result caching
- [ ] Add operation execution history
- [ ] Add resource discovery (files, configs)
- [ ] Add prompt templates for common workflows

