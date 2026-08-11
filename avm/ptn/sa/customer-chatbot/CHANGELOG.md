# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/customer-chatbot/CHANGELOG.md).

## 0.3.0

### Changes

- Added Azure Container Registry resource deployment with managed identity-based ACR Pull role assignments
- Split web apps into separate chat (frontend/backend) and scenario (frontend/backend) services
- Updated default GPT model to gpt-5.4-mini (version 2026-03-17)
- Updated default image tag to "latest"
- Added Cosmos DB and Cognitive Services role assignments for scenario backend
- Changed AI Services `publicNetworkAccess` to always enabled (private endpoint handled separately)

### Breaking Changes

- Removed `containerRegistryHost` parameter (ACR is now deployed within the module)
- Renamed output `acrName` to `azureContainerRegistryName`
- Added new output `azureContainerRegistryEndpoint`
- Renamed output `apiAppName` to `chatApiAppName`
- Renamed output `apiAppUrl` to `chatApiAppUrl`
- Removed output `webAppUrl` (replaced by `chatWebAppUrl` and `scenarioWebAppUrl`)
- Added new outputs: `chatWebAppName`, `scenarioApiAppName`, `scenarioWebAppName`, `scenarioApiAppUrl`, `scenarioWebAppUrl`

## 0.2.0

### Changes

- Updated with latest version changes

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None

