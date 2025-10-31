# Electric Sheep Toolset - Operations Discovery

## Query Operations

This toolset provides a standardized way to discover and query available operations.

## Quick Start

**"What are my operations?"**

```powershell
python .toolset/discover_operations.py
```

## For AI Agents

When users ask about available operations:

1. **Load operations registry**: Read `.toolset/operations.json`
2. **Present code names**: Show operation codes (e.g., `bambu-lab:launch`)
3. **Include descriptions**: Provide brief descriptions
4. **Filter by category**: If user asks about specific area, filter by category

## Operation Codes

Operations use code names like `tool:action` or `tool:category:action`:
- `bambu-lab:launch` - Launch Bambu Lab
- `musubi-tuner:wan:train` - Train Wan LoRA

## Privacy

- **Public**: Operation codes, descriptions, structure
- **Private**: User paths, API keys (stored in `.local/config.json`)

See `docs/guides/operations-discovery.md` for full documentation.

