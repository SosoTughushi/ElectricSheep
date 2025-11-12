---
title: Setting Up an AI-First Repository and Working with Cursor
complexity: simple|medium|advanced
generated: 2025-11-12 11:49:30
---

# Setting Up an AI-First Repository and Working with Cursor

> This article is available in three difficulty levels. Hover over paragraphs or use the complexity selector to switch between simple, medium, and advanced explanations.

## Introduction

<!-- simple:start -->
**Simple:** Welcome! This guide will help you set up a repository that works great with AI assistants like Cursor. Think of it as organizing your code so AI can help you better.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** This guide covers setting up an AI-first repository structure optimized for AI-powered development tools like Cursor. We'll explore best practices for organizing code, documentation, and tooling to maximize AI assistant effectiveness.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** An AI-first repository architecture optimizes code organization, documentation patterns, and tooling infrastructure to maximize the effectiveness of AI-powered development assistants. This guide examines architectural patterns, workflow optimizations, and integration strategies for Cursor and similar AI development environments.

<!-- advanced:end -->

---

## What is an AI-First Repository?

<!-- simple:start -->
**Simple:** An AI-first repository is a project organized so AI assistants can easily understand and help with it. It's like having a well-organized filing cabinet where everything has a clear label.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** An AI-first repository employs structured organization, comprehensive documentation, and standardized patterns that enable AI assistants to effectively understand, navigate, and contribute to the codebase. Key principles include self-documenting code, consistent naming conventions, and explicit metadata.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** AI-first repository architecture applies information architecture principles to software development, creating codebases optimized for AI comprehension and manipulation. This involves semantic organization, explicit metadata systems (like MANIFEST.json), standardized tool interfaces, and documentation patterns that enable autonomous AI agent operation. The architecture prioritizes discoverability, predictability, and textual feedback loops over human-centric optimizations.

<!-- advanced:end -->

---

## Setting Up the Repository Structure

<!-- simple:start -->
**Simple:** Start by creating folders for different parts of your project. Put tools in a 'tools' folder, documentation in a 'docs' folder, and rules in a 'rules' folder. This helps AI find things quickly.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Establish a clear directory hierarchy: `tools/` for executable tools organized by category, `docs/` for documentation, `rules/` for AI agent guidelines, and `.toolset/` for metadata. Each tool should include a MANIFEST.json with standardized metadata for AI discovery.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Implement a hierarchical directory structure following domain-driven design principles: `tools/{category}/{tool-name}/` with standardized subdirectories (`scripts/`, `src/`, `docs/`). Each tool requires a MANIFEST.json following the toolset schema, including id, description, parameters, and AI-friendly metadata. The `.toolset/` directory contains registry.json (tool inventory), operations.json (operation definitions), and configuration files. This structure enables programmatic tool discovery and execution.

<!-- advanced:end -->

---

## Working with Cursor

<!-- simple:start -->
**Simple:** Cursor is an AI-powered code editor. To use it well, write clear comments in your code and organize files logically. Cursor's AI can then better understand what you're trying to do.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Cursor leverages AI models to assist with code generation, refactoring, and navigation. Optimize for Cursor by maintaining clear code structure, comprehensive documentation, and consistent patterns. Use Cursor's rules system (`.cursorrules` files) to guide AI behavior and establish project-specific conventions.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Cursor integrates language models directly into the development workflow, enabling autonomous code generation and modification. Optimize Cursor effectiveness through: (1) structured rulesets in `.cursorrules` files with clear precedence hierarchies, (2) self-documenting code patterns that expose intent to AI models, (3) standardized tool interfaces enabling AI-driven tool discovery and execution, and (4) textual feedback loops where AI can verify its own work through command execution and output analysis. Configure Cursor rules following the project's rule precedence system (system > project > domain > tool).

<!-- advanced:end -->

---

## Best Practices

<!-- simple:start -->
**Simple:** Keep things simple and organized. Write clear names for files and folders. Add comments explaining what your code does. Make sure your README file explains how to use your project.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Follow these practices: (1) Use descriptive, consistent naming conventions, (2) Include MANIFEST.json files for all tools with complete metadata, (3) Maintain up-to-date README files with usage examples, (4) Document the "why" not just the "what", (5) Use standardized script interfaces, and (6) Keep documentation close to code.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Implement these architectural patterns: (1) Semantic versioning for tools and operations, (2) Operation codes (`tool:operation`) for programmatic tool invocation, (3) Structured error handling with parseable output formats, (4) Non-interactive command interfaces (use `--yes` flags), (5) Textual output for AI parsing (avoid binary formats), (6) Self-verification mechanisms enabling AI to validate its own changes, and (7) Privacy-aware design separating public (committed) from private (local config) data.

