# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/insights/data-collection-rule/CHANGELOG.md).

## 0.8.0

### Changes

- Fixed role assignments naming issue when deploying multiple data collection rules with role assignments in the same resource group
- Updated common types to use 'avm-common-types' version `0.6.1`.
- Added resource-derived types for all module parameters.

### Breaking Changes

- The naming of existing role assignments has changed, which may lead to errors when redeploying existing data collection rules with role assignments. To resolve this, either remove the existing role assignments before redeployment or use the `name` property of the role assignment parameter to specify a matching name.

## 0.7.0

### Changes

- Add output `immutableId` to allow use of the DCR's `immutableId`, if generated
- Add output `endpoints` to allow use of the DCR's logging & metrics endpoints, if generated
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.6.1

### Changes

- Regenerate main.json with latest bicep version 0.36.177.2456
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.6.0

### Changes

- Initial version

### Breaking Changes

- None
