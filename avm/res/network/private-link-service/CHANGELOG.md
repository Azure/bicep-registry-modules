# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/private-link-service/CHANGELOG.md).

## 0.4.0

### Changes

- Added support for PLS Direct Connect mode via new `accessMode` and `destinationIPAddress` parameters
- Introduced user-defined types and flattened single-property parameters
- Updated `Microsoft.Network/privateLinkServices` API version to `2025-05-01`

### Breaking Changes

- `ipConfigurations[].properties.subnet.id` is now `ipConfigurations[].subnetResourceId`
- `loadBalancerFrontendIpConfigurations[].id` is now `loadBalancerFrontendIpConfigurationResourceIds`
- `autoApproval.subscriptions` is now `autoApprovalSubscriptionIds`
- `visibility.subscriptions` is now `visibilitySubscriptionIds`

## 0.3.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.3.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
