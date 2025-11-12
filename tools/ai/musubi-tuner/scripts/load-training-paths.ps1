# Load Training Data Paths from Configuration
# This script provides helper functions to load training data paths from .local/config.json
# All training data paths should be loaded through this script to ensure they're never committed

# Get config path (relative to script location)
$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "..\..\..\..\.local\config.json"

# Load configuration
$Config = $null
if (Test-Path $ConfigPath) {
    try {
        $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    } catch {
        Write-Warning "Failed to load config.json: $_"
    }
}

# Function to get training data base directory
function Get-TrainingDataBaseDir {
    param(
        [string]$Fallback = "E:/path/to/TrainingDataSet"
    )
    
    # Try config first
    if ($Config -and $Config.paths -and $Config.paths.training_data -and $Config.paths.training_data.base_directory) {
        return $Config.paths.training_data.base_directory
    }
    
    # Try environment variable
    if ($env:TRAINING_DATA_BASE_DIR) {
        return $env:TRAINING_DATA_BASE_DIR
    }
    
    # Return fallback placeholder
    return $Fallback
}

# Function to get dataset directory for a specific dataset
function Get-DatasetDir {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DatasetName,
        
        [string]$Fallback = "E:/path/to/TrainingDataSet"
    )
    
    $BaseDir = Get-TrainingDataBaseDir -Fallback $Fallback
    return Join-Path $BaseDir $DatasetName
}

# Function to get dataset cache directory
function Get-DatasetCacheDir {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DatasetName,
        
        [string]$Fallback = "E:/path/to/TrainingDataSet"
    )
    
    $DatasetDir = Get-DatasetDir -DatasetName $DatasetName -Fallback $Fallback
    return Join-Path $DatasetDir "cache"
}

# Function to get dataset output directory
function Get-DatasetOutputDir {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DatasetName,
        
        [string]$Fallback = "E:/path/to/TrainingDataSet"
    )
    
    $DatasetDir = Get-DatasetDir -DatasetName $DatasetName -Fallback $Fallback
    return Join-Path $DatasetDir "output"
}

# Function to get source images base directory
function Get-SourceImagesBaseDir {
    param(
        [string]$Fallback = "E:/path/to/Inputs"
    )
    
    # Try config first
    if ($Config -and $Config.paths -and $Config.paths.training_data -and $Config.paths.training_data.source_images_base) {
        return $Config.paths.training_data.source_images_base
    }
    
    # Try environment variable
    if ($env:SOURCE_IMAGES_BASE_DIR) {
        return $env:SOURCE_IMAGES_BASE_DIR
    }
    
    # Return fallback placeholder
    return $Fallback
}

# Function to get source images directory for a specific dataset
function Get-SourceImagesDir {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DatasetName,
        
        [string]$SubPath = "",
        
        [string]$Fallback = "E:/path/to/Inputs"
    )
    
    $BaseDir = Get-SourceImagesBaseDir -Fallback $Fallback
    
    if ($SubPath) {
        return Join-Path $BaseDir $SubPath $DatasetName
    }
    
    # Try config for specific dataset path
    if ($Config -and $Config.paths -and $Config.paths.training_data -and $Config.paths.training_data.datasets -and $Config.paths.training_data.datasets.$DatasetName) {
        if ($Config.paths.training_data.datasets.$DatasetName.source_dir) {
            return $Config.paths.training_data.datasets.$DatasetName.source_dir
        }
    }
    
    return Join-Path $BaseDir $DatasetName
}

# Functions are available when this script is dot-sourced:
# . "$PSScriptRoot\load-training-paths.ps1"
# Then use: Get-DatasetDir -DatasetName "example-dataset"

