# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/maintenance/maintenance-configuration/CHANGELOG.md).

## 0.4.0

### Changes

- Replaced custom type for parameter `maintenanceScope` with resource-derived type to enable all available values (e.g., 'Resource')
- Updated LockType to 'avm-common-types version' `0.7.0`, enabling custom notes for locks.

### Breaking Changes

- Changed type of parameter `visibility` to resource-derived type and changed the default from `''` to nullable.

## 0.3.2

### Changes

- Added type to parameters `extensionProperties`, `tags`, `maintenanceWindow` & `installPatches`
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.3.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
