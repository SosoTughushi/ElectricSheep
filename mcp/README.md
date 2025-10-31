# Electric Sheep MCP Server

This MCP server exposes all available operations from the Electric Sheep toolset to remote Cursor instances or other MCP clients.

## Installation

Install the required dependencies:

```bash
pip install -r mcp/requirements.txt
```

Or install directly:

```bash
pip install mcp
```

## Running the Server

### As a Standalone Server

```bash
python -m mcp.server.server
```

Or specify a workspace root:

```bash
python -m mcp.server.server /path/to/workspace
```

### Via MCP Client Configuration

Add to your Cursor MCP configuration (typically `~/.cursor/mcp.json` or similar):

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

## Available Operations

The server automatically discovers and exposes all operations from:

- **System Tools**: `tools/system/*/MANIFEST.json`
- **AI Tools**: `tools/ai/*/MANIFEST.json`

### System Operations

- `bambu-lab:launch` - Launch Bambu Lab with automatic CPU affinity fix
- `bambu-lab:set-affinity` - Set CPU affinity for running Bambu Lab process
- `bambu-lab:find-installation` - Find Bambu Studio installation path
- `cpu-affinity:check` - Check CPU affinity for processes

### AI Operations

- `musubi-tuner:wan:cache-latents` - Cache VAE latents for Wan training
- `musubi-tuner:wan:cache-text-encoder` - Cache text encoder outputs
- `musubi-tuner:wan:train` - Train LoRA model using Wan architecture
- `musubi-tuner:wan:generate` - Generate video with Wan model

## How It Works

1. **Tool Discovery**: The server reads `.toolset/registry.json` to find registered tools
2. **Manifest Loading**: For each tool, it loads `MANIFEST.json` to get operation details
3. **Operation Mapping**: It maps tools to operations based on entry points and tool-specific logic
4. **Execution**: When an operation is called, it executes the corresponding PowerShell script

## Remote Connection

The server uses stdio transport by default, which works with:

- Cursor IDE MCP integration
- Claude Desktop MCP integration
- Any MCP-compatible client

## Security

- Operations execute PowerShell scripts with the user's permissions
- No authentication by default (stdio transport)
- For production use, consider adding authentication and access controls

## Troubleshooting

### Module Not Found

If you get `ModuleNotFoundError`, ensure you're running from the project root:

```bash
cd YOUR_WORKSPACE_ROOT
python -m mcp.server.server
```

### Script Not Found

Ensure all tool manifests reference correct script paths relative to the tool directory.

### PowerShell Execution Policy

The server uses `-ExecutionPolicy Bypass` to run PowerShell scripts. If you encounter issues, check your PowerShell execution policy.

## Development

To modify the server:

1. Edit `mcp/server/server.py` - Main server implementation
2. Edit `mcp/server/tool_registry.py` - Tool discovery logic
3. Restart the server to apply changes

## Architecture

```
mcp/
├── server/
│   ├── __init__.py          # Package initialization
│   ├── server.py            # Main MCP server
│   └── tool_registry.py     # Tool discovery and loading
├── config/
│   └── server.json          # Server configuration
├── requirements.txt         # Python dependencies
└── README.md               # This file
```
