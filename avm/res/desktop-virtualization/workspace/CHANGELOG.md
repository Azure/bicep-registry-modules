# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/desktop-virtualization/workspace/CHANGELOG.md).

## 0.9.2

### Changes

- Updated all `avm-common-types` imports to `0.7.0` (aligning previously inconsistent `0.6.0`/`0.6.1` references)
- Updated referenced `avm/res/network/private-endpoint` module to `0.12.1`
- Updated API version of workspace resource to stable `2025-10-10`
- Updated API version of the telemetry deployment resource to `2025-04-01`
- Fixed copy/paste leftover in the private endpoint child deployment name (`keyVault-PrivateEndpoint` -> `workspace-PrivateEndpoint`)

### Breaking Changes

- None

## 0.9.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated to latest avm-common-types, enabling custom notes on locks
- Updated API version of workspace resource to `2025-03-01-preview`
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed behavior of `publicNetworkAccess` to automatically set `Disabled` if private endpoints are provided - unless the `publicNetworkAccess` value is set explicitly

## 0.8.0

### Changes

- Initial version

### Breaking Changes

- None
