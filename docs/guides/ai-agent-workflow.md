# AI Agent Workflow Guide

## Overview

This repository is **AI-first** and designed to be used with Cursor or similar AI-powered development tools. The core principle is that AI agents should work autonomously with a **textual feedback loop**: edit code → run it → observe output → self-correct.

## Core Philosophy

### AI-First Design

- **Self-documenting structure**: Tools include `MANIFEST.json` files for AI discovery
- **Standardized patterns**: Consistent structure across all tools
- **Textual interfaces**: Commands and scripts produce clear, parseable output
- **Feedback loops**: Features are designed so AI can verify and correct its own work

### Textual Feedback Loop

The fundamental workflow for AI agents:

```
1. Edit Code
   ↓
2. Run Code (automatically)
   ↓
3. Capture Output (textual)
   ↓
4. Analyze Output
   ↓
5. Self-Correct (if needed)
   ↓
6. Repeat until success
```

## How to Work with This Repository

### 1. Discovery Phase

**Before making changes, always discover what exists:**

```powershell
# List all available operations
python .toolset/discover_operations.py

# Check tool registry
cat .toolset/registry.json

# Read tool manifests
cat tools/{category}/{tool-name}/MANIFEST.json
```

**For AI Agents:**
- Read `rules/development-workflow.cursorrules` first (applies to every message)
- Check `.toolset/registry.json` for available tools
- Read relevant `MANIFEST.json` files to understand tool structure
- Review `rules/README.md` for available rulesets

### 2. Development Phase

**Follow the feedback loop:**

#### Step 1: Make Changes
- Edit code files
- Update manifests if behavior changes
- Update documentation as you go

#### Step 2: Run Immediately
- **Don't ask the user to run commands** - run them yourself
- Use `run_terminal_cmd` to execute scripts
- Capture all output (stdout, stderr, exit codes)

#### Step 3: Analyze Output
- Check exit codes (0 = success, non-zero = failure)
- Parse error messages for actionable information
- Look for expected vs actual behavior mismatches

#### Step 4: Self-Correct
- If errors found, fix them immediately
- Update code based on output analysis
- Re-run to verify fixes

#### Step 5: Document
- Update README.md with changes
- Update MANIFEST.json if parameters changed
- Update registry.json if tool metadata changed
- Add to relevant ruleset if issue was domain-specific

### 3. Execution Preferences

**From `rules/execution-preference.cursorrules`:**

- ✅ **Run commands directly** - Don't ask user to run them
- ✅ **Capture logs** - Redirect output to `logs/` directory
- ✅ **Use non-interactive flags** - `--yes`, `-y`, etc.
- ✅ **Background long-running tasks** - Set `is_background: true`
- ✅ **Quote paths with spaces** - Windows path handling

**Example:**
```powershell
# Good: AI runs command directly
powershell.exe -ExecutionPolicy Bypass -File script.ps1 -Param "value" *> logs/output.log

# Bad: Asking user to run
"Please run: .\script.ps1"
```

### 4. Documentation Updates

**Update documentation in the same iteration as code changes:**

**Priority order:**
1. Tool `README.md` - Usage, examples, troubleshooting
2. Relevant `rules/*.cursorrules` - Domain-specific rules
3. `MANIFEST.json` - If parameters/behavior changed
4. `.toolset/operations.json` - If operation changed
5. `.toolset/registry.json` - If tool metadata changed

**When to update:**
- ✅ After resolving a blocking issue
- ✅ After discovering a workaround
- ✅ After changing tool behavior
- ✅ After adding new functionality
- ✅ After fixing bugs

## Example Workflow

### Scenario: Adding a New Feature

**Iteration 1: Initial Implementation**
```
1. AI reads MANIFEST.json to understand tool structure
2. AI edits code to add feature
3. AI runs script: powershell.exe -File script.ps1
4. Output: "Error: Parameter -NewParam not recognized"
5. AI analyzes: Missing parameter definition
6. AI fixes: Adds parameter to MANIFEST.json
7. AI re-runs script
8. Output: "Success: Feature enabled"
9. AI updates README.md with new feature documentation
```

**Iteration 2: Bug Fix**
```
1. AI runs script with new feature
2. Output: "Error: Cannot access file 'C:\path\file.txt'"
3. AI analyzes: Path handling issue with spaces
4. AI fixes: Adds quotes around path variables
5. AI re-runs script
6. Output: "Success: File processed"
7. AI updates README.md troubleshooting section
8. AI updates relevant ruleset with path handling note
```

