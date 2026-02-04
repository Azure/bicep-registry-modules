<#
.SYNOPSIS
    Test FinOps Hub deployment with realistic sample data (~$10K monthly spend).

.DESCRIPTION
    Generates realistic FOCUS-aligned cost data for testing:
    - ~$10,000 USD monthly spend across Azure services
    - Full month of data with daily granularity
    - Variety of services, resources, and cost patterns
    - Proper FOCUS 1.0r2 schema compliance
    
    AUTOMATICALLY HANDLES:
    - Storage account network firewall (adds your IP, restores after)
    - RBAC permissions (grants Storage Blob Data Contributor)
    - ADF trigger validation (ensures triggers are running)
    - Correct container/path structure per FinOps Hub docs
    
    Uses INGESTION container for direct parquet ingestion (bypasses CSV transform).
    Per docs: Custom FOCUS parquet data goes to ingestion container.

.PARAMETER StorageAccountName
    Name of the FinOps Hub storage account.

.PARAMETER TargetMonthlySpend
    Target monthly spend in USD. Default: 10000

.PARAMETER MonthsOfData
    Number of months of historical data to generate. Default: 2

.PARAMETER SkipFirewallConfig
    Skip automatic firewall configuration (use if already allowed).

.EXAMPLE
    .\Test-FinOpsHub.ps1 -StorageAccountName "stfinopshub123abc"

.EXAMPLE
    .\Test-FinOpsHub.ps1 -StorageAccountName "stfinopshub123abc" -TargetMonthlySpend 50000 -MonthsOfData 3

.EXAMPLE
    # Test full pipeline with CSV (simulates Cost Management export)
    .\Test-FinOpsHub.ps1 -StorageAccountName "stfinopshub123abc" -UseMsExportsPath

.NOTES
    Export Availability:
    - Only EA and MCA accounts can create Cost Management exports
    - Pay-As-You-Go, Free Trial, CSP, Visual Studio accounts CANNOT export
    - This script enables testing for ALL account types
    
    Data Paths:
    - Default (Parquet to ingestion): Faster, bypasses CSV transform
    - UseMsExportsPath (CSV to msexports): Full pipeline test, simulates real exports
#>

param(
    [Parameter(Mandatory)]
    [string]$StorageAccountName,
    
    [double]$TargetMonthlySpend = 10000,
    
    [int]$MonthsOfData = 2,
    
    [switch]$SkipFirewallConfig,
    
    [switch]$UseMsExportsPath  # If set, generates CSV to msexports container (full pipeline test)
)

$ErrorActionPreference = "Stop"

$dataPath = if ($UseMsExportsPath) { "msexports (CSV)" } else { "ingestion (Parquet)" }

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "              FinOps Hub - Test Data Generation                       " -ForegroundColor Cyan
Write-Host "                   Target: ~`$$TargetMonthlySpend/month                " -ForegroundColor Cyan
Write-Host "                   Path: $dataPath                                     " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# STEP 1: VALIDATE ENVIRONMENT
# ============================================================================

Write-Host "STEP 1: Validating environment..." -ForegroundColor Yellow

# Check Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI is required. Install from: https://aka.ms/installazurecli"
}

$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "   Please login to Azure..." -ForegroundColor Yellow
    az login
    $account = az account show | ConvertFrom-Json
}
Write-Host "   OK - Subscription: $($account.name)" -ForegroundColor Green
Write-Host "   OK - User: $($account.user.name)" -ForegroundColor Green

$userObjectId = az ad signed-in-user show --query id -o tsv 2>$null
if (-not $userObjectId) {
    Write-Warning "   Could not determine user object ID (needed for RBAC). You may need to grant permissions manually."
}

# Check Python with pandas/pyarrow
$pythonOk = $false
try {
    $pythonCheck = python -c "import pandas; import pyarrow; print('ok')" 2>$null
    if ($pythonCheck -eq "ok") { $pythonOk = $true }
} catch {}

