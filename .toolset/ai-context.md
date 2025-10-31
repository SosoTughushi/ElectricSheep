# AI Context for Electric Sheep Toolset

This document provides context for AI assistants working with this toolset.

## Repository Purpose

This repository is a collection of tools organized for AI-friendly discovery and execution. Tools are categorized by domain (system, AI, dev, misc) and each tool has standardized metadata.

## Key Principles

1. **Standardized Structure**: Each tool follows a consistent directory structure with MANIFEST.json
2. **Self-Documenting**: Tools include README files and manifests with clear descriptions
3. **Discoverable**: Tools are registered in `.toolset/registry.json`
4. **MCP Ready**: Structure supports future MCP integration for remote control

## Tool Categories

### System Tools
- **Purpose**: OS-level operations, process management, hardware configuration
- **Location**: `tools/system/`
- **Examples**: CPU affinity management, process launchers

### AI Tools
- **Purpose**: Machine learning model training, inference, manipulation
- **Location**: `tools/ai/`
- **Examples**: LoRA training, model conversion

### Dev Tools
- **Purpose**: Development utilities and helpers
- **Location**: `tools/dev/`

### Misc Tools
- **Purpose**: Miscellaneous utilities
- **Location**: `tools/misc/`

## Finding Tools

1. Check `.toolset/registry.json` for registered tools
2. Look for `MANIFEST.json` in tool directories
3. Read `README.md` files in tool directories
4. Check category-specific documentation

## Tool Execution

- **Windows**: PowerShell scripts (`.ps1`)
- **Cross-platform**: Python scripts (`.py`)
- **Entry points**: Defined in tool manifests

## Adding New Tools

1. Create tool directory in appropriate category
2. Add `MANIFEST.json` with tool metadata
3. Create `README.md` with documentation
4. Register tool in `.toolset/registry.json`
5. Add implementation files

## MCP Integration

The repository is structured to support MCP integration:
- Tools can be exposed as MCP resources/tools
- Standardized interfaces enable remote execution
- Configuration in `mcp/` directory (when implemented)

