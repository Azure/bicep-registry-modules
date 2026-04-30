# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/mgmt-groups/subscription-placement/CHANGELOG.md).

## 0.3.1

### Changes

- Fixed inverted condition on `customSubscriptionPlacement` so subscriptions are placed by default and only skipped when `disableSubscriptionPlacement` is explicitly set to `true` ([#6900](https://github.com/Azure/bicep-registry-modules/issues/6900)).

### Breaking Changes

- None

## 0.3.0

### Changes

- Updated `customSubscriptionPlacement` resource to use `tenant()` scope.

### Breaking Changes

- None

## 0.2.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