if (-not $pythonOk) {
    throw "Python with pandas and pyarrow is required. Install: pip install pandas pyarrow"
}
Write-Host "   OK - Python with pandas/pyarrow" -ForegroundColor Green

# ============================================================================
# STEP 2: CONFIGURE STORAGE ACCESS (Handles firewall + RBAC)
# ============================================================================

Write-Host ""
Write-Host "STEP 2: Configuring storage access..." -ForegroundColor Yellow

# Find storage account
$storageAccount = az storage account show --name $StorageAccountName 2>$null | ConvertFrom-Json
if (-not $storageAccount) {
    throw "Storage account '$StorageAccountName' not found in subscription '$($account.name)'"
}
$resourceGroup = $storageAccount.resourceGroup
$storageId = $storageAccount.id
Write-Host "   OK - Found storage account in RG: $resourceGroup" -ForegroundColor Green

# Track original firewall state for cleanup
$originalDefaultAction = $null
$addedIpRule = $null

if (-not $SkipFirewallConfig) {
    # Get current network rules
    $networkRules = az storage account show --name $StorageAccountName --query "networkRuleSet" 2>$null | ConvertFrom-Json
    $originalDefaultAction = $networkRules.defaultAction
    
    if ($networkRules.defaultAction -eq "Deny") {
        Write-Host "   Storage account has firewall enabled (defaultAction: Deny)" -ForegroundColor Yellow
        
        # Get current public IP
        try {
            $myIp = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -TimeoutSec 10).ip
            Write-Host "   Your IP: $myIp" -ForegroundColor Gray
            
            # Check if IP already allowed
            $ipAlreadyAllowed = $networkRules.ipRules | Where-Object { $_.ipAddressOrRange -eq $myIp }
            
            if (-not $ipAlreadyAllowed) {
                Write-Host "   Adding your IP to firewall allow list..." -ForegroundColor Yellow
                az storage account network-rule add --account-name $StorageAccountName --ip-address $myIp --only-show-errors
                $addedIpRule = $myIp
                
                # Wait for firewall rule to propagate
                Write-Host "   Waiting 15 seconds for firewall rule to propagate..." -ForegroundColor Gray
                Start-Sleep -Seconds 15
            } else {
                Write-Host "   Your IP is already in the allow list" -ForegroundColor Green
            }
        } catch {
            Write-Warning "   Could not determine your public IP. If uploads fail, manually add your IP to the storage firewall."
        }
    } else {
        Write-Host "   OK - Storage firewall allows public access" -ForegroundColor Green
    }
}

# Check/Grant RBAC permissions
Write-Host "   Checking RBAC permissions..." -ForegroundColor Gray

if ($userObjectId) {
    # Check for Storage Blob Data Contributor
    $roleAssignments = az role assignment list --assignee $userObjectId --scope $storageId --role "Storage Blob Data Contributor" 2>$null | ConvertFrom-Json
    
    if (-not $roleAssignments -or $roleAssignments.Count -eq 0) {
        Write-Host "   Granting 'Storage Blob Data Contributor' role..." -ForegroundColor Yellow
        az role assignment create `
            --assignee-object-id $userObjectId `
            --role "Storage Blob Data Contributor" `
            --scope $storageId `
            --only-show-errors
        
        Write-Host "   Waiting 30 seconds for RBAC to propagate..." -ForegroundColor Gray
        Start-Sleep -Seconds 30
    } else {
        Write-Host "   OK - You have Storage Blob Data Contributor role" -ForegroundColor Green
    }
}

# ============================================================================
# STEP 3: VERIFY ADF TRIGGERS ARE RUNNING
# ============================================================================

Write-Host ""
Write-Host "STEP 3: Verifying ADF triggers..." -ForegroundColor Yellow

