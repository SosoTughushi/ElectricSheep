# Rule Validation Script
# Validates rule consistency, cross-references, and format compliance

param(
    [switch]$Verbose,
    [switch]$Fix
)

$ErrorActionPreference = "Stop"
$issues = @()
$warnings = @()

Write-Output "Validating ruleset and documentation..."

# Check 1: All .cursorrules files have YAML frontmatter
Write-Output "`n[1/8] Checking YAML frontmatter..."
$rulesFiles = Get-ChildItem -Path "rules" -Filter "*.cursorrules" -Recurse
foreach ($file in $rulesFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "^---\s*\n") {
        $issues += "Missing YAML frontmatter: $($file.FullName)"
    } elseif ($content -match "^---\s*\n(.*?)\n---\s*\n") {
        $frontmatter = $Matches[1]
        if ($frontmatter -notmatch "priority:") {
            $warnings += "Missing 'priority' in frontmatter: $($file.FullName)"
        }
        if ($frontmatter -notmatch "applies_to:") {
            $warnings += "Missing 'applies_to' in frontmatter: $($file.FullName)"
        }
    }
}

# Check 2: All rules referenced in README.md exist
Write-Output "[2/8] Checking rule references in README.md..."
$readmeContent = Get-Content "rules/README.md" -Raw
$referencedRules = [regex]::Matches($readmeContent, "`([^`]+\.cursorrules)`") | ForEach-Object { $_.Groups[1].Value }
foreach ($rule in $referencedRules) {
    $rulePath = Join-Path "rules" $rule
    if (-not (Test-Path $rulePath)) {
        $issues += "Referenced rule not found: $rulePath"
    }
}

# Check 3: All existing rules are referenced in README.md
Write-Output "[3/8] Checking all rules are documented..."
foreach ($file in $rulesFiles) {
    $ruleName = $file.Name
    if ($readmeContent -notmatch [regex]::Escape($ruleName)) {
        $warnings += "Rule not referenced in README.md: $ruleName"
    }
}

# Check 4: Policy cards exist and have YAML frontmatter
Write-Output "[4/8] Checking policy cards..."
$policyCards = @("operational-policy.md", "privacy-policy.md", "ethical-policy.md")
foreach ($card in $policyCards) {
    $cardPath = Join-Path "rules/policy-cards" $card
    if (-not (Test-Path $cardPath)) {
        $issues += "Missing policy card: $cardPath"
    } else {
        $content = Get-Content $cardPath -Raw
        if ($content -notmatch "^---\s*\n") {
            $issues += "Missing YAML frontmatter in policy card: $cardPath"
        }
    }
}

# Check 5: Cross-references are valid
Write-Output "[5/8] Checking cross-references..."
$allRulesContent = Get-ChildItem -Path "rules" -Filter "*.cursorrules" -Recurse | ForEach-Object {
    @{ File = $_.FullName; Content = Get-Content $_.FullName -Raw }
}

foreach ($rule in $allRulesContent) {
    $references = [regex]::Matches($rule.Content, "`([^`]+\.(cursorrules|md))`") | ForEach-Object { $_.Groups[1].Value }
    foreach ($ref in $references) {
        $refPath = if ($ref -match "^rules/") {
            $ref
        } elseif ($ref -match "^docs/") {
            $ref
        } else {
            Join-Path (Split-Path $rule.File -Parent) $ref
        }
        if (-not (Test-Path $refPath)) {
            $warnings += "Broken reference in $($rule.File): $ref"
        }
    }
}

# Check 6: Examples sections exist in rules
Write-Output "[6/8] Checking for Examples sections..."
foreach ($file in $rulesFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "## Examples") {
        $warnings += "Missing Examples section: $($file.FullName)"
    }
}

# Check 7: AGENTS.md exists and references rules
Write-Output "[7/8] Checking AGENTS.md..."
if (-not (Test-Path "AGENTS.md")) {
    $issues += "Missing AGENTS.md file"
} else {
    $agentsContent = Get-Content "AGENTS.md" -Raw
    if ($agentsContent -notmatch "rules/README\.md") {
        $warnings += "AGENTS.md should reference rules/README.md"
    }
}

# Check 8: Quick reference exists
Write-Output "[8/8] Checking quick reference..."
if (-not (Test-Path "docs/guides/quick-reference.md")) {
    $issues += "Missing quick reference: docs/guides/quick-reference.md"
}

# Report results
Write-Output "`n=== Validation Results ==="
if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Output "✅ All checks passed!"
    exit 0
}

if ($issues.Count -gt 0) {
    Write-Output "`n❌ Issues found ($($issues.Count)):"
    foreach ($issue in $issues) {
        Write-Output "  - $issue"
    }
}

if ($warnings.Count -gt 0) {
    Write-Output "`n⚠️  Warnings ($($warnings.Count)):"
    foreach ($warning in $warnings) {
        Write-Output "  - $warning"
    }
}

if ($issues.Count -gt 0) {
    Write-Output "`nValidation failed. Please fix issues above."
    exit 1
} else {
    Write-Output "`nValidation passed with warnings. Consider addressing warnings."
    exit 0
}

