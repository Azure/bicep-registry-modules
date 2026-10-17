# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-generation/CHANGELOG.md).

## 0.3.0

### Changes

- Added an Azure Container Registry with managed identity-based `AcrPull` access for the App Service and Container Instance.
- Added Premium SKU selection, private endpoint, and private DNS integration when private networking or scalability is enabled.
- Configured public placeholder images for the initial deployment so application images can be built and pushed during post-deployment.

### Breaking Changes

- Removed the `acrName` and `imageTag` parameters. The module now provisions and outputs its own Azure Container Registry.

## 0.2.0

### Changes

- Updated AVM module references to latest versions (cognitive-services/account 0.14.2, network-security-group 0.5.3, virtual-network 0.8.1, avm-common-types 0.7.0)
- Updated Azure Resource API versions (Microsoft.Resources/deployments 2025-04-01, Microsoft.CognitiveServices 2026-01-15-preview, Microsoft.Storage/storageAccounts 2025-08-01)
- Updated image model from gpt-image-1 to gpt-image-1-mini

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
