# Available NSFW Models for Local Installation

This document lists NSFW-capable models that can be installed locally via Ollama for use with Cursor.

## Recommended Models

### NSFW-3B-GGUF

- **Size**: ~3B parameters (~2GB)
- **Speed**: Fast (good for quick responses)
- **Quality**: Good for general NSFW content
- **RAM Usage**: ~4GB minimum
- **Best For**: Quick interactions, limited resources

**Install:**
```bash
ollama pull ysn-rfd/NSFW-3B-GGUF
```

**Use in Cursor:**
- Model name: `ysn-rfd/NSFW-3B-GGUF`

### Dolphin 2.2.1 Mistral 7B

- **Size**: ~7B parameters (~4GB)
- **Speed**: Medium (balanced speed/quality)
- **Quality**: Excellent, uncensored
- **RAM Usage**: ~8GB minimum
- **Best For**: Better quality responses, balanced performance

**Install:**
```bash
ollama pull dolphin-2.2.1-mistral-7b
```

**Use in Cursor:**
- Model name: `dolphin-2.2.1-mistral-7b`

### Llama 3 Uncensored

- **Size**: ~8B parameters (~4.5GB)
- **Speed**: Medium-Fast
- **Quality**: Excellent, based on Llama 3
- **RAM Usage**: ~10GB minimum
- **Best For**: High-quality uncensored responses

**Install:**
```bash
ollama pull llama3-uncensored
```

**Use in Cursor:**
- Model name: `llama3-uncensored`

## Other Available Models

### Qwen 2.5 Uncensored

- **Size**: ~7B parameters
- **Speed**: Medium
- **Quality**: Very good
- **RAM Usage**: ~8GB

**Install:**
```bash
ollama pull qwen2.5-uncensored
```

### Mistral 7B Instruct (Uncensored Variants)

- **Size**: ~7B parameters
- **Speed**: Medium
- **Quality**: Excellent instruction following
- **RAM Usage**: ~8GB

**Install:**
```bash
ollama pull mistral-uncensored
```

## Model Comparison

| Model | Size | Speed | Quality | RAM | Best For |
|-------|------|-------|---------|-----|----------|
| NSFW-3B | Small | Fast | Good | 4GB | Quick responses |
| Dolphin Mistral 7B | Medium | Medium | Excellent | 8GB | Balanced |
| Llama 3 Uncensored | Medium | Medium | Excellent | 10GB | Quality |
| Qwen 2.5 Uncensored | Medium | Medium | Very Good | 8GB | Multilingual |

## Installation Tips

1. **Start Small**: Begin with NSFW-3B if you have limited RAM (<8GB)
2. **Upgrade Later**: Move to larger models once comfortable
3. **Multiple Models**: Install multiple models and switch as needed
4. **Storage**: Models require 2-5GB storage each

## Finding More Models

Browse available models on:
- [Ollama Library](https://ollama.com/library)
- [Hugging Face](https://huggingface.co/models)
- Search for "uncensored" or "NSFW" models

## Model Management

**List installed models:**
```bash
ollama list
```

**Remove a model:**
```bash
ollama rm <model-name>
```

**Pull a model:**
```bash
ollama pull <model-name>
```

**Test a model:**
```bash
ollama run <model-name>
```

## System Requirements

### Minimum Requirements
- **RAM**: 8GB (for 3B models), 16GB (for 7B+ models)
- **Storage**: 10GB free space
- **CPU**: Modern multi-core CPU (GPU optional but recommended)

### Recommended Requirements
- **RAM**: 16GB+ (for 7B models)
- **GPU**: NVIDIA GPU with 8GB+ VRAM (for faster inference)
- **Storage**: 50GB+ free space (for multiple models)

## GPU Acceleration

Ollama automatically uses GPU if available. To check:

```bash
ollama run <model-name> --verbose
```

Look for GPU usage in the output. If no GPU is detected, models will run on CPU (slower but still functional).

## Troubleshooting Model Issues

### Model Download Fails
- Check internet connection
- Verify model name is correct
- Try downloading during off-peak hours
- Check available disk space

### Model Runs Slowly
- Ensure GPU is available and being used
- Close other GPU-intensive applications
- Try a smaller model
- Check system RAM usage

### Model Not Appearing in Cursor
- Restart Cursor
- Verify model is installed: `ollama list`
- Check Cursor Base URL is correct
- Try pulling model again

