# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product/CHANGELOG.md).

## 0.2.3

### Changes

- Set default value for `subscriptionRequired` parameter to `true`

## 0.2.2

### Changes

- Recompiled the template with latest Bicep version `0.40.2.10011`
- Updated the policy name parameter to handle optional values correctly by using the safe navigation operator
- Updated API version of Microsoft.Resources/deployments reference to `2025-04-01`

### Breaking Changes

- None

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
