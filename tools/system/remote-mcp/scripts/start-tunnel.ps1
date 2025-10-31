<#
.SYNOPSIS
    Start SSH tunnel for remote MCP access

.DESCRIPTION
    Starts SSH tunnel to forward local port to remote MCP server

.EXAMPLE
    .\start-tunnel.ps1
#>

param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configDir = Join-Path $env:USERPROFILE ".electric-sheep"
$configPath = Join-Path $configDir "tunnel-config.json"

if (-not (Test-Path $configPath)) {
    Write-Error "Configuration not found. Run setup-remote-access.ps1 first."
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json

Write-Host "Starting SSH tunnel..." -ForegroundColor Cyan
Write-Host "Local port: $($config.local_port)" -ForegroundColor Gray
Write-Host "Remote port: $($config.remote_port)" -ForegroundColor Gray
Write-Host "SSH host: $($config.ssh_host)" -ForegroundColor Gray
Write-Host "SSH user: $($config.ssh_user)" -ForegroundColor Gray
Write-Host "`nPress Ctrl+C to stop the tunnel`n" -ForegroundColor Yellow

# Start SSH tunnel
ssh -N -L "$($config.local_port):localhost:$($config.remote_port)" "$($config.ssh_user)@$($config.ssh_host)"