# Find ADF in same resource group
$adfList = az datafactory list --resource-group $resourceGroup 2>$null | ConvertFrom-Json
if ($adfList -and $adfList.Count -gt 0) {
    $adfName = $adfList[0].name
    Write-Host "   Found ADF: $adfName" -ForegroundColor Gray
    
    # Check trigger status
    $triggers = az datafactory trigger list --factory-name $adfName --resource-group $resourceGroup 2>$null | ConvertFrom-Json
    $stoppedTriggers = $triggers | Where-Object { $_.properties.runtimeState -ne "Started" }
    
    if ($stoppedTriggers) {
        Write-Host "   Starting stopped triggers..." -ForegroundColor Yellow
        foreach ($trigger in $stoppedTriggers) {
            Write-Host "      Starting: $($trigger.name)" -ForegroundColor Gray
            az datafactory trigger start --factory-name $adfName --resource-group $resourceGroup --name $trigger.name --only-show-errors
        }
        Write-Host "   OK - All triggers started" -ForegroundColor Green
    } else {
        Write-Host "   OK - All triggers are running" -ForegroundColor Green
    }
} else {
    Write-Warning "   No ADF found in resource group. Ingestion triggers may not fire."
}

# ============================================================================
# STEP 4: GENERATE TEST DATA
# ============================================================================

Write-Host ""
Write-Host "STEP 4: Generating test data..." -ForegroundColor Yellow

$testDataDir = Join-Path $env:TEMP "finops-test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $testDataDir -Force | Out-Null

# Python script to generate realistic FOCUS 1.0r2 data
# Schema reference: https://learn.microsoft.com/cloud-computing/finops/focus/what-is-focus
# Dashboard reference: Uses BilledCost, ChargePeriodStart, ServiceName, ResourceId, etc.
$pythonScript = @"
import pandas as pd
import random
from datetime import datetime, timedelta
import sys
import os

output_dir = sys.argv[1]
target_monthly = float(sys.argv[2])
months = int(sys.argv[3])
subscription_id = sys.argv[4] if len(sys.argv) > 4 else "test-sub-id"

# Realistic Azure service distribution (based on typical enterprise patterns)
services = [
    # (ResourceType, ServiceName, ServiceCategory, AvgDailyBase, Variance, NumResources)
    ("Microsoft.Compute/virtualMachines", "Virtual Machines", "Compute", 120, 0.3, 8),
    ("Microsoft.Compute/disks", "Managed Disks", "Storage", 25, 0.1, 12),
    ("Microsoft.Storage/storageAccounts", "Storage Accounts", "Storage", 45, 0.4, 5),
    ("Microsoft.Sql/servers/databases", "SQL Database", "Databases", 180, 0.2, 3),
    ("Microsoft.ContainerService/managedClusters", "Azure Kubernetes Service", "Compute", 250, 0.25, 2),
    ("Microsoft.Web/sites", "App Service", "Compute", 60, 0.3, 6),
    ("Microsoft.Network/virtualNetworks", "Virtual Network", "Networking", 15, 0.1, 4),
    ("Microsoft.Network/loadBalancers", "Load Balancer", "Networking", 35, 0.15, 3),
    ("Microsoft.Network/applicationGateways", "Application Gateway", "Networking", 85, 0.2, 2),
    ("Microsoft.KeyVault/vaults", "Key Vault", "Security", 8, 0.2, 3),
    ("Microsoft.Insights/components", "Application Insights", "Management", 20, 0.5, 4),
    ("Microsoft.OperationalInsights/workspaces", "Log Analytics", "Management", 40, 0.4, 2),
    ("Microsoft.Cache/Redis", "Azure Cache for Redis", "Databases", 75, 0.15, 2),
    ("Microsoft.DocumentDB/databaseAccounts", "Cosmos DB", "Databases", 95, 0.3, 2),
    ("Microsoft.EventHub/namespaces", "Event Hubs", "Integration", 30, 0.35, 2),
    ("Microsoft.ServiceBus/namespaces", "Service Bus", "Integration", 25, 0.3, 2),
]

# Calculate scaling factor to hit target monthly spend
base_daily_total = sum(s[3] * s[5] for s in services)
days_per_month = 30
scale_factor = target_monthly / (base_daily_total * days_per_month)

