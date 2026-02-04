# FinOps Hub

This module deploys a FinOps Hub for cloud cost analytics using Azure Verified Modules.

## Navigation

- [Resource Types](#resource-types)
- [Usage Examples](#usage-examples)
- [Parameters](#parameters)
- [Outputs](#outputs)
- [Data Collection](#data-collection)

## Resource Types

| Resource Type | API Version |
|:--|:--|
| `Microsoft.Resources/deployments` | 2024-03-01 |
| `Microsoft.Storage/storageAccounts` | 2023-05-01 |
| `Microsoft.KeyVault/vaults` | 2023-07-01 |
| `Microsoft.DataFactory/factories` | 2018-06-01 |
| `Microsoft.Kusto/clusters` | 2023-08-15 |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2023-01-31 |
| `Microsoft.Network/virtualNetworks` | 2024-01-01 |
| `Microsoft.Network/privateEndpoints` | 2024-01-01 |
| `Microsoft.Network/privateDnsZones` | 2024-06-01 |

## Deployment Modes

This module supports two deployment modes to accommodate different environments:

### Enterprise Mode (EA/MCA)

For tenants with Enterprise Agreement or Microsoft Customer Agreement billing:
- Full Cost Management export support
- Price sheets and reservation data available
- Automated data ingestion via ADF pipelines

### Demo Mode (PAYGO/Dev)

For tenants without export-capable billing accounts:
- Use test data generation scripts in `src/`
- Realistic FOCUS 1.0r2 compliant data
- Perfect for demos, POCs, and development

## Usage Examples

### Example 1: Minimal Deployment (Demo Mode)

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:1.0.0' = {
  name: 'finopsHub'
  params: {
    hubName: 'myfinopshub'
    deploymentType: 'storage-only'
    billingAccountType: 'paygo'  // Indicates demo mode
  }
}

// After deployment, run:
// .\src\Test-FinOpsHub.ps1 -StorageAccountName <storage-account-name>
```

### Example 2: ADX Deployment with Enterprise Billing

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:1.0.0' = {
  name: 'finopsHub'
  params: {
    hubName: 'myfinopshub'
    deploymentType: 'adx'
    dataExplorerClusterName: 'myfinopsadx'
    billingAccountType: 'ea'
    
    // Define scopes to monitor
    scopesToMonitor: [
      {
        scopeId: '/providers/Microsoft.Billing/billingAccounts/1234567'
        scopeType: 'ea'
        displayName: 'Contoso EA'
      }
    ]
  }
}

// After deployment, create exports using the PowerShell command from outputs
```

### Example 3: WAF-Aligned Production Deployment

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:1.0.0' = {
  name: 'finopsHub'
  params: {
    hubName: 'prodfinopshub'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'adx'
    dataExplorerClusterName: 'prodfinopsadx'
    networkIsolationMode: 'Managed'
    billingAccountType: 'ea'
    billingAccountId: '1234567'  // Enables MACC tracking
    
    scopesToMonitor: [
      {
        scopeId: '/providers/Microsoft.Billing/billingAccounts/1234567'
        scopeType: 'ea'
        displayName: 'Production EA'
      }
    ]
    
    tags: {
      Environment: 'Production'
      CostCenter: 'FinOps'
    }
  }
}
```

### Example 4: Multi-Cloud Demo

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:1.0.0' = {
  name: 'finopsHub'
  params: {
    hubName: 'multicloudfinops'
    deploymentType: 'adx'
    dataExplorerClusterName: 'multicloudadx'
    dataExplorerSku: 'Dev(No SLA)_Standard_E2a_v4'
    billingAccountType: 'paygo'  // Demo mode
  }
}

// After deployment, generate multi-cloud test data:
// .\src\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName <storage-account-name>
```

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| `hubName` | string | Name of the FinOps Hub instance (3-24 characters). |

**Optional parameters**

| Parameter | Type | Description | Default |
| :-- | :-- | :-- | :-- |
| `location` | string | Azure region for all resources. | `[resourceGroup().location]` |
| `deploymentConfiguration` | string | Deployment profile: "minimal" or "waf-aligned". | `'minimal'` |
| `deploymentType` | string | Data platform: "adx", "fabric", or "storage-only". | `'storage-only'` |
| `billingAccountType` | string | Billing type hint for export support. | `'auto'` |
| `scopesToMonitor` | array | List of billing scopes to monitor. | `[]` |
| `networkIsolationMode` | string | Network isolation: "None", "Managed", or "BringYourOwn". | `'None'` |
| `tags` | object | Tags to apply to all resources. | `{}` |
| `tagsByResource` | object | Resource-specific tags by resource type. | `{}` |
| `enableTelemetry` | bool | Enable/Disable AVM usage telemetry. | `false` |
| `lock` | object | The lock settings of the service (AVM standard interface). | `null` |
| `diagnosticSettings` | array | The diagnostic settings of the service (AVM standard interface). | `[]` |

### Lock Parameter

The `lock` parameter follows the AVM standard interface:

```bicep
lock: {
  kind: 'CanNotDelete'  // 'CanNotDelete', 'ReadOnly', or 'None'
  name: 'myLock'        // Optional custom lock name
  notes: 'Lock notes'   // Optional lock notes
}
```

### Diagnostic Settings Parameter

The `diagnosticSettings` parameter follows the AVM standard interface for forwarding logs and metrics to Azure Monitor:

```bicep
diagnosticSettings: [
  {
    name: 'myDiagnosticSetting'
    workspaceResourceId: '/subscriptions/.../workspaces/myWorkspace'
    metricCategories: [{ category: 'AllMetrics' }]
    logCategoriesAndGroups: [{ category: 'allLogs' }]
  }
]
```

### Billing Account Types

| Type | Export Support | Description |
|------|---------------|-------------|
| `ea` | ✅ Full | Enterprise Agreement |
| `mca` | ✅ Full | Microsoft Customer Agreement |
| `mpa` | ✅ Full | Microsoft Partner Agreement |
| `subscription` | ⚠️ Limited | Subscription-level (costs only) |
| `paygo` | ❌ None | Pay-As-You-Go - use demo mode |
| `csp` | ❌ None | CSP customer - partner manages |

### Scope Types

| Type | FOCUS Costs | Prices | Reservations |
|------|------------|--------|--------------|
| `ea` | ✅ | ✅ | ✅ |
| `mca` | ✅ | ✅ | ✅ |
| `department` | ✅ | ✅ | ⚠️ |
| `subscription` | ✅ | ❌ | ❌ |
| `resourceGroup` | ✅ | ❌ | ❌ |
| `managementGroup` | ✅ | ❌ | ❌ |

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the storage account created. |
| `storageAccountResourceId` | string | Resource ID of the storage account. |
| `dataFactoryName` | string | Name of the Data Factory. |
| `dataExplorerClusterUri` | string | ADX cluster URI (if deployed). |
| `deploymentMode` | string | Effective mode: "enterprise", "demo", or "hybrid". |
| `exportConfiguration` | object | Export setup commands and guidance. |
| `settingsJson` | object | Settings.json content for config container. |
| `gettingStartedGuide` | object | Step-by-step instructions based on mode. |

## Getting Started

### For Demo/Dev Environments (PAYGO)

1. Deploy the module with `billingAccountType: 'paygo'`
2. Navigate to the `src/` folder
3. Run the test data script:
   ```powershell
   .\Test-FinOpsHub.ps1 -StorageAccountName "<storage-account-name>"
   ```
4. Wait ~5 minutes for ADF pipelines to process
5. Query data in ADX: Hub database → Costs table

### For Enterprise Environments (EA/MCA)

1. Deploy the module with `scopesToMonitor` configured
2. Get the export command from deployment outputs
3. Install FinOps Toolkit PowerShell:
   ```powershell
   Install-Module FinOpsToolkit -Force
   ```
4. Create Cost Management exports using the provided command
5. Wait for first export (up to 24 hours)
6. Query data in ADX: Hub database → Costs table

## Folder Structure

```
finops-hub/
├── main.bicep          # Main module entry point
├── modules/            # Internal helper modules
│   ├── scripts/        # KQL scripts for ADX schema
│   └── README.md       # Module architecture docs
├── src/                # Helper scripts
│   ├── Test-FinOpsHub.ps1              # Test data generator
│   ├── Generate-MultiCloudTestData.ps1 # Multi-cloud data
│   └── README.md       # Script documentation
├── tests/              # E2E tests
└── dashboards/         # ADX dashboard templates
```

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [Azure Verified Modules documentation](https://aka.ms/avm). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkID=824704. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

## Related Links

- [FinOps Toolkit Documentation](https://aka.ms/finops/toolkit)
- [FinOps Hubs Overview](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview)
- [Azure Verified Modules](https://aka.ms/avm)
- [FOCUS Specification](https://focus.finops.org)
