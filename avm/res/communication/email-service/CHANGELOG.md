# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/communication/email-service/CHANGELOG.md).

## 0.4.0

### Changes

- Upgraded references to `avm-common-types` (including support for lock 'Notes')
- Added types to `domainResourceIds` & `domainNames` outputs

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
