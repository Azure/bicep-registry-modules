# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app/container-app/CHANGELOG.md).

## 0.22.1

### Changes

- Publishing child module `avm/res/app/container-app/auth-config`.

### Breaking Changes

- None

## 0.22.0

### New Features

- Added `traffic` array parameter to support traffic splitting across multiple revisions, enabling blue-green and canary deployment patterns. Closes [#6713](https://github.com/Azure/bicep-registry-modules/issues/6713).

### Changes

- Updated `Microsoft.App/containerApps` and `Microsoft.App/containerApps/authConfigs` API versions from `2025-10-02-preview` to `2026-01-01`.
- Updated `Microsoft.App/managedEnvironments` API version from `2025-10-02-preview` to `2026-01-01` in all test dependency files.

### Breaking Changes

- **Removed** individual traffic scalar parameters (`trafficLabel`, `trafficLatestRevision`, `trafficRevisionName`, `trafficWeight`) in favor of the new `traffic` array parameter using the resource-derived type. Callers must migrate to the new `traffic` parameter.
- **Removed** `targetPortHttpScheme` parameter as the property was removed in API version `2026-01-01`.

## 0.21.0

### Changes

- Updated API versions to v2025-10-02-preview for enhanced features and capabilities.

### Breaking Changes

- None

## 0.20.0

### Changes

- Update API versions to v2025-10-02-preview for enhanced features and capabilities.
- Updated `avm-common-types` references to latest `0.6.1`

### Breaking Changes

- None

## 0.19.0

### Changes

- Added `kind` parameter to support different types of container apps (e.g., 'workflowapp', 'functionapp').
- Updated API versions to v2025-02-02-preview for additional features.

### Breaking Changes

- None

## 0.18.2

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.18.0

### Changes

- Added support for diagnostic settings with Event Hub, Storage Account, and Log Analytics Workspace.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.17.0

### Changes

- Initial version

### Breaking Changes

- None
