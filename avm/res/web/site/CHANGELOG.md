# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/site/CHANGELOG.md).

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
