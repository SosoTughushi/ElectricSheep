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

For example, your project might look like this:
- `tools/` - All your scripts and programs
- `docs/` - Documentation and guides
- `rules/` - Instructions for AI assistants
- `README.md` - Main project description

Keep folder names simple and clear. Avoid abbreviations that might confuse AI assistants.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Establish a clear directory hierarchy: `tools/` for executable tools organized by category, `docs/` for documentation, `rules/` for AI agent guidelines, and `.toolset/` for metadata. Each tool should include a MANIFEST.json with standardized metadata for AI discovery.

**Recommended Structure:**
```
project-root/
├── tools/
│   ├── system/          # System-level tools
│   ├── ai/              # AI/ML tools
│   └── dev/             # Development tools
├── docs/
│   ├── guides/          # How-to guides
│   └── architecture/    # System design docs
├── rules/               # Cursor rules and conventions
│   └── *.cursorrules    # Rule files
└── .toolset/            # Metadata and registries
    ├── registry.json    # Tool inventory
    └── operations.json  # Operation definitions
```

Each tool directory should contain:
- `MANIFEST.json` - Tool metadata (name, description, parameters)
- `README.md` - Tool documentation
- `scripts/` - Executable scripts

This structure enables AI agents to discover and understand tools programmatically.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Implement a hierarchical directory structure following domain-driven design principles: `tools/{category}/{tool-name}/` with standardized subdirectories (`scripts/`, `src/`, `docs/`). Each tool requires a MANIFEST.json following the toolset schema, including id, description, parameters, and AI-friendly metadata. The `.toolset/` directory contains registry.json (tool inventory), operations.json (operation definitions), and configuration files. This structure enables programmatic tool discovery and execution.

<!-- advanced:end -->

---

## Working with Cursor

<!-- simple:start -->
**Simple:** This repository uses an **AI-first approach** where AI agents handle most tasks automatically. You don't need to write perfect comments or organize files perfectly - the AI agents handle that for you!

**How It Works:**
- **AI generates documentation** - You don't need to write README files or comments; agents create them
- **AI organizes code** - Agents follow standardized patterns and maintain structure
- **AI verifies its own work** - Through structured output and exit codes, agents self-correct
- **You focus on what matters** - Describe what you want, and agents handle the implementation details

**Example:** When you say "Add a tool to monitor GPU temperature", the AI agent will:
1. Create the tool following standard structure
2. Write the documentation automatically
3. Update the registry
4. Test it and verify it works
5. Report success

You don't need to write any code, documentation, or organize files - the agent handles everything!

**Effective Conversations:**
- ✅ "Add a tool to monitor GPU temperature" - Agent handles everything
- ✅ "Fix the script error with brackets in filenames" - Agent self-corrects and updates docs
- ✅ "How does the Bambu Lab tool work?" - Agent discovers and explains automatically
- ❌ "Please write comments explaining this code" - Not needed, agent generates docs automatically

**Remember:** In an AI-first repository, you describe goals and let AI agents do the work. You don't need to write perfect code or documentation - agents handle that!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** This repository implements an **AI-first architecture** where AI agents operate autonomously through textual feedback loops. Cursor's AI models work best when agents can discover tools programmatically, execute operations automatically, and self-correct based on structured output.

**AI-First Principles:**

1. **Autonomous Operation**: AI agents run commands directly, capture output, analyze results, and self-correct without asking you to run commands manually.

2. **Textual Feedback Loop**: The core workflow: Edit Code → Execute → Capture Output → Parse → Analyze → Self-Correct → Verify → Repeat. This enables agents to verify and fix their own work.

3. **Structured Metadata**: Tools include `MANIFEST.json` files with standardized metadata. AI agents can discover and understand tools without reading source code.

4. **Programmatic Discovery**: Use `.toolset/registry.json` for tool discovery and operation codes (`tool:action`) for execution. This enables AI agents to find and use tools autonomously.

5. **Self-Verification**: Agents verify their own work through:
   - Structured output: `STATUS: SUCCESS`, `ERROR_TYPE: FileNotFound`
   - Exit codes: 0 = success, non-zero = failure
   - Output parsing and analysis