<!-- advanced:end -->

---

## Advanced Architectural Patterns

<!-- simple:start -->
**Simple:** Advanced setups use special files that help AI understand your project better. These files act like a map that shows AI where everything is and how to use it.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Advanced AI-first repositories implement sophisticated metadata systems including tool registries, operation codes, and manifest files. These systems enable programmatic discovery, standardized interfaces, and autonomous tool execution by AI agents.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Advanced AI-first architectures implement several critical patterns:

### Tool Registry System

A centralized `.toolset/registry.json` serves as the single source of truth for tool discovery. Each tool entry includes:
- **Tool ID**: Unique identifier following naming conventions
- **Category**: Domain classification (system, ai, dev, misc)
- **Path**: Filesystem location relative to repository root
- **Status**: Active, deprecated, or experimental
- **Version**: Semantic versioning for tool evolution tracking

This registry enables AI agents to programmatically discover available tools without filesystem traversal, reducing computational overhead and ensuring consistency.

### Operation Code System

Operations are identified by structured codes following the pattern `tool:action` or `tool:category:action`. Examples:
- `bambu-lab:launch` - Launch application with auto-configuration
- `musubi-tuner:wan:train` - Train LoRA model using Wan architecture
- `cpu-affinity:check` - Verify CPU affinity settings

These codes enable:
- **Programmatic invocation**: AI agents can execute operations by code name
- **Remote execution**: Operation codes map to MCP endpoints for distributed execution
- **Version-independent references**: Codes remain stable across tool version changes
- **Discovery queries**: Filter operations by category, tool, or action type

### Manifest Schema

Each tool includes a `MANIFEST.json` following a standardized schema:

```json
{
  "id": "tool-name",
  "name": "Human-Readable Name",
  "description": "Tool purpose and capabilities",
  "category": "system|ai|dev|misc",
  "version": "semantic-version",
  "entry_points": {
    "primary": "scripts/main.ps1",
    "alternate": "scripts/alt.ps1"
  },
  "parameters": [
    {
      "name": "paramName",
      "type": "string|int|bool",
      "description": "Parameter purpose",
      "required": true,
      "default": null
    }
  ],
  "operations": [
    {
      "code": "tool:operation",
      "description": "Operation purpose",
      "entry_point": "scripts/operation.ps1"
    }
  ],
  "examples": [
    {
      "description": "Example use case",
      "command": ".\scripts\main.ps1 -Param value"
    }
  ]
}
```

This schema enables AI agents to:
- Understand tool capabilities without reading source code
- Generate correct invocation commands
- Validate parameter usage
- Discover available operations

### Hierarchical Rule System

Rules follow a precedence hierarchy enabling conflict resolution:

1. **System Rules** (highest precedence): Core operational constraints, policy cards
2. **Project Rules**: Repository-wide conventions (`development-workflow.cursorrules`)
3. **Domain Rules**: Category-specific patterns (`mcp-tool-integration.cursorrules`)
4. **Tool Rules**: Tool-specific guidelines (in tool directories)

When conflicts occur, higher precedence rules override lower precedence. This enables:
- **Consistent behavior**: All agents follow same core principles
- **Domain flexibility**: Category-specific optimizations
- **Tool customization**: Per-tool exceptions when needed
- **Conflict resolution**: Clear precedence prevents ambiguity

<!-- advanced:end -->

---

## Autonomous AI Agent Workflows

<!-- simple:start -->
**Simple:** AI assistants can check their own work by running code and seeing if it works correctly. This helps them fix mistakes automatically without asking you for help.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** AI-first repositories enable autonomous agent operation through textual feedback loops. Agents edit code, execute it automatically, capture output, analyze results, and self-correct based on errors. This eliminates the need for human intervention in routine development tasks.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Autonomous AI agent workflows implement the **textual feedback loop** pattern:

```
Edit Code → Execute → Capture Output → Parse → Analyze → Self-Correct → Verify → Repeat
```

### Textual Feedback Loop Architecture

