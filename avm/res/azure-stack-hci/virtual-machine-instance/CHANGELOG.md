# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/virtual-machine-instance/CHANGELOG.md).

## 0.2.0

### Changes

- Updated API version for the referenced `Microsoft.HybridCompute/machines` from `2023-10-03-preview` to `2026-07-15`.
- Updated the referenced `avm/res/hybrid-compute/machine` module from `0.4.1` to `0.6.0`, which creates the Arc machine with API version `2026-07-15` instead of `2024-07-10`.
- Updated the AVM telemetry deployment to API version `2025-04-01`.

### Breaking Changes

- None

## 0.1.2

### Changes

- Added @secure() decorator to osProfile parameter to prevent adminPassword exposure in ARM deployment history
- Updated module metadata description for consistency

### Breaking Changes

- None

## 0.1.1

### Changes

- Added support for `adminPassword`, `httpProxy` & `httpsProxy` parameters

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
