# Electric Sheep Toolset Structure

## Overview

This repository is organized as an AI-friendly toolset, designed for easy discovery, understanding, and future MCP (Model Context Protocol) integration.

## Directory Structure

```
electric-sheep/
├── tools/                          # Main toolset directory
│   ├── system/                    # System/OS level tools
│   │   ├── bambu-lab/            # Bambu Lab related tools
│   │   │   ├── MANIFEST.json     # Tool metadata for AI discovery
│   │   │   ├── README.md         # Tool documentation
│   │   │   ├── scripts/          # Implementation scripts
│   │   │   └── docs/             # Tool-specific docs
│   │   └── cpu-affinity/         # CPU affinity management tools
│   │       ├── MANIFEST.json
│   │       ├── README.md
│   │       └── scripts/
│   │
│   ├── ai/                        # AI/ML tools
│   │   ├── musubi-tuner/         # LoRA training toolkit
│   │   │   ├── MANIFEST.json
│   │   │   ├── README.md
│   │   │   └── [existing structure]
│   │   └── [future AI tools]
│   │
│   ├── dev/                       # Development tools
│   │   └── [future dev tools]
│   │
│   └── misc/                      # Miscellaneous utilities
│       └── [misc tools]
│
├── mcp/                           # MCP integration (future)
│   ├── server/                    # MCP server implementation
│   ├── tools/                     # MCP tool definitions
│   ├── config/                    # MCP configuration
│   └── README.md
│
├── docs/                          # Centralized documentation
│   ├── guides/                    # User guides
│   ├── api/                       # API documentation
│   └── architecture/              # Architecture docs
│
├── .toolset/                      # Toolset metadata
│   ├── registry.json              # Tool registry
│   ├── config.json                # Toolset configuration
│   └── ai-context.md              # AI context information
│
├── rules/                         # Cursor rules (maintained)
├── README.md                      # Main repository README
└── TOOLSET_STRUCTURE.md           # This file

```

## Tool Manifest Format

Each tool directory contains a `MANIFEST.json` file with standardized metadata:

```json
{
  "id": "tool-unique-id",
  "name": "Human Readable Name",
  "description": "Brief description of what the tool does",
  "category": "system|ai|dev|misc",
  "version": "1.0.0",
  "author": "Your Name",
  "tags": ["tag1", "tag2"],
  "platforms": ["windows", "linux"],
  "dependencies": {
    "runtime": ["powershell", "python"],
    "external": []
  },
  "entry_points": {
    "primary": "scripts/main.ps1",
    "alternatives": []
  },
  "parameters": [
    {
      "name": "param1",
      "type": "string",
      "required": true,
      "description": "Parameter description"
    }
  ],
  "examples": [
    {
      "description": "Example usage",
      "command": ".\scripts\main.ps1 -param1 value"
    }
  ],
  "ai_friendly": {
    "context": "Additional context for AI understanding",
    "common_use_cases": ["use case 1", "use case 2"],
    "related_tools": ["tool-id-1", "tool-id-2"]
  }
}
```

## MCP Integration Plan

The MCP structure will allow remote control of tools via Model Context Protocol:

1. **Tool Discovery**: Tools are registered in `.toolset/registry.json`
2. **MCP Server**: Exposes tools as MCP resources/tools
3. **Tool Wrappers**: Standardized interface for executing tools
4. **Configuration**: Tool-specific configs for MCP exposure

## AI-Friendly Features

1. **Standardized Manifests**: Each tool has structured metadata
2. **Clear Documentation**: README files with examples
3. **Tool Registry**: Central registry for discovery
4. **Context Files**: AI context information for understanding
5. **Consistent Structure**: Predictable organization

## Migration Plan

1. Create new directory structure
2. Move existing tools to appropriate categories
3. Generate manifests for each tool
4. Update documentation
5. Create tool registry
6. Prepare MCP skeleton

