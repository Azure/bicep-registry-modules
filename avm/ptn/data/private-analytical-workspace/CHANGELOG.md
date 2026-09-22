# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/data/private-analytical-workspace/CHANGELOG.md).

## 0.2.0

### Changes

- Updated `Microsoft.KeyVault/vaults` API version from `2023-07-01` to `2026-02-01`.
- Updated `avm/res/operational-insights/workspace` module version to `0.16.1`
- Added support for replicas to optional `avm/res/operational-insights/workspace` deployment

### Breaking Changes

- As per the upgrade of the `avm/res/operational-insights/workspace` module, changed the type for `dailyQuotaGb` from int to string to allow for rational number values (e.g. `'0.5'`)

## 0.1.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
