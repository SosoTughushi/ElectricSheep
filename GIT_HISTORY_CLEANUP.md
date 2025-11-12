# Git History Cleanup Guide

This guide explains how to remove sensitive names ("sophie", "angelina", "dani", "ana") from git history.

## ⚠️ WARNING

Rewriting git history is **destructive** and will change commit hashes. If you've already pushed to a remote repository, you'll need to force push, which can affect collaborators.

## Method 1: Using git filter-repo (Recommended)

`git filter-repo` is the modern, recommended tool for rewriting history.

### Installation

```bash
# macOS
brew install git-filter-repo

# Or via pip
pip install git-filter-repo
```

### Remove files and content from history

```bash
cd /Users/sosotughushi/RiderProjects/ElectricSheep

# Remove all occurrences of sensitive names from file contents
git filter-repo --replace-text <(cat <<EOF
sophie==>example-dataset
Sophie==>Example Dataset
SOPHIE==>EXAMPLE-DATASET
angelina==>example-celebrity
Angelina==>Example Celebrity
ANGELINA==>EXAMPLE-CELEBRITY
Angelina Jolie==>Example Celebrity Dataset
Angeline Jolie==>Example Celebrity Dataset
dani==>example-person-dataset
Dani==>Example Person Dataset
DANI==>EXAMPLE-PERSON-DATASET
ana==>example-character-dataset
Ana==>Example Character Dataset
ANA==>EXAMPLE-CHARACTER-DATASET
EOF
)

# Force push to remote (if you have one)
# git push origin --force --all
```

## Method 2: Using BFG Repo-Cleaner

BFG is faster than git filter-branch for large repositories.

### Installation

```bash
# Download from https://rtyley.github.io/bfg-repo-cleaner/
# Or via Homebrew
brew install bfg
```

### Usage

```bash
cd /Users/sosotughushi/RiderProjects/ElectricSheep

# Create a replacements file
cat > replacements.txt <<EOF
sophie==>example-dataset
Sophie==>Example Dataset
angelina==>example-celebrity
Angelina==>Example Celebrity
Angelina Jolie==>Example Celebrity Dataset
dani==>example-person-dataset
ana==>example-character-dataset
EOF

# Run BFG
bfg --replace-text replacements.txt

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

## Method 3: Interactive Rebase (For Recent Commits Only)

If you only need to clean recent commits:

```bash
# Start interactive rebase from before the commits with sensitive data
git rebase -i <commit-before-sensitive-data>

# In the editor, mark commits as 'edit'
# Then for each commit:
git commit --amend
# Edit files to remove sensitive names
git rebase --continue
```

## After Rewriting History

1. **Verify the changes:**
   ```bash
   git log --all --full-history -- "*sophie*" "*angelina*" "*dani*" "*ana*"
   ```

2. **Update remote (if applicable):**
   ```bash
   git push origin --force --all
   git push origin --force --tags
   ```

3. **Notify collaborators** that they need to re-clone or reset their local repositories.

## Current Status

All sensitive names have been replaced in the working directory with generic placeholders:
- "sophie" → "example-dataset"
- "angelina" / "Angelina Jolie" → "example-celebrity-dataset"
- "dani" → "example-person-dataset"
- "ana" → "example-character-dataset"

All file names have been renamed accordingly.

## Next Steps

1. Review all changes: `git status`
2. Commit the current changes: `git add -A && git commit -m "Replace sensitive dataset names with generic placeholders"`
3. Run git filter-repo or BFG to clean history
4. Force push if needed

