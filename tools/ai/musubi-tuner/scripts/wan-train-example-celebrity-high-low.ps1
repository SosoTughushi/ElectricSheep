# Train WAN 2.2 High and Low LoRA Models for Example Celebrity Dataset
# Usage: .\wan-train-example-celebrity-high-low.ps1 -Task "t2v-A14B" -DitLowNoise "path/to/low_noise.safetensors" -DitHighNoise "path/to/high_noise.safetensors" -DatasetConfig "path/to/dataset.toml"

param(
    [Parameter(Mandatory=$true)]
    [string]$Task = "t2v-A14B",  # Options: t2v-A14B, i2v-A14B
    
    [Parameter(Mandatory=$true)]
    [string]$DitLowNoise,  # Path to low noise DiT model
    
    [Parameter(Mandatory=$true)]
    [string]$DitHighNoise,  # Path to high noise DiT model
    
    [Parameter(Mandatory=$true)]
    [string]$DatasetConfig,  # Path to dataset config TOML file
    
    [Parameter(Mandatory=$true)]
    [string]$OutputDir,  # Path to output directory for LoRA files
    
    [Parameter(Mandatory=$true)]
    [string]$OutputName = "example_celebrity_wan22",  # Name for output LoRA file
    
    [Parameter(Mandatory=$false)]
    [int]$NetworkDim = 32,
    
    [Parameter(Mandatory=$false)]
    [double]$LearningRate = 2e-4,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTrainEpochs = 16,
    
    [Parameter(Mandatory=$false)]
    [double]$TimestepBoundary = 0.875,  # 0.875 for T2V, 0.9 for I2V
    
    [Parameter(Mandatory=$false)]
    [switch]$Fp8Base,
    
    [Parameter(Mandatory=$false)]
    [switch]$PreserveDistributionShape = $true
)

# Get musubi-tuner path from config
$ConfigPath = Join-Path $PSScriptRoot "..\..\..\..\.local\config.json"
if (Test-Path $ConfigPath) {
    $Config = Get-Content $ConfigPath | ConvertFrom-Json
    $MusubiTunerPath = $Config.paths.musubi_tuner.installation_path
    $PythonExe = $Config.paths.musubi_tuner.accelerate_exe
    if (-not $PythonExe) {
        $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
    }
} else {
    Write-Host "Warning: .local/config.json not found. Using default paths." -ForegroundColor Yellow
    $MusubiTunerPath = "E:/path/to/musubi-tuner"
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
}

$ScriptPath = Join-Path $MusubiTunerPath "wan_train_network.py"

if (-not (Test-Path $ScriptPath)) {
    Write-Host "Error: Training script not found at $ScriptPath" -ForegroundColor Red
    exit 1
}

Write-Host "=== WAN 2.2 High/Low LoRA Training ===" -ForegroundColor Cyan
Write-Host "Task: $Task" -ForegroundColor Yellow
Write-Host "Low Noise Model: $DitLowNoise" -ForegroundColor Yellow
Write-Host "High Noise Model: $DitHighNoise" -ForegroundColor Yellow
Write-Host "Output: $OutputDir\$OutputName" -ForegroundColor Yellow
Write-Host ""

# Set timestep boundary based on task if not explicitly set
# Note: timestep_boundary expects integer (0-1000), code converts > 1 by dividing by 1000
if ($Task -match "i2v") {
    $TimestepBoundary = 900  # 0.9 * 1000
} elseif ($Task -match "t2v") {
    $TimestepBoundary = 875  # 0.875 * 1000
}

$LaunchArgs = @(
    "launch"
    "--num_cpu_threads_per_process", "1"
    "--mixed_precision", "fp16"
)

$Arguments = @(
    $ScriptPath
    "--task", $Task
    "--dit", $DitLowNoise
    "--dit_high_noise", $DitHighNoise
    "--dataset_config", $DatasetConfig
    "--timestep_boundary", $TimestepBoundary
    "--sdpa"
    "--mixed_precision", "fp16"
    "--optimizer_type", "adamw8bit"
    "--learning_rate", $LearningRate
    "--gradient_checkpointing"
    "--max_data_loader_n_workers", "2"
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

if ($Fp8Base) {
    $Arguments += "--fp8_base"
}

if ($PreserveDistributionShape) {
    $Arguments += "--preserve_distribution_shape"
}

$AllArgs = $LaunchArgs + $Arguments

Write-Host "Starting training..." -ForegroundColor Cyan
Write-Host "Command: $PythonExe $($AllArgs -join ' ')" -ForegroundColor Gray
Write-Host ""

& $PythonExe $AllArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Training failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Training completed!" -ForegroundColor Green
Write-Host "LoRA saved to: $OutputDir\$OutputName" -ForegroundColor Green
