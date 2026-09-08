# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/conversation-knowledge-mining/CHANGELOG.md).

## 0.6.0

### Changes

- Restructured `main.bicep` into a pure orchestrator pattern: all resources are now deployed via local wrapper modules under `modules/{ai,compute,data,identity,monitoring,networking}/`, each wrapping exactly one published `avm/res/...` module, replacing the previous flat `modules/*.bicep` files.
- Added parameters `deployCosmos` (Cosmos DB is now optional; SQL is the primary database), `azureAdTenantId`, `azureAdClientId`, `adminApiKey`, `existingLogAnalyticsWorkspaceId`, `existingFoundryProjectResourceId`, `deployingUserPrincipalType`, `containerRegistryName`, `appServicePlanSku`, and `kind`.
- Backend and frontend App Services now use a system-assigned managed identity instead of a user-assigned identity.
- SQL AAD admin is now permanently set to the deploying principal, relying on the solution accelerator's post-provision `setup-sql-roles.ps1` script to configure additional access.
- Deployer identity is now granted broad data-plane role assignments (Search Index Data Contributor, Storage Blob Data Contributor, Cognitive Services User, ACR Push, SQL AAD admin) directly in the template.
- Renamed all outputs from camelCase to `ALL_CAPS` (e.g. `azureOpenAIEndpoint` → `AZURE_OPENAI_ENDPOINT`) to align with the solution accelerator's environment-variable naming convention.

### Breaking Changes

- Renamed parameter `aiServiceLocation` to `azureAiServiceLocation`.
- Removed parameters `usecase`, `secondaryLocation`, `cosmosDbReplicaLocation`, `azureContentUnderstandingApiVersion`, `azureOpenAIApiVersion`, and `azureAiAgentApiVersion`.
- Renamed all outputs from camelCase to `ALL_CAPS` (see Changes above) — any consumers referencing the old output names must be updated.

## 0.5.0

### Changes

- Upgraded Content Understanding API version default from `2024-12-01-preview` to `2025-11-01`.
- Consolidated the separate Content Understanding AI Services account (`-cu`) into the primary AI Foundry AI Services account.
- Updated allowed values for `aiServiceLocation`: removed `francecentral`; added `southcentralus` and `westeurope`.
- Added `Microsoft.Insights/dataCollectionRules` (`dcr-<suffix>`) for Windows VM performance counters and security events (deployed when `enablePrivateNetworking` and `enableMonitoring` are both true), and associated it with the jumpbox VM via `extensionMonitoringAgentConfig`.
- Enabled `requireInfrastructureEncryption` on the storage account.
- Enabled end-to-end encryption (`e2eEncryptionEnabled`) on backend and frontend web apps.

### Breaking Changes

- Removed parameter `contentUnderstandingLocation` (Content Understanding now uses the consolidated AI Services account in `aiServiceLocation`).
- Removed outputs `azureContentUnderstandingLocation` and `cuFoundryResourceId`. Output `azureOpenAICuEndpoint` is retained and now sourced from `aiFoundryAiServices.outputs.endpoints['Content Understanding']`.

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
