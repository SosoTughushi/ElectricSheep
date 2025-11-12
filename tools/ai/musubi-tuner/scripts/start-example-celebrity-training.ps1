# Start Example Celebrity Dataset WAN 2.2 Training with Logging
# This script finds models, sets up logging, and starts training for both low and high noise LoRAs

param(
    [Parameter(Mandatory=$false)]
    [string]$DitLowNoise,  # Optional: Path to low noise DiT model (will search if not provided)
    
    [Parameter(Mandatory=$false)]
    [string]$DitHighNoise,  # Optional: Path to high noise DiT model (will search if not provided)
    
    [Parameter(Mandatory=$false)]
    [string]$DatasetConfig = "",  # Dataset config path (loaded from config if not provided)
    
    [Parameter(Mandatory=$false)]
    [string]$OutputDir = "",  # Output directory (loaded from config if not provided)
    
    [Parameter(Mandatory=$false)]
    [string]$OutputName = "example_celebrity_wan22",
    
    [Parameter(Mandatory=$false)]
    [string]$LogDir = "",  # Log directory (loaded from config if not provided)
    
    [Parameter(Mandatory=$false)]
    [string]$Task = "t2v-A14B"  # Will auto-detect from model filename if possible
)

# Load training paths helper
. "$PSScriptRoot\load-training-paths.ps1"

# Load paths from config if not provided
if ([string]::IsNullOrEmpty($DatasetConfig)) {
    # Try to get dataset config path from config or use default location
    $RepoRoot = Split-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent) -Parent
    $DatasetConfig = Join-Path $RepoRoot "tools\ai\musubi-tuner\datasets\example-celebrity-dataset-wan22.toml"
}

if ([string]::IsNullOrEmpty($OutputDir)) {
    $OutputDir = Get-DatasetOutputDir -DatasetName "example-celebrity-dataset"
}

if ([string]::IsNullOrEmpty($LogDir)) {
    # Try config first
    $RepoRoot = Split-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent) -Parent
    if ($Config -and $Config.paths -and $Config.paths.logs) {
        $LogDir = $Config.paths.logs
    } else {
        $LogDir = Join-Path $RepoRoot "logs"
    }
}

# Load config for model paths
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
$Config = $null
if (Test-Path $ConfigPath) {
    try {
        $Config = Get-Content $ConfigPath | ConvertFrom-Json
    } catch {
        Write-Log "Error reading config.json: $_" "ERROR"
    }
}

# Create log directory if it doesn't exist
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$LogFile = Join-Path $LogDir "example-celebrity-training-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$ErrorLogFile = Join-Path $LogDir "example-celebrity-training-errors-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
    if ($Level -eq "ERROR") {
        Add-Content -Path $ErrorLogFile -Value $LogMessage
    }
}

function Find-WanModels {
    Write-Log "Searching for WAN 2.2 models..."
    
    $SearchPaths = @(
        "E:/path/to/ComfyUI/models/diffusion_models",
        "E:/path/to/ComfyUI/models/diffusion_models",
        "E:/path/to/models/diffusion_models",
        "E:/path/to/models",
        "E:/path/to/models"
    )
    
    $LowModel = $null
    $HighModel = $null
    
    foreach ($SearchPath in $SearchPaths) {
        if (Test-Path $SearchPath) {
            Write-Log "Checking: $SearchPath"
            $LowFiles = Get-ChildItem $SearchPath -Recurse -Filter "*wan2.2*low*" -ErrorAction SilentlyContinue | Select-Object -First 1
            $HighFiles = Get-ChildItem $SearchPath -Recurse -Filter "*wan2.2*high*" -ErrorAction SilentlyContinue | Select-Object -First 1
            
            if ($LowFiles -and -not $LowModel) {
                $LowModel = $LowFiles.FullName
                Write-Log "Found low noise model: $LowModel"
            }
            if ($HighFiles -and -not $HighModel) {
                $HighModel = $HighFiles.FullName
                Write-Log "Found high noise model: $HighModel"
            }
        }
    }
    
    # Check config.json
    $ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
    if (Test-Path $ConfigPath) {
        try {
            $Config = Get-Content $ConfigPath | ConvertFrom-Json
            if ($Config.models.wan.dit_2_2_t2v_low -and $Config.models.wan.dit_2_2_t2v_low -notmatch "E:/path/to") {
                if (-not $LowModel) {
                    $LowModel = $Config.models.wan.dit_2_2_t2v_low
                    Write-Log "Found low noise model in config: $LowModel"
                }
            }
            if ($Config.models.wan.dit_2_2_t2v_high -and $Config.models.wan.dit_2_2_t2v_high -notmatch "E:/path/to") {
                if (-not $HighModel) {
                    $HighModel = $Config.models.wan.dit_2_2_t2v_high
                    Write-Log "Found high noise model in config: $HighModel"
                }
            }
        } catch {
            Write-Log "Error reading config.json: $_" "ERROR"
        }
    }
    
    return @{
        Low = $LowModel
        High = $HighModel
    }
}

