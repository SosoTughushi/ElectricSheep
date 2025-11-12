# Train Wan 2.1/2.2 LoRA Model
# Usage: .\tools\ai\musubi-tuner\scripts\wan-train.ps1 -Task "t2v-14B" -DitPath "path/to/dit.safetensors" -DatasetConfig "path/to/dataset.toml" -OutputDir "path/to/output" -OutputName "my-lora"
# 
# Performance Tips:
# - Use -DataLoaderWorkers 8 (or higher) for faster data loading if you have strong CPU
# - Use -MaxTrainEpochs 10 instead of 16 for smaller datasets (<50 images)
# - Use -SaveEveryNSteps 100 to save checkpoints frequently during training

param(
    [Parameter(Mandatory=$true)]
    [string]$Task,
    
    [Parameter(Mandatory=$true)]
    [string]$DitPath,
    
    [Parameter(Mandatory=$true)]
    [string]$DatasetConfig,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputDir,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputName,
    
    [Parameter(Mandatory=$false)]
    [string]$DitHighNoise,
    
    [Parameter(Mandatory=$false)]
    [int]$NetworkDim = 32,
    
    [Parameter(Mandatory=$false)]
    [double]$LearningRate = 2e-4,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTrainEpochs = 16,
    
    [Parameter(Mandatory=$false)]
    [int]$SaveEveryNSteps,  # Save checkpoint every N steps (for testing/frequent saves)
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8Base,
    
    [Parameter(Mandatory=$false)]
    [switch]$UseAccelerate = $true,
    
    [Parameter(Mandatory=$false)]
    [int]$MinTimestep,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTimestep,
    
    [Parameter(Mandatory=$false)]
    [switch]$PreserveDistributionShape,
    
    [Parameter(Mandatory=$false)]
    [string]$MixedPrecision = "bf16",  # Use "fp16" for fp16 models, "bf16" for bf16 models
    
    [Parameter(Mandatory=$false)]
    [string]$Resume,  # Path to checkpoint directory to resume from (e.g., "output/angelina_jolie_wan22_low-epoch-5")
    
    [Parameter(Mandatory=$false)]
    [int]$DataLoaderWorkers = 2  # Number of data loader workers (increase for faster data loading, requires more CPU/RAM)
)

# Get musubi-tuner path from config
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
    $MusubiTunerPath = $Config.paths.musubi_tuner.installation_path
    if ($UseAccelerate) {
        $PythonExe = $Config.paths.musubi_tuner.accelerate_exe
        if (-not $PythonExe) {
            $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
        }
    } else {
        $PythonExe = $Config.paths.musubi_tuner.python_exe
        if (-not $PythonExe) {
            $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
        }
    }
} else {
    Write-Host "Warning: .local/config.json not found. Using default paths." -ForegroundColor Yellow
    $MusubiTunerPath = "E:\Stable Diffusion\musubi-tuner"
    if ($UseAccelerate) {
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
    } else {
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
    }
}

$ScriptPath = Join-Path $MusubiTunerPath "wan_train_network.py"

if (-not (Test-Path $ScriptPath)) {
    Write-Host "Error: Script not found at $ScriptPath" -ForegroundColor Red
    exit 1
}

# Determine Python/Accelerate executable
if ($UseAccelerate) {
    $LaunchArgs = @("launch", "--num_cpu_threads_per_process", "1", "--mixed_precision", $MixedPrecision)
} else {
    $LaunchArgs = @()
}

$Arguments = @(
    $ScriptPath
    "--task", $Task
    "--dit", $DitPath
    "--dataset_config", $DatasetConfig
    "--sdpa"
    "--mixed_precision", $MixedPrecision
    "--optimizer_type", "adamw8bit"
    "--learning_rate", $LearningRate
    "--gradient_checkpointing"
    "--max_data_loader_n_workers", $DataLoaderWorkers
    "--persistent_data_loader_workers"
    "--network_module", "networks.lora_wan"
    "--network_dim", $NetworkDim
    "--timestep_sampling", "shift"
    "--discrete_flow_shift", "3.0"
    "--max_train_epochs", $MaxTrainEpochs
    "--save_every_n_epochs", "1"
    "--seed", "42"
    "--output_dir", $OutputDir
    "--output_name", $OutputName
)

if ($SaveEveryNSteps) {
    $Arguments += "--save_every_n_steps", $SaveEveryNSteps
}

if ($DitHighNoise) {
    $Arguments += "--dit_high_noise", $DitHighNoise
}

if ($Fp8Base) {
    $Arguments += "--fp8_base"
}

if ($MinTimestep) {
    $Arguments += "--min_timestep", $MinTimestep
}

if ($MaxTimestep) {
    $Arguments += "--max_timestep", $MaxTimestep
}

if ($PreserveDistributionShape) {
    $Arguments += "--preserve_distribution_shape"
}

if ($Resume) {
    $Arguments += "--resume", $Resume
    Write-Host "Resuming from checkpoint: $Resume" -ForegroundColor Cyan
}

$AllArgs = $LaunchArgs + $Arguments

Write-Host "Starting Wan LoRA training..." -ForegroundColor Cyan
Write-Host "Task: $Task" -ForegroundColor Yellow
Write-Host "Output: $OutputDir\$OutputName" -ForegroundColor Yellow
Write-Host "Command: $PythonExe $($AllArgs -join ' ')" -ForegroundColor Gray

& $PythonExe $AllArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Training failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Training completed!" -ForegroundColor Green

