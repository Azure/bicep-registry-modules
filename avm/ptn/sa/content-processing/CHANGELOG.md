# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-processing/CHANGELOG.md).

## 0.3.0

### Changes

- Upgraded the default Azure OpenAI model to `gpt-5.1` (version `2025-11-13`) and updated the AI Services location guidance and `usageName` accordingly.
- Consolidated Content Understanding onto the shared AI Foundry (`aif-`) AIServices account and removed the separate `aicu-` Cognitive Services account, fixing PDF extraction DNS resolution failures.
- Added a Content Processor Workflow container app (`ca-<suffix>-wkfl`) with its system-assigned identity, storage (Blob/Queue) and AI Services role assignments.
- Configured the container apps to pull images from the solution's Container Registry via a dedicated registry reader identity.
- Fixed the web app `APP_WEB_AUTHORITY` double-slash URL (MSAL.js sign-in), set `ingressTargetPort` to `3000`, and added `APP_REDIRECT_URL` and `APP_POST_REDIRECT_URL` settings.
- Enabled zone-redundant Cosmos DB (WAF reliability) when `enableRedundancy` is `true`.
- Updated the Container Registry module to `container-registry/registry` 0.12.1 with refined public-access, export-policy, and network-rule handling.
- Refreshed all referenced AVM module versions.

### Breaking Changes

- The `gptModelName` and `gptModelVersion` allowed values now accept only `gpt-5.1` and `2025-11-13`. Deployments pinning the previous `gpt-4o` / `2024-08-06` values must be updated.

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