# Start logging
Write-Log "=== Starting Example Celebrity Dataset WAN 2.2 Training ==="
Write-Log "Log file: $LogFile"
Write-Log "Error log file: $ErrorLogFile"

# Find models if not provided
if (-not $DitLowNoise -or -not $DitHighNoise) {
    $Models = Find-WanModels
    
    if (-not $DitLowNoise) {
        $DitLowNoise = $Models.Low
    }
    if (-not $DitHighNoise) {
        $DitHighNoise = $Models.High
    }
}

# Validate models exist
if (-not $DitLowNoise -or -not (Test-Path $DitLowNoise)) {
    Write-Log "ERROR: Low noise model not found: $DitLowNoise" "ERROR"
    Write-Log "Please provide -DitLowNoise parameter or ensure models are in standard locations" "ERROR"
    exit 1
}

if (-not $DitHighNoise -or -not (Test-Path $DitHighNoise)) {
    Write-Log "ERROR: High noise model not found: $DitHighNoise" "ERROR"
    Write-Log "Please provide -DitHighNoise parameter or ensure models are in standard locations" "ERROR"
    exit 1
}

# Auto-detect task and precision from model filename
$LowModelName = Split-Path $DitLowNoise -Leaf
if ($LowModelName -match "i2v") {
    $Task = "i2v-A14B"
    Write-Log "Auto-detected task: $Task (from filename)"
} elseif ($LowModelName -match "t2v") {
    $Task = "t2v-A14B"
    Write-Log "Auto-detected task: $Task (from filename)"
}

if ($LowModelName -match "fp16") {
    $MixedPrecision = "fp16"
    Write-Log "Auto-detected precision: $MixedPrecision (from filename)"
} elseif ($LowModelName -match "bf16") {
    $MixedPrecision = "bf16"
    Write-Log "Auto-detected precision: $MixedPrecision (from filename)"
}

# Validate dataset config
if (-not (Test-Path $DatasetConfig)) {
    Write-Log "ERROR: Dataset config not found: $DatasetConfig" "ERROR"
    exit 1
}

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Log "Created output directory: $OutputDir"
}

# Check for existing checkpoints
$Checkpoints = Get-ChildItem $OutputDir -Directory -Filter "*epoch-*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
if ($Checkpoints) {
    $LatestCheckpoint = $Checkpoints[0].FullName
    Write-Log "Found existing checkpoint: $LatestCheckpoint"
    Write-Log "Starting fresh training (checkpoint will be saved every epoch)"
}

# Get musubi-tuner paths
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
    $MusubiTunerPath = $Config.paths.musubi_tuner.installation_path
    $PythonExe = $Config.paths.musubi_tuner.accelerate_exe
    if (-not $PythonExe -or -not (Test-Path $PythonExe)) {
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
    }
} else {
    Write-Log "Warning: .local/config.json not found. Using default paths." "WARN"
    $MusubiTunerPath = "E:/path/to/musubi-tuner"
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
}

$ScriptPath = Join-Path $MusubiTunerPath "wan_train_network.py"

if (-not (Test-Path $ScriptPath)) {
    Write-Log "ERROR: Training script not found at $ScriptPath" "ERROR"
    exit 1
}

if (-not (Test-Path $PythonExe)) {
    Write-Log "ERROR: Python executable not found at $PythonExe" "ERROR"
    exit 1
}

# Set timestep boundary based on task
# Note: timestep_boundary expects integer (0-1000), code converts > 1 by dividing by 1000
$TimestepBoundary = if ($Task -match "i2v") { 900 } else { 875 }  # 0.9 * 1000 for I2V, 0.875 * 1000 for T2V

