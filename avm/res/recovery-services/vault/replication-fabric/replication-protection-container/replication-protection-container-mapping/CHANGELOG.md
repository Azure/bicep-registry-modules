# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/recovery-services/vault/replication-fabric/replication-protection-container/replication-protection-container-mapping/CHANGELOG.md).

## 0.2.0

### Changes

- Fixed generated policy and target-container resource IDs to include the resource group.

### Breaking Changes

- Mapping names generated from `targetProtectionContainerResourceId` now use the target container name instead of the fabric name. Set `name` explicitly to retain an existing mapping name.

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
