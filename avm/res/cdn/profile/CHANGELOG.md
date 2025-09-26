# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cdn/profile/CHANGELOG.md).

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
