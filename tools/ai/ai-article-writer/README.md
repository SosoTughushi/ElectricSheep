# AI Article Writer

Main orchestrator tool for generating complete articles with text sections, diagrams, and complexity adaptation.

## Overview

The AI Article Writer coordinates multiple specialized tools to create complete articles:
- **Text Generation**: Creates article sections from prompts
- **Diagram Generation**: Generates Mermaid diagrams from descriptions
- **Complexity Adaptation**: Adjusts content complexity for different audiences
- **Article Composition**: Combines all elements into final article

## Quick Start

### 1. Setup Environment

First-time setup installs Node.js dependencies:

```powershell
cd tools\ai\ai-article-writer
npm install
```

Or use the setup script:

```powershell
.\tools\ai\ai-article-writer\scripts\setup-environment.ps1
```

### 2. Generate Article

Generate a complete article:

```powershell
.\tools\ai\ai-article-writer\scripts\generate-article.ps1 -Topic "Setting Up AI-First Repository"
```

## Requirements

- Node.js 18.0 or later
- npm (comes with Node.js)
- PowerShell (Windows) or Bash (Linux/Mac)

## Dependencies

See `package.json` for Node.js dependencies. Main packages include:
- `markdown` - Markdown processing
- `yaml` - YAML configuration parsing
- `ejs` - Template rendering
- Additional packages as needed for diagram generation

## Usage

### Basic Usage

```powershell
.\scripts\generate-article.ps1 -Topic "Your Topic Here"
```

### Advanced Usage

```powershell
.\scripts\generate-article.ps1 `
    -Topic "Advanced Python Topics" `
    -OutputPath "./docs/python-advanced.md" `
    -ComplexityLevel "advanced"
```

## Related Tools

This tool coordinates with:
- `ai-text-generator` - Generates text sections
- `ai-diagram-generator` - Creates diagrams
- `ai-complexity-adapter` - Adjusts complexity
- `ai-article-composer` - Composes final article

## Environment Setup

Node.js dependencies are installed locally:
- **Package file**: `tools/ai/ai-article-writer/package.json`
- **Dependencies**: `tools/ai/ai-article-writer/node_modules/`
- **Installation**: `npm install` (run from tool directory)

## Troubleshooting

### Node.js Not Found

Ensure Node.js 18+ is installed and in your PATH:

```powershell
node --version
npm --version
```

### Dependencies Missing

Reinstall dependencies:

```powershell
cd tools\ai\ai-article-writer
npm install
```

### Module Not Found Errors

If you see module errors, ensure dependencies are installed:

```powershell
npm install
```

## Documentation

- **Usage Guide**: `docs/USAGE.md`
- **Manifest**: `MANIFEST.json`
- **Registry**: `.toolset/registry.json`

