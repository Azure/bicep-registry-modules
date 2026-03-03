# FinOps Hub - Helper Scripts

This folder contains PowerShell scripts that help with deploying, testing, and managing FinOps Hub instances. These scripts are **not required** for deployment but provide enhanced functionality.

## Scripts Overview

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `Deploy-FinOpsHub.ps1` | Interactive deployment helper | When you want guided deployment with validation |
| `Get-BestAdxSku.ps1` | ADX SKU availability checker | Before deployment to find available SKUs |
| `Switch-FinOpsHubState.ps1` | Pause/resume hub operations | When you want to optimize costs by pausing idle resources |

> **Test Data Generation**: Multi-cloud test data generation scripts are maintained in the official [Microsoft FinOps Toolkit](https://aka.ms/finops/toolkit) repository.

## Script Details

### Deploy-FinOpsHub.ps1

Interactive deployment script with:
- **Prerequisites validation** (Azure CLI, Az modules, permissions)
- **Subscription selection** (interactive picker)
- **Parameter validation** (names, regions, billing account types)
- **Cost Management export setup** (automated or guided manual)
- **Post-deployment verification**

```powershell
# Example: Deploy a minimal storage-only hub
.\Deploy-FinOpsHub.ps1 -HubName "myfinopshub" `
    -ResourceGroupName "rg-finops" `
    -Location "eastus" `
    -SubscriptionId "your-sub-id" `
    -TenantId "your-tenant-id"

# Example: Deploy with Azure Data Explorer
.\Deploy-FinOpsHub.ps1 -HubName "myfinopshub" `
    -ResourceGroupName "rg-finops" `
    -Location "eastus" `
    -SubscriptionId "your-sub-id" `
    -TenantId "your-tenant-id" `
    -DeploymentType "adx" `
    -DataExplorerClusterName "myfinopsadx"
```

### Get-BestAdxSku.ps1

Checks ADX SKU availability by region to help select the right SKU:

```powershell
# Example: Find best Dev SKU for Italy North
$result = .\Get-BestAdxSku.ps1 -Location "italynorth" -DeploymentConfiguration "minimal"
Write-Host "Best SKU: $($result.Sku)"
# Output: Dev(No SLA)_Standard_E2a_v4

# Example: Find best production SKU for East US 2
$result = .\Get-BestAdxSku.ps1 -Location "eastus2" -DeploymentConfiguration "waf-aligned"
Write-Host "Best SKU: $($result.Sku)"
# Output: Standard_E2d_v5
```

## Billing Account Types

Cost Management exports are **only supported** for certain billing account types:

| Billing Type | Export Support | Recommendation |
|--------------|---------------|----------------|
| Enterprise Agreement (EA) | ✅ Full | Use managed exports |
| Microsoft Customer Agreement (MCA) | ✅ Full | Use managed exports |
| Microsoft Partner Agreement (MPA) | ✅ Full | Partner manages exports |
| Pay-As-You-Go (PAYGO) | ❌ None | Use test data scripts |
| Free Trial | ❌ None | Use test data scripts |
| Visual Studio / MSDN | ❌ None | Use test data scripts |
| CSP (customer-side) | ❌ Limited | Partner provides data |

For unsupported billing types, use the test data generation scripts from the [Microsoft FinOps Toolkit](https://aka.ms/finops/toolkit) to populate the hub with test data.

## Data Flow Paths

The scripts support two data ingestion paths:

```
Path 1: Ingestion Container (Parquet) - Faster
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Test Script     │────▶│ ingestion/      │────▶│ ingestion_*     │
│ (Parquet)       │     │ container       │     │ pipeline        │
└─────────────────┘     └─────────────────┘     └─────────────────┘

Path 2: MSExports Container (CSV) - Full Pipeline Test
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Test Script     │────▶│ msexports/      │────▶│ msexports_*     │
│ (CSV)           │     │ container       │     │ pipeline        │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## Requirements

- **PowerShell 7.0+** (Core/Cross-platform)
- **Azure CLI** (authenticated)
- **Az PowerShell modules** (Az.Accounts, Az.Storage)
- Optional: Python with `pandas`, `pyarrow` (for Parquet generation)

## See Also

- [main.bicep](../main.bicep) - Bicep module for deployment
- [tests/](../tests/) - E2E test scenarios
- [FinOps Toolkit PowerShell](https://aka.ms/finops/powershell) - Official PowerShell module
