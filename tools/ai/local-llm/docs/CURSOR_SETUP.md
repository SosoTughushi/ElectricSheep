# Cursor Setup Guide for Local NSFW Models

This guide will help you configure Cursor IDE to use a local NSFW-capable language model running through Ollama.

## Prerequisites

1. ✅ Ollama installed (run `.\scripts\install-ollama.ps1`)
2. ✅ NSFW model downloaded (run `.\scripts\setup-nsfw-model.ps1`)
3. ✅ Cursor IDE installed

## Quick Setup (Direct Ollama Connection)

This is the simplest method and works with Cursor's built-in OpenAI API compatibility.

### Step 1: Verify Ollama is Running

Open PowerShell and run:

```powershell
ollama list
```

You should see your installed models listed. If not, start Ollama:

```powershell
ollama serve
```

(Keep this terminal open, or run Ollama as a service)

### Step 2: Configure Cursor

1. **Open Cursor Settings**
   - Press `Ctrl+,` (or `Cmd+,` on Mac)
   - Or go to: File → Preferences → Settings

2. **Navigate to Models Section**
   - Click on "Models" in the left sidebar
   - Or search for "models" in settings

3. **Configure API Settings**
   - **OpenAI API Key**: Enter `sk-ollama` (or any value starting with `sk-`)
   - **Enable Custom API Mode**: Toggle this ON
   - **Base URL**: Set to `http://localhost:11434/v1`

4. **Select Your Model**
   - Click on the model dropdown
   - Your Ollama models should appear in the list
   - Select the NSFW model you installed (e.g., `nsfw-3b`)

5. **Save Settings**
   - Cursor should automatically save
   - Restart Cursor if the model doesn't appear

### Step 3: Test the Connection

1. Open a new chat in Cursor (`Ctrl+L` or `Cmd+L`)
2. Select your local model from the model selector
3. Send a test message
4. Verify you get a response

## Alternative Setup (Using Proxy Server)

If direct connection doesn't work, use a proxy server:

### Step 1: Start Proxy Server

```powershell
.\scripts\start-proxy-server.ps1 -ProxyPort 8000
```

Keep this terminal open while using Cursor.

### Step 2: Configure Cursor

1. Open Cursor Settings (`Ctrl+,`)
2. Go to Models section
3. Configure:
   - **OpenAI API Key**: `sk-proxy` (or any `sk-` prefixed value)
   - **Enable Custom API Mode**: ON
   - **Base URL**: `http://localhost:8000`
4. Select your model from dropdown
5. Save and test

## Troubleshooting

### Model Not Appearing in Cursor

**Problem**: Model doesn't show up in Cursor's model dropdown.

**Solutions**:
- Restart Cursor completely
- Verify Ollama is running: `ollama list`
- Check Base URL is correct: `http://localhost:11434/v1`
- Try pulling the model again: `ollama pull nsfw-3b`

### Connection Errors

**Problem**: Cursor shows connection errors.

**Solutions**:
- Ensure Ollama is running: `ollama serve`
- Check port 11434 is not blocked by firewall
- Verify Base URL format: `http://localhost:11434/v1` (note the `/v1` suffix)
- Try using proxy server instead

### API Key Format

**Problem**: Cursor rejects the API key.

**Solutions**:
- API key must start with `sk-`
- Examples: `sk-ollama`, `sk-proxy`, `sk-local`
- Cursor validates format but doesn't verify with Ollama

### Slow Responses

**Problem**: Model responses are slow.

**Solutions**:
- Check system resources (RAM/VRAM usage)
- Smaller models are faster (3B vs 7B+)
- Ensure GPU is being used if available
- Close other applications using GPU

### Model Not Responding

**Problem**: Model doesn't generate responses.

**Solutions**:
- Test model directly: `ollama run nsfw-3b`
- Check Ollama logs for errors
- Verify model is fully downloaded: `ollama list`
- Try reinstalling model: `ollama pull nsfw-3b`

## Advanced Configuration

### Running Ollama as a Service (Windows)

To run Ollama automatically on startup:

1. Create a scheduled task
2. Set trigger: "At startup"
3. Action: Start program `ollama.exe serve`
4. Set to run whether user is logged in or not

### Custom Model Names

If you've created custom models with `ollama create`, they'll appear in Cursor's model list automatically.

### Multiple Models

You can install multiple models and switch between them in Cursor:

```powershell
ollama pull nsfw-3b
ollama pull dolphin-2.2.1-mistral-7b
```

Both will appear in Cursor's model selector.

## Security Notes

⚠️ **Important**:
- Local models run entirely on your machine
- No data is sent to external servers
- NSFW models are uncensored - use responsibly
- Models can consume significant RAM (4-16GB+)

## Resources

- [Ollama Documentation](https://ollama.com/docs)
- [Ollama API Reference](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Cursor Documentation](https://cursor.sh/docs)
- [CursorCustomModels (Proxy)](https://github.com/rinadelph/CursorCustomModels)

## Next Steps

After setup:
- ✅ Test model with various prompts
- ✅ Configure model parameters if needed
- ✅ Set up multiple models for different use cases
- ✅ Consider running Ollama as a service for auto-start

## Getting Help

If you encounter issues:
1. Check Ollama is running: `ollama list`
2. Test model directly: `ollama run <model-name>`
3. Check Cursor logs for errors
4. Verify network connectivity
5. Review Ollama documentation

