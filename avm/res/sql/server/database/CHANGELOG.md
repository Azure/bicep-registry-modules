# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/database/CHANGELOG.md).

## 0.3.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.2.3

### Changes

- Enabled child modules `avm/res/sql/server/database/backup-short-term-retention-policy` and `avm/res/sql/server/database/backup-long-term-retention-policy` for publishing

### Breaking Changes

- None

## 0.2.2

### Changes

- Recompiled `main.json` with the latest Bicep version

### Breaking Changes

- None

## 0.2.1

### Changes

- Fixed typo in HSM CMK schema implementation

### Breaking Changes

- None

## 0.2.0

### Changes

- Added support for managed HSM customer-managed key encryption
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
