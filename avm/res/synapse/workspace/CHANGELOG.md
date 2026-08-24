# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/synapse/workspace/CHANGELOG.md).

## 0.15.0

### Changes

- For child-module `sql-pool`, updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

### Breaking Changes

- None

## 0.14.4

### Changes

- Publishing child module `avm/res/synapse/workspace/administrator`
- Publishing child module `avm/res/synapse/workspace/big-data-pool`
- Publishing child module `avm/res/synapse/workspace/firewall-rule`
- Publishing child module `avm/res/synapse/workspace/integration-runtime`
- Publishing child module `avm/res/synapse/workspace/key`
- Publishing child module `avm/res/synapse/workspace/sql-pool`

### Breaking Changes

- None

## 0.14.3

### Changes

- Added support for `libraryRequirements` and `customLibraries` when creating Big Data Pools
- Updated API versions

### Breaking Changes

- None

## 0.14.2

### Changes

- Updated API versions

### Breaking Changes

- None

## 0.14.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.14.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter

### Breaking Changes

- Renamed `purviewResourceID` to `purviewResourceId`

## 0.13.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
