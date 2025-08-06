# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/desktop-virtualization/scaling-plan/CHANGELOG.md).

## 0.4.0

### Changes

- Updated `avm-common-types` version to latest version `0.6.0`, enabling custom notes on locks
- Added diverse types

### Breaking Changes

- Introduced a type `hostPoolReferenceType` for the parameter `hostPoolReference` that expects a `hostPoolResourceId` instead of the previous `hostPoolArmPath`
- The property `scalingPlanEnabled` of the new type `hostPoolReferenceType` defaults to `true`

## 0.3.2

### Changes

- Initial version

### Breaking Changes

- None
