# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/backend/CHANGELOG.md).

## 0.2.1

### Changes

- Added length validation to `url` parameter: `@minLength(1)` and `@maxLength(2000)`

### Breaking Changes

- None

## 0.2.0

### Changes

- Add new parameters: `circuitBreaker`, `pool`, `type`

### Breaking Changes

- Update default values for `url` and `tls` parameters

## 0.1.1

### Changes

- Minor json formatting adjustments

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Added types for `credentials`, `proxy`, `serviceFabricCluster` & `tls` parameters

### Breaking Changes

- None
