# Quick Reference Guide

One-page cheat sheet for AI agents working on this repository.

## Decision Matrix: "I Want to X, What Should I Do?"

| Task | Read First | Then Do | Update |
|------|-----------|---------|--------|
| **Start working** | `AGENTS.md` → `rules/README.md` | Read core rules | - |
| **Add a tool** | `rules/mcp-tool-integration.cursorrules` | Create MANIFEST.json, update registry | README.md, registry.json |
| **Run a command** | `rules/execution-preference.cursorrules` | Run directly, capture output | - |
| **Handle error** | `rules/error-handling.cursorrules` | Analyze, self-correct, retry | README.md troubleshooting |
| **Make decision** | `rules/decision-making.cursorrules` | Check rules → proceed/escalate | - |
| **Privacy concern** | `rules/privacy-compliance.cursorrules` | Use .local/config.json | - |
| **Fix a bug** | `rules/development-workflow.cursorrules` | Fix → test → document | README.md, ruleset |
| **Add feature** | `rules/development-workflow.cursorrules` | Code → test → document | README.md, MANIFEST.json |
| **Query operations** | `rules/toolset-operations.cursorrules` | Use discover_operations.py | - |
| **Multi-agent conflict** | `docs/architecture/multi-agent-coordination.md` | Detect → resolve → document | - |

## Common Patterns

### Pattern 1: Adding a Tool
```
1. Read rules/mcp-tool-integration.cursorrules
2. Create tools/{category}/{tool-name}/ directory
3. Create MANIFEST.json with metadata
4. Create README.md with examples
5. Update .toolset/registry.json
6. Test: python mcp/test_registry.py
```

### Pattern 2: Running a Script
```
1. Check execution-preference.cursorrules
2. Run: powershell.exe -ExecutionPolicy Bypass -File script.ps1 *> logs/output.log 2>&1
3. Check exit code: $LASTEXITCODE
4. Analyze output: Get-Content logs/output.log
5. Self-correct if errors found
```

### Pattern 3: Fixing a Bug
```
1. Reproduce bug (run script, capture output)
2. Analyze error output
3. Fix root cause
4. Re-run to verify fix
5. Update README.md troubleshooting section
6. Update relevant ruleset if domain-specific
```

### Pattern 4: Handling Errors
```
1. Capture all output: *> logs/error.log 2>&1
2. Parse structured errors: ERROR_TYPE, ERROR_FILE, etc.
3. Classify error: FileNotFound, PermissionDenied, etc.
4. Apply recovery pattern
5. Re-run to verify
6. Escalate if 3+ failed attempts
```

## Anti-Patterns (Don't Do This)

❌ **Ask user to run commands** - Run them yourself  
❌ **Hardcode user paths** - Use .local/config.json  
❌ **Commit secrets** - Never commit API keys, passwords  
❌ **Skip documentation** - Update docs in same iteration  
❌ **Ignore errors** - Always analyze and self-correct  
❌ **Overwrite without checking** - Check git status first  
❌ **Use unstructured output** - Use STATUS:, ERROR_TYPE: format  
❌ **Skip validation** - Check registry before adding tools  

## Emergency Procedures

### When Things Go Wrong

**Script fails repeatedly:**
1. Check error-handling.cursorrules
2. Verify error type classification
3. Try fallback mechanisms
4. Escalate after 3 attempts

**Can't find tool:**
1. Check .toolset/registry.json
2. Verify MANIFEST.json exists
3. Run: python mcp/test_registry.py
4. Check tool path is correct

**Registry conflict:**
1. Check docs/architecture/multi-agent-coordination.md
2. Verify tool ID is unique
3. Check for uncommitted changes
4. Resolve conflict per procedures

**Privacy violation detected:**
1. Stop operation immediately
2. Check rules/privacy-compliance.cursorrules
3. Remove secrets from code
4. Use .local/config.json instead

## Quick Commands

```powershell
# List all operations
python .toolset/discover_operations.py

# List by category
python .toolset/discover_operations.py --category system

# Get operation details
python .toolset/discover_operations.py --code bambu-lab:launch

# Check registry
Get-Content .toolset/registry.json | ConvertFrom-Json

# Check git status
git status --porcelain

# Validate rules
powershell.exe -ExecutionPolicy Bypass -File rules/validate-rules.ps1
```

## Rule Precedence Quick Reference

1. **System Rules** (Policy Cards) - Highest precedence
   - operational-policy.md
   - privacy-policy.md
   - ethical-policy.md

2. **Project Rules** - Repository-wide
   - development-workflow.cursorrules ⭐ Always applies
   - execution-preference.cursorrules
   - error-handling.cursorrules
   - decision-making.cursorrules
   - privacy-compliance.cursorrules

3. **Domain Rules** - Category-specific
   - mcp-tool-integration.cursorrules
   - toolset-operations.cursorrules
   - bambu-lab-fix.cursorrules

4. **Tool Rules** - Tool-specific (Lowest precedence)

## File Locations

- **Entry Point**: `AGENTS.md` (root)
- **Rules Index**: `rules/README.md`
- **Core Rules**: `rules/*.cursorrules`
- **Policy Cards**: `rules/policy-cards/*.md`
- **Tool Registry**: `.toolset/registry.json`
- **Operations**: `.toolset/operations.json`
- **Local Config**: `.local/config.json` (gitignored)
- **Logs**: `logs/` directory

## Validation Checklist

Before committing changes:
- [ ] Read relevant rulesets
- [ ] Updated README.md (if tool changed)
- [ ] Updated MANIFEST.json (if parameters changed)
- [ ] Updated registry.json (if tool added/modified)
- [ ] No secrets in code
- [ ] No user-specific paths
- [ ] Structured error messages
- [ ] Exit codes set
- [ ] Examples added (if new feature)
- [ ] Documentation updated

## References

- **Entry Point**: `AGENTS.md`
- **Rules Index**: `rules/README.md`
- **Workflow Guide**: `docs/guides/ai-agent-workflow.md`
- **Multi-Agent**: `docs/architecture/multi-agent-coordination.md`

