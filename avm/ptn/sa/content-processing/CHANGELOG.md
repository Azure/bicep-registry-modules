# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-processing/CHANGELOG.md).

## 0.3.0

### Changes

- Updated GPT model to gpt-5.1 with version 2025-11-13
- Updated container image tag to `latest_v2`
- Added v2 Workflow keys in App Configuration for batch processing support (batch processes, schemasets, claim process queue, dead letter queue)
- Added GPT-5 and PHI-4 service prefix keys in App Configuration
- Added Agent Framework keys in App Configuration (model deployment, project connection string, tracing)
- Enhanced resource group tagging with deployment metadata using `deployer()` function
- Updated resource tags parameter to use `resourceInput` type for type-safe tag definitions
- Updated API versions to latest (Microsoft.Resources/resourceGroups@2025-04-01, Microsoft.Resources/tags@2025-04-01)

### Breaking Changes

- None

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
