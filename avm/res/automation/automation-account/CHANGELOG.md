# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/automation/automation-account/CHANGELOG.md).

## 0.17.1

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.17.0

### Changes

- Added support for the `sourceControlConfigurations` parameter and a type for the same

### Breaking Changes

- None

## 0.16.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.16.0

### Changes

- Adding capability to support `webhook` deployment.

### Breaking Changes

- None

## 0.15.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for tags

### Breaking Changes

- None

## 0.15.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Removed the softwareUpdateConfigurations parameter

## 0.14.1

### Changes

- Initial version

### Breaking Changes

- None

