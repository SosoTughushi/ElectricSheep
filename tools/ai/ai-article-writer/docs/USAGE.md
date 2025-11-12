# AI Article Writer - Usage Guide

## Overview

The AI Article Writer generates complete articles by coordinating multiple specialized tools.

## Workflow

1. **Topic Input**: User provides article topic
2. **Text Generation**: Generates article sections
3. **Diagram Generation**: Creates relevant diagrams
4. **Complexity Adaptation**: Adjusts content complexity
5. **Composition**: Combines all elements
6. **Output**: Saves final article

## Examples

### Example 1: Basic Article

```powershell
.\scripts\generate-article.ps1 -Topic "Introduction to Docker"
```

Output: `./output/article.md`

### Example 2: Custom Output Path

```powershell
.\scripts\generate-article.ps1 `
    -Topic "Python Best Practices" `
    -OutputPath "./docs/python-best-practices.md"
```

### Example 3: Advanced Complexity

```powershell
.\scripts\generate-article.ps1 `
    -Topic "Machine Learning Fundamentals" `
    -ComplexityLevel "advanced"
```

## Parameters

- **Topic** (required): Main subject for the article
- **OutputPath** (optional): Where to save the article (default: `./output/article.md`)
- **ComplexityLevel** (optional): `simple`, `medium`, or `advanced` (default: `medium`)

## Output Format

Articles are generated as Markdown files with:
- Frontmatter (YAML)
- Structured sections
- Embedded diagrams (Mermaid)
- Complexity-adapted content

## Integration

This tool integrates with:
- Cursor AI for content generation
- MCP server for remote access
- Other Electric Sheep tools

