# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/event-hub/namespace/eventhub/CHANGELOG.md).

## 0.2.0

### Changes

- Added `identity` support to `captureDescription.destination`  parameter

### Breaking Changes

- Aligned `captureDescription` properties with resource provider format. For example, the parameter `captureDescriptionIntervalInSeconds` was moved to the parameter `captureDescription` as `captureDescription.intervalInSeconds`.

## 0.1.1

### Changes

- Minor updates to parameter descriptions.

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial release
- Updates avm-common-types references to `0.6.1`
- Introduces user defined types `eventHubAuthorizationRuleType`, `consumerGroupType`

### Breaking Changes

- None
