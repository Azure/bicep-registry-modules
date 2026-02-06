# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product/CHANGELOG.md).

## 0.2.1

### Changes

- Added length constraints to the `name`, `displayName` and `description` parameters
- Updated descriptions of various parameters for clarity
- Changed `description` parameter to be nullable with no default value
- Added `@allowed` constraint to the `state` parameter (`'notPublished'` | `'published'`) and made it optional (no default)

### Breaking Changes

- none

## 0.2.0

### Changes

- Added `policies` parameter to allow setting product level policies

### Breaking Changes

- None

## 0.1.1

### Changes

- Minor json formatting adjustments

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- Reduced the `api` & `group` parameter types to `string[]` as its the only value the user can provide
