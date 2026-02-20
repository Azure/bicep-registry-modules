# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/site/CHANGELOG.md).

## 0.22.0

### Changes

- Upgraded all `Microsoft.Web/*` resource API versions to `2025-03-01`
- Added new parameters: `daprConfig`, `ipMode`, `resourceConfig`, `workloadProfileName`, `hostNamesDisabled`, `reserved`, `extendedLocation`
- Added `clientAffinityProxyEnabled` and `clientAffinityPartitioningEnabled` parameters
- Added `outboundVnetRouting` parameter (replaces deprecated `vnetContentShareEnabled`, `vnetImagePullEnabled`, `vnetRouteAllEnabled`)
- Upgraded `functionAppConfig`, `cloningInfo`, `siteConfig`, and `tags` to resource-derived types
- Upgraded `extensions` in slot type to resource-derived type (`resourceInput<'Microsoft.Web/sites/extensions@2025-03-01'>.properties[]?`)
- Unified all `avm-common-types` imports to `0.6.1`
- Updated test dependency API versions to latest GA: `Microsoft.Network/virtualNetworks@2025-05-01`, `Microsoft.Storage/storageAccounts@2025-06-01`, `Microsoft.Web/serverfarms@2025-03-01`
- Strengthened WAF-aligned test with managed identity, private endpoints, and resource lock
- Expanded max test coverage for new parameters across web app, Linux web app, and function app scenarios

### Breaking Changes

- Removed deprecated slot properties `vnetContentShareEnabled`, `vnetImagePullEnabled`, `vnetRouteAllEnabled` from `slotType` (use `outboundVnetRouting` instead)

## 0.21.0

### Changes

- Added support for `sshEnabled` parameter to enable or disable SSH access for the app

### Breaking Changes

- None

## 0.20.0

### Changes

- Updated several API versions
- Updated version of referenced private endpoint AVM res module to latest `0.11.1`

### Breaking Changes

- Added additional setting `ApplicationInsightsAgent_EXTENSION_VERSION` for configs of type `appsettings` that is automatically set if the parameter `applicationInsightResourceId` is provided and no custom `ApplicationInsightsAgent_EXTENSION_VERSION` is configured via the config's `properties` parameter. It automatically selects `~3` for Linux sites & `~2` for Windows. The same logic applies to slots.

## 0.19.4

### Changes

- Recompiled templates with latest Bicep version `0.38.33.2757`

### Breaking Changes

- None

## 0.19.3

### Changes

- Fix `clientAffinityEnabled`, `clientCertMode`, `publicNetworkAccess` for `serverFarmResourceId == ''` case so they aren't given incompatible values when making container functionapp
- Pass through `managedEnvironmentId` value to assignment as it can be `null`, so no `empty` test needed
- Change output type of `customDomainVerificationId` to be nullable because the value in `slotType` can be `null`

### Breaking Changes

- None

## 0.19.2

### Changes

- Introduced [`config`](/Azure/bicep-registry-modules/blob/main/avm/res/web/site/config) as child module
- Introduced [`slot`](/Azure/bicep-registry-modules/blob/main/avm/res/web/site/slot) as child module

### Breaking Changes

- None

## 0.19.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.19.0

### Changes

- `serverFarmResourceId` can be passed as empty string when `kind` is `functionapp,linux,container,azurecontainerapps` and `managedEnvironmentResourceId` is provided.
- Renamed parameter `managedEnvironmentId` to `managedEnvironmentResourceId` to align with naming standards
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Parameter `managedEnvironmentId` has been renamed to `managedEnvironmentResourceId`

## 0.18.0

### Changes

- Added support for `clientAffinityProxyEnabled` parameter to control session affinity cookies
- Added support for `clientAffinityPartitioningEnabled` parameter to enable client affinity partitioning using CHIPS cookies
- Updated Web site resource provider API version to `2024-11-01`
- Updated Web site slot resource provider API version to `2024-11-01`

### Breaking Changes

- Removed `vnetContentShareEnabled` parameter. Use `outboundVnetRouting.contentShareTraffic` instead.
- Removed `vnetImagePullEnabled` parameter. Use `outboundVnetRouting.imagePullTraffic` instead.
- Removed `vnetRouteAllEnabled` parameter. Use `outboundVnetRouting.allTraffic` instead.
- Added new  `outboundVnetRouting` parameter to be optional which supports the following properties:
  - `contentShareTraffic`: Controls whether content share traffic is routed through the VNet. Equivalent to the previous `vnetContentShareEnabled` parameter.
  - `imagePullTraffic`: Controls whether image pull traffic is routed through the VNet. Equivalent to the previous `vnetImagePullEnabled` parameter.
  - `allTraffic`: Controls whether all outbound traffic is routed through the VNet. Equivalent to the previous `vnetRouteAllEnabled` parameter.
- For more information about `outboundVnetRouting`, see the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/templates/microsoft.web/2024-11-01/sites?pivots=deployment-language-bicep#outboundvnetrouting).

## 0.17.0

### Changes

- Updated version of `avm-common-types`to `0.6.0` to enable specifying custom `Notes` for locks
- Added type for tags

### Breaking Changes

- Renamed parameter `virtualNetworkSubnetId` to `virtualNetworkSubnetResourceId` to align with specs

## 0.16.0

### Changes

- Initial version

### Breaking Changes

- None
