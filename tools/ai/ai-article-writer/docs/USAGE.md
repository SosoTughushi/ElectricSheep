# AI Article Writer - Usage Guide

## Overview

The AI Article Writer generates complete articles with three difficulty levels (simple, medium, advanced) and creates interactive HTML viewers.

## Workflow

1. **Topic Input**: User provides article topic ✅
2. **Text Generation**: Generates article sections ✅ (Basic implementation)
3. **Complexity Adaptation**: Creates 3 versions per section ✅
4. **Markdown Output**: Saves article with complexity annotations ✅
5. **HTML Viewer**: Generates interactive viewer with difficulty switching ✅
6. **GitHub Pages**: Ready for deployment ✅

## Examples

### Example 1: Generate Markdown Article

**PowerShell (Windows):**
```powershell
.\tools\ai\ai-article-writer\scripts\generate-article.ps1 -Topic "Introduction to Docker"
```

**Node.js (All platforms):**
```bash
cd tools/ai/ai-article-writer
node src/index.js --topic "Introduction to Docker" --output "../../../docs/docker-guide.md"
```

Output: `docs/docker-guide.md` (or `./output/article.md` by default)

### Example 2: Generate with Custom Output Path

```powershell
.\tools\ai\ai-article-writer\scripts\generate-article.ps1 `
    -Topic "Python Best Practices" `
    -OutputPath "./docs/python-best-practices.md"
```

Or with Node.js:
```bash
node src/index.js --topic "Python Best Practices" --output "../../../docs/python-best-practices.md"
```

### Example 3: Generate Interactive HTML Viewer

After generating a markdown article, create an interactive HTML viewer:

```bash
cd tools/ai/ai-article-writer
node src/article-viewer.js --markdown ../../../docs/article.md --output ../../../docs/article.html
```

This creates an HTML file with:
- Per-section difficulty switching (Simple/Medium/Advanced)
- Global controls to set all sections to one difficulty
- Beautiful, responsive design
- Ready for GitHub Pages deployment

## Parameters

- **Topic** (required): Main subject for the article
- **OutputPath** (optional): Where to save the article (default: `./output/article.md`)
- **ComplexityLevel** (optional): `simple`, `medium`, or `advanced` (default: `medium`)

## Output Format

### Markdown Articles
Articles are generated as Markdown files with:
- Frontmatter (YAML) with title, complexity, and generation date
- Structured sections with headers
- Three complexity levels per section (annotated with HTML comments)
- Format: `<!-- simple:start -->` ... `<!-- simple:end -->`

### HTML Viewers
Interactive HTML viewers include:
- Per-section difficulty buttons
- Global difficulty controls
- Responsive design
- GitHub Pages ready (includes `.nojekyll`)

## Real Example

**Generated Article:**
- Markdown: `docs/ai-first-repository-guide.md`
- HTML Viewer: `docs/ai-first-repository-guide.html`
- Live: https://sosotughushi.github.io/ElectricSheep/ai-first-repository-guide.html

## Integration

This tool integrates with:
- ✅ Cursor AI for content generation (ready for AI integration)
- ⏳ MCP server for remote access (planned)
- ✅ GitHub Pages for hosting
- ✅ Other Electric Sheep tools

## Next Steps for AI Agents

When working with this tool:
1. **Read**: `rules/ai-article-writer.cursorrules` for development guidelines
2. **Check**: `src/index.js` for article generation logic
3. **Enhance**: Add AI-powered content generation (currently uses templates)
4. **Extend**: Integrate diagram generation and MCP server

