# Operations Discovery and Query System

## Overview

The Electric Sheep toolset provides a comprehensive operations discovery system that allows AI agents to query available operations without exposing sensitive information.

## Quick Query

**"What are my operations?"**

Use one of these methods:

### 1. Python Discovery Script
```powershell
python .toolset/discover_operations.py
```

### 2. Query Operations JSON
```powershell
Get-Content .toolset/operations.json | ConvertFrom-Json | Select-Object -ExpandProperty operations | Select-Object code, name, description
```

### 3. Read Cursor Rules
See `rules/toolset-operations.cursorrules` for human-readable descriptions

## Operation Codes

Operations are identified by code names following the pattern: `tool:action` or `tool:category:action`

### System Operations
- `bambu-lab:launch` - Launch Bambu Lab with auto-fix
- `bambu-lab:set-affinity` - Set CPU affinity for running process
- `bambu-lab:find-installation` - Find Bambu Studio installation
- `cpu-affinity:check` - Check CPU affinity for processes

### AI Operations
- `musubi-tuner:activate-env` - Activate virtual environment
- `musubi-tuner:wan:cache-latents` - Cache VAE latents
- `musubi-tuner:wan:cache-text-encoder` - Cache text encoder outputs
- `musubi-tuner:wan:train` - Train LoRA model
- `musubi-tuner:wan:generate` - Generate video

## Query Examples

### List All Operations
```powershell
python .toolset/discover_operations.py
```

### List by Category
```powershell
python .toolset/discover_operations.py --category system
python .toolset/discover_operations.py --category ai
```

### Get Operation Details
```powershell
python .toolset/discover_operations.py --code bambu-lab:launch
python .toolset/discover_operations.py --code musubi-tuner:wan:train
```

## Privacy & Security

### Public (Committed to Git)
- ✅ Operation codes and names
- ✅ Operation descriptions
- ✅ Parameter schemas
- ✅ Tool structure
- ✅ Entry points

### Private (Local Config Only)
- ❌ Installation paths
- ❌ Model file paths
- ❌ Dataset paths
- ❌ API keys
- ❌ User-specific preferences

### Configuration System

User-specific paths are stored in `.local/config.json` (gitignored):
1. Copy `.local/config.example.json` to `.local/config.json`
2. Fill in your actual paths
3. Scripts automatically load from config

## Remote Access

When MCP is implemented, operations will be queryable via:
- MCP protocol endpoints
- Remote discovery API
- Standardized operation registry

## For AI Agents

When asked "what are my operations?" or "what can I do?":

1. **Query operations.json**: Load and parse `.toolset/operations.json`
2. **Filter by context**: If user asks about specific category, filter by `category` field
3. **Return code names**: Present operations as code names with descriptions
4. **Provide details**: If user asks about specific operation, use `--code` query

Example response:
```
Available Operations:

System Operations:
  - bambu-lab:launch - Launch Bambu Lab with automatic CPU affinity fix
  - bambu-lab:set-affinity - Set CPU affinity for running Bambu Lab process
  - cpu-affinity:check - Check CPU affinity for processes

AI Operations:
  - musubi-tuner:wan:train - Train LoRA model using Wan architecture
  - musubi-tuner:wan:generate - Generate video with Wan model
  ...
```

## Files

- `.toolset/operations.json` - Operations registry (public, committable)
- `.toolset/discover_operations.py` - Discovery script
- `rules/toolset-operations.cursorrules` - Cursor rules for operations
- `.local/config.json` - User config (gitignored, not committed)
- `.local/config.example.json` - Config template (public, committable)

