# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/event-hub/namespace/CHANGELOG.md).

## 0.14.1

### Changes

- Enhanced `maximumThroughputUnits` parameter type to use resource schema type reference

### Breaking Changes

- None

## 0.14.0

### Changes

- Added managed HSM Customer-Managed-Key encryption support
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

## 0.13.0

### Changes

- Added type for `eventhubs` & `networkRuleSets` parameters
- Added `identity` support to `eventhubs.captureDescription.destination` parameter

### Breaking Changes

- Aligned `eventhubs.captureDescription` properties with resource provider format. For example, the `eventhubs` parameter `captureDescriptionIntervalInSeconds` was moved to the parameter `captureDescription` as `captureDescription.intervalInSeconds`.
- Adjusted `identity` parameter type to support only a single user-assigned identity (`userAssignedResourceId`) instead of a list, as per the resource provider's API

## 0.12.5

### Changes

- Minor updates to child module eventhub parameter descriptions

### Breaking Changes

- None

## 0.12.4

### Changes

- Introduced [`eventhub`](/Azure/bicep-registry-modules/blob/main/avm/res/event-hub/namespace/eventhub) as child module
- Unify `avm-common-type` version to 0.6.1

### Breaking Changes

- None

## 0.12.3

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.12.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.12.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
