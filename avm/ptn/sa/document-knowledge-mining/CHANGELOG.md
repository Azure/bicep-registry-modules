# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/document-knowledge-mining/CHANGELOG.md).

## 0.4.0

### Changes

- Aligned with `container-service/managed-cluster` 0.13.0 schema (AKS): `aadProfile`, `autoUpgradeProfile`, `apiServerAccessProfile`, and `securityProfile.defender` mappings.
- Added `!` non-null assertions required by stricter Bicep null-checking on conditional module outputs.
- Updated AVM module versions to latest available:
  - `network/private-dns-zone`: 0.8.0 → 0.8.1
  - `network/bastion-host`: 0.8.0 → 0.8.2
  - `compute/virtual-machine`: 0.21.0 → 0.22.1
  - `managed-identity/user-assigned-identity`: 0.4.2 → 0.5.1
  - `document-db/database-account`: 0.18.0 → 0.19.0
  - `app-configuration/configuration-store`: 0.9.2 → 0.9.3
  - `search/search-service`: 0.11.1 → 0.12.1
  - `cognitive-services/account`: 0.14.0 → 0.14.2
  - `network/network-security-group`: 0.5.2 → 0.5.3
  - `container-registry/registry`: 0.9.3 → 0.12.1
  - `operational-insights/workspace`: 0.14.0 → 0.15.1
  - `maintenance/maintenance-configuration`: 0.3.2 → 0.4.0
  - `storage/storage-account`: 0.29.0 → 0.32.0
  - `container-service/managed-cluster`: 0.11.1 → 0.13.1
  - `network/virtual-network`: 0.7.1 → 0.9.0
  - `utl/types/avm-common-types`: 0.5.1 → 0.7.0
- Updated Azure Resource API versions:
  - `Microsoft.ContainerService/managedClusters/maintenanceConfigurations`: 2024-10-01 → 2026-01-01
  - `Microsoft.Resources/deployments` (telemetry): 2024-03-01 → 2024-11-01
  - `Microsoft.Resources/resourceGroups` (sandbox test): 2021-04-01 → 2025-04-01

### Breaking Changes

- None

## 0.3.0

### Changes

- Updated AKS (Azure Kubernetes Service) version to the latest 1.34.2

### Breaking Changes

- None

## 0.2.0

### Changes

- Consolidated network modules into single `modules/virtualNetwork.bicep`
- Simplified subnet configurations with inline defaults
- Added CIDR sizing reference and VM accelerated networking documentation
- Added `cosmosReplicaLocation` parameter to allow custom secondary location for Cosmos DB redundancy
- Removed hardcoded `cosmosDbZoneRedundantHaRegionPairs` region mapping logic in favor of explicit `cosmosReplicaLocation` parameter
- Updated AVM module versions:
  - `operational-insights/workspace`: 0.12.0 → 0.14.0
  - `compute/virtual-machine`: 0.20.0 → 0.21.0
  - `storage/storage-account`: 0.28.0 → 0.29.0
  - `cognitive-services/account`: 0.13.2 → 0.14.0
  - `container-service/managed-cluster`: 0.11.0 → 0.11.1
  - `insights/component`: 0.7.0 → 0.7.1

### Breaking Changes

- Removed separate bastion and jumpbox modules

## 0.1.0

### Changes

- Initial version of Document Knowledge Mining Solution
- Comprehensive AI document processing solution with Azure OpenAI, Cognitive Services, and Azure Search
- Support for private networking, monitoring, redundancy, and scalability configurations
- Integrated Azure Bastion and jumpbox for secure access
- AVM compliance with telemetry, proper naming conventions, and governance

### Breaking Changes

- None