## Key Rules for AI Agents

### Always Read First
1. **`rules/development-workflow.cursorrules`** - Applies to every message
2. **`rules/execution-preference.cursorrules`** - How to execute commands
3. **`rules/README.md`** - Complete rules directory index

### When Adding Tools
- Read `rules/mcp-tool-integration.cursorrules`
- Follow existing tool structure
- Create `MANIFEST.json` using same format
- Update `.toolset/registry.json`

### When Running Code
- Run commands directly (don't ask user)
- Capture output to `logs/` directory
- Analyze output before proceeding
- Self-correct on errors

### When Fixing Issues
- Work on resolution first
- Don't update rulesets until issue is resolved
- After resolution: update rulesets, README, manifests
- Document the "why" not just the "what"

## Textual Feedback Loop Best Practices

### 1. Design for Parseable Output

**Good:**
```powershell
Write-Output "STATUS: SUCCESS"
Write-Output "FILES_PROCESSED: 42"
Write-Output "ERRORS: 0"
```

**Bad:**
```powershell
Write-Host "Everything looks good!" -ForegroundColor Green
```

### 2. Use Exit Codes

**Good:**
```powershell
if ($error) {
    Write-Error "Operation failed: $error"
    exit 1
}
exit 0
```

**Bad:**
```powershell
# No exit code, unclear success/failure
```

### 3. Structured Error Messages

**Good:**
```powershell
Write-Error "ERROR_TYPE: FileNotFound"
Write-Error "ERROR_FILE: $filePath"
Write-Error "ERROR_SUGGESTION: Check if file exists"
```

**Bad:**
```powershell
Write-Error "Something went wrong"
```

### 4. Log Everything

**Good:**
```powershell
# Redirect all output to log file
.\script.ps1 *> logs/script-$(Get-Date -Format 'yyyyMMdd-HHmmss').log
```

**Bad:**
```powershell
# Output goes to console, not captured
.\script.ps1
```

## Multi-Agent Coordination

When multiple AI agents work on the same codebase:

1. **Check registry first** - `.toolset/registry.json` is source of truth
2. **Follow manifest format** - Consistency prevents errors
3. **Update registry when adding tools** - Other agents need to know
4. **Read existing manifests** - Understand patterns before creating new ones
5. **Document changes** - Update README files when modifying tools

See `docs/architecture/multi-agent-coordination.md` for details.

## Common Patterns

### Pattern 1: Script Development
```
1. Create script.ps1
2. Run: powershell.exe -File script.ps1 *> logs/test.log
3. Read logs/test.log
4. Fix errors found
5. Re-run until success
6. Update MANIFEST.json with script details
7. Update README.md with usage examples
```

### Pattern 2: Tool Integration
```
1. Read rules/mcp-tool-integration.cursorrules
2. Create tool directory structure
3. Create MANIFEST.json following format
4. Create README.md with examples
5. Update .toolset/registry.json
6. Test tool execution
7. Update .toolset/operations.json if needed
```

### Pattern 3: Bug Fix
```
1. Reproduce bug (run script, capture output)
2. Analyze error output
3. Fix root cause
4. Re-run to verify fix
5. Update README.md troubleshooting section
6. Update relevant ruleset if domain-specific
```

## Tools Available

### Discovery Tools
- `python .toolset/discover_operations.py` - List all operations
- `.toolset/registry.json` - Tool registry
- `tools/{category}/{tool-name}/MANIFEST.json` - Tool metadata

### Execution Tools
- PowerShell scripts in `tools/{category}/{tool-name}/scripts/`
- Python scripts in `tools/{category}/{tool-name}/`
- MCP server for remote access

### Documentation
- `README.md` - Main repository documentation
- `rules/README.md` - Rules directory index
- `docs/guides/` - Detailed guides
- Tool-specific `README.md` files

## Summary

**For AI Agents Working on This Repository:**

1. ✅ **Read rules first** - Especially `development-workflow.cursorrules`
2. ✅ **Run commands directly** - Don't ask user to run them
3. ✅ **Capture output** - Use logs directory, analyze results
4. ✅ **Self-correct** - Fix errors based on output analysis
5. ✅ **Document as you go** - Update README, manifests, registry together
6. ✅ **Follow feedback loop** - Edit → Run → Analyze → Correct → Repeat

**Remember:** This is an AI-first repository. Features should be designed so AI can verify and correct its own work through textual feedback loops.

