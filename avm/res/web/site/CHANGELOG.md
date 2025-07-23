# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/site/CHANGELOG.md).

## 0.18.0

### Features

- Added support for `clientAffinityProxyEnabled` parameter to control session affinity cookies
- Added support for `clientAffinityPartitioningEnabled` parameter to enable client affinity partitioning using CHIPS cookies
- Updated Web site resource provider API version to `2024-11-01`
- Updated Web site slot resource provider API version to `2024-11-01`

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
