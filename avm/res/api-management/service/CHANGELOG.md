# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/CHANGELOG.md).

## 0.14.0

### Changes

- Added support for `PremiumV2` SKU to the service module and updated related VNet injection documentation.
- Added new `serviceDiagnostics` parameter for service-level diagnostics configuration and corresponding `diagnostic` child module deployment.
- Added new `workspaces` parameter for workspace configuration and corresponding `workspace` child module deployment.
- Added following child modules of the `workspace` module:
  - `workspace/api`
  - `workspace/api/diagnostic`
  - `workspace/api/operation`
  - `workspace/api/operation/policy`
  - `workspace/api/policy`
  - `workspace/api-version-set`
  - `workspace/backend`
  - `workspace/diagnostic`
  - `workspace/logger`
  - `workspace/named-value`
  - `workspace/policy`
  - `workspace/product`
  - `workspace/product/api-link`
  - `workspace/product/group-link`
  - `workspace/product/policy`
  - `workspace/subscription`
- Child module **api** (v0.2.0): Added length decorators and updated parameter descriptions; added missing allowed values; added allowed values to `protocols` parameter; aligned `operationType` and `diagnosticType` definitions; fixed `diagnosticType.alwaysLog` type and corrected `diagnosticType.operationNameFormat` allowed value from `URI` to `Url`.
- Child module **api-version-set** (v0.2.0): Changed `name` parameter to required (was optional with default `"default"`); updated `displayName` description.
- Child module **backend** (v0.2.1): Added length validation to `url` parameter.
- Child module **logger** (v0.2.1): Updated parameter descriptions; added length constraint to `description`; made `description` nullable; renamed internal resource symbol and aligned outputs.
- Child module **named-value** (v0.1.2): Added length constraints to `displayName` and `value` parameters; updated parameter descriptions.
- Child module **product** (v0.3.0): Added length constraints to `name`, `displayName`, and `description`; updated descriptions; changed `description` to be nullable; added `@allowed` constraint to `state` parameter.
- Child module **subscription** (v0.1.2): Updated parameter descriptions; added length constraints to `displayName`, `primaryKey`, and `secondaryKey`; added allowed values to `state`; simplified `scope` description; reordered resource properties.

### Breaking Changes

- The `api.diagnostic.operationNameFormat` parameter - allowed value corrected from `URI` to `Url`.
- Removed redundand (and conflicting) `apiDiagnostics` parameter from the service module; use `diagnostics` property within the `apis` parameter instead.

## 0.13.0

### Changes

- All API versions have been updated to the latest supported versions.
- New parameters `circuitBreaker`, `pool`, `type` added to backend child module.
- New child module `product/policy` added.

### Breaking Changes

- Update default values for `url` and `tls` parameters in `backend` child module to align with new `type` parameter.
- Property `credentials` of the `logger` child module is now conditionally required based on the `type` parameter.

## 0.12.0

### Changes

- Added support for `privateEndpoints` parameter
- Added  `privateEndpoints` output

### Breaking Changes

- `publicNetworkAccess` is set to `Disabled` if not specified and `privateEndpoints` are configured

## 0.11.2

### Changes

- Added support for `publicNetworkAccess` parameter

### Breaking Changes

- None

## 0.11.1

### Changes

- Applied the `@secure()` decorator to the `value` parameter within the `namedValue` input object.
- Minor json formatting adjustments

### Breaking Changes

- None

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
