# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/dev-test-lab/lab/CHANGELOG.md).

## 0.6.0

### Changes

- None

### Breaking Changes

- Deprecated `avm/res/dev-test-lab/lab/secret` as no longer supported by Resource Provider (https://learn.microsoft.com/en-us/azure/templates/microsoft.devtestlab)

## 0.5.1

### Changes

- Publishing child module `avm/res/dev-test-lab/lab/artifactsource`
- Publishing child module `avm/res/dev-test-lab/lab/cost`
- Publishing child module `avm/res/dev-test-lab/lab/notificationchannel`
- Publishing child module `avm/res/dev-test-lab/lab/policyset/policy`
- Publishing child module `avm/res/dev-test-lab/lab/schedule`
- Publishing child module `avm/res/dev-test-lab/lab/secret`
- Publishing child module `avm/res/dev-test-lab/lab/virtualnetwork`

### Breaking Changes

- None

## 0.5.0

### Changes

- Added support for configuring storage account access method (User Assigned Managed Identity or Shared Key) for DevTest Labs. This uses the `storageAccountAccess` parameter.

### Breaking Changes

- None

## 0.4.3

### Changes

- Added support for Lab Secrets in DevTest Labs.
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.4.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
