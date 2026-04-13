# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/authorization-server/CHANGELOG.md).

## 0.1.3

### Changes

- Recompiled the template with latest Bicep version `0.40.2.10011`
- Updated API version of Microsoft.Resources/deployments reference to `2025-04-01`

### Breaking Changes

- None

## 0.1.2

### Changes

- Added support for `authorizationCodeWithPkce` grant type
- Updated descriptions of `authorizationMethods` and `tokenBodyParameters` parameters

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
- Added types for `authorizationMethods`, `bearerTokenSendingMethods` & `clientAuthenticationMethod` parameters

### Breaking Changes

- Removed user-defined type `tokenBodyParameterType` in favor of resource-derived type
