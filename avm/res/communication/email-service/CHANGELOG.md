# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/communication/email-service/CHANGELOG.md).

## 0.4.1

### Changes

- Added output for `domainVerificationRecords`
- Added output type for `verificationRecords` from the domains child module
- Updated `Microsoft.Communication/emailServices` API version from `2023-04-01` to `2025-05-01`
- Updated `Microsoft.Communication/emailServices/domains` API version from `2023-04-01` to `2025-05-01`
- Updated `Microsoft.Communication/emailServices/domains/senderUsernaems` API version from `2023-04-01` to `2025-05-01`


### Breaking Changes

- None

## 0.4.0

### Changes

- Upgraded references to `avm-common-types` (including support for lock 'Notes')
- Added types to `domainResourceIds` & `domainNames` outputs
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Added type for parameter `domains` in `email-service` module
- Added type for parameter `senderUsernames` in `email-service/domain` module
- Added types for tags
- Fixed typo of `domainNames` output (former `domainNamess`)

## 0.3.3

### Changes

- Initial version

### Breaking Changes

- None
