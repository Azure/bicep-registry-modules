# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/data/private-analytical-workspace/CHANGELOG.md).

## 0.2.0

### Changes

- Updated `Microsoft.KeyVault/vaults` API version from `2023-07-01` to `2026-02-01`.
- Updated `avm/res/operational-insights/workspace` module version to `0.16.1`
- Added support for replicas to optional `avm/res/operational-insights/workspace` deployment
- Upgraded `avm/res/network/virtual-network` deployment to `0.10.2`
- Upgraded `avm/res/databricks/access-connector` deployment to `0.4.3`
- Upgraded `avm/res/databricks/workspace` deployment to `0.12.0`
- Upgraded `avm/res/network/private-dns-zone` deployment to `0.8.1`

### Breaking Changes

- As per the upgrade of the `avm/res/operational-insights/workspace` module, changed the type for `dailyQuotaGb` from int to string to allow for rational number values (e.g. `'0.5'`)

## 0.1.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
