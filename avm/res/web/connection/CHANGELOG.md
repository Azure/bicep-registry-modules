# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/connection/CHANGELOG.md).

## 0.4.4

### Changes

- Added `kind` parameter to support V1/V2 connection types for managed identity authentication.
- Added `alternativeParameterValues` parameter for single-authentication (MSI) scenarios.
- Auto-computed `parameterValueType` property set to `Alternative` when `alternativeParameterValues` is provided.

### Breaking Changes

- None

## 0.4.3

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added types to `api`, `customParameterValues`, `nonSecretParameterValues`, `parameterValues` & `testLinks` parameters

### Breaking Changes

- None

## 0.4.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
