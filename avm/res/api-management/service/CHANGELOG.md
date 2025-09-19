# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/CHANGELOG.md).

## 0.11.0

### Changes

- Introduced [`avm/res/api-management/service/api`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/api) as child module
- Introduced [`avm/res/api-management/service/api/diagnostics`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/api/diagnostics) as child module
- Introduced [`avm/res/api-management/service/api/policy`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/api/policy) as child module
- Introduced [`avm/res/api-management/service/api-version-set`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/api-version-set) as child module
- Introduced [`avm/res/api-management/service/authorization-server`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/authorization-server) as child module
- Introduced [`avm/res/api-management/service/backend`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/backend) as child module
- Introduced [`avm/res/api-management/service/cache`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/cache) as child module
- Introduced [`avm/res/api-management/service/identity-provider`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/identity-provider) as child module
- Introduced [`avm/res/api-management/service/logger`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/logger) as child module
- Introduced [`avm/res/api-management/service/named-value`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/named-value) as child module
- Introduced [`avm/res/api-management/service/policy`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/policy) as child module
- Introduced [`avm/res/api-management/service/portalsetting`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/portalsetting) as child module
- Introduced [`avm/res/api-management/service/product`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product) as child module
- Introduced [`avm/res/api-management/service/product/api`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product/api) as child module
- Introduced [`avm/res/api-management/service/product/group`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product/group) as child module
- Introduced [`avm/res/api-management/service/subscription`](/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/subscription) as child module
- Added types for parameters
  - `backends`
  - `caches`
  - `apiDiagnostics`
  - `identityProviders`
  - `loggers`
  - `namedValues`
  - `policies`
  - `portalsettings`
  - `products`
  - `subscriptions`
  - `certificates`
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.


### Breaking Changes

- Reduced type of `products/apis` & `products/products` from array of objects to array of string as only the name can be configured
- Diverse bugfixes like renaming the parameters `identityProvider/signinTenant` to `signInTenant`,`logger/resourceId` to `targetResourceId` & `logger/loggerType` to `type` being named incorrectly and hence not being passed through

## 0.9.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
