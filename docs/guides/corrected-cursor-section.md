# Working with Cursor (Corrected Section)

## AI-First Development Philosophy

This repository is designed with an **AI-first philosophy** - meaning AI agents handle documentation generation, code organization, and most development tasks autonomously. Users don't need to worry about writing perfect comments or organizing files perfectly; the AI agents will handle that.

## How AI Agents Work Here

The core principle is the **textual feedback loop**: AI agents edit code → run it → capture output → analyze → self-correct → repeat. This enables autonomous operation where:

- **AI generates documentation** - You don't need to write README files or comments; agents create them
- **AI organizes code** - Agents follow standardized patterns and maintain structure
- **AI verifies its own work** - Through structured output and exit codes, agents self-correct
- **You focus on what matters** - Describe what you want, and agents handle the implementation details

## Effective Agent Conversations

Here are examples of effective conversations that demonstrate the AI-first approach:

### Example 1: Adding a New Feature

**User**: "Add a tool to monitor GPU temperature"

**Agent Response**:
1. Checks `.toolset/registry.json` for existing tools
2. Creates `tools/system/gpu-monitor/` following standard structure
3. Creates `MANIFEST.json` with tool metadata
4. Creates `README.md` with usage examples
5. Updates registry automatically
6. Runs tests and verifies output
7. Reports success with structured output: `STATUS: SUCCESS`, `TOOL_ID: gpu-monitor`

**Key Point**: User didn't need to write any code, documentation, or organize files - agent handled everything.

### Example 2: Fixing a Bug

**User**: "The script fails when processing files with brackets in the filename"

**Agent Response**:
1. Runs the script to reproduce the error
2. Captures output: `ERROR_TYPE: FileNotFound`, `ERROR_FILE: file[1].txt`
3. Analyzes: PowerShell cmdlet issue with special characters
4. Fixes: Uses `.NET` methods instead: `[System.IO.File]::ReadAllText()`
5. Re-runs script to verify fix
6. Updates `README.md` troubleshooting section automatically
7. Updates relevant ruleset with solution
8. Reports: `STATUS: FIXED`, `SOLUTION: Use .NET methods for special characters`

**Key Point**: Agent self-corrected based on output analysis, updated documentation automatically.

### Example 3: Understanding Existing Code

**User**: "How does the Bambu Lab tool work?"

**Agent Response**:
1. Checks `.toolset/registry.json` → finds `bambu-lab-affinity`
2. Reads `tools/system/bambu-lab/MANIFEST.json` → understands parameters
3. Reads `tools/system/bambu-lab/README.md` → sees examples
4. Explains: "The tool sets CPU affinity for Bambu Studio to prevent crashes. It uses operation code `bambu-lab:launch` and accepts process name as parameter."

**Key Point**: Agent discovered information autonomously using standardized structure.

### Example 4: Multi-Agent Coordination

**Scenario**: Two agents working on the same codebase

**Agent 1**: "I need to add a new GPU monitoring tool"
- Checks registry → sees existing tools
- Creates tool following standard structure
- Updates registry

**Agent 2**: "I need to use the Bambu Lab tool"
- Checks registry → finds tool
- Reads manifest → understands parameters
- Executes correctly

**Key Point**: Both agents work autonomously using the same standardized structure, avoiding conflicts.

## What You Need to Know

As a user, you only need to understand:

1. **Describe what you want** - Be clear about your goal
2. **Trust the feedback loop** - Agents will run code, analyze output, and self-correct
3. **Check structured output** - Agents provide `STATUS:`, `ERROR_TYPE:`, etc. for clarity
4. **Let agents document** - Don't worry about writing perfect documentation; agents generate it

## The Textual Feedback Loop in Action

The fundamental workflow that enables autonomous operation:

```
1. Edit Code
   ↓
2. Run Code (automatically)
   ↓
3. Capture Output (textual, structured)
   ↓
4. Analyze Output
   ↓
5. Self-Correct (if needed)
   ↓
6. Repeat until success
```

**Never ask the user to run commands** - agents run them directly, capture output, analyze, and fix.

## Best Practices for Users

- ✅ **Be clear about goals** - Describe what you want to achieve
- ✅ **Trust the process** - Agents handle implementation details
- ✅ **Review structured output** - Check `STATUS:` messages for results
- ❌ **Don't worry about code organization** - Agents maintain structure
- ❌ **Don't write documentation manually** - Agents generate it
- ❌ **Don't run commands yourself** - Agents run them automatically

## Examples of Structured Output

Agents provide parseable output for verification:

**Success**:
```
STATUS: SUCCESS
FILES_PROCESSED: 42
ERRORS: 0
DURATION: 5.3 seconds
```

**Error**:
```
ERROR_TYPE: FileNotFound
ERROR_FILE: C:\path\to\file.txt
ERROR_SUGGESTION: Check if file exists
```

This structured output enables agents to self-correct and verify their own work.

## Summary

This repository uses an **AI-first approach** where:
- AI agents generate documentation automatically
- AI agents organize code following standardized patterns
- AI agents verify and correct their own work through textual feedback loops
- Users focus on describing goals, not implementation details

You don't need to write perfect comments or organize files perfectly - the AI agents handle that. Just describe what you want, and let the agents do the work.