# Resource group names for variety
resource_groups = ["rg-prod-eastus", "rg-prod-westeu", "rg-dev-eastus", "rg-staging", "rg-shared-services"]
regions = ["eastus", "westeurope", "westus2", "northeurope", "southeastasia"]
environments = ["Production", "Development", "Staging", "Shared"]

today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)

for month_offset in range(months):
    # Go back in time
    ref_date = today.replace(day=1) - timedelta(days=month_offset * 30)
    month_start = ref_date.replace(day=1)
    if month_offset == 0:
        # Current month - up to today
        month_end = today
    else:
        # Past months - full month
        next_month = (month_start + timedelta(days=32)).replace(day=1)
        month_end = next_month - timedelta(days=1)
    
    billing_period_end = (month_start + timedelta(days=32)).replace(day=1)
    
    all_data = []
    
    # Generate data for each day
    current_day = month_start
    while current_day <= month_end:
        for resource_type, service_name, service_category, base_cost, variance, num_resources in services:
            for res_idx in range(num_resources):
                # Daily cost with variance
                daily_cost = base_cost * scale_factor * (1 + random.uniform(-variance, variance))
                
                # Some resources have weekday patterns
                if service_category == "Compute" and current_day.weekday() >= 5:
                    daily_cost *= 0.3  # Less compute on weekends
                
                # Random spikes for realism
                if random.random() < 0.02:
                    daily_cost *= random.uniform(1.5, 3.0)
                
                rg = random.choice(resource_groups)
                region = random.choice(regions)
                env = random.choice(environments)
                
                resource_name = f"{service_name.lower().replace(' ', '-')}-{res_idx+1:02d}"
                resource_id = f"/subscriptions/{subscription_id}/resourceGroups/{rg}/providers/{resource_type}/{resource_name}"
                
                # Calculate different cost types
                billed_cost = round(daily_cost, 4)
                list_cost = round(billed_cost * 1.15, 4)  # 15% discount from list
                contracted_cost = round(billed_cost * 1.05, 4)  # 5% negotiated discount
                effective_cost = billed_cost  # No commitment discounts in test data
                
                row = {
                    # Billing columns
                    "BillingAccountId": "EA-12345678",
                    "BillingAccountName": "Contoso Enterprise Agreement",
                    "BillingCurrency": "USD",
                    "BillingPeriodStart": month_start.strftime("%Y-%m-%d"),
                    "BillingPeriodEnd": billing_period_end.strftime("%Y-%m-%d"),
                    
                    # Charge columns
                    "ChargeCategory": "Usage",
                    "ChargeClass": "Regular",
                    "ChargeDescription": f"{service_name} usage",
                    "ChargeFrequency": "Usage-Based",
                    "ChargePeriodStart": current_day.strftime("%Y-%m-%dT00:00:00Z"),
                    "ChargePeriodEnd": (current_day + timedelta(days=1)).strftime("%Y-%m-%dT00:00:00Z"),
                    
                    # Cost columns
                    "BilledCost": billed_cost,
                    "ContractedCost": contracted_cost,
                    "EffectiveCost": effective_cost,
                    "ListCost": list_cost,
                    
                    # Provider columns
                    "InvoiceIssuerName": "Microsoft",
                    "ProviderName": "Microsoft",
                    "PublisherName": "Microsoft",
                    
                    # Pricing columns
                    "PricingCategory": "On-Demand",
                    "PricingQuantity": round(random.uniform(1, 100), 2),
                    "PricingUnit": "Hours" if "Compute" in service_category else "GB" if "Storage" in service_category else "Units",
                    
                    # Resource columns
                    "RegionId": region,
                    "RegionName": region.replace("eastus", "East US").replace("westeurope", "West Europe").replace("westus2", "West US 2"),
                    "ResourceId": resource_id,
                    "ResourceName": resource_name,
                    "ResourceType": resource_type,
                    
                    # Service columns  
                    "ServiceCategory": service_category,
                    "ServiceName": service_name,
                    
                    # Sub account (subscription)
                    "SubAccountId": subscription_id,
                    "SubAccountName": f"Azure {env}",
                    
                    # Tags
                    "Tags": f'{{"Environment":"{env}","CostCenter":"IT-{random.randint(1000,9999)}"}}',
                    
                    # Usage columns
                    "UsageQuantity": round(random.uniform(1, 100), 2),
                    "UsageUnit": "Hours" if "Compute" in service_category else "GB" if "Storage" in service_category else "Units",
                    
                    # FinOps Hub metadata
                    "x_SourceName": "FinOps Hub Test Data",
                    "x_SourceProvider": "Microsoft",
                    "x_SourceType": "FocusExport",
                    "x_SourceVersion": "1.0r2",
                }
                all_data.append(row)
        
        current_day += timedelta(days=1)
    
    # Write output file for this month
    df = pd.DataFrame(all_data)
    month_str = month_start.strftime("%Y-%m")
    
    # Check if we should output CSV (for msexports) or Parquet (for ingestion)
    output_format = sys.argv[5] if len(sys.argv) > 5 else "parquet"
    
    if output_format == "csv":
        output_file = os.path.join(output_dir, f"costs_{month_str}.csv.gz")
        df.to_csv(output_file, index=False, compression='gzip')
    else:
        output_file = os.path.join(output_dir, f"costs_{month_str}.parquet")
        df.to_parquet(output_file, index=False, compression='snappy')
    
    total_cost = df["BilledCost"].sum()
    print(f"Generated {month_str}: {len(df)} rows, USD {total_cost:,.2f} total spend ({output_format})")

