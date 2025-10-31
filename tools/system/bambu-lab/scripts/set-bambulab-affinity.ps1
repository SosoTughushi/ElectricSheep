# Bambu Lab CPU Affinity Automation Script
# This script automatically sets CPU affinity for Bambu Lab processes
# to prevent crashes when using all CPU cores

param(
    [string]$ProcessName = "BambuStudio",
    [int[]]$AffinityCores = @(0..15),  # Use first 16 cores (0-15), excluding hyperthreaded cores
    [switch]$WaitForProcess = $false
)

Write-Host "Bambu Lab CPU Affinity Setter" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Function to set CPU affinity
function Set-ProcessAffinity {
    param(
        [System.Diagnostics.Process]$Process,
        [int[]]$Cores
    )
    
    try {
        # Convert core array to a 64-bit affinity mask using bit shifting
        [UInt64]$affinityMask = 0
        foreach ($core in $Cores) {
            if ($core -ge 0 -and $core -lt 64) {
                $affinityMask = $affinityMask -bor ([UInt64]1 -shl $core)
            }
        }
        
        # Set affinity
        $Process.ProcessorAffinity = [IntPtr]([UInt64]$affinityMask)
        Write-Host "✓ Set affinity for PID $($Process.Id) to cores: $($Cores -join ', ')" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ Failed to set affinity for PID $($Process.Id): $_" -ForegroundColor Red
        return $false
    }
}

# Wait for process if requested
if ($WaitForProcess) {
    Write-Host "Waiting for $ProcessName to start..." -ForegroundColor Yellow
    $process = $null
    while ($null -eq $process) {
        $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
    Write-Host "Found $ProcessName (PID: $($process.Id))" -ForegroundColor Green
}
else {
    # Find existing processes
    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($null -eq $processes -or $processes.Count -eq 0) {
        Write-Host "✗ No running process found: $ProcessName" -ForegroundColor Red
        Write-Host "  Tip: Use -WaitForProcess switch to wait for the process to start" -ForegroundColor Yellow
        exit 1
    }
}

# Set affinity for all matching processes
$successCount = 0
foreach ($proc in $processes) {
    if (Set-ProcessAffinity -Process $proc -Cores $AffinityCores) {
        $successCount++
    }
}

Write-Host ""
Write-Host "Completed: Set affinity for $successCount process(es)" -ForegroundColor Cyan

# Monitor for new processes (optional)
if ($WaitForProcess) {
    Write-Host ""
    Write-Host "Monitoring for new $ProcessName processes..." -ForegroundColor Yellow
    Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
    
    $existingPIDs = @()
    foreach ($p in $processes) {
        $existingPIDs += $p.Id
    }
    
    while ($true) {
        Start-Sleep -Seconds 2
        $currentProcesses = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        foreach ($proc in $currentProcesses) {
            if ($proc.Id -notin $existingPIDs) {
                Write-Host "New process detected (PID: $($proc.Id))" -ForegroundColor Yellow
                if (Set-ProcessAffinity -Process $proc -Cores $AffinityCores) {
                    $existingPIDs += $proc.Id
                }
            }
        }
    }
}

