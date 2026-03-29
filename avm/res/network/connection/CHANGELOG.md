# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/connection/CHANGELOG.md).

## 0.1.7

### Changes

- Updated VPN Gateway SKUs in all e2e test dependencies from non-AZ (`VpnGw2`, `VpnGw1`) to AZ-enabled (`VpnGw2AZ`) to fix `NonAzSkusNotAllowedForVPNGateway` deployment errors, as Azure no longer supports non-AZ VPN Gateway SKUs.

### Breaking Changes

- None

## 0.1.6

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.1.5

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
