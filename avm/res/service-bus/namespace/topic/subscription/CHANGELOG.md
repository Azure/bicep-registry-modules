# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/service-bus/namespace/topic/subscription/CHANGELOG.md).

## 0.2.0

### Changes

- `duplicateDetectionHistoryTimeWindow` is now optional and not sent by default. The service does not persist this property on subscriptions, so sending it caused `what-if` to report a change on every run.

### Breaking Changes

- ``duplicateDetectionHistoryTimeWindow`` no longer defaults to ``PT10M``.

## 0.1.0

### Changes

- Initial release

### Breaking Changes

- None
