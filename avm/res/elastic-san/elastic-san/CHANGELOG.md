# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/elastic-san/elastic-san/CHANGELOG.md).

## 0.5.0

### Changes

- Upgraded resource API versions and module references to align with the latest standards:
  - `Microsoft.Resources/deployments` → **2025-04-01**
  - `Microsoft.ElasticSan/elasticSans` → **2024-05-01**
  - `Microsoft.ElasticSan/elasticSans/volumegroups` → **2024-05-01**
  - `Microsoft.ElasticSan/elasticSans/volumegroups/volumes` → **2024-05-01**
  - `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` → **2024-05-01**
  - `Microsoft.KeyVault/vaults` → **2025-05-01**
- Updated Bicep Registry module references:
  - `br/public:avm/utl/types/avm-common-types` → **0.6.1**
  - `br/public:avm/res/network/private-endpoint` → **0.11.1**
- Updated tags parameters in main module and volume group submodule to use the latest resource input types.

### Breaking Changes

- None

## 0.4.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.
- Updated parameter `volume-group`'s `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.4.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed implementation of `availabilityZone` parameter from an optional `nullable` to mandatory to force users to make a conscious decision. To opt out of setting an Availability Zone you can specify the value `-1`.
- Added support for `enforceDataIntegrityCheckForIscsi` parameter to volume group as per its latest API version `2024-05-01`

## 0.3.1

### Changes

- Initial version

### Breaking Changes

- None
