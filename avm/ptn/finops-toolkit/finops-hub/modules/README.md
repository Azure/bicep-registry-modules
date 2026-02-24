# FinOps Hub - Internal Bicep Modules

This folder contains internal helper modules used by the main `main.bicep` template. These are **not** standalone AVMs - they are implementation details that should not be used directly.

## Module Architecture

```
main.bicep (the AVM entry point)
    │
    ├── modules/storage.bicep          → Uses: avm/res/storage/storage-account
    ├── modules/keyVault.bicep         → Uses: avm/res/key-vault/vault
    ├── modules/dataFactory.bicep      → Uses: avm/res/data-factory/factory
    │
    ├── modules/dataFactoryResources.bicep  → ADF child resources (pipelines, datasets, triggers)
    ├── modules/network.bicep               → Managed VNet, subnets, NSG, Private DNS zones
    ├── modules/triggerManagement.bicep     → PowerShell deployment scripts for trigger control
    │
    ├── modules/adxSchemaSetup.bicep        → Orchestrates KQL script deployment order
    ├── modules/hub-database.bicep          → Generic KQL script runner for ADX
    ├── modules/adxManagedIdentityPolicy.bicep   → ADX MI policy configuration
    ├── modules/adxManagedPrivateEndpoint.bicep  → ADF managed PE to ADX
    ├── modules/adxPrivateEndpointApproval.bicep → PE approval logic
    │
    └── modules/scripts/                    → KQL scripts (see scripts/README.md)
```

## How Modules Work

### 1. AVM Wrapper Modules
These modules wrap Azure Verified Modules (AVMs) with FinOps Hub-specific configurations:

| Module | Wraps AVM | Purpose |
|--------|-----------|---------|
| `storage.bicep` | `avm/res/storage/storage-account` | Creates storage with FinOps containers |
| `keyVault.bicep` | `avm/res/key-vault/vault` | Stores storage keys for ADF |
| `dataFactory.bicep` | `avm/res/data-factory/factory` | Creates ADF with managed identity |

### 2. Custom Resource Modules
These modules create resources not available as AVMs:

| Module | Purpose |
|--------|---------|
| `dataFactoryResources.bicep` | All ADF pipelines, datasets, linked services, triggers |
| `network.bicep` | Self-contained VNet for "Managed" network isolation |
| `triggerManagement.bicep` | Deployment scripts to stop/start triggers |

### 3. ADX Schema Modules
These modules deploy the FinOps Hub schema to Azure Data Explorer:

| Module | Purpose |
|--------|---------|
| `adxSchemaSetup.bicep` | Orchestrates KQL script deployment in correct order |
| `hub-database.bicep` | Generic wrapper that creates `Microsoft.Kusto/clusters/databases/scripts` resources |
| `adxManagedIdentityPolicy.bicep` | Sets cluster-level MI policy via deployment script |

## Key Concepts

### Script Deployment Mechanism

KQL scripts are deployed using native ADX `scripts` resources:

```bicep
// 1. adxSchemaSetup.bicep loads KQL at compile time
var rawTablesScript = loadTextContent('scripts/IngestionSetup_RawTables.kql')

// 2. Passes to hub-database.bicep module
module ingestionScripts 'hub-database.bicep' = {
  params: {
    scripts: {
      RawTables: rawTablesScript
    }
  }
}

// 3. hub-database.bicep creates ADX script resources
resource script 'scripts' = [for scr in items(scripts): {
  name: scr.key
  properties: {
    scriptContent: scr.value
    continueOnErrors: true
    forceUpdateTag: utcNow()  // Forces re-execution each deployment
  }
}]
```

### Network Isolation Modes

The `network.bicep` module supports the "Managed" mode:

| Mode | What Module Creates | Who Manages Upgrades |
|------|--------------------|--------------------|
| `None` | Nothing (public access) | Just redeploy |
| `Managed` | VNet, subnet, NSG, DNS zones, PEs | Just redeploy |
| `BringYourOwn` | Nothing (customer provides) | Customer tests before upgrade |

## Adding New Modules

When adding new functionality:

1. **Prefer AVMs**: If an AVM exists for the resource, create a thin wrapper
2. **Follow naming**: Use descriptive names that match Azure resource types
3. **Keep types separate**: Use `types.bicep` for shared type definitions
4. **Document dependencies**: Add comments explaining module dependencies

## See Also

- [scripts/README.md](./scripts/README.md) - KQL script documentation
- [main.bicep](../main.bicep) - Main module entry point
- [FinOps Toolkit](https://aka.ms/finops/toolkit) - Official documentation
