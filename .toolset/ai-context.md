# AI Context for Electric Sheep Toolset

This document provides context for AI assistants working with this toolset.

## ⭐ IMPORTANT: Development Workflow Rules

**Before starting any work, read**: `rules/development-workflow.cursorrules`

These rules apply to **every message** during development and cover:
- Documenting changes as you go
- Updating manifests and registries
- When and how to update rulesets (only after resolving issues)
- Iterative documentation updates

## Repository Purpose

This repository is a collection of tools organized for AI-friendly discovery and execution. Tools are categorized by domain (system, AI, dev, misc) and each tool has standardized metadata.

## Key Principles

1. **Standardized Structure**: Each tool follows a consistent directory structure with MANIFEST.json
2. **Self-Documenting**: Tools include README files and manifests with clear descriptions
3. **Discoverable**: Tools are registered in `.toolset/registry.json`
4. **MCP Ready**: Structure supports MCP integration for remote control
5. **Documentation First**: Always update documentation when making changes (see development workflow rules)

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

See `rules/mcp-tool-integration.cursorrules` for complete workflow.

Quick steps:
1. Create tool directory in appropriate category
2. Add `MANIFEST.json` with tool metadata
3. Create `README.md` with documentation
4. Register tool in `.toolset/registry.json`
5. Add implementation files

## MCP Integration

The repository includes a fully functional MCP server:
- Tools are exposed as MCP resources/tools
- Standardized interfaces enable remote execution
- Configuration in `mcp/` directory
- See `mcp/README.md` for setup and usage

## Rules and Guidelines

- **Development Workflow**: `rules/development-workflow.cursorrules` (applies to every message)
- **Tool Integration**: `rules/mcp-tool-integration.cursorrules`
- **All Rules**: `rules/README.md`

