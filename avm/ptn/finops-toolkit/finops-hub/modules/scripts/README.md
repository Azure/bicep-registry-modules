# FinOps Hub - KQL Scripts

This folder contains Kusto Query Language (KQL) scripts that are deployed to Azure Data Explorer (ADX) during Bicep deployment. These scripts define the complete FinOps Hub database schema.

## How Scripts Are Deployed

Scripts are **NOT** run manually. They are:

1. **Loaded at compile time** via Bicep's `loadTextContent()` function
2. **Deployed as Azure resources** using `Microsoft.Kusto/clusters/databases/scripts`
3. **Executed by ADX** during the Bicep deployment

```
┌─────────────────────────┐    Compile Time     ┌────────────────────┐
│  adxSchemaSetup.bicep   │ ◄───────────────────│  *.kql files       │
│  loadTextContent(...)   │    loadTextContent  │  (this folder)     │
└───────────┬─────────────┘                     └────────────────────┘
            │
            │ Passes script content
            ▼
┌─────────────────────────┐
│   hub-database.bicep    │
│   Creates script        │
│   resources             │
└───────────┬─────────────┘
            │
            │ Azure Resource Manager
            ▼
┌─────────────────────────┐
│  Microsoft.Kusto/       │
│  clusters/databases/    │
│  scripts                │  ← ADX executes KQL
└─────────────────────────┘
```

## Script Categories

### 1. OpenData Functions (`OpenDataFunctions*.kql`)

Large lookup functions for Azure resource metadata:

| File | Size | Purpose |
|------|------|---------|
| `OpenDataFunctions_resource_type_1.kql` | ~50KB | Resource type lookup (A-C) |
| `OpenDataFunctions_resource_type_2.kql` | ~50KB | Resource type lookup (D-M) |
| `OpenDataFunctions_resource_type_3.kql` | ~50KB | Resource type lookup (N-R) |
| `OpenDataFunctions_resource_type_4.kql` | ~50KB | Resource type lookup (S-V) |
| `OpenDataFunctions_resource_type_5.kql` | ~50KB | Resource type lookup (W-Z) |
| `OpenDataFunctions.kql` | ~5KB | Wrapper functions that call resource_type_* |

These are split across files because ADX has a ~1MB script size limit.

### 2. Ingestion Database Scripts (`IngestionSetup_*.kql`)

Configure the `Ingestion` database that receives raw Cost Management exports:

| File | Purpose |
|------|---------|
| `IngestionSetup_RawTables.kql` | Creates raw tables (Costs_raw, Prices_raw) with retention |
| `IngestionSetup_HubInfra.kql` | Hub infrastructure tables (settings, metadata) |
| `IngestionSetup_v1_0.kql` | FOCUS 1.0 schema views/functions |
| `IngestionSetup_v1_2.kql` | FOCUS 1.0r2 schema views/functions |
| `IngestionSetup_MACC.kql` | MACC commitment tracking tables |

### 3. Hub Database Scripts (`HubSetup_*.kql`)

Configure the `Hub` database with materialized views and user-facing functions:

| File | Purpose |
|------|---------|
| `HubSetup_v1_0.kql` | FOCUS 1.0 materialized views |
| `HubSetup_v1_2.kql` | FOCUS 1.0r2 materialized views |
| `HubSetup_Latest.kql` | Latest version aliases (Costs, Prices, etc.) |
| `HubSetup_OpenData.kql` | OpenData functions for Hub database |

### 4. Dashboard Query Functions (`DashboardQueries_*.kql`)

Pre-built KQL functions for Power BI and ADX dashboards:

| File | Purpose |
|------|---------|
| `DashboardQueries_Advanced.kql` | Advanced analytics (anomaly detection, forecasting) |
| `DashboardQueries_FOCUS_UseCases.kql` | FOCUS use case implementations |
| `DashboardQueries_MACC.kql` | MACC commitment analysis |

### 5. Utility Scripts

| File | Purpose |
|------|---------|
| `Common.kql` | Shared utility functions |
| `ClusterSetup_ManagedIdentityPolicy.kql` | Cluster-level MI policy (special handling) |
| `ManualEntry_MACC.kql` | Customer-facing script for manual MACC data entry |

## Script Execution Order

Scripts are deployed in a specific order to handle dependencies:

```
1. Ingestion DB: OpenData internal functions (resource_type_1-5)
2. Ingestion DB: OpenData wrapper functions
3. Ingestion DB: Common functions
4. Ingestion DB: Hub infrastructure
5. Ingestion DB: Raw tables (with retention from parameter)
6. Ingestion DB: Versioned scripts (v1_0, v1_2)
7. Ingestion DB: MACC setup
8. Hub DB: Common functions  
9. Hub DB: OpenData functions
10. Hub DB: Versioned scripts (v1_0, v1_2)
11. Hub DB: Latest functions
12. Hub DB: Dashboard queries
```

This order is defined in [adxSchemaSetup.bicep](../adxSchemaSetup.bicep).

## Key Script Patterns

### Parameter Substitution

Some scripts use placeholders that are replaced at deployment time:

```kql
// In IngestionSetup_RawTables.kql:
.alter-merge table Costs_raw policy retention '{ "SoftDeletePeriod": "$$rawRetentionInDays$$d" }'
```

The `$$rawRetentionInDays$$` placeholder is replaced by Bicep:

```bicep
var rawTablesScript = replace(
    loadTextContent('scripts/IngestionSetup_RawTables.kql'),
    '$$rawRetentionInDays$$', 
    string(rawRetentionInDays)
)
```

### Idempotent Operations

Scripts use `.create-or-alter` for idempotency:

```kql
// Safe to run multiple times
.create-or-alter function Costs_v1_0() { ... }

// Creates table only if it doesn't exist
.create table Costs_raw (columns...) 
```

### Error Handling

Scripts are deployed with `continueOnErrors: true` to allow partial success:

```bicep
resource script 'scripts' = {
  properties: {
    continueOnErrors: true  // Don't fail if one command fails
    forceUpdateTag: utcNow()  // Always re-run on deployment
  }
}
```

## Manual MACC Entry

The `ManualEntry_MACC.kql` file is special - it's a **customer-facing script** that users can run manually to enter MACC commitment data:

```kql
// Users modify the values and run in ADX Query Editor
.ingest inline into table MACC_Commitment <|
2024-01-01,2026-12-31,1000000,EA,123456789,MACC-2024-001
```

This script is included in the module output for users to copy.

## Adding New Scripts

When adding new KQL scripts:

1. **Follow naming convention**: `{Category}_{Purpose}.kql`
2. **Use idempotent operations**: `.create-or-alter`, `.create table ... ifnotexists`
3. **Handle large scripts**: Split if > 500KB (ADX limit is ~1MB)
4. **Update adxSchemaSetup.bicep**: Add to correct deployment order
5. **Test locally first**: Use ADX Query Editor to validate syntax

## See Also

- [adxSchemaSetup.bicep](../adxSchemaSetup.bicep) - Deployment orchestration
- [hub-database.bicep](../hub-database.bicep) - Script resource creation
- [Azure Data Explorer Scripts](https://learn.microsoft.com/azure/data-explorer/database-script) - Official documentation