**Effective Agent Conversations:**

**Example 1**: "Add a GPU monitoring tool"
- Agent checks registry → creates tool structure → generates MANIFEST.json → writes README.md → updates registry → tests → reports success
- **You don't write any code or docs** - agent handles everything

**Example 2**: "Fix the script error with special characters"
- Agent runs script → captures error → analyzes → fixes → re-runs → updates troubleshooting docs → reports fix
- **Agent self-corrects and documents automatically**

**Example 3**: "How does tool X work?"
- Agent queries registry → reads MANIFEST.json → reads README.md → explains capabilities
- **Agent discovers information autonomously**

**Key Point**: In an AI-first repository, you describe goals and let agents handle implementation. Agents generate documentation, organize code, and verify their own work through structured feedback loops.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** This repository implements an **AI-first architecture** optimized for autonomous AI agent operation. The core principle is the **textual feedback loop**: agents edit code → execute → capture output → parse → analyze → self-correct → verify → repeat. This enables fully autonomous operation where agents generate documentation, organize code, and verify their own work without human intervention.

**Architectural Patterns:**

1. **Textual Feedback Loop**: Agents verify their own work through structured output parsing, exit code validation, and iterative self-correction. Never ask users to run commands - agents execute directly and capture all output.

2. **Programmatic Discovery**: Tools registered in `.toolset/registry.json` with standardized `MANIFEST.json` files enable AI agents to discover and understand tools without reading source code. Operation codes (`tool:action`) enable version-independent execution.

3. **Autonomous Documentation**: Agents generate documentation automatically in the same iteration as code changes. Users don't write README files or comments - agents create them following standardized patterns.

4. **Self-Verification Mechanisms**: Agents validate their own work through:
   - Structured output: `STATUS: SUCCESS`, `ERROR_TYPE: FileNotFound`, `ERROR_SUGGESTION: ...`
   - Exit codes: 0 = success, non-zero = failure
   - Output pattern matching against expected behavior
   - Dependency verification before execution

5. **Hierarchical Rule System**: Rules follow precedence (system > project > domain > tool) enabling conflict resolution. Cursor rules configured following this hierarchy guide agent behavior consistently.

**Effective Agent Conversations:**

**Example 1**: "Add a GPU monitoring tool"
- Agent: Checks `.toolset/registry.json` → Creates `tools/system/gpu-monitor/` → Generates `MANIFEST.json` → Writes `README.md` → Updates registry → Executes tests → Reports `STATUS: SUCCESS`, `TOOL_ID: gpu-monitor`
- **User writes zero code or documentation** - agent handles everything autonomously

**Example 2**: "Fix script error with brackets in filenames"
- Agent: Executes script → Captures `ERROR_TYPE: FileNotFound`, `ERROR_FILE: file[1].txt` → Analyzes PowerShell cmdlet issue → Fixes using `.NET` methods → Re-executes → Updates `README.md` troubleshooting → Updates ruleset → Reports `STATUS: FIXED`
- **Agent self-corrects and documents automatically**

**Example 3**: "How does the Bambu Lab tool work?"
- Agent: Queries `.toolset/registry.json` → Finds `bambu-lab-affinity` → Reads `MANIFEST.json` → Reads `README.md` → Explains capabilities and operation code
- **Agent discovers information autonomously using standardized structure**

**Key Principle**: In an AI-first repository, users describe goals and agents handle implementation. Agents generate documentation, organize code following standardized patterns, and verify their own work through textual feedback loops. Users don't need to write perfect comments or organize files perfectly - agents handle that autonomously.

<!-- advanced:end -->

---

## Best Practices

<!-- simple:start -->
**Simple:** Keep things simple and organized. Write clear names for files and folders. Add comments explaining what your code does. Make sure your README file explains how to use your project.

**Best Practices:**
- Name files clearly: `generate-report.py` is better than `gr.py`
- Use folders to group related files
- Write a README that explains:
  - What your project does
  - How to set it up
  - How to use it
- Add comments in your code explaining tricky parts
- Keep your code organized and easy to read

