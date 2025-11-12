# AI Article Writer - Technical Plan

## Technology Stack Decision

### Selected Stack: JavaScript/Node.js

**Decision**: Use JavaScript/HTML/CSS/Node.js stack instead of Python for article-writing tools.

**Rationale**:
- Better integration with web-based AI tools and APIs
- Easier HTML/CSS manipulation for article formatting
- Rich ecosystem for markdown processing
- Better suited for async operations (API calls, file I/O)
- User preference for this particular task

### Core Technologies

- **Runtime**: Node.js (v18+)
- **Language**: JavaScript (ES6+)
- **UI**: HTML/CSS for any web interfaces
- **Package Manager**: npm
- **Scripts**: PowerShell (Windows) / Bash (Linux/Mac)

## Architecture Overview

### Tool Structure

```
tools/ai/ai-article-writer/
├── MANIFEST.json          # Tool metadata
├── README.md              # Documentation
├── package.json           # Node.js dependencies
├── scripts/               # PowerShell/Bash scripts
│   ├── generate-article.ps1
│   └── setup-environment.ps1
└── src/                   # JavaScript source
    ├── index.js           # Main entry point
    ├── generators/        # Text/diagram generators
    ├── adapters/          # Complexity adapter
    └── composer/          # Article composer
```

### Component Architecture

```
┌─────────────────────────────────────────┐
│     AI Article Writer (Orchestrator)    │
│         PowerShell Scripts               │
└──────────────┬──────────────────────────┘
               │
               ├──► Text Generator (Node.js)
               ├──► Diagram Generator (Node.js)
               ├──► Complexity Adapter (Node.js)
               └──► Article Composer (Node.js)
```

## Implementation Details

### 1. Text Generator

**Purpose**: Generate article sections from prompts

**Technology**: Node.js with markdown processing

**Key Features**:
- Accept topic and section prompts
- Generate markdown content
- Support for multiple sections
- Integration with AI APIs (Cursor, OpenAI, etc.)

### 2. Diagram Generator

**Purpose**: Generate Mermaid diagrams from descriptions

**Technology**: Node.js with Mermaid.js

**Key Features**:
- Parse diagram descriptions
- Generate Mermaid syntax
- Embed in markdown output
- Support multiple diagram types

### 3. Complexity Adapter

**Purpose**: Adapt content to three difficulty levels

**Technology**: Node.js with content processing

**Key Features**:
- Generate three versions (simple, medium, advanced)
- Store in structured format
- Support hover UI integration
- Paragraph-level adaptation

### 4. Article Composer

**Purpose**: Combine all components into final article

**Technology**: Node.js with template engine (EJS)

**Key Features**:
- Combine text sections
- Embed diagrams
- Apply complexity levels
- Generate final markdown output
- YAML frontmatter support

## Data Flow

```
User Input (Topic)
    ↓
Article Writer (Orchestrator)
    ↓
┌─────────────────────────────────────┐
│ 1. Text Generator                  │
│    → Generate sections              │
│ 2. Diagram Generator               │
│    → Generate diagrams              │
│ 3. Complexity Adapter              │
│    → Adapt to 3 levels             │
└─────────────────────────────────────┘
    ↓
Article Composer
    ↓
Final Markdown Article
```

## File Structure

### Article Output Format

```markdown
---
title: Article Title
complexity: simple|medium|advanced
generated: 2024-01-01 12:00:00
---

# Article Title

[Content with complexity annotations]

## Section 1

<!-- simple: Beginner-friendly explanation -->
<!-- medium: Intermediate explanation -->
<!-- advanced: Expert-level explanation -->
```

## Integration Points

### With Cursor AI
- Use Cursor's AI capabilities for content generation
- Structured prompts for consistent output
- Error handling and retry logic

### With MCP Server
- Expose operations via MCP
- Support remote access
- Operation codes: `ai-article-writer:generate`

### With Other Tools
- Coordinate with related tools
- Shared utilities library
- Common configuration format

## Development Phases

### Phase 1: Foundation
- [x] Technology stack decision (JavaScript/Node.js)
- [ ] Basic Node.js project structure
- [ ] Package.json setup
- [ ] PowerShell script wrappers

### Phase 2: Core Components
- [ ] Text generator implementation
- [ ] Diagram generator implementation
- [ ] Complexity adapter implementation
- [ ] Article composer implementation

### Phase 3: Integration
- [ ] Orchestrator coordination
- [ ] Error handling
- [ ] Progress indicators
- [ ] Output formatting

### Phase 4: Enhancement
- [ ] MCP integration
- [ ] Advanced features
- [ ] UI components (if needed)
- [ ] Documentation

## Related Documentation

- **Rules**: `rules/ai-article-writer.cursorrules`
- **Manifest**: `tools/ai/ai-article-writer/MANIFEST.json`
- **Usage**: `tools/ai/ai-article-writer/docs/USAGE.md`

