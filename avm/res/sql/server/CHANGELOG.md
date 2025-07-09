# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/CHANGELOG.md).

## 0.20.0

### Changes

- `tags` parameters are now properly typed instead of using `object` type.

### Breaking Changes

- Renamed `partnerServers` array to `partnerServerResourceIds` in the failover group module to make it possible to use SQL servers from different resource groups.

## 0.19.1

### Changes

- Initial version

### Breaking Changes

- None
