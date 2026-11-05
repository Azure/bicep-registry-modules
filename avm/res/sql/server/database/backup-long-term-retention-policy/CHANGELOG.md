# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/database/backup-long-term-retention-policy/CHANGELOG.md).

## 0.2.0

### Changes

- None

### Breaking Changes

- The `timeBasedImmutabilityMode` now defaults to `Unlocked` (instead of `Locked`) if time-based immutability is enabled, as a `Locked` immutability cannot be reverted

## 0.1.1

### Changes

- Added support for time-based immutability settings

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None