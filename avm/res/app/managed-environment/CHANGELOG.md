# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app/managed-environment/CHANGELOG.md).

## 0.13.3

### Changes

- Publishing child module `avm/res/app/managed-environment/certificate`
- Publishing child module `avm/res/app/managed-environment/storage`

### Breaking Changes

- None

## 0.13.2

### Changes

- Renamed child module folder `certificates` to `certificate` for singular naming consistency

### Breaking Changes

- None

## 0.13.1

### Changes

- Fixed identity condition making it impossible to deploy the module without a user-assigned identity

### Breaking Changes

- None

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
