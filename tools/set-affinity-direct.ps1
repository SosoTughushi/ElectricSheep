# Direct affinity setting test
$pid = 2920
$proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
if ($proc) {
    Write-Host "Current affinity: $($proc.ProcessorAffinity)"
    
    # Create mask for cores 0-15
    [UInt64]$mask = 0
    0..15 | ForEach-Object { $mask = $mask -bor ([UInt64]1 -shl $_) }
    
    Write-Host "Setting affinity mask: $mask"
    try {
        $proc.ProcessorAffinity = [IntPtr]::new([Int64]$mask)
        Write-Host "Success! New affinity: $($proc.ProcessorAffinity)"
    } catch {
        Write-Host "Error: $_"
    }
} else {
    Write-Host "Process not found"
}

