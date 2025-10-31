# Quick Start Guide

## Bambu Lab Crash Fix - Quick Steps

### ⚡ Fastest Solution (Try This First)

1. **Disable NVIDIA Threaded Optimization:**
   - Open NVIDIA Control Panel
   - 3D Settings → Manage 3D Settings → Program Settings
   - Add Bambu Studio → Set "Threaded Optimization" to **Off**
   - Restart Bambu Lab

2. **If that doesn't work, use automation:**

   **Launch Bambu Lab with auto-fix:**
   ```powershell
   .\tools\bambulab-launcher.ps1
   ```

   **Or set affinity for already running process:**
   ```powershell
   .\tools\set-bambulab-affinity.ps1 -WaitForProcess
   ```

### 📋 System Info

- **CPU**: Intel i7-14700K (20 cores, 28 logical processors)
- **GPU**: NVIDIA RTX 3090
- **OS**: Windows 11 Pro

### 📚 Full Documentation

See `docs/bambu-lab-fix-guide.md` for detailed instructions and troubleshooting.

