# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/elastic-san/elastic-san/CHANGELOG.md).

## 0.4.0

### Changes

- None

### Breaking Changes

- Changed implementation of `availabilityZone` parameter from an optional `nullable` to mandatory to force users to make a conscious decision. To opt out of setting an Availability Zone you can specify the value `-1`.
- Added support for `enforceDataIntegrityCheckForIscsi` parameter to volume group as per its latest API version `2024-05-01`

## 0.3.1

### Changes

- Initial version

### Breaking Changes

- None
