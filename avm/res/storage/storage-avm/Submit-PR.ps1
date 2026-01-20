# GitHub PR Automation Script for AVM Module Submission
# This script automates the fork, clone, copy, commit, and push workflow

param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory = $false)]
    [string]$ClonePath = "C:\repos\bicep-registry-modules",
    
    [Parameter(Mandatory = $false)]
    [string]$ModuleSourcePath = "C:\Pluralsight\AVM\avm\res\storage\storage-avm"
)

# Configuration
$UPSTREAM_REPO = "https://github.com/Azure/bicep-registry-modules.git"
$FORK_REPO = "https://github.com/$GitHubUsername/bicep-registry-modules.git"
$FEATURE_BRANCH = "feat/storage-avm-module"
$MODULE_DEST = "avm\res\storage\storage-avm"

Write-Host "=== AVM Module PR Submission Script ===" -ForegroundColor Green
Write-Host "GitHub Username: $GitHubUsername" -ForegroundColor Cyan
Write-Host "Clone Path: $ClonePath" -ForegroundColor Cyan
Write-Host "Module Source: $ModuleSourcePath" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clone the fork
Write-Host "Step 1: Cloning your fork..." -ForegroundColor Yellow
if (Test-Path $ClonePath) {
    Write-Host "Directory exists, skipping clone" -ForegroundColor Gray
} else {
    git clone $FORK_REPO $ClonePath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Clone failed! Make sure you've forked the repo." -ForegroundColor Red
        exit 1
    }
}
Write-Host "✓ Fork cloned successfully" -ForegroundColor Green
Write-Host ""

# Step 2: Navigate to repo
cd $ClonePath

# Step 3: Add upstream remote (if not exists)
Write-Host "Step 2: Setting up upstream remote..." -ForegroundColor Yellow
$remotes = git remote
if ($remotes -notcontains "upstream") {
    git remote add upstream $UPSTREAM_REPO
    Write-Host "✓ Upstream remote added" -ForegroundColor Green
} else {
    Write-Host "✓ Upstream remote already configured" -ForegroundColor Green
}
Write-Host ""

# Step 4: Update main branch
Write-Host "Step 3: Updating main branch..." -ForegroundColor Yellow
git checkout main
git pull origin main
Write-Host "✓ Main branch updated" -ForegroundColor Green
Write-Host ""

# Step 5: Create feature branch
Write-Host "Step 4: Creating feature branch..." -ForegroundColor Yellow
git checkout -b $FEATURE_BRANCH 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Feature branch created: $FEATURE_BRANCH" -ForegroundColor Green
} else {
    git checkout $FEATURE_BRANCH
    Write-Host "✓ Switched to feature branch: $FEATURE_BRANCH" -ForegroundColor Green
}
Write-Host ""

# Step 6: Copy module files
Write-Host "Step 5: Copying module files..." -ForegroundColor Yellow
$MODULE_FULL_PATH = Join-Path $ClonePath $MODULE_DEST
if (!(Test-Path $MODULE_FULL_PATH)) {
    New-Item -ItemType Directory -Path $MODULE_FULL_PATH -Force | Out-Null
}
Copy-Item -Path "$ModuleSourcePath\*" -Destination $MODULE_FULL_PATH -Recurse -Force
Write-Host "✓ Module files copied to: $MODULE_DEST" -ForegroundColor Green
Write-Host ""

# Step 7: Stage changes
Write-Host "Step 6: Staging changes..." -ForegroundColor Yellow
git add $MODULE_DEST
$status = git status --short
Write-Host "Files staged:" -ForegroundColor Cyan
Write-Host $status
Write-Host "✓ Changes staged" -ForegroundColor Green
Write-Host ""

# Step 8: Commit
Write-Host "Step 7: Committing changes..." -ForegroundColor Yellow
$commitMessage = @"
feat: Add Storage Account AVM Resource Module

- Implements Microsoft.Storage/storageAccounts resource
- Supports configurable SKU, kind, and access tier
- Includes three test scenarios: defaults, max, and WAF-aligned
- Full documentation and examples included
- Follows AVM best practices and guidelines
"@

git commit -m $commitMessage
Write-Host "✓ Changes committed" -ForegroundColor Green
Write-Host ""

# Step 9: Push to fork
Write-Host "Step 8: Pushing to your fork..." -ForegroundColor Yellow
git push origin $FEATURE_BRANCH
if ($LASTEXITCODE -ne 0) {
    Write-Host "Push failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Pushed to: origin/$FEATURE_BRANCH" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "=== PR Submission Ready ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Go to: https://github.com/$GitHubUsername/bicep-registry-modules" -ForegroundColor White
Write-Host "2. You should see a 'Compare & pull request' button" -ForegroundColor White
Write-Host "3. Click it and fill in the PR details (use GITHUB_PR_GUIDE.md as reference)" -ForegroundColor White
Write-Host "4. Submit the PR!" -ForegroundColor White
Write-Host ""
Write-Host "GitHub PR URL (after creating):" -ForegroundColor Cyan
Write-Host "https://github.com/Azure/bicep-registry-modules/pulls" -ForegroundColor Yellow
Write-Host ""
Write-Host "✓ Local setup complete!" -ForegroundColor Green
