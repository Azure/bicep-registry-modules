# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/desktop-virtualization/host-pool/CHANGELOG.md).

## 0.8.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.8.0

### Changes

- Added parameters
  - `managedPrivateUDP`
  - `directUDP`
  - `publicUDP`
  - `relayUDP`
  - `managementType`

  with default values
- Updated resource to API version `2025-03-01-preview`
- Added several types
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed 'ring' parameter to a nullable `int` to remove the original workaround using a value of `-1` to achieve the same.

## 0.7.0

### Changes

- Added secure `registrationToken` output
- Update avm-common-types API versions (including added 'Notes' support for locks)
- Added tags type

### Breaking Changes

- Fixed bug of `vmTemplate` that was seemingly not applied due to incorrect condition

## 0.6.0

### Changes

- Initial version

### Breaking Changes

- None