Remember: If AI can understand your code easily, it can help you better!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Follow these practices: (1) Use descriptive, consistent naming conventions, (2) Include MANIFEST.json files for all tools with complete metadata, (3) Maintain up-to-date README files with usage examples, (4) Document the "why" not just the "what", (5) Use standardized script interfaces, and (6) Keep documentation close to code.

**Detailed Practices:**

**1. Naming Conventions**
- Use kebab-case for files: `my-tool.ps1`
- Use descriptive names: `train-model.py` not `train.py`
- Be consistent across the project

**2. MANIFEST.json Files**
Every tool should have a MANIFEST.json with:
- Tool name and description
- Parameters and their types
- Usage examples
- Entry points

**3. README Files**
Include:
- Purpose and capabilities
- Installation instructions
- Usage examples
- Troubleshooting tips

**4. Documentation Philosophy**
- Explain "why" decisions were made
- Document assumptions and constraints
- Include examples for common use cases

**5. Script Interfaces**
- Use consistent parameter formats
- Provide help text (`--help` flags)
- Return clear exit codes (0 = success, non-zero = error)

**6. Documentation Location**
- Keep docs near the code they describe
- Use README.md in each directory
- Reference related documentation

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Implement these architectural patterns: (1) Semantic versioning for tools and operations, (2) Operation codes (`tool:operation`) for programmatic tool invocation, (3) Structured error handling with parseable output formats, (4) Non-interactive command interfaces (use `--yes` flags), (5) Textual output for AI parsing (avoid binary formats), (6) Self-verification mechanisms enabling AI to validate its own changes, and (7) Privacy-aware design separating public (committed) from private (local config) data.

<!-- advanced:end -->

---

## Advanced Architectural Patterns

<!-- simple:start -->
**Simple:** Advanced setups use special files that help AI understand your project better. These files act like a map that shows AI where everything is and how to use it.

**Key Files:**
- **MANIFEST.json** - Describes what each tool does and how to use it
- **registry.json** - Lists all available tools in your project
- **operations.json** - Lists all actions that can be performed

Think of these files like a restaurant menu: they tell AI what's available and how to order it. Without them, AI has to search through all your code to figure things out. With them, AI can quickly find what it needs.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Advanced AI-first repositories implement sophisticated metadata systems including tool registries, operation codes, and manifest files. These systems enable programmatic discovery, standardized interfaces, and autonomous tool execution by AI agents.

**Core Components:**

**1. Tool Registry** (`.toolset/registry.json`)
A central list of all tools in your repository. Each entry includes:
- Tool ID and name
- Category (system, ai, dev, misc)
- File path
- Status (active, deprecated, experimental)
- Version number

**2. Operation Codes**
Unique identifiers for operations, like `tool:action` or `tool:category:action`. Examples:
- `bambu-lab:launch` - Launch an application
- `musubi-tuner:train` - Train a model

These codes enable AI to execute operations without knowing exact file paths.

**3. Manifest Files** (`MANIFEST.json`)
Each tool includes a manifest describing:
- What the tool does
- What parameters it accepts
- How to use it (examples)
- Entry points (which scripts to run)

**Benefits:**
- AI can discover tools without reading source code
- Standardized interfaces make automation easier
- Version tracking enables evolution management
- Operation codes remain stable across changes

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Advanced AI-first architectures implement several critical patterns:

### Tool Registry System