**Phase 1: Code Modification**
- Agent modifies code based on requirements
- Changes follow established patterns and conventions
- Documentation updated simultaneously (same iteration)

**Phase 2: Automatic Execution**
- Agent executes commands directly using `run_terminal_cmd`
- Never asks user to run commands manually
- Uses non-interactive flags (`--yes`, `-y`) for automation
- Redirects output to `logs/` directory for analysis

**Phase 3: Output Capture**
- All stdout, stderr, and exit codes captured
- Output stored in timestamped log files
- Structured error messages enable parsing:
  ```
  ERROR_TYPE: FileNotFound
  ERROR_FILE: /path/to/file.txt
  ERROR_SUGGESTION: Check if file exists
  ```

**Phase 4: Output Analysis**
- Parse exit codes (0 = success, non-zero = failure)
- Extract structured error information
- Compare expected vs actual behavior
- Identify root causes from error patterns

**Phase 5: Self-Correction**
- Agent fixes errors based on analysis
- Updates code, manifests, and documentation
- Re-executes to verify fixes
- Iterates until success or escalation threshold

**Phase 6: Verification**
- Final execution confirms success
- Output matches expected patterns
- Documentation reflects actual behavior
- Changes committed atomically

### Self-Verification Mechanisms

Agents verify their own work through:

**1. Exit Code Validation**
```powershell
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR_TYPE: ExecutionFailed"
    Write-Error "EXIT_CODE: $LASTEXITCODE"
    exit 1
}
exit 0
```

**2. Structured Output Parsing**
```powershell
Write-Output "STATUS: SUCCESS"
Write-Output "FILES_PROCESSED: 42"
Write-Output "ERRORS: 0"
```

**3. Expected Behavior Matching**
- Compare output against expected patterns
- Validate file creation/modification
- Verify operation completion signals

**4. Dependency Verification**
- Check prerequisite tools exist
- Validate configuration files present
- Verify environment setup

### Error Recovery Patterns

**Pattern 1: Parameter Validation Errors**
```
Error detected → Check MANIFEST.json → Update parameter definition → Re-execute
```

**Pattern 2: File Path Issues**
```
Error detected → Analyze path format → Add quotes/escape characters → Re-execute
```

**Pattern 3: Missing Dependencies**
```
Error detected → Check registry → Install/configure dependency → Re-execute
```

**Pattern 4: Configuration Errors**
```
Error detected → Check .local/config.json → Update configuration → Re-execute
```

### Autonomous Operation Principles

1. **Never ask user to run commands** - Execute directly
2. **Capture all output** - Enable analysis and debugging
3. **Self-correct on errors** - Fix based on output analysis
4. **Document as you go** - Update docs in same iteration
5. **Verify before completion** - Confirm success through execution
6. **Escalate only when stuck** - After multiple correction attempts

<!-- advanced:end -->

---

## Multi-Agent Coordination

<!-- simple:start -->
**Simple:** When multiple AI assistants work on the same project, they use shared files to coordinate. These files act like a shared notebook where everyone can see what others are doing.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Multiple AI agents can work simultaneously on the same codebase by following standardized structures and using shared metadata files. The registry system prevents conflicts, and manifest files ensure consistent understanding across agents.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Multi-agent coordination in AI-first repositories requires sophisticated conflict prevention and resolution mechanisms:

### Conflict Prevention Strategies

**1. Single Source of Truth**
- `.toolset/registry.json` - Centralized tool inventory
- `.toolset/operations.json` - Operation definitions
- Standardized manifest format - Consistent tool metadata

**2. Standardized Patterns**
- Predictable directory structures: `tools/{category}/{tool-name}/`
- Consistent manifest schemas prevent misunderstandings
- Operation code conventions enable discovery

**3. Atomic Operations**
- Tools registered atomically (all-or-nothing)
- Manifest updates include all required fields
- Documentation updated with code changes

### Conflict Detection Mechanisms

**Type 1: Registry Conflicts**
```powershell
# Before adding tool, check for ID conflicts
$registry = Get-Content .toolset/registry.json | ConvertFrom-Json
$existingIds = $registry.tools | ForEach-Object { $_.id }
if ($newToolId -in $existingIds) {
    Write-Error "CONFLICT: Tool ID '$newToolId' already exists"
    exit 1
}
```

