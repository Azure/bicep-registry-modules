# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/proximity-placement-group/CHANGELOG.md).

## 0.4.0

### Changes

- None

### Breaking Changes

- Renamed `zones` parameter to singular `availabilityZone`
- Changed type of `availabilityZone` to singular integer without a default as the resource is zone-redundant, not zonal. As a result, users **must** define a zone upon deployment, but can opt out by providing a value of -1
- Added allowed set `[-1,1,2,3]` to `availabilityZone` parameter

## 0.3.2

### Changes

- Initial version

### Breaking Changes

- None
