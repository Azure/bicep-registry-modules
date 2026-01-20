# Quick PR Submission Commands

## Option 1: Automated Script (Recommended)

```powershell
# Run the PowerShell script
cd 'C:\Pluralsight\AVM\avm\res\storage\storage-avm'
.\Submit-PR.ps1 -GitHubUsername "your-github-username"
```

This script will:
✓ Clone your fork
✓ Create feature branch
✓ Copy your module
✓ Stage, commit, and push changes
✓ Provide next steps

---

## Option 2: Manual Commands

```powershell
# 1. Clone your fork
git clone https://github.com/YOUR_USERNAME/bicep-registry-modules.git
cd bicep-registry-modules

# 2. Create feature branch
git checkout -b feat/storage-avm-module

# 3. Copy module
Copy-Item -Path 'C:\Pluralsight\AVM\avm\res\storage\storage-avm' -Destination 'avm\res\storage' -Recurse -Force

# 4. Stage and commit
git add avm/res/storage/storage-avm/
git commit -m "feat: Add Storage Account AVM Resource Module"

# 5. Push to fork
git push origin feat/storage-avm-module
```

---

## Next Steps (After Push)

1. **Go to GitHub**: https://github.com/YOUR_USERNAME/bicep-registry-modules
2. **Click**: "Compare & pull request" button
3. **Fill in PR title**:
   ```
   Add Storage Account AVM Resource Module
   ```
4. **Fill in PR description**: (see GITHUB_PR_GUIDE.md for template)
5. **Click**: "Create pull request"

---

## After PR is Created

- ✅ GitHub Actions will run validation tests automatically
- ✅ AVM maintainers will review your module
- ✅ Respond to any requested changes
- ✅ Once merged, module publishes to `br/public:avm`

---

## Module Will Be Available At

```
br/public:avm/res/storage/storage-avm:latest
br/public:avm/res/storage/storage-avm:0.1.0
```

You can then use in other Bicep files:
```bicep
module storageAccount 'br/public:avm/res/storage/storage-avm:latest' = {
  name: 'stgDeploy'
  params: {
    name: 'mystg'
    location: 'centralsweden'
  }
}
```

---

## Troubleshooting

**Q: The script can't find git**
```powershell
# Make sure git is installed and in PATH
git --version
```

**Q: Authentication fails**
```powershell
# Set up Git credentials (you may need to use personal access token)
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

**Q: Need to make changes after pushing**
```powershell
# Make your changes
git add .
git commit -m "fix: Description of fix"
git push origin feat/storage-avm-module  # Auto-updates the PR
```

---

**Status**: 🚀 Ready to submit! Choose Option 1 or 2 above to get started.
