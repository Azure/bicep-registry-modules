# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/finops-toolkit/finops-hub/CHANGELOG.md).

## 1.0.0

### New Features

- Complete rewrite using Azure Verified Modules (AVM) resource modules
- Support for three deployment types: `storage-only`, `adx` (Azure Data Explorer), `fabric` (Microsoft Fabric)
- Configuration profiles: `minimal` for dev/test, `waf-aligned` for production
- Azure Data Explorer integration with automatic schema deployment
- Microsoft Fabric eventhouse integration
- Private endpoint support for all resources (storage, Key Vault, Data Factory, ADX)
- Managed identity support with option to bring existing identity
- Existing ADX cluster support
- RBAC-based Key Vault authorization (recommended)
- Automatic trigger management for idempotent deployments
- **MACC (Microsoft Azure Consumption Commitment) tracking support**:
  - New ADX tables: `MACC_Lots_raw`, `MACC_Events_raw`, `MACC_Lots_final`, `MACC_Events_final`
  - New ADF pipelines: `macc_FetchLots`, `macc_FetchEvents`, `macc_SyncAll`
  - Dashboard queries for MACC status, trends, forecasting, and alerts
  - Enable by providing `billingAccountId` parameter
  - Prerequisites: ADF MI needs Billing Account Reader role

### Breaking Changes

- Parameter `storageSku` replaced by `deploymentConfiguration` profile
- Parameter `exportScopes` removed (not applicable to new architecture)
- Parameters `configContainer`, `exportContainer`, `ingestionContainer` removed (now standardized)
- Container names now follow FinOps toolkit standard: `config`, `msexports`, `ingestion`
- New required parameter `hubName` constraints: 3-24 characters

### Resources Deployed

- Storage Account (ADLS Gen2) via `avm/res/storage/storage-account`
- Key Vault via `avm/res/key-vault/vault`
- Data Factory via `avm/res/data-factory/factory`
- User-Assigned Managed Identity via `avm/res/managed-identity/user-assigned-identity`
- Azure Data Explorer (optional) via `avm/res/kusto/cluster`
- Role assignments via `avm/ptn/authorization/resource-role-assignment`

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

