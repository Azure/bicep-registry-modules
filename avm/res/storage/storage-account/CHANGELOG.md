# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/storage/storage-account/CHANGELOG.md).

## 0.26.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.26.1

### Changes

- Added metadata to exported types

### Breaking Changes

- None

## 0.26.0

### Changes

- Addressed diverse warnings
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed the type for the `diagnosticSettings` parameter to only support metrics. This matches the implementation of the resource provider.

## 0.25.1

### Changes

- Enabling child module `avm/res/storage/storage-account/file-service/share` for publishing (added telemetry option)

### Breaking Changes

- None

## 0.25.0

### Changes

- None

### Breaking Changes

- Update the `immutabilityPolicy` module name to avoid deployment name conflicts

## 0.24.0

### Changes

- None

### Breaking Changes

- Changed the default value for `enableHierarchicalNamespace` to `null` and changed its type from `bool` to nullable `bool`: `bool?`
  - **Only** if a non-null value is passed to the resource provider, allowing users to completely omitting the parameter

## 0.23.0

### Changes

- Added additional SKU's to support v2 Filestorage

### Breaking Changes

- None

## 0.22.1

### Changes

- Corrected spelling of 'secondaryAccessKey' output

### Breaking Changes

- output name changed from 'secondayAccessKey' to 'secondaryAccessKey'
