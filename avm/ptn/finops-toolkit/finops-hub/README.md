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
  - [Cost Estimation](#cost-estimation)
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

### Cost Estimation

> **⚠️ Disclaimer**: All estimates are based on **Azure PAYGO (Pay-As-You-Go) public pricing** as of January 2025. Your actual costs may be **significantly lower** with:
> - **Enterprise Agreement (EA)** discounts (typically 10-40% off)
> - **Azure Reserved Instances** for ADX clusters (up to 65% savings)
> - **Azure Hybrid Benefit** for Windows-based workloads
> - **Dev/Test pricing** for non-production environments
> - **Regional pricing variations**
>
> Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) for precise quotes based on your agreement.

#### Infrastructure Costs by Deployment Type

| Deployment Type | Configuration | Monthly Cost | Annual Cost | Best For |
|----------------|---------------|--------------|-------------|----------|
| **storage-only** | minimal | ~$5-15 | ~$60-180 | Basic cost data storage, Power BI only |
| **storage-only** | waf-aligned | ~$20-40 | ~$240-480 | Production storage with ZRS |
| **adx** (Dev SKU) | minimal | ~$50-100 | ~$600-1,200 | Dev/test, POCs, small orgs |
| **adx** (Standard) | minimal | ~$400-550 | ~$4,800-6,600 | Production, medium orgs |
| **adx** (Standard) | waf-aligned | ~$550-800 | ~$6,600-9,600 | Enterprise, HA required |
| **fabric** | minimal | ~$5-15 + Fabric | ~$60-180 + Fabric | Existing Fabric capacity |

#### Cost Breakdown by Resource

| Resource | Minimal Config | WAF-Aligned Config | Notes |
|----------|---------------|-------------------|-------|
| **Storage Account** | ~$2-10/mo | ~$15-50/mo | LRS vs ZRS, depends on data volume |
| **Key Vault** | ~$0.50/mo | ~$0.50/mo | Minimal operations |
| **Data Factory** | ~$5-20/mo | ~$10-30/mo | Based on pipeline runs |
| **ADX Dev SKU** | ~$45/mo* | N/A | *With auto-stop (8 hrs/day) |
| **ADX Standard (2 nodes)** | ~$380/mo | ~$500/mo | E2d_v5, always-on |
| **Private Endpoints** | N/A | ~$7-10/mo | Per endpoint ($0.01/hr) |
| **Managed VNet** | N/A | ~$5/mo | VNet + DNS zones |

> *ADX Dev SKU with `enableAutoStop: true` runs ~8 hours/day on average, reducing costs by ~65%.

#### Data Storage Costs

Storage costs scale with your organization's cloud spend. Data volume correlates with the number of cost line items (resources, services, tags) rather than dollar amounts directly.

| Monthly Cloud Spend | Est. Line Items/Month | Est. Data/Month | Storage Cost/Month | Storage Cost/Year |
|--------------------|----------------------|-----------------|-------------------|-------------------|
| **$200K** | 50K-100K | 2-5 GB | $0.10-0.25 | $1.20-3 |
| **$500K** | 100K-250K | 5-12 GB | $0.25-0.60 | $3-7 |
| **$800K** | 150K-400K | 8-20 GB | $0.40-1 | $5-12 |
| **$1M** | 200K-500K | 10-25 GB | $0.50-1.25 | $6-15 |
| **$2M** | 400K-1M | 20-50 GB | $1-2.50 | $12-30 |
| **$5M** | 1M-2.5M | 50-125 GB | $2.50-6.25 | $30-75 |
| **$10M** | 2M-5M | 100-250 GB | $5-12.50 | $60-150 |

> Storage pricing: Standard_LRS ~$0.02/GB, Premium_ZRS ~$0.15/GB for hot tier. Estimates assume daily FOCUS exports with 13 months retention.

#### ADX Data Ingestion & Retention Costs

| Monthly Cloud Spend | Data Volume | Ingestion/Month | 1-Year ADX Storage | 3-Year ADX Storage |
|--------------------|-------------|-----------------|-------------------|-------------------|
| **$200K** | ~3 GB/mo | ~$0.15 | ~$0.75 | ~$2.25 |
| **$500K** | ~8 GB/mo | ~$0.40 | ~$2 | ~$6 |
| **$800K** | ~14 GB/mo | ~$0.70 | ~$3.50 | ~$10.50 |
| **$1M** | ~18 GB/mo | ~$0.90 | ~$4.50 | ~$13.50 |
| **$2M** | ~35 GB/mo | ~$1.75 | ~$8.75 | ~$26 |
| **$5M** | ~85 GB/mo | ~$4.25 | ~$21 | ~$64 |
| **$10M** | ~175 GB/mo | ~$8.75 | ~$44 | ~$131 |

