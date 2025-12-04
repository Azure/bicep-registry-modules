# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/service-bus/namespace/CHANGELOG.md).

## 0.16.1

### Changes

- Added publishing criteria to child modules for `Topic` and `Queue`.

### Breaking Changes

- None

## 0.16.0

### Changes

- Added managed HSM customer-managed key support
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.15.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.15.0

### Changes

- Added secure outputs for the module's main resource's secrets (e.g., connection strings)
- Small template improvements (e.g., removing redundant fallback values)
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed `publicNetworkAccess` default value to `nullable` and removed `''` from allowed value set. The behavior of the the null value matches the previous empty string.
- Added a type for tags

## 0.14.1

### Changes

- Initial version

### Breaking Changes

- None
