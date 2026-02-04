# FinOps Hub `[FinopsToolkit/FinopsHub]`

This module deploys a FinOps Hub for cloud cost analytics, enabling organizations to ingest, normalize, and analyze cloud cost data from Azure, AWS, GCP, and other providers using the FOCUS specification.

You can reference the module as follows:

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: { (...) }
}
```

For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#resource-types)
- [Usage examples](#usage-examples)
- [Parameters](#parameters)
- [Outputs](#outputs)
- [Cross-referenced modules](#cross-referenced-modules)
- [Notes](#notes)
- [Data Collection](#data-collection)

## Resource Types

| Resource Type | API Version |
|:--|:--|
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.DataFactory/factories` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults) |
| `Microsoft.Kusto/clusters` | [2023-08-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters) |
| `Microsoft.Kusto/clusters/databases` | [2023-08-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/databases) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Network/privateDnsZones` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones) |
| `Microsoft.Network/privateEndpoints` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/privateEndpoints) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks) |
| `Microsoft.Resources/deployments` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2024-03-01/deployments) |
| `Microsoft.Storage/storageAccounts` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-05-01/storageAccounts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/finops-toolkit/finops-hub:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [ADX deployment with enterprise billing](#example-2-adx-deployment-with-enterprise-billing)
- [WAF-aligned](#example-3-waf-aligned)
- [Multi-cloud demo](#example-4-multi-cloud-demo)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults](./tests/e2e/defaults)

<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  name: 'finopsHub'
  params: {
    // Required parameters
    hubName: 'myfinopshub'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "hubName": {
      "value": "myfinopshub"
    }
  }
}
```

</details>
<p>

### Example 2: _ADX deployment with enterprise billing_

This instance deploys the module with Azure Data Explorer and enterprise billing account configuration.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-minimal](./tests/e2e/adx-minimal)

<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  name: 'finopsHub'
  params: {
    // Required parameters
    hubName: 'myfinopshub'
    // Non-required parameters
    billingAccountType: 'ea'
    dataExplorerClusterName: 'myfinopsadx'
    deploymentType: 'adx'
    scopesToMonitor: [
      {
        displayName: 'Contoso EA'
        scopeId: '/providers/Microsoft.Billing/billingAccounts/1234567'
        scopeType: 'ea'
      }
    ]
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-waf-aligned](./tests/e2e/adx-waf-aligned)

<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  name: 'finopsHub'
  params: {
    // Required parameters
    hubName: 'prodfinopshub'
    // Non-required parameters
    billingAccountId: '1234567'
    billingAccountType: 'ea'
    dataExplorerClusterName: 'prodfinopsadx'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'adx'
    networkIsolationMode: 'Managed'
    scopesToMonitor: [
      {
        displayName: 'Production EA'
        scopeId: '/providers/Microsoft.Billing/billingAccounts/1234567'
        scopeType: 'ea'
      }
    ]
    tags: {
      CostCenter: 'FinOps'
      Environment: 'Production'
    }
  }
}
```

</details>
<p>

### Example 4: _Multi-cloud demo_

This instance deploys the module for multi-cloud demo scenarios using test data.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-minimal](./tests/e2e/adx-minimal)

<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  name: 'finopsHub'
  params: {
    // Required parameters
    hubName: 'multicloudfinops'
    // Non-required parameters
    billingAccountType: 'paygo'
    dataExplorerClusterName: 'multicloudadx'
    dataExplorerSku: 'Dev(No SLA)_Standard_E2a_v4'
    deploymentType: 'adx'
  }
}

// After deployment, generate multi-cloud test data:
// .\src\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName <storage-account-name>
```

</details>
<p>

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

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced Azure Verified Modules references, as well as their versions.

| Reference | Type | Version |
| :-- | :-- | :-- |
| `avm/utl/types/avm-common-types` | Remote reference | [0.6.1](https://github.com/Azure/bicep-registry-modules/tree/avm/utl/types/avm-common-types/0.6.1) |

## Notes

> **📚 Full Documentation**: For comprehensive documentation, see [Microsoft Learn - FinOps Hubs](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview).

### Architecture Decision Records

For detailed information about the design decisions, FinOps Foundation alignment, and engineering rationale, see [ADR.md](./ADR.md).

### FinOps Toolkit Alignment

This AVM module is aligned with **[FinOps Toolkit](https://aka.ms/finops/toolkit) v0.7** and the **[FOCUS Specification](https://focus.finops.org/) 1.0r2**.

| Documentation | Link |
|--------------|------|
| Deploy FinOps Hub | [learn.microsoft.com/...deploy-hub](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/deploy-hub) |
| Configure Exports | [learn.microsoft.com/...configure-exports](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/configure-exports) |
| Power BI Reports | [learn.microsoft.com/...powerbi](https://learn.microsoft.com/cloud-computing/finops/toolkit/powerbi) |
| KQL Functions | [modules/scripts/README.md](./modules/scripts/README.md) |
| ADX Dashboard | [dashboards/README.md](./dashboards/README.md) |

### Deployment Modes

| Mode | Billing Types | Use Case | Documentation |
|------|---------------|----------|---------------|
| **Enterprise** | EA, MCA, MPA | Production with Cost Management exports | [Configure Exports](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/configure-exports) |
| **Demo** | PAYGO, CSP, Dev | POCs and demos with test data | [src/README.md](./src/README.md) |

### Getting Started

Helper scripts in the [src/](./src/) folder simplify deployment and testing:

| Script | Purpose |
|--------|---------|
| `Deploy-FinOpsHub.ps1` | Interactive deployment with validation |
| `Generate-MultiCloudTestData.ps1` | Generate FOCUS 1.0-1.3 test data (Azure/AWS/GCP/DC) |
| `Get-BestAdxSku.ps1` | Find available ADX SKUs by region |

See [src/README.md](./src/README.md) for detailed usage, or use the `gettingStartedGuide` output from deployment.

### Visualization Options

| Option | Included | Best For | Documentation |
|--------|----------|----------|---------------|
| **ADX Dashboard** | ✅ Yes | Central FinOps team, real-time analysis | [dashboards/README.md](./dashboards/README.md) |
| **Power BI Reports** | External | Department distribution, RLS, mobile | [aka.ms/finops/toolkit/powerbi](https://aka.ms/finops/toolkit/powerbi) |

### Folder Structure

For module architecture details, see [modules/README.md](./modules/README.md).

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [Azure Verified Modules documentation](https://aka.ms/avm). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkID=824704. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

## Related Links

- [FinOps Toolkit Documentation](https://aka.ms/finops/toolkit)
- [FinOps Hubs Overview](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview)
- [Azure Verified Modules](https://aka.ms/avm)
- [FOCUS Specification](https://focus.finops.org)
