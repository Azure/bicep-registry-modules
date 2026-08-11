# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/finops-toolkit/finops-hub/CHANGELOG.md).

## 0.2.0

### Changes

- Upgraded the embedded FinOps hub implementation from FinOps Toolkit 0.3 to FinOps Toolkit v14
- Added support for Azure Data Explorer clusters and the Hub and Ingestion databases
- Added support for Microsoft Fabric, managed exports, recommendations, remote hubs, retention settings, and current FinOps Toolkit configuration options
- Added Azure Data Explorer outputs and retained `exportScopes` as a compatibility alias for `scopesToMonitor`
- Defaulted Azure Data Explorer capacity to one node for dev/test SKUs and two nodes for standard SKUs

### Breaking Changes

- Updated the FinOps hub storage paths, datasets, schemas, pipelines, and triggers to the FinOps Toolkit v14 implementation
- Removed the obsolete `configContainer`, `exportContainer`, `ingestionContainer`, and `convertToParquet` parameters
- Enabled managed exports by default, which grants the hub identity Role Based Access Control Administrator on its storage account

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
