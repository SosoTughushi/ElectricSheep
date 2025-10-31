# CPU Affinity Checker

## Overview

Utility tools for checking and displaying CPU affinity settings for running processes. Useful for debugging process affinity issues and verifying affinity configurations.

## Tools Included

### 1. `check-affinity.ps1`
Checks and displays CPU affinity for processes by name.

**Usage:**
```powershell
.\scripts\check-affinity.ps1
```

Displays:
- Process ID
- Affinity value (decimal and hex)
- Enabled cores list
- Total core count

### 2. `set-affinity-direct.ps1`
Direct affinity setting test script (for debugging).

**Note:** This is a test/debugging script. Modify the PID and cores in the script before use.

## Use Cases

- Verify CPU affinity settings after applying changes
- Debug affinity-related issues
- Inspect which cores are assigned to processes
- Understand current affinity configuration

## Related Tools

- See `../bambu-lab/` for Bambu Lab affinity management tools

