# Electric Sheep Toolset

An AI-friendly collection of tools organized for easy discovery, execution, and **MCP (Model Context Protocol) integration** for remote access.

## Overview

This repository serves as a toolset workspace, organizing tools into clear categories with standardized metadata for AI assistants and automated systems. Each tool includes:

- **Standardized manifests** (`MANIFEST.json`) with metadata
- **Documentation** (`README.md`) with usage examples
- **Clear organization** by category (system, AI, dev, misc)
- **MCP Server** for remote access from Cursor, Claude Desktop, and other MCP clients

## Structure

```
electric-sheep/
├── tools/                  # Main toolset directory
│   ├── system/            # System/OS level tools
│   │   ├── bambu-lab/     # Bambu Lab CPU affinity management
│   │   └── cpu-affinity/  # CPU affinity utilities
│   ├── ai/                # AI/ML tools
│   │   ├── ai-article-writer/  # Article generation with 3 difficulty levels ✅
│   │   └── musubi-tuner/  # LoRA training toolkit
│   ├── dev/               # Development tools (future)
│   └── misc/              # Miscellaneous utilities (future)
│
├── .toolset/              # Toolset metadata
│   ├── registry.json      # Tool registry
│   ├── config.json        # Toolset configuration
│   └── ai-context.md      # AI context information
│
├── mcp/                   # MCP integration (planned)
├── docs/                  # Centralized documentation
├── rules/                 # Cursor rules
└── TOOLSET_STRUCTURE.md   # Detailed structure documentation
```

## Quick Start

### System Tools

**Bambu Lab CPU Affinity Manager:**
```powershell
# Launch Bambu Lab with auto-fix
.\tools\system\bambu-lab\scripts\bambulab-launcher.ps1

# Set affinity for running process
.\tools\system\bambu-lab\scripts\set-bambulab-affinity.ps1 -WaitForProcess
```

**CPU Affinity Checker:**
```powershell
.\tools\system\cpu-affinity\scripts\check-affinity.ps1
```

### AI Tools

**AI Article Writer:**
Generate articles with three difficulty levels and interactive HTML viewers:
```powershell
.\tools\ai\ai-article-writer\scripts\generate-article.ps1 -Topic "Your Topic"
```
See `tools/ai/ai-article-writer/README.md` for full documentation.
**Live Example**: https://sosotughushi.github.io/ElectricSheep/ai-first-repository-guide.html

**Musubi Tuner (LoRA Training):**
See `tools/ai/musubi-tuner/README.md` for full documentation.

## Tool Discovery

Tools are registered in `.toolset/registry.json` and include standardized manifests (`MANIFEST.json`) for AI discovery. Each tool directory contains:

- `MANIFEST.json` - Tool metadata and parameters
- `README.md` - Usage documentation
- `scripts/` or implementation files - Actual tool code

## Operations Discovery

**Query available operations:**

```powershell
# List all operations
python .toolset/discover_operations.py

# List by category
python .toolset/discover_operations.py --category system
python .toolset/discover_operations.py --category ai

# Get operation details
python .toolset/discover_operations.py --code bambu-lab:launch
```

See `docs/guides/operations-discovery.md` for full documentation.

**Operation codes** (short identifiers):
- `bambu-lab:launch` - Launch Bambu Lab with auto-fix
- `musubi-tuner:wan:train` - Train Wan LoRA model
- And more... (see operations registry)


## Categories

- **System**: OS-level tools, process management, hardware configuration
- **AI**: Machine learning tools, model training, inference
- **Dev**: Development utilities (to be added)
- **Misc**: Miscellaneous utilities (to be added)

## Documentation

### For AI Agents
- **Entry Point**: `AGENTS.md` ⭐ **Start here!** - Complete AI agent onboarding and workflow
- **Rules Index**: `rules/README.md` - Complete rules directory with onboarding path
- **Workflow Guide**: `docs/guides/ai-agent-workflow.md` - Comprehensive workflow guide
- **Quick Reference**: `docs/guides/quick-reference.md` - One-page cheat sheet

### General Documentation
- **Structure**: See `TOOLSET_STRUCTURE.md` for detailed architecture
- **Tool Registry**: See `.toolset/registry.json` for all registered tools
- **Tool Docs**: Each tool has its own `README.md` in its directory

## MCP Integration

✅ **MCP Server is now available!** Connect to this toolset from remote Cursor instances or other MCP clients.

**Quick Setup:**

1. Install dependencies:
   ```bash
   pip install -r mcp/requirements.txt
   ```

2. Configure your MCP client (see `mcp/SETUP.md` for details)

3. Connect and use operations like `bambu-lab:launch` or `musubi-tuner:wan:train`

See `mcp/README.md` and `mcp/SETUP.md` for full documentation.

## System Information

See `rules/system-info.cursorrules` for hardware and OS details.

## Privacy & Security

This repository is designed to be **safe for public GitHub**. See `rules/privacy-compliance.cursorrules` for complete privacy guidelines.

**Quick Summary:**
- ✅ **Public**: Operation codes, descriptions, tool structure, manifests
- ❌ **Private**: User paths, API keys, personal data (stored in `.local/config.json`)

**Configuration System:**
1. Copy `.local/config.example.json` to `.local/config.json`
2. Fill in your actual paths and settings
3. `.local/config.json` is gitignored and never committed