**Type 2: Operation Code Conflicts**
```powershell
# Check for duplicate operation codes
$operations = Get-Content .toolset/operations.json | ConvertFrom-Json
$existingCodes = $operations.operations | ForEach-Object { $_.code }
if ($newCode -in $existingCodes) {
    Write-Error "CONFLICT: Operation code '$newCode' already exists"
    exit 1
}
```

**Type 3: File Modification Conflicts**
```powershell
# Check git status before modifying
$status = git status --porcelain $filePath
if ($status) {
    Write-Warning "CONFLICT_RISK: File has uncommitted changes"
    # Analyze compatibility or wait
}
```

### Conflict Resolution Strategies

**Strategy 1: Last Writer Wins (Non-Critical)**
- Applies to: Documentation, manifests (non-conflicting changes)
- Action: Most recent change takes precedence
- Use when: Changes are additive or non-conflicting

**Strategy 2: Merge Required (Critical)**
- Applies to: Registry, operations, core configuration
- Action: Must merge changes, not overwrite
- Use when: Changes affect multiple tools/operations

**Strategy 3: Consensus Required (Breaking)**
- Applies to: Breaking changes, major modifications
- Action: All agents must agree or escalate to user
- Use when: Changes affect core functionality

### Communication Patterns

Agents communicate through:

**1. Manifest Files**
- Tool metadata conveys capabilities
- Parameter definitions enable correct usage
- Examples demonstrate proper invocation

**2. Documentation**
- README files explain tool purpose
- Troubleshooting sections document known issues
- Change logs track evolution

**3. Git History**
- Commit messages describe changes
- Branch names indicate work in progress
- Tags mark stable versions

**4. Registry Entries**
- Status fields indicate tool state
- Version numbers track evolution
- Categories enable discovery

### Coordination Best Practices

1. **Check registry first** - Before adding tools
2. **Read existing manifests** - Understand patterns
3. **Update registry atomically** - Include all metadata
4. **Document changes** - Leave notes for other agents
5. **Validate before committing** - Ensure compatibility
6. **Use git properly** - Handle merge conflicts correctly

<!-- advanced:end -->

---

## Advanced Metadata Systems

<!-- simple:start -->
**Simple:** Metadata files help AI understand your project structure. They're like labels on boxes that tell you what's inside without opening them.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Advanced metadata systems include tool registries, operation definitions, and manifest files that enable AI agents to discover and understand tools without reading source code. These systems separate public metadata (committable) from private configuration (user-specific).

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Advanced metadata systems in AI-first repositories implement several sophisticated patterns:

### Public vs Private Metadata Separation

**Public Metadata (Committed to Git)**
- Tool structure and organization
- Operation codes and descriptions
- Parameter schemas and types
- Tool capabilities and examples
- Entry points and interfaces

**Private Metadata (Local Config Only)**
- Installation paths (`C:\Program Files\...`)
- Model file locations
- Dataset directories
- API keys and secrets
- User-specific preferences

This separation enables:
- **Public sharing**: Repository can be shared without exposing sensitive data
- **AI discovery**: Agents can understand tools without user-specific paths
- **Privacy protection**: Sensitive information never committed
- **Configuration flexibility**: Each user configures their own environment

### Configuration System Architecture

**Template File (Public)**
`.local/config.example.json`:
```json
{
  "tools": {
    "musubi-tuner": {
      "venv_path": "C:/path/to/venv",
      "models_path": "C:/path/to/models"
    }
  }
}
```

**User Config (Private, Gitignored)**
`.local/config.json`:
```json
{
  "tools": {
    "musubi-tuner": {
      "venv_path": "D:/MyProjects/venv",
      "models_path": "D:/MyModels"
    }
  }
}
```

**Config Loader Pattern**
```powershell
# Load config with fallback to defaults
$configPath = ".local/config.json"
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
} else {
    # Use defaults or prompt for setup
    Write-Warning "Config not found, using defaults"
}
```

### Operation Discovery System

**Operations Registry** (`.toolset/operations.json`):
```json
{
  "operations": [
    {
      "code": "tool:operation",
      "name": "Human-Readable Name",
      "description": "Operation purpose",
      "category": "system|ai|dev|misc",
      "tool_id": "tool-name",
      "entry_point": "scripts/operation.ps1",
      "parameters": [
        {
          "name": "param",
          "type": "string",
          "required": true
        }
      ]
    }
  ]
}
```

