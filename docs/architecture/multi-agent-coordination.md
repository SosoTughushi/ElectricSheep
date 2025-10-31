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

## Future: MCP Integration

When MCP is implemented, tools will be exposed as:
- Remote-executable resources
- Standardized API endpoints
- Discoverable via MCP protocol

This structure prepares tools for that future while maintaining multi-agent compatibility today.

