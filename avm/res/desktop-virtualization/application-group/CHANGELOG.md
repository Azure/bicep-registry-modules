# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/desktop-virtualization/application-group/CHANGELOG.md).

## 0.4.0

### Changes

- Added support for the `application` module parameters
  - `applicationType`
  - `msixPackageApplicationId`
  - `msixPackageFamilyName`
- Added support for the `application-group` module parameter
  - `showInFeed`
- Updated API version of
  - `Microsoft.DesktopVirtualization/applicationGroups` from `2023-09-05` to `2024-04-03`
  - `Microsoft.DesktopVirtualization/applicationGroups/applications` from `2023-09-05` to `2024-04-03`
- Added exported User-defined type for the `applications` parameter

### Breaking Changes

- Added a type for the `tags` parameter

## 0.3.3

### Changes

- Initial version

### Breaking Changes

- None