**Discovery Script** (`.toolset/discover_operations.py`):
- Query operations by category
- Filter by tool ID
- Get detailed operation information
- Enable programmatic discovery

**Usage Patterns**:
```powershell
# List all operations
python .toolset/discover_operations.py

# Filter by category
python .toolset/discover_operations.py --category ai

# Get operation details
python .toolset/discover_operations.py --code musubi-tuner:wan:train
```

### Manifest-Driven Development

Manifests enable:
- **AI code generation**: Generate invocation commands from manifest
- **Parameter validation**: Check parameter usage against schema
- **Documentation generation**: Auto-generate docs from metadata
- **Tool discovery**: Find tools by capability, not just name
- **Version management**: Track tool evolution through versions

### Metadata Evolution Patterns

**Versioning Strategy**
- Semantic versioning: `major.minor.patch`
- Breaking changes increment major version
- New features increment minor version
- Bug fixes increment patch version

**Backward Compatibility**
- Maintain operation codes across versions
- Deprecate rather than remove features
- Document migration paths
- Support multiple versions during transition

**Metadata Validation**
- Schema validation for manifests
- Registry consistency checks
- Operation code uniqueness verification
- Parameter type validation

<!-- advanced:end -->

---

## Privacy-Aware Design Patterns

<!-- simple:start -->
**Simple:** Some information should stay private (like passwords or file paths on your computer). AI-first repositories keep this information separate from the code that gets shared.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Privacy-aware design separates public metadata (safe to commit) from private configuration (user-specific paths, API keys). This enables repository sharing while protecting sensitive information.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Privacy-aware design in AI-first repositories implements strict separation between public and private data:

### Data Classification Framework

**Public Data (Committable)**
- ✅ Tool structure and organization
- ✅ Operation codes and descriptions
- ✅ Parameter schemas (types, names, descriptions)
- ✅ Tool capabilities and examples
- ✅ Entry points and interfaces
- ✅ Documentation and guides
- ✅ Rulesets and conventions

**Private Data (Never Committed)**
- ❌ Installation paths (`C:\Program Files\...`)
- ❌ User-specific directories
- ❌ Model file locations
- ❌ Dataset paths
- ❌ API keys and secrets
- ❌ Authentication tokens
- ❌ Personal preferences

### Privacy Protection Mechanisms

**1. Gitignore Patterns**
```
.local/config.json          # User configuration
.local/logs/               # Execution logs
**/secrets/                # Secret files
**/*.key                   # Key files
**/*.env                   # Environment files
```

**2. Template-Based Configuration**
- Provide `.local/config.example.json` (committed)
- Users copy to `.local/config.json` (gitignored)
- Scripts load from user config with fallbacks

**3. Path Abstraction**
- Scripts accept paths as parameters
- Defaults loaded from config, not hardcoded
- Relative paths preferred over absolute

**4. Secret Management**
- Never hardcode secrets in scripts
- Load from environment variables
- Use secure credential stores
- Document required secrets without exposing values

### Privacy Compliance Patterns

**Pattern 1: Config Loading**
```powershell
# Load from config, never hardcode
$config = Load-Config
$toolPath = $config.tools.tool_name.path
if (-not $toolPath) {
    Write-Error "ERROR_TYPE: ConfigMissing"
    Write-Error "ERROR_SUGGESTION: Set path in .local/config.json"
    exit 1
}
```

**Pattern 2: Parameter Validation**
```powershell
# Accept paths as parameters, not hardcoded
param(
    [string]$ToolPath = $null
)

if (-not $ToolPath) {
    $ToolPath = $config.tools.tool_name.path
}
```

**Pattern 3: Example Generation**
```powershell
# Examples use placeholders, not real paths
# Example: .\script.ps1 -Path "C:\path\to\tool"
# Never: .\script.ps1 -Path "C:\Users\John\Documents\..."
```

### Privacy-Aware Documentation

**Good Documentation**:
```markdown
## Configuration

Set the tool path in `.local/config.json`:

```json
{
  "tools": {
    "tool-name": {
      "path": "C:/path/to/tool"
    }
  }
}
```
```

**Bad Documentation**:
```markdown
## Configuration

The tool is located at `C:\Users\John\Documents\MyTools\...`
```

### Privacy Verification Checklist

