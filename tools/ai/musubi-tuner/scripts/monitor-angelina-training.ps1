# Monitor Angelina Training Progress
# This script checks training status and logs progress

param(
    [string]$LogDir = "E:\Soso\Projects\electric-sheep\logs",
    [string]$OutputDir = "E:\Stable Diffusion\TrainingDataSet\Angelina Jolie\output"
)

Write-Host "=== Angelina Training Monitor ===" -ForegroundColor Cyan
Write-Host ""

# Check for running processes
$TrainingProcs = Get-Process -Name python,accelerate -ErrorAction SilentlyContinue | Where-Object { 
    $_.MainWindowTitle -like "*wan*" -or 
    $_.CommandLine -like "*wan_train*" -or
    $_.CommandLine -like "*angelina*"
}

if ($TrainingProcs) {
    Write-Host "Training processes found:" -ForegroundColor Green
    $TrainingProcs | ForEach-Object {
        Write-Host "  PID: $($_.Id) | CPU: $([math]::Round($_.CPU,2))s | Memory: $([math]::Round($_.WorkingSet64/1MB,2))MB | Started: $($_.StartTime)" -ForegroundColor Yellow
    }
} else {
    Write-Host "No active training processes found" -ForegroundColor Yellow
}

Write-Host ""

# Check output directory for checkpoints
if (Test-Path $OutputDir) {
    $Checkpoints = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    if ($Checkpoints) {
        Write-Host "Latest checkpoints:" -ForegroundColor Green
        $Checkpoints | Select-Object -First 5 | ForEach-Object {
            $Epoch = if ($_.Name -match "epoch-(\d+)") { $matches[1] } else { "?" }
            Write-Host "  Epoch $Epoch : $($_.Name) | Modified: $($_.LastWriteTime)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No checkpoints found yet" -ForegroundColor Yellow
    }
    
    # Check for LoRA files
    $LoraFiles = Get-ChildItem $OutputDir -Filter "*.safetensors" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    if ($LoraFiles) {
        Write-Host ""
        Write-Host "LoRA files:" -ForegroundColor Green
        $LoraFiles | Select-Object -First 5 | ForEach-Object {
            $SizeMB = [math]::Round($_.Length / 1MB, 2)
            Write-Host "  $($_.Name) | Size: ${SizeMB}MB | Modified: $($_.LastWriteTime)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""

# Check latest log files
$LatestLog = Get-ChildItem "$LogDir\angelina-training*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($LatestLog) {
    Write-Host "Latest log: $($LatestLog.Name)" -ForegroundColor Cyan
    Write-Host "Last modified: $($LatestLog.LastWriteTime)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Recent log entries:" -ForegroundColor Cyan
    Get-Content $LatestLog.FullName -Tail 15 | ForEach-Object {
        if ($_ -match "ERROR") {
            Write-Host $_ -ForegroundColor Red
        } elseif ($_ -match "WARN") {
            Write-Host $_ -ForegroundColor Yellow
        } elseif ($_ -match "epoch|step|loss") {
            Write-Host $_ -ForegroundColor Green
        } else {
            Write-Host $_ -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "=== End Monitor ===" -ForegroundColor Cyan

