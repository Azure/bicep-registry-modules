# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/document-knowledge-mining/CHANGELOG.md).

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
