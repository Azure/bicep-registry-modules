# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/hybrid-container-service/provisioned-cluster-instance/CHANGELOG.md).

## 0.3.0

### Changes

- Updated `Microsoft.KeyVault/vaults` and `Microsoft.KeyVault/vaults/secrets` API versions from `2023-07-01` to `2026-02-01`.
- Updated API version from `2024-01-01` to `2026-04-01-preview`
- Added `securityProfile` parameter (FIPS image, custom CA trust certificates)
- Added `gpuCountPerNode` to agent pool profiles
- Added `authorizedIPRanges` to cluster VM access profile

### Breaking Changes

- None (all new properties are optional/additive)

## 0.2.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
