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

First-time setup creates a Python virtual environment and installs dependencies:

```powershell
.\tools\ai\ai-article-writer\scripts\setup-environment.ps1
```

### 2. Activate Environment

Before using the tool, activate the virtual environment:

```powershell
.\tools\ai\ai-article-writer\scripts\activate.ps1
```

### 3. Generate Article

Generate a complete article:

```powershell
.\tools\ai\ai-article-writer\scripts\generate-article.ps1 -Topic "Python Virtual Environments"
```

## Requirements

- Python 3.10 or later
- PowerShell (Windows) or Bash (Linux/Mac)
- Virtual environment (created by setup script)

## Dependencies

See `requirements.txt` for Python dependencies. Main packages include:
- `markdown` - Markdown processing
- `pyyaml` - YAML configuration parsing
- `jinja2` - Template rendering
- `mermaid` - Diagram generation support

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

The virtual environment is located at:
- **Path**: `tools/ai/ai-article-writer/.venv`
- **Activation**: `.\scripts\activate.ps1`
- **Python**: `.\scripts\activate.ps1` then use `python` command

## Troubleshooting

### Virtual Environment Not Found

If you see "Virtual environment not found", run the setup script:

```powershell
.\scripts\setup-environment.ps1
```

### Python Not Found

Ensure Python 3.10+ is installed and in your PATH:

```powershell
python --version
```

### Dependencies Missing

Reinstall dependencies:

```powershell
.\scripts\activate.ps1
pip install -r requirements.txt
```

## Documentation

- **Usage Guide**: `docs/USAGE.md`
- **Manifest**: `MANIFEST.json`
- **Registry**: `.toolset/registry.json`

