# FinOps Hub - Helper Scripts

This folder contains PowerShell scripts that help with deploying, testing, and managing FinOps Hub instances. These scripts are **not required** for deployment but provide enhanced functionality.

## Scripts Overview

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `Deploy-FinOpsHub.ps1` | Interactive deployment helper | When you want guided deployment with validation |
| `Test-FinOpsHub.ps1` | Generate and upload test data | After deployment to validate the pipeline |
| `Generate-MultiCloudTestData.ps1` | Multi-cloud FOCUS data generator | Testing multi-cloud scenarios (AWS, GCP, DC) |
| `Get-BestAdxSku.ps1` | ADX SKU availability checker | Before deployment to find available SKUs |

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

### Test-FinOpsHub.ps1

Validates the deployment by:
- **Generating realistic FOCUS test data** (~$10K monthly spend)
- **Handling storage firewall** (auto-adds your IP)
- **Granting RBAC permissions** (Storage Blob Data Contributor)
- **Uploading to correct container** (ingestion or msexports)
- **Verifying ADF trigger status**

```powershell
# Example: Quick test with defaults
.\Test-FinOpsHub.ps1 -StorageAccountName "stfinopshub123abc"

# Example: Larger test dataset
.\Test-FinOpsHub.ps1 -StorageAccountName "stfinopshub123abc" `
    -TargetMonthlySpend 50000 `
    -MonthsOfData 6
```

### Generate-MultiCloudTestData.ps1

Generates synthetic FOCUS-compliant cost data for:
- **Azure** (simulates Cost Management exports)
- **AWS** (Data Exports / CUR FOCUS format)
- **GCP** (BigQuery FOCUS export simulation)
- **Data Center** (on-premises infrastructure)

Features:
- Azure Hybrid Benefit simulation
- Reservations and Savings Plans
- Spot/Preemptible instances
- Marketplace charges
- FOCUS 1.0-1.3 compliance

```powershell
# Example: Generate all cloud providers, 3 months, $100K total
.\Generate-MultiCloudTestData.ps1

# Example: Generate and upload to Azure Storage
.\Generate-MultiCloudTestData.ps1 -Upload `
    -StorageAccountName "stfinopshub123abc" `
    -MonthsOfData 6 `
    -TotalBudget 500000

# Example: Generate only AWS data
.\Generate-MultiCloudTestData.ps1 -CloudProvider "AWS" `
    -FocusVersion "1.3" `
    -OutputFormat "Parquet"
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

For unsupported billing types, use `Test-FinOpsHub.ps1` or `Generate-MultiCloudTestData.ps1` to populate the hub with test data.

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
