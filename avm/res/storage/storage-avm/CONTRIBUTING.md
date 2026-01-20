# Contributing to Storage AVM Module

This document provides guidelines for contributing to the Storage Account Azure Verified Module (AVM).

## Prerequisites

- Azure Bicep CLI (`bicep` command)
- Azure CLI (`az` command)
- PowerShell 7+

## Local Validation

Before submitting a PR, ensure the module passes all validations:

### 1. Bicep Syntax Validation
```powershell
bicep build main.bicep
bicep build tests/e2e/defaults/main.test.bicep
bicep build tests/e2e/max/main.test.bicep
bicep build tests/e2e/waf-aligned/main.test.bicep
```

### 2. Template Validation
```powershell
# Login to Azure first
az login

# Validate the main template
az deployment group validate \
  --resource-group rg-storage-avm-test \
  --template-file main.bicep \
  --parameters main.bicepparam

# Validate test templates
az deployment group validate \
  --resource-group rg-storage-avm-test \
  --template-file tests/e2e/defaults/main.test.bicep \
  --parameters tests/e2e/defaults/main.bicepparam
```

### 3. Test Deployment (Optional - Actual Deployment)
```powershell
# Deploy test scenario
az deployment group create \
  --name stg-avm-test \
  --resource-group rg-storage-avm-test \
  --template-file tests/e2e/defaults/main.test.bicep \
  --parameters tests/e2e/defaults/main.bicepparam
```

## Module Structure

```
avm/res/storage/storage-avm/
├── main.bicep                    # Main module code
├── main.bicepparam               # Default parameters
├── README.md                     # Module documentation
├── metadata.json                 # Module metadata
├── tests/
│   └── e2e/
│       ├── defaults/            # Default scenario tests
│       ├── max/                 # Maximum features tests
│       └── waf-aligned/         # WAF-aligned deployment tests
└── .github/
    └── workflows/
        └── validation.yml       # GitHub Actions workflow
```

## Making Changes

1. **Update main.bicep** - Make changes to the module code
2. **Update README.md** - Document any new parameters or outputs
3. **Update metadata.json** - Bump the version number
4. **Test changes** - Run validation scripts locally
5. **Submit PR** - Create a pull request with clear description

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- MAJOR version for incompatible API changes
- MINOR version for new functionality (backward compatible)
- PATCH version for bug fixes

## PR Checklist

- [ ] Bicep syntax is valid
- [ ] All tests pass locally
- [ ] README.md is updated
- [ ] Version number is bumped
- [ ] No hardcoded values (use parameters)
- [ ] All parameters have descriptions
- [ ] All outputs have descriptions
- [ ] Tags are properly handled
- [ ] Sensitive data uses `@secure()` decorator where needed

## Testing Scenarios

### Default Scenario
Tests the module with minimal required parameters and sensible defaults.

### Maximum Scenario  
Tests the module with all available parameters and features configured.

### WAF-Aligned Scenario
Tests the module with Well-Architected Framework best practices enabled.

## Feedback and Support

For questions or issues:
1. Check existing issues in the main AVM repository
2. Open a new issue with clear description
3. Reference this module path: `avm/res/storage/storage-avm`
