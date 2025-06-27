# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/service-bus/namespace/CHANGELOG.md).

## 0.15.0

### Changes

- Added secure outputs for the module's main resource's secrets (e.g., connection strings)
- Small template improvements (e.g., removing redundant fallback values)

### Breaking Changes

- Changed `publicNetworkAccess` default value to `nullable` and removed `''` from allowed value set. The behavior of the the null value matches the previous empty string.
- Added a type for tags

## 0.14.1

### Changes

- Initial version

### Breaking Changes

- None