> ADX pricing: ~$0.05/GB ingestion, ~$0.02/GB/month hot cache storage. Estimates assume FOCUS daily exports.

#### Total Cost Examples by Cloud Spend

**Key insight: FinOps Hub costs are ~95% fixed infrastructure (ADX cluster), not variable with your cloud spend.**

| Component | Monthly Cost | What Drives It |
|-----------|--------------|----------------|
| **ADX Cluster** (Standard 2-node) | ~$380 | Fixed - cluster size, not data |
| **Data Factory** | ~$10-15 | Fixed - pipeline runs |
| **Storage + Key Vault** | ~$5-10 | Mostly fixed, tiny data cost |
| **Data ingestion/storage** | ~$1-5 | Variable - scales with data |
| **Total** | **~$400-410/mo** | ~95% fixed |

#### Real-World Example: $1M/mo Cloud Spend with 10% MoM Growth

Starting at $1M/mo cloud spend, growing 10% month-over-month:

| Period | Cloud Spend Range | Data Generated | FinOps Hub Cost | Cumulative Hub Cost |
|--------|-------------------|----------------|-----------------|---------------------|
| **Year 1** | $1M → $3.1M/mo | ~350 GB total | ~$405/mo | **~$4,860** |
| **Year 2** | $3.1M → $9.8M/mo | ~1.1 TB total | ~$415/mo | **~$9,840** |
| **Year 3** | $9.8M → $31M/mo | ~3.5 TB total | ~$450/mo | **~$15,240** |

> **3-Year Total: ~$15,240** for FinOps Hub infrastructure

#### Cost vs. Value Comparison

| Metric | Year 1 | Year 2 | Year 3 | 3-Year Total |
|--------|--------|--------|--------|--------------|
| **Total Cloud Spend** | ~$21M | ~$66M | ~$207M | **~$294M** |
| **FinOps Hub Cost** | ~$4,860 | ~$4,980 | ~$5,400 | **~$15,240** |
| **Hub as % of Spend** | 0.023% | 0.008% | 0.003% | **0.005%** |
| **10% Savings Opportunity** | $2.1M | $6.6M | $20.7M | **$29.4M** |

> **ROI**: Even achieving just 1% cloud savings through FinOps visibility = **$2.94M saved** vs **$15K** Hub cost (196:1 return)

#### Why Doesn't Cost Scale With Cloud Spend?

The ADX cluster processes cost **line items** (rows), not dollars. A $10M/mo enterprise with simple architecture may have fewer line items than a $500K startup with microservices. The cluster is sized for query performance, not data volume.

| Cloud Spend | Typical Line Items/Month | Data Volume | Variable Cost Impact |
|-------------|-------------------------|-------------|---------------------|
| $200K - $2M | 50K - 1M | 2-50 GB | +$0 - $2/mo |
| $2M - $10M | 1M - 5M | 50-250 GB | +$2 - $10/mo |
| $10M+ | 5M+ | 250+ GB | +$10 - $50/mo |

> The variable data costs are negligible compared to the ~$400/mo fixed cluster cost.

#### Cost Optimization Tips

1. **Use Dev SKU for non-production**: Dev(No SLA) SKUs are ~90% cheaper than Standard
2. **Enable auto-stop**: Reduces Dev SKU costs by ~65% when cluster is idle
3. **Start with storage-only**: Upgrade to ADX later when analytics needs grow
4. **Use minimal config for dev/test**: WAF-aligned adds ~30-50% for HA features
5. **Tune retention policies**: Reduce ADX hot cache retention for older data
6. **Pause when not in use**: See below for dramatic savings

#### Pause/Resume: Pay Only When You Need Analytics

**If you don't need real-time analytics 24/7**, you can pause ADX or Fabric and save 80-95% on compute costs. Your data remains safe in storage - pause only stops the analytics engine.

