# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/storage/storage-account/CHANGELOG.md).

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
