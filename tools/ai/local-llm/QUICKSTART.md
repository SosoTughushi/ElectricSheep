# Quick Start Guide

Get your local NSFW model running in Cursor in 3 simple steps!

## Step 1: Install Ollama

```powershell
cd tools\ai\local-llm
.\scripts\install-ollama.ps1
```

This will download and install Ollama automatically.

## Step 2: Download NSFW Model

```powershell
.\scripts\setup-nsfw-model.ps1 -ModelName nsfw-3b
```

This downloads the NSFW-3B model (~2GB). You can use other models like:
- `dolphin-2.2.1-mistral-7b` (better quality, ~4GB)
- `llama3-uncensored` (high quality, ~4.5GB)

## Step 3: Configure Cursor

```powershell
.\scripts\configure-cursor.ps1
```

Or manually:
1. Open Cursor Settings (`Ctrl+,`)
2. Go to **Models** section
3. Set **OpenAI API Key**: `sk-ollama`
4. Enable **Custom API Mode**
5. Set **Base URL**: `http://localhost:11434/v1`
6. Select your model from dropdown
7. Done! 🎉

## Test It

1. Open Cursor
2. Start a new chat (`Ctrl+L`)
3. Select your local model
4. Send a message!

## Troubleshooting

**Model not appearing?**
- Restart Cursor
- Verify Ollama is running: `ollama list`
- Check Base URL has `/v1` suffix

**Connection errors?**
- Start Ollama: `ollama serve` (keep terminal open)
- Or use proxy: `.\scripts\start-proxy-server.ps1`

## Need More Help?

- **Full Setup Guide**: `docs\CURSOR_SETUP.md`
- **Model List**: `docs\MODEL_LIST.md`
- **Main README**: `README.md`

## Quick Commands Reference

```powershell
# Check Ollama status
ollama list

# Test model directly
ollama run nsfw-3b

# Install another model
ollama pull dolphin-2.2.1-mistral-7b

# Remove a model
ollama rm nsfw-3b

# Start Ollama server
ollama serve
```

Happy coding! 🚀

