# Find Bambu Studio Installation
Write-Host "Searching for Bambu Studio..." -ForegroundColor Cyan
Write-Host ""

$possiblePaths = @(
    "C:\Program Files\BambuStudio\BambuStudio.exe",
    "C:\Program Files (x86)\BambuStudio\BambuStudio.exe",
    "$env:LOCALAPPDATA\Programs\BambuStudio\BambuStudio.exe",
    "$env:USERPROFILE\AppData\Local\Programs\BambuStudio\BambuStudio.exe"
)

$found = $false
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        Write-Host "Found Bambu Studio at:" -ForegroundColor Green
        Write-Host $path -ForegroundColor Yellow
        Write-Host ""
        Write-Host "To launch with auto-fix, run:" -ForegroundColor Cyan
        Write-Host ".\tools\bambulab-launcher.ps1 -BambuLabPath $path" -ForegroundColor White
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "Bambu Studio not found in common locations" -ForegroundColor Red
    Write-Host "Please provide the path manually when running the launcher script" -ForegroundColor Yellow
}
