# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/logger/CHANGELOG.md).

## 0.2.2

### Changes

- Recompiled the template with latest Bicep version `0.40.2.10011`
- Updated API version of Microsoft.Resources/deployments reference to `2025-04-01`

### Breaking Changes

- None

## 0.2.1

### Changes

- Udpated parameter descriptions: `name` and `description`.
- Added length constraint to the `description` parameter, following API specification.
- Made `description` parameter nullable.
- Renamed internal resource symbol from `loggers` to `logger` and aligned outputs.

### Breaking Changes

- None

## 0.2.0

### Changes

- Property `credentials` is conditionally omitted when `type` of logger is `azureMonitor`.

### Breaking Changes

- Property `credentials` is now conditional.

## 0.1.1

### Changes

- Minor json formatting adjustments

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Added type for `credentials` parameter

### Breaking Changes

- None
