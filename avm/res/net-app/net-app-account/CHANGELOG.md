# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/net-app/net-app-account/CHANGELOG.md).

## 0.11.0

### Changes

- None

### Breaking Changes

- Changed `net-app/net-app-account/capacity-pool/volume` parameter `zone` to `availabiltiyZone`
- Changed `net-app/net-app-account/capacity-pool/volume` parameter's `availabilityZone`'s allowed set from `[0,1,2,3]` to `[-1,1,2,3]`. `-1` works in the same way as the previous `0` to specify that no zone is to be set

## 0.10.0

### Changes

- Initial version

### Breaking Changes

- None