print("Done!")
"@

$pythonScriptPath = Join-Path $testDataDir "generate.py"
$pythonScript | Set-Content $pythonScriptPath -Encoding utf8

# Determine output format based on path
$outputFormat = if ($UseMsExportsPath) { "csv" } else { "parquet" }

# Run Python script
python $pythonScriptPath $testDataDir $TargetMonthlySpend $MonthsOfData $account.id $outputFormat

if ($LASTEXITCODE -ne 0) {
    throw "Failed to generate test data"
}

# ============================================================================
# STEP 5: UPLOAD TO STORAGE
# Two paths based on documentation:
# - msexports: CSV files simulating Cost Management exports (full pipeline test)
# - ingestion: Parquet files for direct ADX ingestion (faster, custom data)
# ============================================================================

Write-Host ""
Write-Host "STEP 5: Uploading to storage..." -ForegroundColor Yellow

$runId = [guid]::NewGuid().ToString().Substring(0, 8)
$exportTime = Get-Date -Format "yyyyMMddHHmm"

if ($UseMsExportsPath) {
    # ============================================================================
    # MSEXPORTS PATH: CSV files simulating Cost Management exports
    # Path: msexports/{scope-path}/{export-name}/{date-range}/{export-time}/{guid}/{file}
    # ============================================================================
    
    $dataFiles = Get-ChildItem -Path $testDataDir -Filter "*.csv.gz"
    $scopePath = "subscriptions/$($account.id)"
    $exportName = "FinOpsHubTest"
    
    $uploadSuccess = $true
    foreach ($file in $dataFiles) {
        $monthMatch = [regex]::Match($file.Name, 'costs_(\d{4})-(\d{2})\.csv\.gz')
        if ($monthMatch.Success) {
            $year = $monthMatch.Groups[1].Value
            $month = $monthMatch.Groups[2].Value
            
            # Calculate date range for this month
            $startDate = "${year}${month}01"
            $lastDay = [DateTime]::DaysInMonth([int]$year, [int]$month)
            $endDate = "${year}${month}${lastDay}"
            $dateRange = "${startDate}-${endDate}"
            
            # msexports path format matching Cost Management
            $blobPath = "$scopePath/$exportName/$dateRange/$exportTime/$runId/$($file.Name)"
            
            Write-Host "   Uploading: $($file.Name) -> msexports/$blobPath" -ForegroundColor Gray
            
            $result = az storage blob upload `
                --account-name $StorageAccountName `
                --auth-mode login `
                --container-name msexports `
                --file $file.FullName `
                --name $blobPath `
                --overwrite `
                --only-show-errors 2>&1
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "   FAILED: $result" -ForegroundColor Red
                $uploadSuccess = $false
            }
        }
    }
    
    if (-not $uploadSuccess) {
        throw "Failed to upload test data"
    }
    
    Write-Host "   OK - Uploaded $($dataFiles.Count) CSV files to msexports" -ForegroundColor Green
    
    # Create manifest.json for each month (required for msexports trigger)
    Write-Host ""
    Write-Host "STEP 6: Creating export manifests..." -ForegroundColor Yellow
    
    foreach ($file in $dataFiles) {
        $monthMatch = [regex]::Match($file.Name, 'costs_(\d{4})-(\d{2})\.csv\.gz')
        if ($monthMatch.Success) {
            $year = $monthMatch.Groups[1].Value
            $month = $monthMatch.Groups[2].Value
            
            $startDate = "${year}${month}01"
            $lastDay = [DateTime]::DaysInMonth([int]$year, [int]$month)
            $endDate = "${year}${month}${lastDay}"
            $dateRange = "${startDate}-${endDate}"
            
            # Cost Management manifest format (API version 2023-07-01-preview)
            $manifest = @{
                manifestVersion = "2024-04-01"
                dataFormat = "csv"
                blobCount = 1
                byteCount = $file.Length
                compressData = $true
                eTag = "`"$([guid]::NewGuid().ToString())`""
                createdTime = (Get-Date).ToString("o")
                exportConfig = @{
                    resourceId = "/subscriptions/$($account.id)"
                    type = "FocusCost"
                    dataVersion = "1.0r2"
                }
                runInfo = @{
                    runId = $runId
                    startDate = "${year}-${month}-01T00:00:00Z"
                    endDate = (Get-Date "${year}-${month}-01").AddMonths(1).ToString("yyyy-MM-ddT00:00:00Z")
                    runType = "OnDemand"
                }
                blobs = @(
                    @{
                        blobName = $file.Name
                        byteCount = $file.Length
                    }
                )
            } | ConvertTo-Json -Depth 5
            
            $manifestPath = Join-Path $testDataDir "manifest_$year-$month.json"
            $manifest | Set-Content $manifestPath -Encoding utf8
            
            $manifestBlobPath = "$scopePath/$exportName/$dateRange/$exportTime/$runId/manifest.json"
            
            az storage blob upload `
                --account-name $StorageAccountName `
                --auth-mode login `
                --container-name msexports `
                --file $manifestPath `
                --name $manifestBlobPath `
                --overwrite `
                --only-show-errors
            
            Write-Host "   OK - Created manifest for $year-$month (triggers msexports_ExecuteETL)" -ForegroundColor Green
        }
    }
    
    $containerUsed = "msexports"
    $triggerName = "msexports_ManifestAdded"
    $pipelineName = "msexports_ExecuteETL -> msexports_ETL_ingestion"
    
} else {
    # ============================================================================
    # INGESTION PATH: Parquet files for direct ADX ingestion
    # Path: {dataset}/{yyyy}/{mm}/{scope-path}/{ingestion-id}__{filename}.parquet
    # ============================================================================
    
    $dataFiles = Get-ChildItem -Path $testDataDir -Filter "*.parquet"
    $scopePath = "subscriptions/$($account.id)/test-data"
    
    $uploadSuccess = $true
    foreach ($file in $dataFiles) {
        $monthMatch = [regex]::Match($file.Name, 'costs_(\d{4})-(\d{2})\.parquet')
        if ($monthMatch.Success) {
            $year = $monthMatch.Groups[1].Value
            $month = $monthMatch.Groups[2].Value
            
            # ingestion path format for custom FOCUS data
            $blobPath = "Costs/$year/$month/$scopePath/${runId}__$($file.Name)"
            
            Write-Host "   Uploading: $($file.Name) -> ingestion/$blobPath" -ForegroundColor Gray
            
            $result = az storage blob upload `
                --account-name $StorageAccountName `
                --auth-mode login `
                --container-name ingestion `
                --file $file.FullName `
                --name $blobPath `
                --overwrite `
                --only-show-errors 2>&1
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "   FAILED: $result" -ForegroundColor Red
                $uploadSuccess = $false
            }
        }
    }
    
    if (-not $uploadSuccess) {
        throw "Failed to upload test data"
    }
    
    Write-Host "   OK - Uploaded $($dataFiles.Count) parquet files to ingestion" -ForegroundColor Green
    
    # Create manifest.json for each month to trigger ingestion
    Write-Host ""
    Write-Host "STEP 6: Triggering ingestion pipeline..." -ForegroundColor Yellow
    
    foreach ($file in $dataFiles) {
        $monthMatch = [regex]::Match($file.Name, 'costs_(\d{4})-(\d{2})\.parquet')
        if ($monthMatch.Success) {
            $year = $monthMatch.Groups[1].Value
            $month = $monthMatch.Groups[2].Value
            
            # Empty manifest.json triggers the ingestion_ManifestAdded pipeline
            $manifest = @{
                description = "FinOps Hub Test Data - Trigger file"
                createdTime = (Get-Date).ToString("o")
                source = "Test-FinOpsHub.ps1"
            } | ConvertTo-Json
            
            $manifestPath = Join-Path $testDataDir "manifest_$year-$month.json"
            $manifest | Set-Content $manifestPath -Encoding utf8
            
            $manifestBlobPath = "Costs/$year/$month/$scopePath/manifest.json"
            
            az storage blob upload `
                --account-name $StorageAccountName `
                --auth-mode login `
                --container-name ingestion `
                --file $manifestPath `
                --name $manifestBlobPath `
                --overwrite `
                --only-show-errors
            
            Write-Host "   OK - Triggered ingestion for $year-$month" -ForegroundColor Green
        }
    }
    
    $containerUsed = "ingestion"
    $triggerName = "ingestion_ManifestAdded"
    $pipelineName = "ingestion_ExecuteETL -> ingestion_ETL_dataExplorer"
}

# ============================================================================
# STEP 7: CLEANUP (Restore firewall if we modified it)
# ============================================================================

if ($addedIpRule) {
    Write-Host ""
    Write-Host "STEP 7: Restoring storage firewall..." -ForegroundColor Yellow
    az storage account network-rule remove --account-name $StorageAccountName --ip-address $addedIpRule --only-show-errors
    Write-Host "   OK - Removed your IP from firewall allow list" -ForegroundColor Green
}

# Cleanup temp files
Remove-Item $testDataDir -Recurse -Force

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "                    Test Data Uploaded!                               " -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "   Storage Account: $StorageAccountName"
Write-Host "   Container:       $containerUsed"
Write-Host "   Target Spend:    ~`$$TargetMonthlySpend per month"
Write-Host "   Months:          $MonthsOfData"
Write-Host ""
Write-Host "Pipeline Flow:" -ForegroundColor Yellow
Write-Host "   1. Trigger: $triggerName"
Write-Host "   2. Pipeline: $pipelineName"
Write-Host "   3. Update policy copies to Costs_final_v1_0 via transform function"
Write-Host "   4. Dashboard reads from Hub.Costs() function"
Write-Host ""
Write-Host "Verification commands:" -ForegroundColor Yellow
Write-Host "   # Check pipeline runs (should see ingestion_ExecuteETL):"
Write-Host "   az datafactory pipeline-run query-by-factory --factory-name <adf-name> --resource-group $resourceGroup --last-updated-after `"$(Get-Date (Get-Date).AddHours(-1) -Format 'o')`""
Write-Host ""
Write-Host "   # Check data in ADX:"
Write-Host "   Costs_raw | count"
Write-Host "   Costs() | summarize sum(BilledCost) by bin(ChargePeriodStart, 1d) | order by ChargePeriodStart desc"
Write-Host ""
