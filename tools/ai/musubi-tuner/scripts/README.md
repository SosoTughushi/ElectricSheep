# Musubi Tuner Helper Scripts

PowerShell wrapper scripts for easy access to Musubi Tuner from the Cursor workspace.

## Usage

All scripts can be run from the workspace root:

### Activate Environment

```powershell
.\tools\ai\musubi-tuner\scripts\activate.ps1
```

### Cache Latents

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -VaeCacheCpu
```

For Wan 2.2 (no CLIP):
```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth"
```

For I2V:
```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-latents.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -I2V
```

### Cache Text Encoder Outputs

```powershell
.\tools\ai\musubi-tuner\scripts\wan-cache-text-encoder.ps1 `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -T5Path "C:/path/to/t5.pth" `
    -BatchSize 16 `
    -Fp8T5
```

### Train LoRA

```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-14B" `
    -DitPath "C:/path/to/dit.safetensors" `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -OutputDir "C:/path/to/output" `
    -OutputName "my-lora" `
    -NetworkDim 32 `
    -LearningRate 2e-4 `
    -MaxTrainEpochs 16 `
    -Fp8Base
```

For Wan 2.2 (with high-noise model):
```powershell
.\tools\ai\musubi-tuner\scripts\wan-train.ps1 `
    -Task "t2v-A14B" `
    -DitPath "C:/path/to/low_noise.safetensors" `
    -DitHighNoise "C:/path/to/high_noise.safetensors" `
    -DatasetConfig "C:/path/to/dataset.toml" `
    -OutputDir "C:/path/to/output" `
    -OutputName "my-lora" `
    -Fp8Base
```

### Generate Video

**T2V:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output.mp4" `
    -VideoWidth 832 `
    -VideoHeight 480 `
    -VideoLength 81 `
    -InferSteps 20 `
    -Fp8
```

**I2V:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "i2v-14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -ClipPath "C:/path/to/clip.pth" `
    -ImagePath "C:/path/to/start_image.jpg" `
    -SavePath "C:/path/to/output.mp4" `
    -Fp8
```

**Wan 2.2:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-A14B" `
    -Prompt "A beautiful sunset over mountains" `
    -DitPath "C:/path/to/low_noise.safetensors" `
    -DitHighNoise "C:/path/to/high_noise.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output.mp4" `
    -Fp8
```

**Batch Mode:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -FromFile "C:/path/to/prompts.txt" `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output_directory"
```

**Interactive Mode:**
```powershell
.\tools\ai\musubi-tuner\scripts\wan-generate.ps1 `
    -Task "t2v-14B" `
    -Interactive `
    -DitPath "C:/path/to/dit.safetensors" `
    -VaePath "C:/path/to/vae.safetensors" `
    -T5Path "C:/path/to/t5.pth" `
    -SavePath "C:/path/to/output_directory"
```

## Notes

- All paths should use forward slashes `/` or be properly quoted
- Scripts automatically activate the virtual environment when needed
- Check script output for any errors or warnings
- For advanced options, use the Python scripts directly with `--help`

