# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/db-for-my-sql/flexible-server/CHANGELOG.md).

## 0.10.1

### Changes

- Updated `version` parameter to support MySQL versions 8.4 and 9.3 (preview)
- Fixed minor typos.

### Breaking Changes

- None

## 0.10.0

### Changes

- Added support for managed HSM customer-managed key encryption
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`
- Updated the API versions for all referenced resource types

### Breaking Changes

- None

## 0.9.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.9.0

### Changes

- Added support for MySQL Flexible Server configurations as child resources
- New `configurations` parameter allows setting MySQL server configuration parameters directly through the module
- Created new configuration child resource module at `configuration/main.bicep`
- Added `configurationType` definition with proper typing for configuration parameters
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.8.1

### Changes

- Bugfix: Fixed issue where setting `highAvailability` to `Disabled`, the deployment would throw an error due to an incorrect module-internal logic.
- Updated diverse API versions

### Breaking Changes

- None

## 0.8.0

### Changes

- Initial version

### Breaking Changes

- None
