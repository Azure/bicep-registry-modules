# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-generation/CHANGELOG.md).

## 0.2.0

### Changes

- Fixed resource group tags implementation to use the spread operator (`...resourceGroup().tags`) directly in the tags object, replacing the `existing` resource reference pattern that caused `InvalidTemplate` errors on certain ARM backend versions

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
