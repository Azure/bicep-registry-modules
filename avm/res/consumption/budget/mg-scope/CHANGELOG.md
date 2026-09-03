# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/consumption/budget/mg-scope/CHANGELOG.md).

## 0.2.0

### Changes

- Added optional `notifications` parameter to allow per-notification control over `operator`, `threshold`, and `thresholdType`, enabling a single budget to mix `Actual` and `Forecasted` notifications. The legacy `thresholds` and `thresholdType` parameters remain supported as a fallback.

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
