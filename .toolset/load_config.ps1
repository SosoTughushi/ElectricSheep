# Load Configuration Helper
# This script loads configuration from .local/config.json or falls back to defaults

param(
    [Parameter(Mandatory=$false)]
    [string]$ConfigKey
)

function Get-LocalConfig {
    $configPath = ".\.local\config.json"
    $examplePath = ".\.local\config.example.json"
    
    # Try to load local config
    if (Test-Path $configPath) {
        try {
            $config = Get-Content $configPath -Raw | ConvertFrom-Json
            return $config
        } catch {
            Write-Warning "Failed to parse local config: $_"
        }
    }
    
    # Fall back to example (which has placeholder paths)
    if (Test-Path $examplePath) {
        try {
            $config = Get-Content $examplePath -Raw | ConvertFrom-Json
            Write-Warning "Using example config template. Please copy to config.json and update paths."
            return $config
        } catch {
            Write-Error "Failed to load configuration"
            return $null
        }
    }
    
    Write-Error "No configuration file found. Please create .local/config.json"
    return $null
}

function Get-ConfigValue {
    param(
        [Parameter(Mandatory=$true)]
        [object]$Config,
        
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    $parts = $Path.Split('.')
    $value = $Config
    
    foreach ($part in $parts) {
        if ($value -and $value.PSObject.Properties[$part]) {
            $value = $value.$part
        } else {
            return $null
        }
    }
    
    return $value
}

# If ConfigKey parameter provided, return that value
if ($ConfigKey) {
    $config = Get-LocalConfig
    if ($config) {
        $value = Get-ConfigValue -Config $config -Path $ConfigKey
        if ($value) {
            return $value
        } else {
            Write-Error "Config key '$ConfigKey' not found"
            exit 1
        }
    }
} else {
    # Return full config
    return Get-LocalConfig
}

