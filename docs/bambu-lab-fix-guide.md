# Bambu Lab Crash Fix Guide

## Problem Summary

Bambu Lab crashes when clicking if all CPU cores are enabled. This appears to be related to:
- NVIDIA driver optimizations conflicting with the application
- High core count CPU (28 logical processors) causing compatibility issues
- Multiple GPU setup (NVIDIA RTX 3090 + Intel integrated)

## Solutions (Try in Order)

### Solution 1: Disable NVIDIA Threaded Optimization ⭐ RECOMMENDED

This is the easiest and most permanent fix if it works for your system.

**Steps:**
1. Right-click on desktop → "NVIDIA Control Panel"
2. Navigate to: **3D Settings** → **Manage 3D Settings** → **Program Settings**
3. Click **"Add"** and browse to Bambu Studio executable:
   - Default path: `C:\Program Files\BambuStudio\BambuStudio.exe`
4. Find **"Threaded Optimization"** in the settings list
5. Set it to **"Off"**
6. Click **"Apply"**
7. Restart Bambu Lab

**Why this works:** NVIDIA's threaded optimization can cause conflicts with applications that manage their own threading, leading to crashes.

### Solution 2: Automated CPU Affinity Scripts

If Solution 1 doesn't work, use these PowerShell scripts to automatically limit CPU usage.

#### Option A: Set Affinity for Already Running Process

```powershell
# Run in PowerShell (may need Administrator privileges)
.\tools\set-bambulab-affinity.ps1 -WaitForProcess
```

This will:
- Wait for Bambu Lab to start
- Automatically set CPU affinity to cores 0-15 (excludes hyperthreaded cores)
- Continue monitoring for new processes

#### Option B: Launch with Auto-Fix

```powershell
# Run in PowerShell (may need Administrator privileges)
.\tools\bambulab-launcher.ps1 -BambuLabPath "C:\Program Files\BambuStudio\BambuStudio.exe"
```

This will:
- Launch Bambu Lab
- Automatically set CPU affinity on startup
- Monitor and apply affinity to any child processes

#### Customizing Core Selection

You can specify which cores to use:

```powershell
# Use only first 8 cores (0-7)
.\tools\set-bambulab-affinity.ps1 -AffinityCores (0..7)

# Use specific cores (e.g., 0, 2, 4, 6, 8, 10, 12, 14)
.\tools\set-bambulab-affinity.ps1 -AffinityCores @(0,2,4,6,8,10,12,14)
```

### Solution 3: Manual Task Manager Method (Current Workaround)

If scripts don't work, continue using the manual method:

1. Launch Bambu Lab
2. Press `Ctrl + Shift + Esc` to open Task Manager
3. Go to **Details** tab
4. Find `BambuStudio.exe`
5. Right-click → **Set affinity**
6. Uncheck some cores (typically uncheck half, keeping cores 0-13 or similar)
7. Click **OK**

## Creating a Shortcut

To make Solution 2 easier, create a shortcut:

1. Right-click on `bambulab-launcher.ps1` → **Create shortcut**
2. Right-click the shortcut → **Properties**
3. In **Target**, change to:
   ```
   powershell.exe -ExecutionPolicy Bypass -File "YOUR_WORKSPACE_ROOT\tools\system\bambu-lab\scripts\bambulab-launcher.ps1"
   ```
4. Optionally check **"Run as administrator"** if needed
5. Click **OK**

## Troubleshooting

### Script says "Access Denied"
- Run PowerShell as Administrator
- Right-click PowerShell → "Run as administrator"

### Affinity doesn't stick
- Some processes may need to be killed and restarted
- Try using the launcher script instead of setting affinity after launch

### Still crashes after trying solutions
1. Update NVIDIA drivers: https://www.nvidia.com/Download/index.aspx
2. Update Bambu Lab to latest version
3. Check Windows Event Viewer for detailed error messages
4. Try reducing to fewer cores (e.g., 8 cores instead of 16)

## Technical Details

- **System**: Windows 11 Pro Build 26100
- **CPU**: Intel i7-14700K (20 physical cores, 28 logical processors)
- **Default Affinity**: Cores 0-15 (16 cores, avoiding hyperthreaded pairs)
- **Why this works**: Limiting CPU cores prevents threading conflicts that cause crashes

## References

- Bambu Lab Forum discussions on crashes
- NVIDIA Control Panel documentation
- Windows Task Manager CPU affinity feature

