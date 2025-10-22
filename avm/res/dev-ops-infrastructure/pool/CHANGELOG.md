# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/dev-ops-infrastructure/pool/CHANGELOG.md).

## 0.7.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.7.0

### Changes

- Added the `weekDaysScheme` to the `daysData` configuration
- Added checks to ensure that `daysData` does not contain both `allWeekScheme` and `weekDaysScheme` at the same time or a combination of `weekDaysScheme` and `allWeekScheme` with individual days.
- Added a test for `weekDaysScheme`
- Updated ReadMe with AzAdvertizer reference
### Breaking Changes

- None

## 0.6.0

### Changes

- Added 'allWeekScheme' as a supported value for the `daysData` configuration to mimic the Azure Portal deployment experience and its Quickstart templates.
- Added metadata to exported types

### Breaking Changes

- None

## 0.5.0

### Changes

- Initial version

### Breaking Changes

- None
