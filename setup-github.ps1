# GitHub Connection Setup Script
# This script helps you connect your local repository to GitHub

Write-Host "=== GitHub Connection Setup ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check/Set Git Identity
Write-Host "Step 1: Git User Identity" -ForegroundColor Yellow
$currentName = git config --global user.name
$currentEmail = git config --global user.email

if ($currentName) {
    Write-Host "Current git user name: $currentName" -ForegroundColor Green
} else {
    Write-Host "Git user name not set" -ForegroundColor Red
    $name = Read-Host "Enter your name (for git commits)"
    if ($name) {
        git config --global user.name $name
        Write-Host "[OK] Git user name set" -ForegroundColor Green
    }
}

if ($currentEmail) {
    Write-Host "Current git email: $currentEmail" -ForegroundColor Green
} else {
    Write-Host "Git email not set" -ForegroundColor Red
    $email = Read-Host "Enter your email (for git commits)"
    if ($email) {
        git config --global user.email $email
        Write-Host "[OK] Git email set" -ForegroundColor Green
    }
}

Write-Host ""

# Step 2: Check for existing remote
Write-Host "Step 2: Check Remote Repository" -ForegroundColor Yellow
$remotes = git remote -v
if ($remotes) {
    Write-Host "Current remotes:" -ForegroundColor Cyan
    Write-Host $remotes
    $existing = Read-Host "Remote already exists. Do you want to update it? (y/n)"
    if ($existing -eq "n") {
        Write-Host "Skipping remote setup" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""

# Step 3: Get GitHub Repository URL
Write-Host "Step 3: GitHub Repository URL" -ForegroundColor Yellow
Write-Host "Choose an option:"
Write-Host "1. Create a new repository on GitHub (recommended)"
Write-Host "2. Connect to an existing repository"
$choice = Read-Host "Enter choice (1 or 2)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "To create a new repository:" -ForegroundColor Cyan
    Write-Host "1. Go to https://github.com/new"
    Write-Host "2. Repository name: electric-sheep"
    Write-Host "3. Choose Public or Private"
    Write-Host "4. DO NOT initialize with README, .gitignore, or license"
    Write-Host "5. Click 'Create repository'"
    Write-Host ""
    $username = Read-Host "Enter your GitHub username"
    $repoUrl = "https://github.com/$username/electric-sheep.git"
} else {
    $repoUrl = Read-Host "Enter GitHub repository URL (e.g., https://github.com/username/electric-sheep.git)"
}

Write-Host ""

# Step 4: Add remote
Write-Host "Step 4: Adding Remote Repository" -ForegroundColor Yellow
try {
    # Remove existing origin if it exists
    $existingOrigin = git remote get-url origin 2>$null
    if ($existingOrigin) {
        Write-Host "Removing existing origin remote..." -ForegroundColor Yellow
        git remote remove origin
    }
    
    git remote add origin $repoUrl
    Write-Host "[OK] Remote 'origin' added: $repoUrl" -ForegroundColor Green
} catch {
    Write-Host "Error adding remote: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 5: Handle nested repository
Write-Host "Step 5: Checking Nested Repository" -ForegroundColor Yellow
if (Test-Path "ai-tools\musubi-tuner\.git") {
    Write-Host "Found nested git repository in ai-tools/musubi-tuner" -ForegroundColor Yellow
    Write-Host "This is already excluded in .gitignore, so it's safe to proceed." -ForegroundColor Green
}

Write-Host ""

# Step 6: Stage and commit changes
Write-Host "Step 6: Preparing to Commit" -ForegroundColor Yellow
$status = git status --short
if ($status) {
    Write-Host "Current changes:" -ForegroundColor Cyan
    git status --short
    Write-Host ""
    $commit = Read-Host "Stage all changes and commit? (y/n)"
    if ($commit -eq "y") {
        git add .
        $commitMessage = Read-Host "Enter commit message (or press Enter for default)"
        if (-not $commitMessage) {
            $commitMessage = "Initial commit: Electric Sheep Toolset with MCP support"
        }
        git commit -m $commitMessage
        Write-Host "[OK] Changes committed" -ForegroundColor Green
    }
} else {
    Write-Host "No uncommitted changes found" -ForegroundColor Green
}

Write-Host ""

# Step 7: Push to GitHub
Write-Host "Step 7: Push to GitHub" -ForegroundColor Yellow
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan

# Check if we need to rename branch to main
if ($currentBranch -eq "master") {
    $rename = Read-Host "Rename branch from 'master' to 'main'? (y/n) [recommended: y]"
    if ($rename -ne "n") {
        git branch -M main
        $currentBranch = "main"
        Write-Host "[OK] Branch renamed to 'main'" -ForegroundColor Green
    }
}

$push = Read-Host "Push to GitHub? (y/n)"
if ($push -eq "y") {
    Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
    try {
        git push -u origin $currentBranch
        Write-Host ""
        Write-Host "[OK] Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
    } catch {
        Write-Host "Error pushing: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "If you need to authenticate:" -ForegroundColor Yellow
        Write-Host "1. Use a Personal Access Token (PAT) instead of password"
        Write-Host "2. Or use SSH: git remote set-url origin git@github.com:username/electric-sheep.git"
    }
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Verify your repository at: $repoUrl"
Write-Host "2. Add a README or description on GitHub"
Write-Host "3. Consider adding topics/tags on GitHub"

