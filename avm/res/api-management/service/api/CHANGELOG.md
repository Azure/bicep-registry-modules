# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/api/CHANGELOG.md).

## 0.2.1

### Changes

- Recompiled the template with latest Bicep version `0.40.2.10011`
- Updated API version of Microsoft.Resources/deployments reference to `2025-04-01`

### Breaking Changes

- None

## 0.2.0

### Changes

- Added length decorators to multiple parameters
- Updated descriptions of various parameters for clarity
- Added missing allowed values to `format` parameter and `type` parameter
- Added allowed values to `protocols` parameter
- Updated module deployment names for consistency
- Aligned `operationType` definition with the `operation` child module specification
- Aligned `diagnosticType` definition with the `diagnostic` child module specification
- Changed `diagnosticType.alwaysLog` type to specific union `('allErrors')?`
- Fixed `diagnosticType.operationNameFormat` allowed value from `URI` to `Url`, matching API specification

### Breaking Changes

- The `diagnosticType.operationNameFormat` allowed value has been corrected from `URI` to `Url`

## 0.1.1

### Changes

- Minor json formatting adjustments

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
