# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-wan/CHANGELOG.md).

## 0.4.0

### Changes

- Updated API versions for Virtual WAN from 2024-03-01 to 2025-04-01
- Updated API versions Resource Group creation in all tests from 2021-04-01 to 2025-04-01
- Removed unnecessary ternary expression from 'allowVnetToVnetTraffic'
- Updated default parameter values to match product group recommendations
- Updated userAssignedIdentities API version from 2018-11-30 to 2024-11-30 in test dependencies

### Breaking Changes

- The default for 'allowBranchToBranchTraffic' has been changed from 'false' to 'true' to align with the Virtual WAN product group's recommendations.
- Removed 'disableVpnEncryption' and 'allowVnetToVnet' parameters, as they are no longer relevant per the Virtual WAN product group's recommendations.

## 0.3.1

### Changes

- Initial version

### Breaking Changes

- None