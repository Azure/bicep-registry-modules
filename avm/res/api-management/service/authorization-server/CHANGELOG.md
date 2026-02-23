# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/authorization-server/CHANGELOG.md).

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