Write-Log "=== Training Configuration ==="
Write-Log "Task: $Task"
Write-Log "Low Noise Model: $DitLowNoise"
Write-Log "High Noise Model: $DitHighNoise"
Write-Log "Dataset Config: $DatasetConfig"
Write-Log "Output Directory: $OutputDir"
Write-Log "Output Name: $OutputName"
Write-Log "Mixed Precision: $MixedPrecision"
Write-Log "Timestep Boundary: $TimestepBoundary"

# Build training command
$LaunchArgs = @(
    "launch"
    "--num_cpu_threads_per_process", "1"
    "--mixed_precision", $MixedPrecision
)

$Arguments = @(
    $ScriptPath
    "--task", $Task
    "--dit", $DitLowNoise
    "--dit_high_noise", $DitHighNoise
    "--dataset_config", $DatasetConfig
    "--timestep_boundary", $TimestepBoundary
    "--sdpa"
    "--mixed_precision", $MixedPrecision
    "--optimizer_type", "adamw8bit"
    "--learning_rate", "2e-4"
    "--gradient_checkpointing"
    "--max_data_loader_n_workers", "2"
    "--persistent_data_loader_workers"
    "--network_module", "networks.lora_wan"
    "--network_dim", "32"
    "--timestep_sampling", "shift"
    "--discrete_flow_shift", "3.0"
    "--max_train_epochs", "16"
    "--save_every_n_epochs", "1"
    "--seed", "42"
    "--output_dir", $OutputDir
    "--output_name", $OutputName
    "--preserve_distribution_shape"
)

$AllArgs = $LaunchArgs + $Arguments

Write-Log "=== Starting Training ==="
Write-Log "Command: $PythonExe $($AllArgs -join ' ')"

# Start training process with output redirection
$ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
$ProcessInfo.FileName = $PythonExe
$ProcessInfo.Arguments = ($AllArgs -join ' ')
$ProcessInfo.UseShellExecute = $false
$ProcessInfo.RedirectStandardOutput = $true
$ProcessInfo.RedirectStandardError = $true
$ProcessInfo.CreateNoWindow = $true

$Process = New-Object System.Diagnostics.Process
$Process.StartInfo = $ProcessInfo

# Set up output handlers
$OutputBuilder = New-Object System.Text.StringBuilder
$ErrorBuilder = New-Object System.Text.StringBuilder

$OutputHandler = {
    if (-not [string]::IsNullOrEmpty($EventArgs.Data)) {
        $line = $EventArgs.Data
        Write-Log $line
        [void]$OutputBuilder.AppendLine($line)
    }
}

$ErrorHandler = {
    if (-not [string]::IsNullOrEmpty($EventArgs.Data)) {
        $line = $EventArgs.Data
        Write-Log $line "ERROR"
        [void]$ErrorBuilder.AppendLine($line)
    }
}

$Process.add_OutputDataReceived($OutputHandler)
$Process.add_ErrorDataReceived($ErrorHandler)

# Start the process
try {
    $Process.Start() | Out-Null
    $Process.BeginOutputReadLine()
    $Process.BeginErrorReadLine()
    
    Write-Log "Training process started (PID: $($Process.Id))"
    Write-Log "Monitoring output... (Press Ctrl+C to stop)"
    
    # Wait for process to complete
    $Process.WaitForExit()
    
    $ExitCode = $Process.ExitCode
    
    Write-Log "=== Training Process Completed ==="
    Write-Log "Exit Code: $ExitCode"
    
    if ($ExitCode -eq 0) {
        Write-Log "Training completed successfully!" "INFO"
    } else {
        Write-Log "Training failed with exit code $ExitCode" "ERROR"
        Write-Log "Check error log: $ErrorLogFile" "ERROR"
    }
    
    exit $ExitCode
    
} catch {
    Write-Log "Error starting training process: $_" "ERROR"
    Write-Log $_.Exception.Message "ERROR"
    Write-Log $_.ScriptStackTrace "ERROR"
    exit 1
} finally {
    if (-not $Process.HasExited) {
        $Process.Kill()
        Write-Log "Process terminated" "WARN"
    }
    $Process.Dispose()
}

