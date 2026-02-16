# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/db-for-postgre-sql/flexible-server/CHANGELOG.md).

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
