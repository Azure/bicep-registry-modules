# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/marketplace-gallery-image/CHANGELOG.md).

## 0.2.0

### Changes

- Updated telemetry resource API version from `2024-03-01` to `2024-07-01`.
- Updated test harness to use cluster module `0.4.0` with inline ACI deployment for faster, more reliable e2e tests.
- Aligned test domain/network configuration with shared HCI test harness (`hci.local` / `172.20.0.x`).
- Added `hciHostImageReferenceId` parameter support in e2e tests for pre-baked image CI acceleration.
- Fixed typo in role assignment condition comment.

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
