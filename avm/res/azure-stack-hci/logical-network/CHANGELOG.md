# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/logical-network/CHANGELOG.md).

## 0.3.0

### Changes

- Updated ARM API version from `2024-05-01-preview` to `2024-10-01-preview` for Azure Stack HCI 24H2 support
- Updated telemetry resource API version from `2024-03-01` to `2024-07-01`
- Updated test harness to use cluster module v0.4.0 with inline ACI deployment
- Added pre-baked image support (`hciHostImageReferenceId`) to e2e tests
- Aligned test domain and network configuration with shared HCI test harness (`hci.local` / `172.20.0.x`)
- Fixed typo in role assignment condition comment

### Breaking Changes

- None

## 0.2.0

### Changes

- Support ipPools

### Breaking Changes

- Removed input parameter `startingAddress`
- Removed input parameter `endingAddress`

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
