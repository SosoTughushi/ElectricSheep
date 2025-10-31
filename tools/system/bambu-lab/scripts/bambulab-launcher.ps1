# Bambu Lab Launcher with Automatic CPU Affinity Fix
# This script launches Bambu Lab and automatically sets CPU affinity

param(
    [string]$BambuLabPath = "C:\Program Files\BambuStudio\BambuStudio.exe",
    [int[]]$AffinityCores = @(0..15),  # Use first 16 cores (0-15)
    [switch]$CheckNvidiaSettings = $true
)

Write-Host "Bambu Lab Launcher with Auto-Fix" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if Bambu Lab exists
if (-not (Test-Path $BambuLabPath)) {
    Write-Host "[X] Bambu Lab not found at: $BambuLabPath" -ForegroundColor Red
    Write-Host "  Please update the path in the script or provide it as a parameter" -ForegroundColor Yellow
    exit 1
}

# Get process name from path
$processName = [System.IO.Path]::GetFileNameWithoutExtension($BambuLabPath)

# Check NVIDIA settings reminder
if ($CheckNvidiaSettings) {
    Write-Host "Reminder: Consider disabling NVIDIA Threaded Optimization:" -ForegroundColor Yellow
    Write-Host "  NVIDIA Control Panel > 3D Settings > Program Settings > Bambu Studio" -ForegroundColor Yellow
    Write-Host "  Set 'Threaded Optimization' to 'Off'" -ForegroundColor Yellow
    Write-Host ""
}

# Launch Bambu Lab
Write-Host "Launching Bambu Lab..." -ForegroundColor Green
try {
    $process = Start-Process -FilePath $BambuLabPath -PassThru
    Write-Host "[OK] Started Bambu Lab (PID: $($process.Id))" -ForegroundColor Green
    
    # Wait a moment for process to initialize
    Start-Sleep -Seconds 2
    
    # Set CPU affinity
    Write-Host ""
    Write-Host "Setting CPU affinity..." -ForegroundColor Yellow
    # Convert core array to a 64-bit affinity mask using bit shifting
    [UInt64]$affinityMask = 0
    foreach ($core in $AffinityCores) {
        if ($core -ge 0 -and $core -lt 64) {
            $affinityMask = $affinityMask -bor ([UInt64]1 -shl $core)
        }
    }
    
    try {
        $process.ProcessorAffinity = [IntPtr]::new([Int64]$affinityMask)
        Write-Host "[OK] Set CPU affinity to cores: $($AffinityCores -join ', ')" -ForegroundColor Green
    }
    catch {
        Write-Host "[X] Failed to set CPU affinity: $_" -ForegroundColor Red
        Write-Host "  You may need to run this script as Administrator" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Bambu Lab is running. Monitoring for child processes..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
    
    # Monitor for child processes
    $existingPIDs = @($process.Id)
    while ($true) {
        Start-Sleep -Seconds 2
        
        # Check if main process is still running
        if (-not (Get-Process -Id $process.Id -ErrorAction SilentlyContinue)) {
            Write-Host "Bambu Lab process ended." -ForegroundColor Yellow
            break
        }
        
        # Check for new processes with same name
        $currentProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue
        foreach ($proc in $currentProcesses) {
            if ($proc.Id -notin $existingPIDs) {
                Write-Host "New process detected (PID: $($proc.Id)), setting affinity..." -ForegroundColor Yellow
                try {
                    $proc.ProcessorAffinity = [IntPtr]::new([Int64]$affinityMask)
                    Write-Host "[OK] Set affinity for PID $($proc.Id)" -ForegroundColor Green
                    $existingPIDs += $proc.Id
                }
                catch {
                    Write-Host "[X] Failed to set affinity for PID $($proc.Id)" -ForegroundColor Red
                }
            }
        }
    }
}
catch {
    Write-Host "[X] Failed to launch Bambu Lab: $_" -ForegroundColor Red
    exit 1
}

