# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/container-instance/container-group/CHANGELOG.md).

## 0.7.0

### Changes

- Fixed `iPv4Address` to be nullable
- Added support for
  - `confidentialComputeProperties`
  - `containerGroupProfile`
  - `extensions`
  - `identityAcls`
  - `standbyPoolProfile`
  - `containers.properties.configMap`

### Breaking Changes

- None

## 0.6.1

### Changes

- Updated ReadMe with AzAdvertizer reference
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Replaced custom type of `dnsConfig` parameter with resource-derived type

### Breaking Changes

- None

## 0.6.0

### Changes

- Initial version

### Breaking Changes

- None
