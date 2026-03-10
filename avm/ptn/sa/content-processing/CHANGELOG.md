# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-processing/CHANGELOG.md).

## 0.2.0

### Changes

- Added Cognitive Services account and AI project management modules for AI Foundry
- Enhanced Container Registry with security and networking improvements (private endpoints, network rules, export policy controls)
- Migrated from legacy AI Hub/AI Project to new AI Foundry project model using Cognitive Services projects
- Updated all AVM module references to latest versions (Container App 0.19.0, Cosmos DB 0.18.0, App Configuration 0.9.2, etc.)
- Improved private networking configuration with proper DNS zone integration
- Added Virtual Machine and Bastion Host modules and updated the virtual network and subnet creation logic
- Updated resource naming conventions to use `solutionSuffix` pattern and refactored params based on AVM WAF Standards
- Improved conditional resource provisioning for monitoring and WAF-aligned features

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
