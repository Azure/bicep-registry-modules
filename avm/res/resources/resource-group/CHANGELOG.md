# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/resources/resource-group/CHANGELOG.md).

## 0.4.4

### Changes

- Fixed child module deployment names creation to prevent conflicts when two Resource Groups are deployed in the same subscription at the same time.
- Updated API version for `Microsoft.Resources/deployments` to `2025-04-01` for telemetry deployment resource.

### Breaking Changes

- None

## 0.4.3

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.4.2

### Changes

- Updated type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.4.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
