# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/CHANGELOG.md).

## 0.22.0

### Changes

- For child-module `database`, updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

### Breaking Changes

- None

## 0.21.4

### Changes

- Enabled child modules `avm/res/sql/server/auditing-setting`, `avm/res/sql/server/elastic-pool`, `avm/res/sql/server/encryption-protector`, `avm/res/sql/server/failover-group`, `avm/res/sql/server/firewall-rule`, `avm/res/sql/server/key`, `avm/res/sql/server/security-alert-policy`, `avm/res/sql/server/virtual-network-rule`, `avm/res/sql/server/vulnerability-assessment`, `avm/res/sql/server/database/backup-short-term-retention-policy`, and `avm/res/sql/server/database/backup-long-term-retention-policy` for publishing

### Breaking Changes

- None

## 0.21.3

### Changes

- Fixed server-level customer-managed key autorotation when using a versionless Key Vault key URI
- Added regression coverage for CMK autorotation without an explicit server key version

### Breaking Changes

- None

## 0.21.2

### Changes

- Added suppoort for SQL Server outbound firewall rules

### Breaking Changes

- None

## 0.21.1

### Changes

- Fixed typo in HSM CMK schema implementation

### Breaking Changes

- None

## 0.21.0

### Changes

- Added support for managed HSM customer-managed key encryption for both server and database
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

## 0.20.3

### Changes

- Enabling child module `avm/res/sql/server/database` for publishing (added telemetry option)

### Breaking Changes

- None

## 0.20.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.20.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.20.0

### Changes

- `tags` parameters are now properly typed instead of using `object` type.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `partnerServers` array to `partnerServerResourceIds` in the failover group module to make it possible to use SQL servers from different resource groups.

## 0.19.1

### Changes

- Initial version

### Breaking Changes

- None
