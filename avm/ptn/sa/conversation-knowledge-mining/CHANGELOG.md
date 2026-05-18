# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/conversation-knowledge-mining/CHANGELOG.md).

## 0.4.0

### Changes

- Updated all AVM module references to latest versions (`cognitive-services/account:0.14.2`, `compute/virtual-machine:0.22.0`, `network/network-security-group:0.5.3`, `network/virtual-network:0.8.1`, `avm/utl/types/avm-common-types:0.7.0`).
- Updated Azure Resource API versions to latest stable (`Microsoft.CognitiveServices@2025-12-01`, `Microsoft.KeyVault@2025-05-01`, `Microsoft.Storage@2025-08-01`, `Microsoft.App/containerApps@2026-01-01`).
- Changed default embedding model from `text-embedding-ada-002` to `text-embedding-3-small`.
- Added system-assigned managed identity to frontend web app.
- Added private endpoint support for frontend web app in WAF-aligned (private networking) scenario.
- Added `privatelink.azurewebsites.net` private DNS zone for web app private endpoints.
- Added conditional `APP_API_BASE_URL` and `BACKEND_API_HOST` app settings for private networking.
- Added private endpoint support for backend web app in WAF-aligned (private networking) scenario.
- Changed SQL Database SKU to provisioned `GP_Gen5` when `enableRedundancy` is `true` (zone redundancy not supported on serverless `GP_S_Gen5`); serverless SKU is retained when redundancy is disabled.

### Breaking Changes

- None

## 0.3.0

### Changes

- Updated all AVM module references and API versions to latest.
- Refactored AI Search deployment to reduce deployment time.
- Added new outputs: `apiAppName`, `agentNameConversation`, `agentNameTitle`.
- Added new app settings: `AGENT_NAME_CONVERSATION`, `AGENT_NAME_TITLE`, `API_APP_NAME`, `AI_FOUNDRY_RESOURCE_ID`.
- Code formatting and style improvements.

### Breaking Changes

- None

## 0.2.0

### Changes

- Updated all the moudules including waf & non-waf with readme.
- Removed usage of dpeloyment script bicep module.

### Breaking Changes

- None

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