A centralized [`.toolset/registry.json`](https://github.com/SosoTughushi/ElectricSheep/blob/master/.toolset/registry.json) serves as the single source of truth for tool discovery. Each tool entry includes:
- **Tool ID**: Unique identifier following naming conventions
- **Category**: Domain classification (system, ai, dev, misc)
- **Path**: Filesystem location relative to repository root
- **Status**: Active, deprecated, or experimental
- **Version**: Semantic versioning for tool evolution tracking

This registry enables AI agents to programmatically discover available tools without filesystem traversal, reducing computational overhead and ensuring consistency.

**Example**: See the [actual registry](https://github.com/SosoTughushi/ElectricSheep/blob/master/.toolset/registry.json) for real-world tool entries.

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

**Real Examples**:
- [Bambu Lab MANIFEST.json](https://github.com/SosoTughushi/ElectricSheep/blob/master/tools/system/bambu-lab/MANIFEST.json) - Complete system tool example
- [Musubi Tuner MANIFEST.json](https://github.com/SosoTughushi/ElectricSheep/blob/master/tools/ai/musubi-tuner/MANIFEST.json) - AI tool example
- [Remote MCP MANIFEST.json](https://github.com/SosoTughushi/ElectricSheep/blob/master/tools/system/remote-mcp/MANIFEST.json) - Complex tool with multiple operations

### Hierarchical Rule System

Rules follow a precedence hierarchy enabling conflict resolution:

1. **System Rules** (highest precedence): Core operational constraints, policy cards
2. **Project Rules**: Repository-wide conventions ([`development-workflow.cursorrules`](https://github.com/SosoTughushi/ElectricSheep/blob/master/rules/development-workflow.cursorrules))
3. **Domain Rules**: Category-specific patterns ([`mcp-tool-integration.cursorrules`](https://github.com/SosoTughushi/ElectricSheep/blob/master/rules/mcp-tool-integration.cursorrules))
4. **Tool Rules**: Tool-specific guidelines (in tool directories)

When conflicts occur, higher precedence rules override lower precedence. This enables:
- **Consistent behavior**: All agents follow same core principles
- **Domain flexibility**: Category-specific optimizations
- **Tool customization**: Per-tool exceptions when needed
- **Conflict resolution**: Clear precedence prevents ambiguity

**See Also**: [Rules Directory README](https://github.com/SosoTughushi/ElectricSheep/blob/master/rules/README.md) for complete ruleset index

<!-- advanced:end -->

---

## Autonomous AI Agent Workflows

<!-- simple:start -->
**Simple:** AI assistants can check their own work by running code and seeing if it works correctly. This helps them fix mistakes automatically without asking you for help.

**How It Works:**
1. AI writes or changes code
2. AI runs the code automatically
3. AI checks if it worked (did it produce the right output?)
4. If there's an error, AI fixes it and tries again
5. This repeats until it works or AI needs your help

This means AI can fix many problems on its own! For example, if AI writes code with a typo, it can run the code, see the error message, fix the typo, and try again - all without asking you.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** AI-first repositories enable autonomous agent operation through textual feedback loops. Agents edit code, execute it automatically, capture output, analyze results, and self-correct based on errors. This eliminates the need for human intervention in routine development tasks.

**The Feedback Loop Process:**

1. **Code Modification**: Agent makes changes following project patterns
2. **Automatic Execution**: Agent runs commands directly (never asks you to run them)
3. **Output Capture**: All output (success messages, errors, exit codes) is captured
4. **Analysis**: Agent parses output to understand what happened
5. **Self-Correction**: Agent fixes issues based on error analysis
6. **Verification**: Agent re-runs to confirm fixes work

**Key Principles:**
- **Never ask user to run commands** - Execute directly
- **Capture all output** - Store logs for analysis
- **Structured errors** - Use formats like `ERROR_TYPE: FileNotFound`
- **Exit codes** - Use 0 for success, non-zero for failure
- **Iterative fixing** - Try multiple times before asking for help

**Example Flow:**
```
Agent writes script → Runs it → Gets error "File not found" 
→ Checks if file exists → Creates missing file → Runs again 
→ Success! → Moves to next task
```

This enables AI to handle routine tasks autonomously, only escalating when truly stuck.

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

**How They Coordinate:**
- **Registry file** - Lists all tools, so agents know what exists
- **Manifest files** - Describe each tool, so agents understand how to use them
- **Git** - Tracks changes so agents can see what others modified

Think of it like a shared whiteboard: everyone writes what they're working on, so others can see and avoid conflicts. If two agents try to add the same tool, the registry file helps prevent duplicates.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Multiple AI agents can work simultaneously on the same codebase by following standardized structures and using shared metadata files. The registry system prevents conflicts, and manifest files ensure consistent understanding across agents.

**Coordination Mechanisms:**

**1. Single Source of Truth**
- `.toolset/registry.json` - Central tool inventory
- `.toolset/operations.json` - Operation definitions
- Standardized manifest format - Consistent tool metadata

**2. Conflict Prevention**
- Check registry before adding tools (prevent duplicates)
- Use unique operation codes
- Follow naming conventions

**3. Communication Channels**
- **Manifest files** - Describe tool capabilities
- **Documentation** - Explain tool purpose and usage
- **Git commits** - Record changes with clear messages
- **Registry status** - Indicate tool state (active, deprecated)

**4. Conflict Resolution**
- **Non-critical changes** (docs, examples): Last writer wins
- **Critical changes** (registry, operations): Must merge carefully
- **Breaking changes**: Require consensus or user approval

**Best Practices:**
- Always check registry before adding tools
- Read existing manifests to understand patterns
- Update registry atomically (all metadata at once)
- Document changes clearly for other agents
- Validate before committing

This enables multiple agents to work in parallel without stepping on each other's work.

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

**Two Types of Information:**

**Public (Safe to Share):**
- What tools exist
- What each tool does
- How to use tools (examples)
- What parameters tools need

**Private (Keep Secret):**
- Where tools are installed on your computer
- Your API keys and passwords
- Personal file paths
- Your specific settings

Keep private information in a separate config file that doesn't get shared. This way, you can share your project without exposing personal information!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Advanced metadata systems include tool registries, operation definitions, and manifest files that enable AI agents to discover and understand tools without reading source code. These systems separate public metadata (committable) from private configuration (user-specific).

**Public vs Private Separation:**

**Public Metadata** (Committed to Git):
- Tool structure and organization
- Operation codes and descriptions
- Parameter schemas (types, names, descriptions)
- Tool capabilities and examples
- Entry points and interfaces

**Private Configuration** (Local Only, Gitignored):
- Installation paths (`C:\Program Files\...`)
- User-specific directories
- API keys and secrets
- Model file locations
- Personal preferences

**Configuration Pattern:**
1. Create `.local/config.example.json` (committed) with placeholder paths
2. Users copy to `.local/config.json` (gitignored) with their actual paths
3. Scripts load from user config, fallback to defaults if missing

**Benefits:**
- Repository can be shared safely
- Each user configures their own environment
- Sensitive data never committed
- AI can understand tools without user-specific paths

**Example:**
```json
// config.example.json (committed)
{
  "tools": {
    "my-tool": {
      "path": "C:/path/to/tool"
    }
  }
}

// config.json (gitignored, user-specific)
{
  "tools": {
    "my-tool": {
      "path": "D:/MyTools/my-tool"
    }
  }
}
```

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

**What to Keep Private:**
- Passwords and API keys
- File paths on your computer (like `C:\Users\YourName\...`)
- Personal settings
- Secret keys

**What's Safe to Share:**
- Code structure
- How tools work
- Examples (using placeholder paths)
- Documentation

**How to Protect Privacy:**
- Put private info in `.local/config.json` (not shared)
- Use `.gitignore` to prevent sharing private files
- Use example files with placeholder values
- Never hardcode personal paths in code

Remember: If you wouldn't want strangers to see it, don't commit it!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Privacy-aware design separates public metadata (safe to commit) from private configuration (user-specific paths, API keys). This enables repository sharing while protecting sensitive information.

**Privacy Protection Strategies:**

**1. Gitignore Patterns**
Add to `.gitignore`:
```
.local/config.json    # User configuration
.local/logs/         # Execution logs
**/secrets/          # Secret files
**/*.key             # Key files
**/*.env             # Environment files
```

**2. Template-Based Configuration**
- Provide `.local/config.example.json` (committed) with placeholders
- Users copy to `.local/config.json` (gitignored) with real values
- Scripts load from user config with fallbacks

**3. Path Abstraction**
- Scripts accept paths as parameters
- Defaults loaded from config, never hardcoded
- Prefer relative paths over absolute

**4. Secret Management**
- Never hardcode secrets in scripts
- Load from environment variables
- Document required secrets without exposing values

**Privacy Checklist:**
- [ ] No hardcoded user paths
- [ ] No API keys or secrets
- [ ] Config files use templates
- [ ] Examples use placeholders
- [ ] Gitignore covers private files
- [ ] Documentation doesn't expose sensitive data

This enables safe repository sharing while protecting user privacy.

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

**Self-Documenting Tips:**
- **Clear names**: `train-model.py` is better than `train.py`
- **Organized folders**: Group related files together
- **README files**: Put one in each major folder explaining what's there
- **Consistent structure**: Use the same organization everywhere

**Example Structure:**
```
my-project/
├── README.md          # Main project description
├── tools/
│   ├── README.md      # What tools are here
│   └── my-tool/
│       ├── README.md  # How to use this tool
│       └── script.py
└── docs/              # More detailed documentation
```

When everything has a clear name and place, both you and AI can find things quickly!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Self-documenting structures use clear naming, consistent organization, and comprehensive metadata to enable understanding without reading source code. Manifests, registries, and standardized patterns make tools discoverable and understandable.

**Documentation Hierarchy:**

**Level 1: Entry Points**
- `README.md` - Project overview
- `QUICKSTART.md` - Quick start guide
- `AGENTS.md` - AI agent onboarding

**Level 2: Rules and Conventions**
- `rules/README.md` - Rules directory index
- `rules/*.cursorrules` - Cursor rule files

**Level 3: Guides and Architecture**
- `docs/guides/` - How-to guides
- `docs/architecture/` - System design docs

**Level 4: Metadata**
- `MANIFEST.json` - Tool metadata
- `.toolset/registry.json` - Tool registry
- `.toolset/operations.json` - Operation definitions

**Naming Conventions:**
- Directories: `tools/{category}/{tool-name}/`
- Files: `MANIFEST.json`, `README.md`, `*.cursorrules`
- Operations: `tool:action` or `tool:category:action`

**Documentation Proximity:**
- Tool docs in `tools/{category}/{tool-name}/README.md`
- Script docs near scripts
- Rule docs in `rules/` directory

**Self-Discovery Mechanisms:**
- Registry-based discovery (query `.toolset/registry.json`)
- Manifest-based understanding (read `MANIFEST.json`)
- Operation-based execution (use operation codes)

This layered approach enables understanding at different levels of detail without reading source code.

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Self-documenting structures in AI-first repositories implement several architectural patterns:

### Hierarchical Documentation System

**Level 1: Entry Points**
- [`AGENTS.md`](https://github.com/SosoTughushi/ElectricSheep/blob/master/AGENTS.md) - AI agent onboarding (primary entry)
- [`README.md`](https://github.com/SosoTughushi/ElectricSheep/blob/master/README.md) - Human-facing documentation
- [`QUICKSTART.md`](https://github.com/SosoTughushi/ElectricSheep/blob/master/QUICKSTART.md) - Quick start guide

**Level 2: Rules and Conventions**
- [`rules/README.md`](https://github.com/SosoTughushi/ElectricSheep/blob/master/rules/README.md) - Rules directory index
- [`rules/development-workflow.cursorrules`](https://github.com/SosoTughushi/ElectricSheep/blob/master/rules/development-workflow.cursorrules) - Core workflow rules
- Domain-specific rulesets for specialized patterns

**Level 3: Guides and Architecture**
- `docs/guides/` - Detailed workflow guides
- `docs/architecture/` - System architecture documentation
- Tool-specific README files

**Level 4: Metadata**
- `MANIFEST.json` - Tool metadata (see [Bambu Lab example](https://github.com/SosoTughushi/ElectricSheep/blob/master/tools/system/bambu-lab/MANIFEST.json))
- [`.toolset/registry.json`](https://github.com/SosoTughushi/ElectricSheep/blob/master/.toolset/registry.json) - Tool registry
- [`.toolset/operations.json`](https://github.com/SosoTughushi/ElectricSheep/blob/master/.toolset/operations.json) - Operation definitions

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

See the [actual registry](https://github.com/SosoTughushi/ElectricSheep/blob/master/.toolset/registry.json) for implementation.

**2. Manifest-Based Understanding**
```powershell
# Understand tool without reading source
$manifest = Get-Content tools/ai/tool/MANIFEST.json | ConvertFrom-Json
$capabilities = $manifest.description
$parameters = $manifest.parameters
```

Example: [Musubi Tuner MANIFEST.json](https://github.com/SosoTughushi/ElectricSheep/blob/master/tools/ai/musubi-tuner/MANIFEST.json)

**3. Operation-Based Execution**
```powershell
# Execute by operation code
python .toolset/discover_operations.py --code tool:operation
# Get entry point and parameters
```

See [operations discovery guide](https://github.com/SosoTughushi/ElectricSheep/blob/master/docs/guides/operations-discovery.md) for details.

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

**How It Works:**
- AI can ask "What tools are available?" and get a list
- AI can ask "How do I use tool X?" and get instructions
- AI can run tools using simple codes like `tool:action`

**Example:**
Instead of remembering `.\tools\system\my-tool\scripts\run.ps1 -Param value`, AI can use `my-tool:run` and the system figures out the rest!

This makes it much easier for AI to help you - it doesn't need to remember long file paths or complicated commands.

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Programmatic interfaces enable AI agents to discover tools, understand capabilities, and execute operations through standardized APIs. Operation codes, discovery scripts, and structured metadata enable automation.

**Key Interfaces:**

**1. Operation Codes**
Structured identifiers like `tool:action` or `tool:category:action`:
- `bambu-lab:launch` - Launch application
- `musubi-tuner:train` - Train model
- `cpu-affinity:check` - Check settings

**2. Discovery APIs**
- List all operations: `python .toolset/discover_operations.py`
- Filter by category: `--category ai`
- Get operation details: `--code tool:operation`

**3. Execution Methods**
- Direct script execution: `.\tools\category\tool\scripts\main.ps1`
- Operation-based: `Invoke-Operation -Code "tool:operation"`
- Future MCP integration for remote execution

**4. Interface Patterns**
- **Non-interactive**: Always use `--yes`, `--force` flags
- **Structured output**: `STATUS: SUCCESS`, `ERRORS: 0`
- **Exit codes**: 0 = success, non-zero = failure
- **Error reporting**: `ERROR_TYPE: ValidationFailed`

**Benefits:**
- Standardized interfaces across all tools
- Programmatic discovery without filesystem traversal
- Automation-friendly (non-interactive execution)
- Parseable output for AI analysis

This enables AI agents to autonomously discover and execute operations.

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

---

## Further Reading

<!-- simple:start -->
**Simple:** Want to learn more? Here are some helpful resources about AI-assisted development and organizing code for AI:

- **[Cursor Documentation](https://cursor.sh/docs)** - Learn how to use Cursor effectively
- **[GitHub Copilot](https://github.com/features/copilot)** - Another AI coding assistant with similar concepts
- **[Clean Code Book](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)** - A book about writing code that's easy to understand
- **[GitHub Search](https://github.com/search?q=ai-first+cursor-ready&type=repositories)** - Look for "AI-first" or "cursor-ready" templates on GitHub

Search for "AI coding assistant best practices" or "organizing code for AI" to find more resources!

<!-- simple:end -->

<!-- medium:start -->
**Medium:** Explore these resources to deepen your understanding of AI-first development and related concepts:

**AI Development Tools:**
- [Cursor Documentation](https://cursor.sh/docs) - Official Cursor IDE documentation
- [GitHub Copilot](https://github.com/features/copilot) - AI pair programming tool
- [Codeium](https://codeium.com/) - Free AI coding assistant
- [Continue.dev](https://www.continue.dev/) - Open-source AI coding assistant

**Repository Organization:**
- [Semantic Versioning](https://semver.org/) - Version numbering standards
- [Keep a Changelog](https://keepachangelog.com/) - Changelog best practices
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message standards

**AI-Agent Development:**
- [LangChain](https://www.langchain.com/) - Framework for building AI applications
- [AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) - Autonomous AI agent framework
- [AgentGPT](https://agentgpt.reworkd.ai/) - Browser-based AI agent platform

**Code Quality:**
- [Clean Code by Robert Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - Writing maintainable code
- [The Art of Readable Code](https://www.amazon.com/Art-Readable-Code-Practical-Techniques/dp/0596802293) - Code readability principles

**Related Repositories:**
- Search GitHub for "AI-first", "cursor-ready", or "AI-agent" repositories
- Look for projects using `.cursorrules` files
- Find repositories with tool registries or manifest systems

<!-- medium:end -->

<!-- advanced:start -->
**Advanced:** Deep dive into these resources exploring AI-first development, autonomous agents, and related architectural patterns:

**AI Development Tools & Frameworks:**
- [Cursor Documentation](https://cursor.sh/docs) - Official Cursor IDE documentation and best practices
- [GitHub Copilot](https://github.com/features/copilot) - Microsoft's AI pair programming tool
- [Continue.dev](https://www.continue.dev/) - Open-source AI coding assistant with extensibility
- [Codeium](https://codeium.com/) - Free AI coding assistant with multiple model support
- [Tabnine](https://www.tabnine.com/) - AI code completion tool

**Autonomous AI Agents:**
- [AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) - Autonomous AI agent framework with goal-oriented execution
- [AgentGPT](https://agentgpt.reworkd.ai/) - Browser-based autonomous AI agent platform
- [LangChain](https://www.langchain.com/) - Framework for building LLM-powered applications
- [LangGraph](https://github.com/langchain-ai/langgraph) - Stateful agent orchestration framework
- [CrewAI](https://github.com/joaomdmoura/crewAI) - Multi-agent framework for collaborative AI agents
- [AutoGen](https://github.com/microsoft/autogen) - Microsoft's multi-agent conversation framework

**Repository Organization & Standards:**
- [Semantic Versioning](https://semver.org/) - Version numbering specification
- [Keep a Changelog](https://keepachangelog.com/) - Changelog format standards
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message convention
- [Semantic Release](https://semantic-release.gitbook.io/) - Automated version management

**Code Architecture & Patterns:**
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Robert Martin's architectural principles
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html) - Eric Evans' DDD concepts
- [The Twelve-Factor App](https://12factor.net/) - Methodology for building SaaS applications
- [API Design Patterns](https://cloud.google.com/apis/design) - Google's API design guide

**AI-Agent Research & Papers:**
- [ReAct: Synergizing Reasoning and Acting](https://arxiv.org/abs/2210.03629) - Reasoning + Acting pattern
- [AutoGPT Paper](https://github.com/Significant-Gravitas/AutoGPT/tree/master/benchmark) - Autonomous agent research
- [Tool Learning with Foundation Models](https://arxiv.org/abs/2304.08354) - Tool use in LLMs

**MCP & Protocol Standards:**
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) - Protocol for AI-tool integration
- [OpenAI Function Calling](https://platform.openai.com/docs/guides/function-calling) - Function calling patterns
- [Anthropic Tools](https://docs.anthropic.com/claude/docs/tools-use) - Claude's tool use system

**Related Repositories & Projects:**
- [Awesome AI Coding Tools](https://github.com/sindresorhus/awesome#ai-coding-tools) - Curated list of AI coding tools
- Search GitHub for: `topic:ai-first`, `topic:cursor-rules`, `topic:ai-agent`
- Look for repositories using `.cursorrules`, tool registries, or manifest systems
- Explore projects implementing autonomous agent workflows

**Community & Discussions:**
- [Cursor Discord](https://discord.gg/cursor) - Cursor community discussions
- [r/Cursor](https://www.reddit.com/r/cursor/) - Reddit community
- [LangChain Discord](https://discord.gg/langchain) - LangChain community
- [AI Engineering Discord](https://discord.gg/ai-engineering) - AI engineering discussions

**Books:**
- [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - Robert C. Martin
- [The Art of Readable Code](https://www.amazon.com/Art-Readable-Code-Practical-Techniques/dp/0596802293) - Dustin Boswell
- [Designing Data-Intensive Applications](https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321) - Martin Kleppmann

These resources provide deeper insights into AI-first development, autonomous agent architectures, and related patterns that complement the concepts discussed in this guide.

<!-- advanced:end -->
