# Check CPU Affinity for Bambu Studio
$processes = Get-Process -Name bambu-studio -ErrorAction SilentlyContinue
if ($processes) {
    foreach ($proc in $processes) {
        Write-Host "PID: $($proc.Id)"
        $affinityValue = $proc.ProcessorAffinity.ToInt64()
        Write-Host "Affinity (decimal): $affinityValue"
        $affinityHex = [Convert]::ToString($affinityValue, 16)
        Write-Host "Affinity (hex): 0x$affinityHex"
        $cores = @()
        for ($i=0; $i -lt 64; $i++) {
            $bit = [math]::Pow(2, $i)
            if (($affinityValue -band $bit) -ne 0) {
                $cores += $i
            }
        }
        Write-Host "Cores enabled: $($cores -join ', ')"
        Write-Host "Total cores: $($cores.Count)"
        Write-Host ""
    }
} else {
    Write-Host "No bambu-studio processes found"
}

