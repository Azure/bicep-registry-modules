# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app/session-pool/CHANGELOG.md).

## 0.3.0

### Changes

- Updated resource API version from `2024-10-02-preview` to `2025-07-01`
- Added support for the parameter `secrets`
- Updated all references of the `avm-common-types` module to the latest version `0.6.1`

### Breaking Changes

- Removed all exported types in favor of imported types (resource-derived types)
- Replaced parameters `cooldownPeriodInSeconds`, `registryCredentials`, `targetIngressPort`, `containers` in favor of the combined parameter `customContainerTemplate`
- Replaced parameter `cooldownPeriodInSeconds` with combined parameter `dynamicPoolConfiguration.lifecycleConfiguration`
- Replaced parameter `sessionNetworkStatus` in favor of the combined parameter `sessionNetworkConfiguration`
- Replaced parameters `maxConcurrentSessions` & `readySessionInstances` in favor of the combined parameter `scaleConfiguration`
- Changed type of `systemAssignedMIPrincipalId` output from empty string to an more accurate `null`

## 0.2.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for tags parameter

### Breaking Changes

- Added name of `environmentId` parameter to `environmentResourceId`

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