Before committing:
- [ ] No hardcoded user paths
- [ ] No API keys or secrets
- [ ] Config files use templates
- [ ] Examples use placeholders
- [ ] Gitignore covers private files
- [ ] Documentation doesn't expose sensitive data

<!-- advanced:end -->

---

## Self-Documenting Structures

<!-- simple:start -->
**Simple:** Good projects explain themselves. Files are named clearly, folders are organized logically, and documentation is easy to find. This helps both humans and AI understand the project.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Self-documenting structures use clear naming, consistent organization, and comprehensive metadata to enable understanding without reading source code. Manifests, registries, and standardized patterns make tools discoverable and understandable.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Self-documenting structures in AI-first repositories implement several architectural patterns:

### Hierarchical Documentation System

**Level 1: Entry Points**
- `AGENTS.md` - AI agent onboarding (primary entry)
- `README.md` - Human-facing documentation
- `QUICKSTART.md` - Quick start guide

**Level 2: Rules and Conventions**
- `rules/README.md` - Rules directory index
- `rules/development-workflow.cursorrules` - Core workflow rules
- Domain-specific rulesets for specialized patterns

**Level 3: Guides and Architecture**
- `docs/guides/` - Detailed workflow guides
- `docs/architecture/` - System architecture documentation
- Tool-specific README files

**Level 4: Metadata**
- `MANIFEST.json` - Tool metadata
- `.toolset/registry.json` - Tool registry
- `.toolset/operations.json` - Operation definitions

### Naming Conventions

**Directories**
- `tools/{category}/{tool-name}/` - Predictable tool locations
- `scripts/` - Executable scripts
- `src/` - Source code
- `docs/` - Documentation

**Files**
- `MANIFEST.json` - Tool metadata (standardized name)
- `README.md` - Tool documentation
- `*.cursorrules` - Cursor rule files
- `*.example.json` - Configuration templates

**Operations**
- `tool:action` - Simple operations
- `tool:category:action` - Categorized operations
- Consistent naming enables discovery

### Documentation Proximity Principle

**Co-location**
- Tool documentation in `tools/{category}/{tool-name}/README.md`
- Script documentation near scripts
- Rule documentation in `rules/` directory
- Architecture docs in `docs/architecture/`

**Single Source of Truth**
- Tool capabilities in `MANIFEST.json`
- Tool inventory in `.toolset/registry.json`
- Operation definitions in `.toolset/operations.json`
- Avoid duplication, reference instead

### Self-Discovery Mechanisms

**1. Registry-Based Discovery**
```powershell
# Discover tools programmatically
$registry = Get-Content .toolset/registry.json | ConvertFrom-Json
$tools = $registry.tools | Where-Object { $_.category -eq "ai" }
```

**2. Manifest-Based Understanding**
```powershell
# Understand tool without reading source
$manifest = Get-Content tools/ai/tool/MANIFEST.json | ConvertFrom-Json
$capabilities = $manifest.description
$parameters = $manifest.parameters
```

**3. Operation-Based Execution**
```powershell
# Execute by operation code
python .toolset/discover_operations.py --code tool:operation
# Get entry point and parameters
```

### Documentation Patterns

**Pattern 1: Progressive Disclosure**
- Entry points provide overview
- Rules provide detailed conventions
- Guides provide comprehensive workflows
- Manifests provide technical details

**Pattern 2: Example-Driven**
- Every tool includes usage examples
- Examples demonstrate common patterns
- Examples show error handling
- Examples cover edge cases

**Pattern 3: Troubleshooting Sections**
- Document known issues
- Provide solutions
- Explain workarounds
- Include error message patterns

### Self-Documentation Best Practices

1. **Name clearly** - Names convey purpose
2. **Organize logically** - Structure reflects relationships
3. **Document comprehensively** - Cover all aspects
4. **Update together** - Code and docs in same iteration
5. **Use metadata** - Manifests enable discovery
6. **Provide examples** - Show, don't just tell

<!-- advanced:end -->

---

## Programmatic Interfaces

<!-- simple:start -->
**Simple:** AI assistants can use special commands to find and use tools automatically. These commands work like a menu that shows what's available.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Programmatic interfaces enable AI agents to discover tools, understand capabilities, and execute operations through standardized APIs. Operation codes, discovery scripts, and structured metadata enable automation.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Programmatic interfaces in AI-first repositories enable autonomous agent operation through standardized APIs:

### Operation Code System

