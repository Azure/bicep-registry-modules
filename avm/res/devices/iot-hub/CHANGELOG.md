# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/devices/iot-hub/CHANGELOG.md).

## 0.4.0

### Changes

- Serialized private endpoint deployments to prevent concurrent IoT Hub updates from failing with ETag conflicts.
- Updated the consumer group child module's existing IoT Hub reference from `2025-08-01-preview` to the stable `2023-06-30` API version.
- Updated test dependency resources to their latest stable API versions.

### Breaking Changes

- None

## 0.3.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.2.0

### Changes

- Added support for deploying `Microsoft.Devices/IotHubs/eventHubEndpoints/ConsumerGroups` using `consumerGroups` parameter

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
