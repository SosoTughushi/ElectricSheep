# Local LLM Setup for Cursor

## Overview

This toolset helps you install and configure local NSFW-capable language models for use with Cursor IDE. It uses Ollama as the local model server and provides scripts to set up models and configure Cursor integration.

## Features

- ✅ Automated Ollama installation
- ✅ NSFW model download and setup
- ✅ Cursor configuration guide
- ✅ Proxy server setup (optional)
- ✅ Model management scripts

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges (for installation)
- Internet connection (for downloads)

## Quick Start

### Step 1: Install Ollama

```powershell
.\scripts\install-ollama.ps1
```

This script will:
- Download Ollama installer if not present
- Install Ollama on your system
- Verify installation

### Step 2: Setup NSFW Model

```powershell
.\scripts\setup-nsfw-model.ps1 -ModelName nsfw-3b
```

Available models:
- `nsfw-3b` - NSFW-3B-GGUF model (recommended)
- `dolphin-2.2.1-mistral-7b` - Dolphin Mistral 7B (uncensored)
- `llama3-uncensored` - Llama 3 uncensored variant

### Step 3: Configure Cursor

Follow the instructions in `docs/CURSOR_SETUP.md` to configure Cursor to use your local model.

## Scripts

### `install-ollama.ps1`

Installs Ollama framework on Windows.

**Usage:**
```powershell
.\scripts\install-ollama.ps1
```

**Features:**
- Downloads Ollama installer
- Installs to default location
- Adds to PATH
- Verifies installation

### `setup-nsfw-model.ps1`

Downloads and sets up an NSFW-capable model in Ollama.

**Usage:**
```powershell
.\scripts\setup-nsfw-model.ps1 -ModelName nsfw-3b
```

**Parameters:**
- `ModelName` (optional): Name of the model to install. Default: `nsfw-3b`

**Available Models:**
- `nsfw-3b` - Small, fast NSFW model (3B parameters)
- `dolphin-2.2.1-mistral-7b` - Dolphin Mistral 7B uncensored
- `llama3-uncensored` - Llama 3 uncensored

### `configure-cursor.ps1`

Opens Cursor settings and provides configuration instructions.

**Usage:**
```powershell
.\scripts\configure-cursor.ps1
```

This script will:
- Check if Cursor is installed
- Display configuration instructions
- Help you set up the OpenAI API key and custom API mode

### `start-proxy-server.ps1`

Starts a proxy server to connect Ollama with Cursor (if needed).

**Usage:**
```powershell
.\scripts\start-proxy-server.ps1 -ProxyPort 8000
```

**Note:** This requires Python and the `cursor-custom-models` package. See `docs/CURSOR_SETUP.md` for details.

## Configuration

### Using Ollama Directly (Recommended)

Ollama runs on `http://localhost:11434` by default. Cursor can connect directly if configured properly.

### Using Proxy Server

If direct connection doesn't work, use a proxy server that translates Cursor's API requests to Ollama's format.

## Model Information

### NSFW-3B-GGUF

- **Size:** ~3B parameters
- **Format:** GGUF
- **Speed:** Fast inference
- **Use Case:** General NSFW content without filtering

**Pull Command:**
```bash
ollama pull nsfw-3b
```

### Dolphin 2.2.1 Mistral 7B

- **Size:** ~7B parameters
- **Format:** GGUF
- **Speed:** Medium inference
- **Use Case:** More capable uncensored model

**Pull Command:**
```bash
ollama pull dolphin-2.2.1-mistral-7b
```

## Troubleshooting

### Ollama Not Found

If `ollama` command is not recognized:
1. Restart your terminal/PowerShell
2. Check if Ollama is in PATH: `$env:PATH -split ';' | Select-String ollama`
3. Reinstall Ollama if needed

### Model Download Fails

- Check internet connection
- Verify model name is correct
- Try pulling manually: `ollama pull <model-name>`

### Cursor Can't Connect

- Ensure Ollama is running: `ollama list`
- Check if port 11434 is accessible
- Verify proxy server is running (if using proxy)
- Check Cursor settings match configuration

### Model Not Showing in Cursor

- Restart Cursor after configuration
- Verify API key format (should start with `sk-...`)
- Check Custom API Mode is enabled
- Verify Base URL is correct (`http://localhost:11434` or proxy URL)

## Security Notes

⚠️ **Important:**
- Local models run entirely on your machine
- No data is sent to external servers
- NSFW models are uncensored - use responsibly
- Models consume significant RAM/VRAM - ensure adequate resources

## Resources

- [Ollama Documentation](https://ollama.com/docs)
- [Ollama Models](https://ollama.com/library)
- [Cursor Documentation](https://cursor.sh/docs)
- [Cursor Custom Models](https://github.com/rinadelph/CursorCustomModels)

## See Also

- `docs/CURSOR_SETUP.md` - Detailed Cursor configuration guide
- `docs/MODEL_LIST.md` - List of available NSFW models

