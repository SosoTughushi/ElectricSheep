# Train Wan 2.1/2.2 LoRA Model
# Usage: .\tools\ai\musubi-tuner\scripts\wan-train.ps1 -Task "t2v-14B" -DitPath "path/to/dit.safetensors" -DatasetConfig "path/to/dataset.toml" -OutputDir "path/to/output" -OutputName "my-lora"

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
    [switch]$Fp8Base,
    
    [Parameter(Mandatory=$false)]
    [switch]$UseAccelerate = $true
)

$MusubiTunerPath = "C:/path/to/musubi-tuner"
$ScriptPath = Join-Path $MusubiTunerPath "wan_train_network.py"

if (-not (Test-Path $ScriptPath)) {
    Write-Host "Error: Script not found at $ScriptPath" -ForegroundColor Red
    exit 1
}

# Determine Python/Accelerate executable
if ($UseAccelerate) {
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\accelerate.exe"
    $LaunchArgs = @("launch", "--num_cpu_threads_per_process", "1", "--mixed_precision", "bf16")
} else {
    $PythonExe = Join-Path $MusubiTunerPath "venv\Scripts\python.exe"
    $LaunchArgs = @()
}

$Arguments = @(
    $ScriptPath
    "--task", $Task
    "--dit", $DitPath
    "--dataset_config", $DatasetConfig
    "--sdpa"
    "--mixed_precision", "bf16"
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

if ($DitHighNoise) {
    $Arguments += "--dit_high_noise", $DitHighNoise
}

if ($Fp8Base) {
    $Arguments += "--fp8_base"
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

