# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/hybrid-container-service/provisioned-cluster-instance/CHANGELOG.md).

## 0.3.0

### Changes

- Added `authorizedIPRanges` to cluster VM access profile
- Updated the referenced `avm/res/kubernetes/connected-cluster` module from `0.1.1` to `0.3.0`, which deploys `Microsoft.Kubernetes/connectedClusters` with the stable API version `2026-05-01`
- Updated the `Microsoft.Kubernetes/connectedClusters` reference from `2024-07-15-preview` to `2026-05-01`
- Updated `Microsoft.KeyVault/vaults` and `Microsoft.KeyVault/vaults/secrets` from `2023-07-01` to `2026-02-01`
- Updated the AVM telemetry deployment to API version `2025-04-01`
- Kept `Microsoft.HybridContainerService/provisionedClusterInstances` on the stable `2024-01-01`, as Azure Local's AKS Arc extension doesn't accept `2026-04-01-preview` for creating clusters at the time of this release; the preview-only `securityProfile` and `gpuCountPerNode` properties are therefore not offered
- Recompiled template (previously listed as `0.2.2`, which was never published)

### Breaking Changes

- None (all new properties are optional/additive)

## 0.2.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