**Code Structure**
- Format: `tool:action` or `tool:category:action`
- Examples: `bambu-lab:launch`, `musubi-tuner:wan:train`
- Enables: Version-independent references, remote execution, discovery queries

**Code Resolution**
```powershell
# Resolve operation code to execution command
$operation = Get-Operation -Code "tool:operation"
$command = "$($operation.entry_point) $($operation.parameters)"
Execute-Command $command
```

### Discovery APIs

**1. Operations Discovery**
```powershell
# List all operations
python .toolset/discover_operations.py

# Filter by category
python .toolset/discover_operations.py --category ai

# Get operation details
python .toolset/discover_operations.py --code tool:operation
```

**2. Registry Queries**
```powershell
# Query tool registry
$registry = Get-Content .toolset/registry.json | ConvertFrom-Json
$tools = $registry.tools | Where-Object { $_.status -eq "active" }
```

**3. Manifest Parsing**
```powershell
# Parse tool manifest
$manifest = Get-Content tools/category/tool/MANIFEST.json | ConvertFrom-Json
$capabilities = $manifest.description
$operations = $manifest.operations
```

### Execution Interfaces

**1. Direct Script Execution**
```powershell
# Execute tool script directly
.\tools\category\tool\scripts\main.ps1 -Param value
```

**2. Operation-Based Execution**
```powershell
# Execute by operation code
Invoke-Operation -Code "tool:operation" -Parameters @{Param="value"}
```

**3. MCP Integration (Future)**
```json
{
  "method": "tools/call",
  "params": {
    "name": "tool:operation",
    "arguments": {
      "param": "value"
    }
  }
}
```

### Interface Patterns

**Pattern 1: Non-Interactive Execution**
```powershell
# Always use non-interactive flags
.\script.ps1 --yes --force --no-prompt
```

**Pattern 2: Structured Output**
```powershell
# Output in parseable format
Write-Output "STATUS: SUCCESS"
Write-Output "RESULT: $result"
Write-Output "ERRORS: 0"
```

**Pattern 3: Exit Code Semantics**
```powershell
# Use exit codes consistently
if ($error) { exit 1 } else { exit 0 }
```

**Pattern 4: Error Reporting**
```powershell
# Structured error messages
Write-Error "ERROR_TYPE: ValidationFailed"
Write-Error "ERROR_FIELD: parameter"
Write-Error "ERROR_MESSAGE: Invalid value"
```

### Remote Execution Architecture

**MCP Server Integration**
- Tools exposed as MCP resources
- Operation codes map to MCP endpoints
- Standardized request/response format
- Authentication and authorization

**Remote Discovery**
- Query operations via MCP protocol
- Discover tools without local access
- Execute operations remotely
- Monitor execution status

### Interface Best Practices

1. **Standardize interfaces** - Consistent patterns across tools
2. **Enable discovery** - Programmatic tool finding
3. **Support automation** - Non-interactive execution
4. **Provide structure** - Parseable output formats
5. **Handle errors** - Structured error reporting
6. **Document interfaces** - Clear API documentation

<!-- advanced:end -->

---

## Conclusion

<!-- simple:start -->
**Simple:** Setting up an AI-first repository helps you work better with AI assistants. Start simple, keep things organized, and you'll see the benefits quickly!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** An AI-first repository structure significantly enhances productivity when working with AI development tools. By following these patterns and best practices, you create a codebase that AI assistants can effectively understand and contribute to.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** AI-first repository architecture represents a paradigm shift toward codebases optimized for AI comprehension and manipulation. The investment in structured organization, comprehensive documentation, and standardized interfaces pays dividends in AI-assisted development velocity and quality. As AI development tools evolve, these architectural patterns will become increasingly critical for maintaining competitive development workflows.

<!-- advanced:end -->


## Next Steps

<!-- simple:start -->
Try setting up a small project using these ideas. Start with clear folder names and a good README file.

<!-- simple:end -->

<!-- medium:start -->
Begin by creating a basic tool structure with MANIFEST.json files. Experiment with Cursor's rules system and observe how AI behavior changes with different rule configurations.

<!-- medium:end -->

<!-- advanced:start -->
Implement a complete toolset following the patterns described. Create operation codes, integrate with MCP servers, and establish automated verification workflows. Consider contributing to open-source AI-first repository templates.

<!-- advanced:end -->
