# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/elastic-pool/CHANGELOG.md).

## 0.2.0

### Changes

- Added the `diagnosticSettings` parameter
- Updated the `tags` type to API version `2025-01-01`
- Updated `avm-common-types` to version `0.7.0`

### Breaking Changes

- The default name of role assignments is now derived from the elastic pool resource ID instead of the server resource ID, avoiding conflicts when assigning the same role to the same principal on multiple elastic pools of a server. Role assignments created with the default name by a previous version are re-created with a new name

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None