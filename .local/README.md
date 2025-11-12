# Local Configuration

This directory contains user-specific configuration files that are **never committed** to the repository.

## Setup

1. Copy `config.example.json` to `config.json`:
   ```powershell
   Copy-Item .local\config.example.json .local\config.json
   ```

2. Edit `config.json` and fill in your actual paths:
   - Training data directories
   - Model paths
   - Musubi Tuner installation path
   - Log directory

## Configuration Structure

### Training Data Paths

All training data paths are loaded from `.local/config.json` to ensure they're never committed:

- **Base Directory**: `paths.training_data.base_directory` - Root directory for all training datasets
- **Source Images**: `paths.training_data.source_images_base` - Root directory for source images
- **Dataset-specific paths**: `paths.training_data.datasets.<dataset_name>.source_dir`

### Environment Variables (Alternative)

You can also use environment variables instead of config file:

- `TRAINING_DATA_BASE_DIR` - Base directory for training datasets
- `SOURCE_IMAGES_BASE_DIR` - Base directory for source images

## Security

- ✅ `.local/config.json` is gitignored
- ✅ `.local/config.example.json` contains only placeholders (safe to commit)
- ✅ All scripts load paths from config, never hardcode them

## Scripts Using Config

All training scripts automatically load paths from `.local/config.json`:

- `prepare-*-dataset.ps1` scripts
- `start-angelina-training.ps1`
- `launch-angelina-training.ps1`
- `run-angelina-training-complete.ps1`
- `monitor-angelina-training.ps1`

Use the `load-training-paths.ps1` helper script to access paths in your own scripts.
