# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/data-protection/backup-vault/CHANGELOG.md).

## 0.13.3

### Changes

- Added the customer-managed key's user-assigned identity to the resource's managed identities.
- Updated the Key Vault API version used for customer-managed key references.

### Breaking Changes

- None

## 0.13.2

### Changes

- Added optional `dataSourceSetInfo` to `backupInstanceType` to support data source types that require a DatasourceSet (e.g., AKS).

### Breaking Changes

- None

## 0.13.1

### Changes

- Publishing child module `avm/res/data-protection/backup-vault/backup-instance`
- Publishing child module `avm/res/data-protection/backup-vault/backup-policy`

### Breaking Changes

- None

## 0.13.0

### Changes

- Added managed HSM customer-managed key support
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.12.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.12.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
