# Rules Directory

This directory contains rulesets for AI agents working on this repository. These rules guide agent behavior and ensure consistent development practices.

## First-Time Agent Onboarding

**New to this repository?** Follow this exact sequence:

### Step 1: Read Entry Point
1. **Read `AGENTS.md`** (root level) - Core philosophy and quick start
2. **Read this file** (`rules/README.md`) - Complete rules directory index

### Step 2: Read Core Rules (Required)
3. **Read `development-workflow.cursorrules`** ⭐ **CRITICAL** - Applies to EVERY message
4. **Read `execution-preference.cursorrules`** - How to execute commands
5. **Read `error-handling.cursorrules`** - Error recovery patterns
6. **Read `decision-making.cursorrules`** - Decision framework

### Step 3: Read Comprehensive Guide
7. **Read `docs/guides/ai-agent-workflow.md`** - Complete workflow guide

### Step 4: Read Task-Specific Rules (As Needed)
8. **Adding/modifying tools?** → `mcp-tool-integration.cursorrules`
9. **Working with operations?** → `toolset-operations.cursorrules`
10. **Privacy concerns?** → `privacy-compliance.cursorrules`
11. **Domain-specific work?** → Read relevant domain rules

### Step 5: Validation Checklist

Before starting work, verify:
- [ ] Read `AGENTS.md` for core philosophy
- [ ] Read `development-workflow.cursorrules` (applies to every message)
- [ ] Read `execution-preference.cursorrules` (how to run commands)
- [ ] Read `error-handling.cursorrules` (error recovery)
- [ ] Read `decision-making.cursorrules` (decision framework)
- [ ] Read task-specific rules as needed
- [ ] Understand rule precedence (see below)

## Decision Tree: What Should I Read First?

```
Are you new to this repository?
├─ YES → Read AGENTS.md → Read this file → Follow onboarding steps above
└─ NO → Continue below

What is your task?
├─ General development → development-workflow.cursorrules
├─ Adding/modifying tools → mcp-tool-integration.cursorrules
├─ Running commands → execution-preference.cursorrules
├─ Encountering errors → error-handling.cursorrules
├─ Making decisions → decision-making.cursorrules
├─ Privacy concerns → privacy-compliance.cursorrules
├─ Working with operations → toolset-operations.cursorrules
├─ Article-writing tools → ai-article-writer.cursorrules
└─ Domain-specific → Read relevant domain rule
```

## Quick Reference Matrix

| Task | Primary Rule | Secondary Rules |
|------|-------------|----------------|
| **Starting work** | `AGENTS.md` | `development-workflow.cursorrules` |
| **Adding a tool** | `mcp-tool-integration.cursorrules` | `development-workflow.cursorrules`, `toolset-operations.cursorrules` |
| **Running commands** | `execution-preference.cursorrules` | `error-handling.cursorrules` |
| **Handling errors** | `error-handling.cursorrules` | `execution-preference.cursorrules` |
| **Making decisions** | `decision-making.cursorrules` | `development-workflow.cursorrules` |
| **Privacy/data** | `privacy-compliance.cursorrules` | `development-workflow.cursorrules` |
| **Using operations** | `toolset-operations.cursorrules` | `execution-preference.cursorrules` |
| **Bambu Lab issues** | `bambu-lab-fix.cursorrules` | `error-handling.cursorrules` |
| **Article-writing tools** | `ai-article-writer.cursorrules` | `development-workflow.cursorrules` |
| **System info** | `system-info.cursorrules` | `execution-preference.cursorrules` |

## Rule Categories

### Core Rules (Always Apply)
- **`development-workflow.cursorrules`** ⭐ **REQUIRED** - Applies to every message
- **`execution-preference.cursorrules`** - How to execute commands
- **`error-handling.cursorrules`** - Error recovery patterns
- **`decision-making.cursorrules`** - Decision framework
- **`privacy-compliance.cursorrules`** - Privacy and data handling