| Usage Pattern | Hours/Month | ADX Standard Cost | ADX Dev Cost | Fabric F2 Cost |
|---------------|-------------|-------------------|--------------|----------------|
| **Always-on** | 730 hrs | ~$380/mo | ~$130/mo | ~$263/mo |
| **Business hours** (8x5) | 160 hrs | ~$85/mo | ~$30/mo | ~$58/mo |
| **Weekly review** (4 hrs/wk) | 16 hrs | ~$10/mo | ~$3/mo | ~$6/mo |
| **Monthly review** (8 hrs/mo) | 8 hrs | ~$5/mo | ~$2/mo | ~$3/mo |

> **Weekly reviewer example**: ~$20-25/mo total (Storage + KV + ADF + 16 hrs ADX Dev)

**Use the helper script** to safely pause and resume:

```powershell
# Pause the hub (stop incurring compute charges)
.\src\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Pause

# Resume the hub (when ready to review - processes any backlog)
.\src\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Resume
```

The script handles the correct order (stop triggers before cluster, start cluster before triggers) and waits for resources to be ready. See [src/Manage-FinOpsHubState.ps1](./src/Manage-FinOpsHubState.ps1) for details.

> **⚠️ Backlog Processing**: If paused for days/weeks, expect 30 min to several hours for ADF to process accumulated data when resumed.

### Getting Started

Helper scripts in the [src/](./src/) folder simplify deployment and testing:

| Script | Purpose |
|--------|---------|
| `Deploy-FinOpsHub.ps1` | Interactive deployment with validation |
| `Generate-MultiCloudTestData.ps1` | Generate FOCUS 1.0-1.3 test data (Azure/AWS/GCP/DC) |
| `Get-BestAdxSku.ps1` | Find available ADX SKUs by region |
| `Manage-FinOpsHubState.ps1` | Pause/resume hub to optimize costs |

See [src/README.md](./src/README.md) for detailed usage, or use the `gettingStartedGuide` output from deployment.

### Visualization Options

| Option | Included | Best For | Documentation |
|--------|----------|----------|---------------|
| **ADX Dashboard** | ✅ Yes | Central FinOps team, real-time analysis | [dashboards/README.md](./dashboards/README.md) |
| **Power BI Reports** | External | Department distribution, RLS, mobile | [aka.ms/finops/toolkit/powerbi](https://aka.ms/finops/toolkit/powerbi) |

### Folder Structure

For module architecture details, see [modules/README.md](./modules/README.md).

### Upgrade Safety & Data Protection

**This module is designed for safe upgrades that preserve existing data.** When upgrading to new versions (e.g., FOCUS 1.2 → 1.3 → 1.4), your historical cost data is protected:

| Resource | Protection Mechanism | Behavior During Upgrade |
|----------|---------------------|------------------------|
| **Storage Account** | ARM incremental deployment | Containers only created if missing; existing blobs **never deleted** |
| **ADX Tables** | `.create-merge table` command | New columns **added** without deleting existing data |
| **ADX Functions** | `.create-or-alter function` | Logic updated; underlying data **untouched** |
| **Key Vault** | Soft delete (90 days) + Purge protection | Secrets recoverable even if accidentally deleted |

#### Recommended Protection Settings

For production environments with years of cost data, we recommend:

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    hubName: 'prodfinopshub'
    
    // Enable resource lock to prevent accidental deletion
    lock: {
      kind: 'CanNotDelete'
      name: 'finops-hub-data-protection'
    }
    
    // WAF-aligned enables purge protection and geo-redundant storage
    deploymentConfiguration: 'waf-aligned'
  }
}
```

#### What Happens During FOCUS Version Upgrades

| Upgrade Path | Data Impact | Action Required |
|-------------|-------------|-----------------|
| **FOCUS 1.0 → 1.2** | None - existing data preserved | Re-run pipeline to transform with new columns |
| **FOCUS 1.2 → 1.3** | None - schema extended | New optional columns added to existing tables |
| **FOCUS 1.3 → 1.4** | None - backward compatible | New functions deployed alongside existing |

#### Backup Recommendations

For critical production data:

1. **Azure Backup**: Enable blob versioning on storage account
2. **ADX Export**: Use `.export` command to backup historical data periodically
3. **Cross-region**: Use `waf-aligned` for Zone-Redundant Storage (ZRS)

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [Azure Verified Modules documentation](https://aka.ms/avm). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkID=824704. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

## Related Links

- [FinOps Toolkit Documentation](https://aka.ms/finops/toolkit)
- [FinOps Hubs Overview](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview)
- [Azure Verified Modules](https://aka.ms/avm)
- [FOCUS Specification](https://focus.finops.org)
