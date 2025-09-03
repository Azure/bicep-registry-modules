# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/application-gateway/CHANGELOG.md).

## 0.7.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.7.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed parameter `zones` to `availabilityZones`
- Added `availabilityZones` allowed set, enforcing users to provide zones as integer values

## 0.6.0

### Changes

- Initial version

### Breaking Changes

- None
