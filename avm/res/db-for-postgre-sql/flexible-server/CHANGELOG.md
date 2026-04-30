# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/db-for-postgre-sql/flexible-server/CHANGELOG.md).

## 0.15.4

### Changes

- Updated `Microsoft.DBforPostgreSQL/flexibleServers` API version from `2025-06-01-preview` to `2026-01-01-preview` in the parent module and all child modules
- Added storage parameters `storageType`, `storageTier`, `storageIops`, and `storageThroughput` to expose all storage properties available in the API
- Replaced the `@allowed` list constraint on `storageSizeGB` with `@minValue(32)` to support the larger sizes available with `PremiumV2_LRS` and `UltraSSD_LRS` storage types
- Updated `avm/res/network/private-endpoint` module reference from `0.11.1` to `0.12.0`

### Breaking Changes

- None

## 0.15.3

### Changes

- Publishing child module `avm/res/db-for-postgre-sql/flexible-server/administrator`
- Publishing child module `avm/res/db-for-postgre-sql/flexible-server/advanced-threat-protection-setting`
- Publishing child module `avm/res/db-for-postgre-sql/flexible-server/configuration`
- Publishing child module `avm/res/db-for-postgre-sql/flexible-server/database`
- Publishing child module `avm/res/db-for-postgre-sql/flexible-server/firewall-rule`
- Updated `Microsoft.DBforPostgreSQL/flexibleServers` existing resource reference in child modules from API version `2025-06-01-preview` to `2025-08-01` (latest stable GA)

### Breaking Changes

- None

## 0.15.2

### Changes

- Fixed bug when using managed HSM with a custom key version

### Breaking Changes

- None

## 0.15.1

### Changes

- Added support for Postgresql version '18'.

### Breaking Changes

- None

## 0.15.0

### Changes

- Added support for Managed HSM Key Vaults for Encryption.

### Breaking Changes

- None

## 0.14.0

### Changes

- Updated API version to `2025-06-01-preview`
- Added read replica example
- Added authConfigType as a resource defined type to address replica servers deployments. The existing administrators block was being passed
- Added replicationRole parameter
- Added conditional output for the fullyQualifiedDomainName property. In rare instances the deployment of the module would fail if the fullyQualifiedDomainName property was not returned from Azure. There is a long standing support ticket with the Flexible Server product group to address the issue permanently.
- Added support for SystemAssigned identities

### Breaking Changes

- None

## 0.13.2

### Changes

- Changed the type and implementation for customer managed keys to enable the now possible auto-key rotation. Parameter `customerManagedKey`.
- Updated references to 'avm-common-types version' to latest `0.6.1`

### Breaking Changes

- None

## 0.13.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `administrators` & `firewallRules` parameters
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.13.0

### Changes

- Bugfix: Fixed issue where the incorrect database ownership was set during initial deployment of DB for Postgre SQL Flexible Server.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.12.1

### Changes

- Bugfix: Fixed issue where setting `highAvailability` to `Disabled`, the deployment would throw an error due to an incorrect module-internal logic.
- Updated diverse API versions

### Breaking Changes

- None

## 0.12.0

### Changes

- Initial version

### Breaking Changes

- None
