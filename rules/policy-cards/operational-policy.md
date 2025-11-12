---
policy_type: operational
priority: system
applies_to: runtime_operations
version: 1.0.0
enforcement: required
---

# Operational Policy Card

**Policy Type**: Operational Constraints  
**Priority**: System (Highest)  
**Enforcement**: Required at Runtime

## Overview

This policy card defines operational constraints that must be enforced at runtime. These constraints override all other rules and cannot be bypassed.

## Operational Constraints

### Constraint 1: Resource Limits

**Rule**: Operations must respect system resource limits.

**Requirements**:
- CPU usage: Monitor and throttle if exceeding 80% sustained
- Memory usage: Fail gracefully if memory limit exceeded
- Disk space: Check available space before file operations
- Network: Implement timeouts and retry limits

**Enforcement**:
```powershell
# Check resources before operation
$cpuUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
if ($cpuUsage -gt 80) {
    Write-Warning "RESOURCE_LIMIT: High CPU usage ($cpuUsage%)"
    Write-Warning "ACTION: Throttling operation"
    Start-Sleep -Seconds 5
}
```

### Constraint 2: Timeout Limits

**Rule**: All operations must have timeout limits.

**Requirements**:
- Network operations: 30 second timeout
- File operations: 60 second timeout
- Long-running operations: 300 second timeout (5 minutes)
- Background operations: No timeout (but log progress)

**Enforcement**:
```powershell
# Set timeout for operation
$timeout = 30
$job = Start-Job -ScriptBlock { /* operation */ }
if (Wait-Job -Job $job -Timeout $timeout) {
    $result = Receive-Job -Job $job
} else {
    Stop-Job -Job $job
    Write-Error "ERROR_TYPE: TimeoutError"
    Write-Error "ERROR_TIMEOUT: $timeout seconds"
    exit 1
}
```

### Constraint 3: Error Recovery Limits

**Rule**: Limit retry attempts to prevent infinite loops.

**Requirements**:
- Maximum retries: 3 attempts
- Retry delay: Exponential backoff (2s, 4s, 8s)
- After max retries: Escalate or fail gracefully

**Enforcement**:
```powershell
$maxRetries = 3
$attempt = 0
while ($attempt -lt $maxRetries) {
    try {
        # Operation
        break
    } catch {
        $attempt++
        if ($attempt -ge $maxRetries) {
            Write-Error "ERROR_TYPE: MaxRetriesExceeded"
            exit 1
        }
        Start-Sleep -Seconds ([Math]::Pow(2, $attempt))
    }
}
```

### Constraint 4: Logging Requirements

**Rule**: All operations must log to `logs/` directory.

**Requirements**:
- Log file naming: `{operation}-{timestamp}.log`
- Log all output: stdout, stderr, exit codes
- Log rotation: Keep last 30 days of logs
- Log format: Structured, parseable

**Enforcement**:
```powershell
$logFile = "logs/operation-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
.\script.ps1 *> $logFile 2>&1
$exitCode = $LASTEXITCODE
Add-Content -Path $logFile -Value "EXIT_CODE: $exitCode"
```

### Constraint 5: State Management

**Rule**: Operations must be idempotent when possible.

**Requirements**:
- Check state before modifying
- Support resume/retry mechanisms
- Don't duplicate work if already done
- Document state changes

**Enforcement**:
```powershell
# Check if operation already completed
$stateFile = ".local/state/operation-state.json"
if (Test-Path $stateFile) {
    $state = Get-Content $stateFile | ConvertFrom-Json
    if ($state.status -eq "completed") {
        Write-Output "STATUS: Already completed, skipping"
        exit 0
    }
}
# Perform operation
# Update state file
```

## Violation Handling

**Policy Violations**:
- Log violation with `POLICY_VIOLATION:` prefix
- Stop operation if violation is critical
- Escalate to user if violation cannot be resolved
- Document violation in log file

**Example**:
```powershell
if ($cpuUsage -gt 95) {
    Write-Error "POLICY_VIOLATION: CPU usage exceeds 95%"
    Write-Error "ACTION: Stopping operation to prevent system instability"
    exit 1
}
```

## References

- **Error Handling**: `rules/error-handling.cursorrules` - Error recovery patterns
- **Execution Preferences**: `rules/execution-preference.cursorrules` - Execution guidelines
- **Decision Making**: `rules/decision-making.cursorrules` - Escalation procedures

