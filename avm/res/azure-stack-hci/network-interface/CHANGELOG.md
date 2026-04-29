# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/network-interface/CHANGELOG.md).

## 0.2.0

### Changes

- Updated resource API version from `2024-01-01` to `2025-04-01-preview` for 24H2 compatibility.
- Updated telemetry resource API version from `2023-07-01` to `2024-07-01`.
- Added optional `macAddress` parameter.
- Added optional `networkSecurityGroupResourceId` parameter.
- Updated test harness to use cluster module `0.4.0` with inline ACI deployment for faster, more reliable e2e tests.
- Added `hciHostImageReferenceId` parameter support in e2e tests for pre-baked image CI acceleration.

### Breaking Changes

- None

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
