# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/db-for-my-sql/flexible-server/CHANGELOG.md).

## 0.9.0

### Changes

- Added support for MySQL Flexible Server configurations as child resources
- New `configurations` parameter allows setting MySQL server configuration parameters directly through the module
- Created new configuration child resource module at `configuration/main.bicep`
- Added `configurationType` definition with proper typing for configuration parameters

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
