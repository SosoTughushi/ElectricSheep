# Multi-Agent Coordination

## How Multiple Agents Work on the Same Codebase

Yes, **multiple AI agents work on the same files** - they share the same codebase and filesystem. This is why our standardized structure is important.

## Why This Structure Helps

### 1. **Single Source of Truth**
- `.toolset/registry.json` - All tools registered here
- `MANIFEST.json` files - Consistent metadata format
- Clear directory structure - Predictable locations

### 2. **Prevents Conflicts**
- **Standardized manifests** - Agents understand tool structure without guessing
- **Clear categorization** - Tools go in predictable locations (`tools/{category}/{tool-name}/`)
- **Documentation** - Each tool self-documents, reducing confusion

### 3. **AI-Friendly Discovery**
When an agent needs to:
- Find a tool → Check `.toolset/registry.json`
- Understand a tool → Read `MANIFEST.json` and `README.md`
- Use a tool → Follow examples in manifest
- Add a tool → Follow existing structure

## Example: Two Agents Working Together

**Agent 1:** "I need to add a new GPU monitoring tool"
1. Checks `.toolset/registry.json` → sees existing tools
2. Checks `tools/system/` → sees system tools pattern
3. Creates `tools/system/gpu-monitor/` following existing structure
4. Creates `MANIFEST.json` using same format
5. Updates `.toolset/registry.json`

**Agent 2:** "I need to use the Bambu Lab tool"
1. Checks `.toolset/registry.json` → finds `bambu-lab-affinity`
2. Reads `tools/system/bambu-lab/MANIFEST.json` → understands parameters
3. Reads `tools/system/bambu-lab/README.md` → sees examples
4. Executes tool correctly

**Result:** Both agents work on same files, understand structure, avoid conflicts.

## Best Practices for Multi-Agent Work

1. **Always check registry first** - `.toolset/registry.json` is the source of truth
2. **Follow manifest format** - Consistency prevents errors
3. **Update registry when adding tools** - Other agents need to know
4. **Read existing manifests** - Understand patterns before creating new ones
5. **Document changes** - Update README files when modifying tools

## File Conventions

- **Manifests**: `tools/{category}/{tool-name}/MANIFEST.json`
- **Documentation**: `tools/{category}/{tool-name}/README.md`
- **Scripts**: `tools/{category}/{tool-name}/scripts/`
- **Registry**: `.toolset/registry.json` (central registry)

## Conflict Prevention

Since agents work on the same files:
- ✅ **Standardized structure** - Predictable locations
- ✅ **Manifest system** - Clear metadata prevents misunderstandings
- ✅ **Registry** - Single source of truth for tool discovery
- ✅ **Documentation** - Self-documenting structure
- ⚠️ **Version control** - Use git properly for merge conflicts
- ⚠️ **Communication** - Agents can read manifests/docs left by others

## Conflict Detection

### Types of Conflicts

**Type 1: Registry Conflicts**
- Multiple agents add tools with same ID
- Same tool registered multiple times
- **Detection**: Check `.toolset/registry.json` for duplicate IDs before adding

**Type 2: File Modification Conflicts**
- Multiple agents modify same file simultaneously
- **Detection**: Check git status before modifying, detect uncommitted changes

**Type 3: Manifest Conflicts**
- Conflicting parameter definitions
- Inconsistent tool metadata
- **Detection**: Validate MANIFEST.json against schema, check for conflicts

**Type 4: Operation Code Conflicts**
- Duplicate operation codes
- Conflicting operation definitions
- **Detection**: Check `.toolset/operations.json` for existing codes

### Conflict Detection Procedures

**Before Making Changes:**

```powershell
# Step 1: Check git status
$status = git status --porcelain
if ($status) {
    Write-Warning "CONFLICT_RISK: Uncommitted changes detected"
    Write-Warning "FILES: $status"
    Write-Warning "ACTION: Review changes before proceeding"
}

# Step 2: Check registry for conflicts
$registry = Get-Content .toolset/registry.json | ConvertFrom-Json
$existingIds = $registry.tools | ForEach-Object { $_.id }
if ($newToolId -in $existingIds) {
    Write-Error "CONFLICT: Tool ID '$newToolId' already exists"
    Write-Error "ACTION: Use different ID or update existing tool"
    exit 1
}

# Step 3: Check operations for conflicts
$operations = Get-Content .toolset/operations.json | ConvertFrom-Json
$existingCodes = $operations.operations | ForEach-Object { $_.code }
if ($newOperationCode -in $existingCodes) {
    Write-Error "CONFLICT: Operation code '$newOperationCode' already exists"
    Write-Error "ACTION: Use different operation code"
    exit 1
}
```

## Conflict Resolution

### Resolution Strategies

**Strategy 1: Last Writer Wins (Default)**
- For non-critical files (documentation, manifests)
- Most recent change takes precedence
- **Use when**: Changes are additive or non-conflicting

**Strategy 2: Merge Required**
- For critical files (registry.json, operations.json)
- Must merge changes, not overwrite
- **Use when**: Changes affect multiple tools/operations

**Strategy 3: Consensus Required**
- For breaking changes or major modifications
- All agents must agree on resolution
- **Use when**: Changes affect core functionality

### Conflict Resolution Procedures

**Procedure 1: Registry Conflicts**