### Tool Integration Rules
- **`mcp-tool-integration.cursorrules`** - How to add new tools to the toolset
- **`toolset-operations.cursorrules`** - Available operations and usage patterns

### Execution & System Rules
- **`system-info.cursorrules`** - System hardware/OS information

### Domain-Specific Rules
- **`bambu-lab-fix.cursorrules`** - Bambu Lab crash fix solutions and implementation
- **`ai-article-writer.cursorrules`** - Article-writing tools (JavaScript/Node.js stack)

### Policy Cards (Runtime Governance)
- **`policy-cards/operational-policy.md`** - Operational constraints
- **`policy-cards/privacy-policy.md`** - Privacy rules
- **`policy-cards/ethical-policy.md`** - Ethical guidelines

## Hierarchical Rule Precedence

Rules follow a hierarchical precedence system. When conflicts occur, higher precedence wins.

### Precedence Levels (Highest to Lowest)

1. **System Rules** (Policy Cards)
   - `policy-cards/operational-policy.md`
   - `policy-cards/privacy-policy.md`
   - `policy-cards/ethical-policy.md`
   - **Applies to**: Runtime operational constraints, privacy, ethics

2. **Project Rules** (Repository-Wide)
   - `development-workflow.cursorrules` ⭐ **Always applies**
   - `execution-preference.cursorrules`
   - `error-handling.cursorrules`
   - `decision-making.cursorrules`
   - `privacy-compliance.cursorrules`
   - **Applies to**: All development work in this repository

3. **Domain Rules** (Category-Specific)
   - `mcp-tool-integration.cursorrules` (tool integration)
   - `toolset-operations.cursorrules` (operations)
   - `bambu-lab-fix.cursorrules` (Bambu Lab domain)
   - `ai-article-writer.cursorrules` (article-writing tools)
   - **Applies to**: Specific domains or categories

4. **Tool Rules** (Tool-Specific)
   - Rules in individual tool directories
   - Tool-specific `README.md` files
   - **Applies to**: Specific tools only

### Conflict Resolution

When rules conflict:

1. **Check precedence** - Higher precedence wins
2. **Check scope** - More specific rule applies
3. **Check policy cards** - System policies override all
4. **Document conflict** - Note in relevant ruleset
5. **Escalate if needed** - See `decision-making.cursorrules`

**Example:**
- Policy card says "Never commit API keys" (Level 1)
- Tool rule says "Commit config.json" (Level 4)
- **Resolution**: Policy card wins - don't commit API keys, use `.local/config.json`

### Override Mechanisms

Rules can be overridden by:
- **Higher precedence rules** - System > Project > Domain > Tool
- **Explicit exceptions** - Documented in ruleset with justification
- **User instruction** - When user explicitly requests override (document why)

## Rule Priority (Legacy - Use Precedence Above)

1. **`development-workflow.cursorrules`** - Always applies, read first
2. **Domain-specific rules** - Apply when working in that domain
3. **Integration rules** - Apply when adding/modifying tools
4. **Execution rules** - Apply when running code

## Contributing Rules

When adding new rulesets:

1. **Follow naming convention**: `{domain}-{topic}.cursorrules`
2. **Add YAML frontmatter** with metadata:
   ```yaml
   ---
   priority: project|domain|tool
   applies_to: when this rule is relevant
   conflicts_with: list of conflicting rules
   examples: link to examples
   ---
   ```
3. **Add entry to this README.md** - Include in appropriate category
4. **Reference from relevant rules** - Link from `development-workflow.cursorrules` if applicable
5. **Add examples** - Include "Good" vs "Bad" patterns
6. **Keep focused** - One ruleset = one concern

## Related Documentation

- **Entry Point**: `AGENTS.md` - Main agent entry point
- **Workflow Guide**: `docs/guides/ai-agent-workflow.md` - Comprehensive guide
- **Quick Reference**: `docs/guides/quick-reference.md` - One-page cheat sheet
- **Multi-Agent**: `docs/architecture/multi-agent-coordination.md` - Multi-agent patterns

