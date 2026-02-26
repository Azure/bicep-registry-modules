# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cdn/profile/CHANGELOG.md).

## 0.17.2

### Changes

- Fixed `identity` variable to check `formattedUserAssignedIdentities` instead of `formattedRoleAssignments` when determining identity type. This bug was introduced in v0.17.0 and led to unintended logical behavior. (#6538)

### Breaking Changes

- None

## 0.17.1

### Changes

- Updated test files to use generic dummy hostname for URL redirect action parameters.

### Breaking Changes

- None

## 0.17.0

### Changes

- Added a dependency on the profile_originGroups module for ruleSets to ensure proper deployment order.

### Breaking Changes

- None


## 0.16.1

### Changes

- Fixed bug when using `secrets` that treats the `secretVersion` as a mandatory property even though it is not.

### Breaking Changes

- None

## 0.16.0

### Changes

- Added type parameters
  - `endpoint`
  - `secrets`
- Added type for `afdEndpoints` parameters
  - `cacheConfiguration`
  - `patternsToMatch`
  - `supportedProtocols`
  - `ruleSets`
- Added type for `customDomains` parameters
  - `extendedProperties`
  - `customizedCipherSuiteSet`
- Added type for `endpoints` parameters
  - `properties`
  - `tags`
- Added type for `originGroups.origins.sharedPrivateLinkResource` parameters
- Added type for `originGroups` parameters
  - `healthProbeSettings`
  - `loadBalancingSettings`
  - `origins`
- Added type for `rulesets.rules` parameters
  - `actions`
  - `conditions`
- Updated references of `avm-common-types` to latest `0.6.1`
- Added export for types
  - `originGroupType`
  - `ruleSetType`
  - `afdEndpointType`
  - `customDomainType`
  - `endpointType`
  - `secretType`

### Breaking Changes

- Renamed parameter `endpointProperties` to `endpoint`
- Changed type for outputs `endpointName`, `endpointId` & `uri` from `''` to `null`
- Changed type of `secret.subjectAlternativeNames` from `array` to `string[]` as per the resource provider interface
- Changed type of `afdEndpoints.routes.ruleSets` from `{ name: string }[]` to simply `string[]`
- Changed behavior of `originGroups.origins.originHostHeader` property so that
  - If you specify a value other than `''`, the value is used
  - If you specify `''`as the value, the service calculates a `originHostHeader` for you
  - If you don't specify anything, or `null`, the origin's `hostName` is used instead

## 0.15.1

### Changes

- Added type for `tags` parameter

### Breaking Changes

- None

## 0.15.0

### Changes

- Added TLS13 as allowed minimumTlsVersion parameter for the customDomain resource
- Updated Microsoft.Cdn/profiles API version to 2025-06-01
- Removed "Standard_Microsoft" SKU from tests since this SKU can no longer be newly deployed as of Aug 15th, 2025. However, we keep the SKU as allowed parameter for users who already have it deployed and want to manage it with AVM. Ref: https://azure.microsoft.com/en-us/updates/?id=498522
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.14.0

### Changes

- APIs upgraded to latest versions
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.13.0

### Changes

- Initial version

### Breaking Changes

- None
