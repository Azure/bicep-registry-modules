# GitHub PR Submission Guide

This guide walks you through forking, cloning, and submitting your AVM Storage Account module to the Azure/bicep-registry-modules repository.

## Prerequisites
- GitHub account
- Git installed locally
- Your module ready at: `c:\Pluralsight\AVM\avm\res\storage\storage-avm\`

## Step 1: Fork Azure/bicep-registry-modules Repository

1. Open https://github.com/Azure/bicep-registry-modules
2. Click the **Fork** button (top-right corner)
3. Keep default settings
4. Click **Create fork**

**Result**: You now have your own copy at `https://github.com/<YOUR_USERNAME>/bicep-registry-modules`

## Step 2: Clone Your Fork Locally

```powershell
# Set variables
$GITHUB_USERNAME = "your-github-username"
$FORK_URL = "https://github.com/$GITHUB_USERNAME/bicep-registry-modules.git"
$CLONE_PATH = "C:\repos\bicep-registry-modules"

# Clone the fork
git clone $FORK_URL $CLONE_PATH

# Navigate to the cloned directory
cd $CLONE_PATH
```

## Step 3: Copy Your Module

```powershell
# Copy your module to the cloned repo
$MODULE_SOURCE = "C:\Pluralsight\AVM\avm\res\storage\storage-avm"
$MODULE_DEST = "$CLONE_PATH\avm\res\storage\storage-avm"

# Create destination if it doesn't exist
if (!(Test-Path $MODULE_DEST)) {
    New-Item -ItemType Directory -Path $MODULE_DEST -Force | Out-Null
}

# Copy all files
Copy-Item -Path "$MODULE_SOURCE\*" -Destination $MODULE_DEST -Recurse -Force

# Verify copy
Get-ChildItem -Path $MODULE_DEST -Recurse | Measure-Object
```

## Step 4: Create Feature Branch

```powershell
cd $CLONE_PATH

# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feat/storage-avm-module
```

## Step 5: Stage and Commit Changes

```powershell
cd $CLONE_PATH

# Stage the new module
git add avm/res/storage/storage-avm/

# Verify staged files
git status

# Commit with descriptive message
git commit -m "feat: Add Storage Account AVM Resource Module (avm/res/storage/storage-avm)

- Implements Microsoft.Storage/storageAccounts resource
- Supports configurable SKU, kind, and access tier
- Includes three test scenarios: defaults, max, and WAF-aligned
- Full documentation and examples included
- Follows AVM best practices and guidelines"
```

## Step 6: Push to Your Fork

```powershell
cd $CLONE_PATH

# Push the feature branch
git push origin feat/storage-avm-module

# Verify push
git log --oneline -5
```

## Step 7: Create Pull Request

1. Go to your fork: `https://github.com/<YOUR_USERNAME>/bicep-registry-modules`
2. You should see a **"Compare & pull request"** button
3. Click it
4. Fill in the PR details:

**Title:**
```
Add Storage Account AVM Resource Module
```

**Description:**
```markdown
## Description
This PR adds a new Storage Account resource module to the Azure Verified Modules (AVM) program.

## Module Details
- **Path**: `avm/res/storage/storage-avm`
- **Type**: Resource Module
- **Resource Type**: `Microsoft.Storage/storageAccounts`
- **API Version**: 2023-01-01

## Features
- Configurable Storage Account SKU (Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS)
- Multiple kind options (Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage)
- Access tier configuration (Hot, Cool)
- HTTPS enforcement option
- Public network access control
- Tag support

## Test Scenarios
1. **Default** - Standard_LRS, StorageV2, Hot tier with minimal tags
2. **Max** - Standard_GRS, StorageV2, Cool tier with comprehensive tags
3. **WAF-Aligned** - Zone-redundant (ZRS), HTTPS enforced, private access only

## Validation
- [x] Bicep syntax validated (no errors)
- [x] All test scenarios compile successfully
- [x] Comprehensive README.md documentation
- [x] CONTRIBUTING.md guidelines included
- [x] GitHub Actions workflow for CI/CD
- [x] Follows AVM naming conventions and standards
- [x] All parameters have descriptions
- [x] All outputs have descriptions

## Checklist
- [x] Module follows AVM conventions
- [x] All tests pass locally
- [x] Documentation is complete
- [x] No breaking changes
- [x] Ready for community review

## Related Issues
Closes N/A (New module contribution)
```

5. Click **Create pull request**

## Step 8: Monitor PR Status

After creating the PR:
1. GitHub Actions will automatically run validation tests
2. AVM maintainers will review the module
3. You may be asked for changes
4. Once approved, the module will be merged
5. Automated CI/CD will publish to `br/public:avm`

## Useful Git Commands

```powershell
# Check current branch
git branch

# View commit history
git log --oneline -10

# View changes before commit
git diff

# Undo last commit (if needed)
git reset --soft HEAD~1

# Pull latest changes from upstream
git fetch origin
git rebase origin/main
```

## Troubleshooting

**Q: How do I sync my fork with the main repo?**
```powershell
git remote add upstream https://github.com/Azure/bicep-registry-modules.git
git fetch upstream
git rebase upstream/main
git push origin main --force
```

**Q: The PR fails CI/CD checks, what do I do?**
- Review the GitHub Actions log for errors
- Fix issues locally
- Commit and push - the PR will auto-update

**Q: How long until my module is published?**
- After merge: Automated CI/CD publishes within minutes
- Module available at: `br/public:avm/res/storage/storage-avm:latest`

---

**Status**: Ready to submit! Follow the steps above to complete the PR submission.
