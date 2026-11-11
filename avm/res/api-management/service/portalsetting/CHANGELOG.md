# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/portalsetting/CHANGELOG.md).

## 0.2.0

### Changes

- Added an open `portalSettingPropertiesType` to secure only the delegation validation key. Other properties remain unconstrained and are forwarded unchanged, as with the previous native `object` contract.

### Breaking Changes

- `properties.validationKey`, when provided, must now be a string or `null`. The previous native `object` contract did not validate this field. Callers relying on another value type must pass the base64-encoded key as a string.

## 0.1.2

### Changes

- Recompiled the template with latest Bicep version `0.40.2.10011`
- Updated API version of Microsoft.Resources/deployments reference to `2025-04-01`

### Breaking Changes

- None

## 0.1.1

### Changes

- Minor json formatting adjustments

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Added type to `properties` parameter. Note: The properties are dependent on the value of the `name` parameter.

### Breaking Changes

- None
