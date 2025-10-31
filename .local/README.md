# Local Configuration Directory

This directory contains user-specific configuration files that are **NOT committed to git**.

## Setup

1. Copy `config.example.json` to `config.json`:
   ```powershell
   Copy-Item .local\config.example.json .local\config.json
   ```

2. Edit `config.json` with your actual paths and settings

3. Never commit `config.json` - it contains your personal paths and potentially sensitive information

## Files

- `config.example.json` - Template (committed, safe to share)
- `config.json` - Your actual config (gitignored, contains your paths)

## Configuration Structure

The config file contains:
- **paths**: Installation paths for tools
- **models**: Model file paths
- **datasets**: Dataset configuration paths
- **api_keys**: API keys (if needed)
- **user_preferences**: User-specific preferences

## Usage in Scripts

Scripts should load configuration from `.local/config.json` and use defaults from `config.example.json` if local config doesn't exist.

## Privacy

- ✅ Safe to commit: `config.example.json` (template only)
- ❌ Never commit: `config.json` (contains your actual paths)
- ❌ Never commit: API keys, personal paths, user-specific data

