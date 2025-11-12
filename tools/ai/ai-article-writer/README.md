# AI Article Writer

Main orchestrator tool for generating complete articles with text sections, diagrams, and complexity adaptation.

## Status: ✅ Implemented and Working

**Current Implementation:**
- ✅ Article generation with 3 difficulty levels (simple, medium, advanced)
- ✅ Interactive HTML viewer with per-section difficulty switching
- ✅ Markdown article generation
- ✅ GitHub Pages hosting ready
- ✅ Node.js/JavaScript implementation complete

**What's Working:**
- Article generation from topics
- Three complexity levels per section
- HTML viewer with interactive difficulty switching
- PowerShell scripts for Windows
- GitHub Pages deployment

**Future Enhancements:**
- AI-powered content generation (currently uses template content)
- Diagram generation integration
- MCP server integration
- Advanced template system

## Overview

The AI Article Writer coordinates multiple specialized tools to create complete articles:
- **Text Generation**: Creates article sections from prompts ✅ (Basic implementation)
- **Diagram Generation**: Generates Mermaid diagrams from descriptions ⏳ (Planned)
- **Complexity Adaptation**: Adjusts content complexity for different audiences ✅ (Implemented)
- **Article Composition**: Combines all elements into final article ✅ (Implemented)

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

Or run Node.js directly (works on all platforms):

```bash
cd tools/ai/ai-article-writer
node src/index.js --topic "Your Topic" --output "../../../docs/article.md"
```

### 3. Generate Interactive HTML Viewer

Create an interactive HTML viewer from a markdown article:

```bash
cd tools/ai/ai-article-writer
node src/article-viewer.js --markdown ../../../docs/article.md --output ../../../docs/article.html
```

### 4. Preview Article Locally

Preview the generated HTML article in your browser before pushing to GitHub Pages:

**Windows (PowerShell):**
```powershell
.\tools\ai\ai-article-writer\scripts\preview-article.ps1
# Or with regeneration:
.\tools\ai\ai-article-writer\scripts\preview-article.ps1 -Regenerate
# Or specify custom article:
.\tools\ai\ai-article-writer\scripts\preview-article.ps1 -ArticlePath "docs/my-article.html"
```

**macOS/Linux (Bash):**
```bash
./tools/ai/ai-article-writer/scripts/preview-article.sh
# Or with regeneration:
./tools/ai/ai-article-writer/scripts/preview-article.sh --regenerate
# Or specify custom article:
./tools/ai/ai-article-writer/scripts/preview-article.sh docs/my-article.html
```

The preview script will:
- Optionally regenerate HTML from markdown (`-Regenerate` / `--regenerate`)
- Start a local HTTP server (Python or Node.js)
- Open the article in your default browser
- Display the local URL (default: http://localhost:8080)

**Note**: Always preview locally before pushing to catch formatting issues early!

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

## Implementation Details

### Source Files
- `src/index.js` - Main article generator (generates markdown with 3 complexity levels)
- `src/article-viewer.js` - HTML viewer generator (creates interactive HTML from markdown)

### Generated Files
- Markdown articles with complexity annotations
- Interactive HTML viewers with difficulty switching
- GitHub Pages ready (includes `.nojekyll` file)

### Example Output
See the generated article: `docs/ai-first-repository-guide.html`
- Hosted on GitHub Pages: https://sosotughushi.github.io/ElectricSheep/ai-first-repository-guide.html
- Source markdown: `docs/ai-first-repository-guide.md`

### Deployment Workflow

**IMPORTANT**: When updating articles, always push changes for GitHub Pages:

1. **Edit markdown** (`docs/article.md`)
2. **Regenerate HTML**: `node tools/ai/ai-article-writer/src/article-viewer.js --markdown docs/article.md --output docs/article.html`
3. **Preview locally**: `.\tools\ai\ai-article-writer\scripts\preview-article.ps1 -Regenerate`
4. **Commit both files**: `git add docs/article.md docs/article.html && git commit -m "Update article"`
5. **Push to master**: `git push origin master`
6. **Wait 1-5 minutes** for GitHub Pages to rebuild

See `rules/ai-article-writer.cursorrules` for complete deployment guidelines.

## Documentation

- **Usage Guide**: `docs/USAGE.md`
- **Manifest**: `MANIFEST.json`
- **Registry**: `.toolset/registry.json`
- **Rules**: `rules/ai-article-writer.cursorrules`
- **Architecture**: `docs/architecture/ai-article-writer-technical-plan.md`

