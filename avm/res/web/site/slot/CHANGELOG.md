# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/site/slot/CHANGELOG.md).

## 0.3.1

### Changes

- Upgraded all `Microsoft.Web/sites/slots/*` resource API versions to `2025-03-01`
- Added new parameters: `daprConfig`, `ipMode`, `resourceConfig`, `workloadProfileName`, `hostNamesDisabled`, `reserved`, `scmSiteAlsoStopped`, `e2eEncryptionEnabled`
- Added `clientAffinityProxyEnabled` and `clientAffinityPartitioningEnabled` parameters
- Added `outboundVnetRouting` parameter for consolidated VNet routing control
- Upgraded `functionAppConfig`, `cloningInfo`, and `siteConfig` to resource-derived types
- Unified all `avm-common-types` imports to `0.6.1`

### Breaking Changes

- None

## 0.3.0

### Changes

- Added support for `sshEnabled` parameter to enable or disable SSH access for the app

### Breaking Changes

- None

## 0.2.0

### Changes

- Updated version of referenced private endpoint AVM res module to latest `0.11.1`

### Breaking Changes

- Added additional setting `ApplicationInsightsAgent_EXTENSION_VERSION` for configs of type `appsettings` that is automatically set if the parameter `applicationInsightResourceId` is provided and no custom `ApplicationInsightsAgent_EXTENSION_VERSION` is configured via the config's `properties` parameter. It automatically selects `~3` for Linux sites & `~2` for Windows.

## 0.1.1

### Changes

- Recompiled templates with latest Bicep version `0.38.33.2757`

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
