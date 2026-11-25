# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/event-grid/topic/CHANGELOG.md).

## 0.10.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.9.3

### Changes

- Publishing child modules: `event-subscription`

### Breaking Changes

- None

## 0.9.2

### Changes

- Added `endpoint` output to expose the Event Grid topic endpoint.
- Updated `private-endpoint` module reference to `0.11.1`.

### Breaking Changes

- None

## 0.9.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.9.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
