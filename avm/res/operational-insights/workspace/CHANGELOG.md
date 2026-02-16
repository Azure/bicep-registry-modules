# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/operational-insights/workspace/CHANGELOG.md).

## 0.15.0

### Changes

- Update to the newest API versions.

### Breaking Changes

- Parameter `dailyQuotaGb` now expects a `string` value. Existing deployments that pass an integer (e.g., `10`) must be updated to pass a string (e.g., `'10'`). Fractional values like `'0.5'` are now supported.

## 0.14.1

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.14.0

### Changes

- Added `defaultDataCollectionRuleResourceId` parameter.
- Added `SecuredByPerimeter` to allowed values for `publicNetworkAccessForIngestion` and `publicNetworkAccessForQuery`.
- Updated API version to `2025-07-01`.
- Updated API version of the Sentinel onboarding to `2025-09-01`.

### Breaking Changes

- None

## 0.13.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.
- Expanded documentation of diverse parameters

### Breaking Changes

- Changed lower bound of `tables.retentionInDays` & `tables.totalRetentionInDays` to `4` as per their official limits. To use the default, don't provide the value or use `null`. This replaces the previous `-1` value that translated to the default.

## 0.12.0

### Changes

- Added support for workspace replication
- Updated API versions
- Implemented strong typing for the `tags` parameter
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.11.2

### Changes

- Initial version

### Breaking Changes

- None
