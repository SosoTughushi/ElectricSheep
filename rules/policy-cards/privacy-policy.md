---
policy_type: privacy
priority: system
applies_to: data_handling
version: 1.0.0
enforcement: required
---

# Privacy Policy Card

**Policy Type**: Privacy and Data Protection  
**Priority**: System (Highest)  
**Enforcement**: Required at Runtime

## Overview

This policy card defines privacy constraints that must be enforced at runtime. Privacy violations are serious and cannot be bypassed.

## Privacy Constraints

### Constraint 1: No Secrets in Code

**Rule**: Never hardcode API keys, passwords, tokens, or secrets in code.

**Requirements**:
- Use environment variables or local config files
- Load secrets from `.local/config.json` (gitignored)
- Use placeholders in example/template files
- Validate before committing (no secrets in git)

**Enforcement**:
```powershell
# Check for secrets before committing
$secretPatterns = @(
    "(api[_-]?key|password|secret|token)\s*[:=]\s*['\`"]?[a-zA-Z0-9]{10,}",
    "sk-[a-zA-Z0-9]{20,}"
)

$content = Get-Content $file -Raw
foreach ($pattern in $secretPatterns) {
    if ($content -match $pattern) {
        Write-Error "POLICY_VIOLATION: Potential secret detected in $file"
        exit 1
    }
}
```

### Constraint 2: No User Paths in Committed Files

**Rule**: Never commit user-specific file paths.

**Requirements**:
- Use placeholders: `C:/path/to/` or `E:/path/to/`
- Load actual paths from `.local/config.json`
- Document path requirements in example files
- Validate paths don't contain user names

**Enforcement**:
```powershell
# Check for user-specific paths
$userPathPattern = "E:\\Users\\[^\\]+|C:\\Users\\[^\\]+"
$content = Get-Content $file -Raw
if ($content -match $userPathPattern) {
    Write-Error "POLICY_VIOLATION: User-specific path detected in $file"
    Write-Error "SUGGESTION: Use placeholder or load from .local/config.json"
    exit 1
}
```

### Constraint 3: Local Config Separation

**Rule**: User-specific configuration must be in `.local/` directory (gitignored).

**Requirements**:
- `.local/config.json` - User config (never committed)
- `.local/config.example.json` - Template (committed)
- All user-specific data in `.local/` directory
- Document required fields in example file

**Enforcement**:
```powershell
# Ensure .local/config.json is gitignored
$gitignore = Get-Content .gitignore -Raw
if ($gitignore -notmatch "\.local/config\.json") {
    Write-Error "POLICY_VIOLATION: .local/config.json not in .gitignore"
    exit 1
}

# Check example file uses placeholders
$exampleContent = Get-Content .local/config.example.json -Raw
if ($exampleContent -match "sk-[a-zA-Z0-9]{20,}") {
    Write-Error "POLICY_VIOLATION: Example file contains real secrets"
    exit 1
}
```

### Constraint 4: Logging Privacy

**Rule**: Never log sensitive data (API keys, passwords, personal info).

**Requirements**:
- Redact secrets from logs
- Use `[REDACTED]` placeholder for sensitive data
- Log operation status, not sensitive details
- Validate logs before committing

**Enforcement**:
```powershell
# Redact secrets from log output
$logEntry = $response | ConvertTo-Json
$logEntry = $logEntry -replace $apiKey, "[REDACTED]"
$logEntry = $logEntry -replace $password, "[REDACTED]"
Add-Content -Path "logs/operation.log" -Value $logEntry
```

### Constraint 5: Data Minimization

**Rule**: Only collect and store data that is necessary for operation.

**Requirements**:
- Don't collect unnecessary user data
- Don't store data longer than needed
- Use temporary storage when possible
- Clean up temporary data after operation

**Enforcement**:
```powershell
# Use temporary file, clean up after
$tempFile = New-TemporaryFile
try {
    # Use temp file
    $result = Process-File -Path $tempFile
} finally {
    # Always clean up
    Remove-Item -Path $tempFile -Force
}
```

## Violation Handling

**Privacy Violations**:
- **Critical**: Stop operation immediately
- Log violation with `PRIVACY_VIOLATION:` prefix
- Escalate to user if violation detected
- Never proceed if privacy violation found

**Example**:
```powershell
if ($content -match $secretPattern) {
    Write-Error "PRIVACY_VIOLATION: Secret detected in $file"
    Write-Error "ACTION: Stopping operation - privacy violation"
    Write-Error "SUGGESTION: Remove secret before proceeding"
    exit 1
}
```

## Data Classification

### Public Data (Can Commit)
- Operation codes
- Tool structure
- Documentation
- Code (without secrets)
- Config templates (with placeholders)

### Private Data (Never Commit)
- API keys, tokens, secrets
- User-specific paths
- Personal information
- Local configuration
- Credentials

## References

- **Privacy Compliance**: `rules/privacy-compliance.cursorrules` - Detailed privacy rules
- **Development Workflow**: `rules/development-workflow.cursorrules` - Documentation requirements
- **Decision Making**: `rules/decision-making.cursorrules` - Escalation procedures

