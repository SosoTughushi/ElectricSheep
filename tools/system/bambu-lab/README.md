# Bambu Lab CPU Affinity Manager

## Overview

This tool automates CPU affinity settings for Bambu Lab/Studio to prevent crashes when using all CPU cores. The application crashes when clicking if all 28 logical processors are enabled on systems with high core counts.

## Quick Start

### Launch Bambu Lab with Auto-Fix
```powershell
.\scripts\bambulab-launcher.ps1
```

### Set Affinity for Running Process
```powershell
.\scripts\set-bambulab-affinity.ps1 -WaitForProcess
```

### Find Bambu Studio Installation
```powershell
.\scripts\find-bambustudio.ps1
```

## Tools Included

### 1. `bambulab-launcher.ps1`
Launches Bambu Lab and automatically sets CPU affinity on startup.

**Parameters:**
- `-BambuLabPath`: Path to Bambu Studio executable (default: `C:\Program Files\BambuStudio\BambuStudio.exe`)
- `-AffinityCores`: Array of CPU cores to use (default: `0..15` - first 16 cores)
- `-CheckNvidiaSettings`: Show reminder about NVIDIA settings (default: `$true`)

### 2. `set-bambulab-affinity.ps1`
Sets CPU affinity for already running Bambu Lab processes.

**Parameters:**
- `-ProcessName`: Process name to target (default: `"BambuStudio"`)
- `-AffinityCores`: Array of CPU cores to use (default: `0..15`)
- `-WaitForProcess`: Wait for process to start if not found (default: `$false`)

### 3. `find-bambustudio.ps1`
Searches common installation locations for Bambu Studio.

**Output:**
- Path to executable if found
- Launch command suggestion

## Problem Description

Bambu Lab crashes when clicking if all CPU cores are enabled. This is caused by:
1. NVIDIA Threaded Optimization conflicting with Bambu Lab
2. High core count (28 logical processors) causing compatibility issues
3. Multiple GPU setup (NVIDIA + Intel integrated) may cause conflicts

## Solutions

### Solution 1: Disable NVIDIA Threaded Optimization (Recommended First Step)
1. Open NVIDIA Control Panel
2. Navigate to: 3D Settings > Manage 3D Settings > Program Settings
3. Add Bambu Studio to the program list
4. Set "Threaded Optimization" to "Off"
5. Apply changes and restart Bambu Lab

### Solution 2: Use This Tool (Automated CPU Affinity)
The scripts automatically limit CPU affinity to a subset of cores (default: first 16 cores), which prevents the crash.

## Requirements

- Windows PowerShell
- Administrator privileges (for affinity changes)
- Bambu Lab/Studio installed

## Notes

- You may need to run PowerShell as Administrator for affinity changes to work
- Default configuration uses cores 0-15 (first 16 cores)
- Customize cores using the `-AffinityCores` parameter

## Related Documentation

- See `docs/bambu-lab-fix-guide.md` for detailed troubleshooting
- See `../../rules/bambu-lab-fix.cursorrules` for AI context

