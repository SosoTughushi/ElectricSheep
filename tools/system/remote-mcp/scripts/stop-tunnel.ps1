<#
.SYNOPSIS
    Stop SSH tunnel

.DESCRIPTION
    Stops running SSH tunnel process

.EXAMPLE
    .\stop-tunnel.ps1
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configDir = Join-Path $env:USERPROFILE ".electric-sheep"
$configPath = Join-Path $configDir "tunnel-config.json"

if (-not (Test-Path $configPath)) {
    Write-Error "Configuration not found"
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json

Write-Host "Stopping SSH tunnel..." -ForegroundColor Cyan

# Find and kill SSH tunnel process
$processes = Get-Process ssh -ErrorAction SilentlyContinue | Where-Object {
    $_.CommandLine -like "*$($config.local_port):localhost:$($config.remote_port)*"
}

if ($processes) {
    $processes | Stop-Process -Force
    Write-Host "Tunnel stopped" -ForegroundColor Green
}
else {
    Write-Host "No tunnel process found" -ForegroundColor Yellow
}

