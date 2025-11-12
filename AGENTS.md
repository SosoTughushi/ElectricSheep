# AGENTS.md - README for AI Agents

> **This is the primary entry point for AI agents working on this repository.**
> 
> Read this file first, then proceed to detailed rules in `rules/` directory.

## Quick Start

**First time here?** Follow this sequence:

1. **Read this file** (you're here) - Understand core philosophy
2. **Read `rules/README.md`** - Complete rules directory index and onboarding path
3. **Read `rules/development-workflow.cursorrules`** - Applies to EVERY message
4. **Read `docs/guides/ai-agent-workflow.md`** - Comprehensive workflow guide
5. **Read domain-specific rules** as needed for your task

## Core Philosophy

### AI-First Design

This repository is designed **by AI, for AI**. Every structure, convention, and pattern is optimized for autonomous AI agent operation.

**Key Principles:**
- **Self-documenting**: Tools include `MANIFEST.json` files for AI discovery
- **Standardized patterns**: Consistent structure across all tools
- **Textual interfaces**: Commands produce clear, parseable output
- **Feedback loops**: Features enable AI to verify and correct its own work

### Textual Feedback Loop

The fundamental workflow:

```
Edit Code → Run Code → Capture Output → Analyze → Self-Correct → Repeat
```

**Never ask the user to run commands** - run them yourself, capture output, analyze, and fix.

## Repository Structure

```
electric-sheep/
├── AGENTS.md              # You are here - agent entry point
├── README.md              # Human-facing documentation
├── rules/                 # All rulesets (see rules/README.md)
│   ├── README.md         # Rules directory index ⭐ START HERE
│   ├── development-workflow.cursorrules  # Applies to EVERY message
│   ├── execution-preference.cursorrules  # How to execute commands
│   ├── error-handling.cursorrules        # Error recovery patterns
│   ├── decision-making.cursorrules       # Decision framework
│   ├── privacy-compliance.cursorrules   # Privacy guidelines
│   └── policy-cards/     # Runtime governance policies
├── docs/                  # Documentation
│   ├── guides/           # Detailed guides
│   └── architecture/     # Architecture docs
├── tools/                 # Toolset directory
│   ├── system/           # System tools
│   ├── ai/               # AI/ML tools
│   ├── dev/              # Development tools
│   └── misc/             # Miscellaneous
└── .toolset/             # Toolset metadata
    ├── registry.json     # Tool registry (source of truth)
    └── operations.json   # Operation definitions
```

## Core Conventions

### Execution
- **Always run commands directly** - Use `run_terminal_cmd` tool
- **Capture all output** - Redirect to `logs/` directory
- **Use non-interactive flags** - `--yes`, `-y`, etc.
- **Quote paths with spaces** - Windows path handling

### Documentation
- **Update docs in same iteration** as code changes
- **Priority order**: README.md → ruleset → MANIFEST.json → registry.json
- **Document the "why"** not just the "what"

### Discovery
- **Check registry first** - `.toolset/registry.json` is source of truth
- **Read MANIFEST.json** - Understand tool structure before modifying
- **Query operations** - Use `python .toolset/discover_operations.py`

### Error Handling
- **Self-correct on errors** - Fix based on output analysis
- **Use structured error messages** - `ERROR_TYPE:`, `ERROR_FILE:`, etc.
- **Set exit codes** - `exit 0` (success) or `exit 1` (failure)
- **Log everything** - Redirect output to log files

## Rule Precedence

Rules follow hierarchical precedence (highest to lowest):

1. **System rules** - Core operational constraints (policy cards)
2. **Project rules** - Repository-wide rules (`development-workflow.cursorrules`)
3. **Domain rules** - Category-specific rules (`mcp-tool-integration.cursorrules`)
4. **Tool rules** - Tool-specific rules (in tool directories)

When conflicts occur, higher precedence wins. See `rules/README.md` for details.

## Decision Framework

When encountering ambiguous situations:

1. **Check rules** - Is there a relevant ruleset?
2. **Check examples** - Look for similar patterns
3. **Check registry** - What do existing tools do?
4. **Proceed autonomously** - If safe and reversible
5. **Ask user** - Only if irreversible or high-risk

See `rules/decision-making.cursorrules` for detailed guidance.

## Privacy & Security

**Never commit:**
- User-specific paths
- API keys
- Personal data
- Local configuration (`.local/config.json`)

**Always commit:**
- Operation codes
- Tool structure
- Manifests (with placeholders)
- Documentation

See `rules/privacy-compliance.cursorrules` for details.

## Multi-Agent Coordination

Multiple agents work on the same codebase:

- **Single source of truth** - `.toolset/registry.json`
- **Standardized manifests** - Consistent format prevents conflicts
- **Document changes** - Update README files for other agents
- **Resolve conflicts** - See `docs/architecture/multi-agent-coordination.md`

## Quick Reference

**I want to...**
- **Add a tool** → Read `rules/mcp-tool-integration.cursorrules`
- **Fix a bug** → Read `rules/error-handling.cursorrules`
- **Make a decision** → Read `rules/decision-making.cursorrules`
- **Handle privacy** → Read `rules/privacy-compliance.cursorrules`
- **Understand workflow** → Read `docs/guides/ai-agent-workflow.md`

See `docs/guides/quick-reference.md` for complete decision matrix.

## Next Steps

1. ✅ Read `rules/README.md` - Complete rules directory and onboarding
2. ✅ Read `rules/development-workflow.cursorrules` - Applies to every message
3. ✅ Read `docs/guides/ai-agent-workflow.md` - Comprehensive guide
4. ✅ Read domain-specific rules as needed

## Resources

- **Rules Index**: `rules/README.md`
- **Workflow Guide**: `docs/guides/ai-agent-workflow.md`
- **Quick Reference**: `docs/guides/quick-reference.md`
- **Multi-Agent**: `docs/architecture/multi-agent-coordination.md`
- **Tool Registry**: `.toolset/registry.json`
- **Operations**: `.toolset/operations.json`

---

**Remember**: This is an AI-first repository. Work autonomously, verify your own changes, and document as you go.