```powershell
# Detect conflict
if ($toolId -in $existingIds) {
    # Check if it's the same tool (same path)
    $existingTool = $registry.tools | Where-Object { $_.id -eq $toolId }
    if ($existingTool.path -eq $newToolPath) {
        # Same tool - update instead of create
        Write-Output "RESOLUTION: Updating existing tool entry"
        # Update existing entry
    } else {
        # Different tool - conflict
        Write-Error "CONFLICT: Tool ID '$toolId' used by different tool"
        Write-Error "EXISTING: $($existingTool.path)"
        Write-Error "NEW: $newToolPath"
        Write-Error "ACTION: Use different tool ID"
        exit 1
    }
}
```

**Procedure 2: File Modification Conflicts**

```powershell
# Before modifying file
$filePath = "tools/system/tool/MANIFEST.json"
$gitStatus = git status --porcelain $filePath

if ($gitStatus) {
    # File has uncommitted changes
    Write-Warning "CONFLICT_RISK: File has uncommitted changes"
    
    # Check if changes are compatible
    $currentContent = Get-Content $filePath -Raw
    $proposedChanges = # ... proposed changes
    
    # Try to merge
    if (CanMerge($currentContent, $proposedChanges)) {
        Write-Output "RESOLUTION: Changes are compatible, proceeding"
        # Apply changes
    } else {
        Write-Error "CONFLICT: Changes conflict with uncommitted modifications"
        Write-Error "ACTION: Wait for other agent to commit, or coordinate merge"
        exit 1
    }
}
```

**Procedure 3: Operation Code Conflicts**

```powershell
# Check for operation code conflicts
$newCode = "new-tool:operation"
$existing = $operations.operations | Where-Object { $_.code -eq $newCode }

if ($existing) {
    # Check if it's the same operation (same tool, same entry point)
    if ($existing.tool_id -eq $newToolId -and $existing.entry_point -eq $newEntryPoint) {
        Write-Output "RESOLUTION: Operation already exists, skipping"
    } else {
        Write-Error "CONFLICT: Operation code '$newCode' already used"
        Write-Error "EXISTING: $($existing.tool_id):$($existing.entry_point)"
        Write-Error "NEW: $newToolId:$newEntryPoint"
        Write-Error "ACTION: Use different operation code"
        exit 1
    }
}
```

### Merge Conflict Resolution

**When Git Merge Conflicts Occur:**

1. **Identify conflict type**
   - Registry conflict (duplicate IDs)
   - File conflict (simultaneous edits)
   - Operation conflict (duplicate codes)

2. **Apply resolution strategy**
   - **Last writer wins**: Accept most recent change
   - **Merge**: Combine both changes if compatible
   - **Consensus**: Escalate to user if incompatible

3. **Validate resolution**
   - Check registry.json is valid JSON
   - Verify no duplicate IDs/codes
   - Test tool discovery still works

4. **Document resolution**
   - Note in commit message
   - Update relevant documentation
   - Log conflict for future reference

**Example Merge Resolution:**

```powershell
# After git merge conflict
# tools/system/new-tool/MANIFEST.json has conflicts

# Step 1: Read conflicted file
$content = Get-Content "tools/system/new-tool/MANIFEST.json" -Raw

# Step 2: Identify conflict markers
if ($content -match "<<<<<<< HEAD") {
    # Conflict detected
    # Extract both versions
    $ourVersion = # ... extract our version
    $theirVersion = # ... extract their version
    
    # Step 3: Merge if compatible
    if (AreCompatible($ourVersion, $theirVersion)) {
        $merged = MergeVersions($ourVersion, $theirVersion)
        Set-Content -Path "tools/system/new-tool/MANIFEST.json" -Value $merged
        Write-Output "RESOLUTION: Merged compatible changes"
    } else {
        Write-Error "CONFLICT: Incompatible changes, manual resolution needed"
        exit 1
    }
}
```

## Communication Patterns

### Via Manifests and Documentation

Agents communicate through:
- **MANIFEST.json** - Tool metadata and structure
- **README.md** - Usage instructions and examples
- **Registry** - Tool discovery and status
- **Git commits** - Change history and coordination

### Best Practices

1. **Read before writing** - Check existing manifests/docs
2. **Update documentation** - Leave notes for other agents
3. **Use consistent patterns** - Follow existing structure
4. **Validate changes** - Ensure compatibility before committing
5. **Document conflicts** - Note resolution in commit messages

## Examples

### Example 1: Avoiding Registry Conflict

**Scenario**: Agent wants to add tool, but ID might conflict.

**Good:**
```powershell
# Check registry first
$registry = Get-Content .toolset/registry.json | ConvertFrom-Json
$newToolId = "gpu-monitor"

if ($newToolId -in ($registry.tools | ForEach-Object { $_.id })) {
    Write-Error "CONFLICT: Tool ID '$newToolId' already exists"
    Write-Error "ACTION: Use different ID like 'gpu-monitor-v2'"
    exit 1
}

# Safe to add
# ... add tool to registry
```

**Bad:**
```powershell
# Don't check - might create duplicate
# Just add tool to registry
# Could cause conflicts
```

### Example 2: Handling File Conflicts

**Scenario**: Multiple agents modifying same README.

**Good:**
```powershell
# Check git status before modifying
$status = git status --porcelain "tools/system/tool/README.md"
if ($status) {
    Write-Warning "CONFLICT_RISK: README.md has uncommitted changes"
    Write-Warning "ACTION: Reading current version, appending changes"
    # Read current, append instead of overwrite
} else {
    # Safe to modify
    # ... update README
}
```

**Bad:**
```powershell
# Overwrite without checking
# Might lose other agent's changes
Set-Content -Path "README.md" -Value $newContent
```

## Future: MCP Integration

When MCP is implemented, tools will be exposed as:
- Remote-executable resources
- Standardized API endpoints
- Discoverable via MCP protocol

This structure prepares tools for that future while maintaining multi-agent compatibility today.

