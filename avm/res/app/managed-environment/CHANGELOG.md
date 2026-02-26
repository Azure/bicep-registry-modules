# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app/managed-environment/CHANGELOG.md).

## 0.13.0

### Changes

- Added support for parameters
  - `daprConfiguration`
  - `ingressConfiguration`
  - `kedaConfiguration`
  - `peerAuthentication`
- Added type for parameter `tags`

### Breaking Changes

- None

## 0.12.0

### Changes

- Added types for parameters `openTelemetryConfiguration` & `workloadProfiles`

### Breaking Changes

- Changed `appConfiguration` type to expect `logAnalyticsWorkspaceResourceId` for the `destination` 'log-analytics' instead of the explicit log analytics configuration (including e.g., the shared key). The module now pulls this information in dynamically.

## 0.11.3

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for tags parameter

### Breaking Changes

- None

## 0.11.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
