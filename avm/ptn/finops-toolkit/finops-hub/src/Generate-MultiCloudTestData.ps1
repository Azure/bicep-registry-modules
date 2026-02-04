<#
.SYNOPSIS
    Generates multi-cloud FOCUS-compliant test data for FinOps Hub validation.

.DESCRIPTION
    This script generates synthetic cost data in FOCUS 1.0-1.3 format for:
    - Azure (Cost Management Managed Exports simulation)
    - AWS (Data Exports / CUR FOCUS format)
    - GCP (BigQuery FOCUS export simulation)
    - Data Center (On-premises infrastructure)

    The generated data can be uploaded to Azure Storage for FinOps Hub ingestion testing.
    
    Features:
    - Azure Hybrid Benefit simulation
    - Azure Marketplace charges
    - Reservations and Savings Plans (commitment discounts)
    - Spot/Preemptible instances (60-90% discounts)
    - Realistic weighted service distribution

.PARAMETER OutputPath
    Directory to save generated files. Default: ./test-data

.PARAMETER CloudProvider
    Which cloud provider data to generate. Options: Azure, AWS, GCP, DataCenter, All
    Default: All

.PARAMETER MonthsOfData
    Number of months of historical data to generate, ending at today.
    Default: 3 (generates 3 months ending today)

.PARAMETER StartDate
    Start date for generated data. Overrides MonthsOfData if specified.

.PARAMETER EndDate
    End date for generated data. Default: Today

.PARAMETER DailyRowCount
    Approximate number of rows per day. Default: 100

.PARAMETER TotalBudget
    Target total cost in USD for all generated data. Default: 100000 ($100K)
    Costs are scaled proportionally to achieve this target.

.PARAMETER FocusVersion
    FOCUS specification version. Options: 1.0, 1.1, 1.2, 1.3
    Default: 1.3

.PARAMETER OutputFormat
    Output file format. Options: Parquet, CSV, Both
    Default: Parquet

.PARAMETER StorageAccountName
    Azure Storage account name for upload.

.PARAMETER Upload
    Upload generated files to Azure Storage.

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1
    # Generates 3 months of data for all providers, $100K total budget

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1 -MonthsOfData 6 -TotalBudget 500000
    # Generates 6 months of data, $500K total budget

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "mystorageaccount"
    # Generates and uploads data to storage account

.NOTES
    FOCUS Specification Reference: https://focus.finops.org/focus-specification/v1-3/
    
    Author: FinOps Hub Team
    Version: 1.0.0
#>

[CmdletBinding()]
param(
    [string]$OutputPath = "./test-data",
    
    [ValidateSet("Azure", "AWS", "GCP", "DataCenter", "All")]
    [string]$CloudProvider = "All",
    
    [int]$MonthsOfData = 3,
    
    [datetime]$StartDate,
    
    [datetime]$EndDate = (Get-Date),
    
    [int]$DailyRowCount = 100,
    
    [decimal]$TotalBudget = 100000,
    
    [ValidateSet("1.0", "1.1", "1.2", "1.3")]
    [string]$FocusVersion = "1.3",
    
    [ValidateSet("Parquet", "CSV", "Both")]
    [string]$OutputFormat = "Parquet",
    
    [string]$StorageAccountName,
    
    [switch]$Upload
)

# Calculate StartDate from MonthsOfData if not explicitly provided
if (-not $PSBoundParameters.ContainsKey('StartDate')) {
    # Start from the first day of the month, MonthsOfData months ago
    $StartDate = (Get-Date -Day 1).AddMonths(-$MonthsOfData + 1)
}

# Ensure EndDate is today (fill up to current date)
if ($EndDate -gt (Get-Date)) {
    $EndDate = Get-Date
}

# ============================================================================
# FOCUS Column Definitions (v1.3)
# ============================================================================

# Mandatory FOCUS columns for Cost and Usage dataset
$MandatoryColumns = @(
    "BilledCost",
    "BillingAccountId",
    "BillingAccountName",
    "BillingCurrency",
    "BillingPeriodEnd",
    "BillingPeriodStart",
    "ChargeCategory",
    "ChargeClass",
    "ChargeDescription",
    "ChargePeriodEnd",
    "ChargePeriodStart",
    "ContractedCost",
    "EffectiveCost",
    "InvoiceIssuerName",
    "ListCost",
    "PricingQuantity",
    "PricingUnit",
    "ServiceProviderName"  # New in 1.3, replaces ProviderName
)

# Conditional/Recommended FOCUS columns
$ConditionalColumns = @(
    "AvailabilityZone",
    "ChargeFrequency",
    "CommitmentDiscountCategory",
    "CommitmentDiscountId",
    "CommitmentDiscountName",
    "CommitmentDiscountQuantity",
    "CommitmentDiscountStatus",
    "CommitmentDiscountType",
    "CommitmentDiscountUnit",
    "ConsumedQuantity",
    "ConsumedUnit",
    "ContractedUnitPrice",
    "HostProviderName",  # New in 1.3
    "InvoiceId",
    "ListUnitPrice",
    "PricingCategory",
    "RegionId",
    "RegionName",
    "ResourceId",
    "ResourceName",
    "ResourceType",
    "ServiceCategory",
    "ServiceName",
    "ServiceSubcategory",
    "SkuId",
    "SkuPriceId",
    "SubAccountId",
    "SubAccountName",
    "SubAccountType",
    "Tags"
)

# ============================================================================
# Provider-Specific Configuration
# ============================================================================

# ============================================================================
# Realistic Cost Distribution Configuration
# Weight = probability of selection (higher = more rows)
# CostMin/CostMax = daily cost range per resource in USD
# This creates realistic cloud spend patterns where Compute dominates
# ============================================================================

$ProviderConfigs = @{
    Azure = @{
        ServiceProviderName = "Microsoft"
        InvoiceIssuerName = "Microsoft"
        HostProviderName = "Microsoft"
        BillingAccountType = "Billing Profile"
        SubAccountType = "Subscription"
        Regions = @(
            @{ Id = "swedencentral"; Name = "Sweden Central" },
            @{ Id = "westeurope"; Name = "West Europe" },
            @{ Id = "eastus"; Name = "East US" },
            @{ Id = "westus2"; Name = "West US 2" }
        )
        # Services with weighted distribution and realistic cost ranges
        # Weight: Higher = more frequent, CostMin/CostMax: Daily cost per resource
        Services = @(
            @{ Name = "Virtual Machines"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000 },
            @{ Name = "Azure Kubernetes Service"; Category = "Compute"; Subcategory = "Containers"; Weight = 20; CostMin = 100; CostMax = 3000 },
            @{ Name = "Azure SQL Database"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 800 },
            @{ Name = "Cosmos DB"; Category = "Databases"; Subcategory = "NoSQL Databases"; Weight = 8; CostMin = 20; CostMax = 500 },
            @{ Name = "Storage"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 10; CostMin = 5; CostMax = 200 },
            @{ Name = "Azure Data Explorer"; Category = "Analytics"; Subcategory = "Analytics Platforms"; Weight = 5; CostMin = 50; CostMax = 600 },
            @{ Name = "App Service"; Category = "Compute"; Subcategory = "Web Apps"; Weight = 4; CostMin = 10; CostMax = 300 },
            @{ Name = "Key Vault"; Category = "Security"; Subcategory = "Key Management"; Weight = 2; CostMin = 1; CostMax = 50 },
            @{ Name = "Virtual Network"; Category = "Networking"; Subcategory = "Virtual Networks"; Weight = 2; CostMin = 5; CostMax = 100 },
            @{ Name = "Azure Functions"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 2; CostMin = 0.10; CostMax = 30 },
            @{ Name = "Azure Marketplace"; Category = "Marketplace"; Subcategory = "Third Party"; Weight = 5; CostMin = 10; CostMax = 500; IsMarketplace = $true }
        )
        ResourceTypes = @("microsoft.compute/virtualmachines", "microsoft.storage/storageaccounts", "microsoft.sql/servers", "microsoft.kusto/clusters", "microsoft.containerservice/managedclusters", "microsoft.documentdb/databaseaccounts", "microsoft.web/sites", "microsoft.keyvault/vaults", "microsoft.network/virtualnetworks")
        BillingCurrency = "USD"
    }
    AWS = @{
        ServiceProviderName = "Amazon Web Services"
        InvoiceIssuerName = "Amazon Web Services"
        HostProviderName = "Amazon Web Services"
        BillingAccountType = "Management Account"
        SubAccountType = "Member Account"
        Regions = @(
            @{ Id = "us-east-1"; Name = "US East (N. Virginia)" },
            @{ Id = "us-west-2"; Name = "US West (Oregon)" },
            @{ Id = "eu-west-1"; Name = "Europe (Ireland)" },
            @{ Id = "ap-southeast-1"; Name = "Asia Pacific (Singapore)" }
        )
        # Services with weighted distribution and realistic cost ranges
        Services = @(
            @{ Name = "Amazon EC2"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000 },
            @{ Name = "Amazon EKS"; Category = "Compute"; Subcategory = "Containers"; Weight = 18; CostMin = 100; CostMax = 2500 },
            @{ Name = "Amazon RDS"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 800 },
            @{ Name = "Amazon S3"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 12; CostMin = 5; CostMax = 300 },
            @{ Name = "Amazon Redshift"; Category = "Analytics"; Subcategory = "Data Warehouses"; Weight = 8; CostMin = 50; CostMax = 1000 },
            @{ Name = "Amazon DynamoDB"; Category = "Databases"; Subcategory = "NoSQL Databases"; Weight = 6; CostMin = 10; CostMax = 400 },
            @{ Name = "Amazon CloudFront"; Category = "Networking"; Subcategory = "Content Delivery"; Weight = 4; CostMin = 5; CostMax = 150 },
            @{ Name = "AWS Lambda"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 3; CostMin = 0.10; CostMax = 30 },
            @{ Name = "Amazon SQS"; Category = "Integration"; Subcategory = "Messaging"; Weight = 2; CostMin = 0.50; CostMax = 20 }
        )
        ResourceTypes = @("AWS::EC2::Instance", "AWS::S3::Bucket", "AWS::RDS::DBInstance", "AWS::EKS::Cluster", "AWS::DynamoDB::Table", "AWS::Lambda::Function")
        BillingCurrency = "USD"
    }
    GCP = @{
        ServiceProviderName = "Google Cloud"
        InvoiceIssuerName = "Google Cloud"
        HostProviderName = "Google Cloud"
        BillingAccountType = "Billing Account"
        SubAccountType = "Project"
        Regions = @(
            @{ Id = "us-central1"; Name = "Iowa" },
            @{ Id = "us-east1"; Name = "South Carolina" },
            @{ Id = "europe-west1"; Name = "Belgium" },
            @{ Id = "asia-east1"; Name = "Taiwan" }
        )
        # Services with weighted distribution and realistic cost ranges
        Services = @(
            @{ Name = "Compute Engine"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000 },
            @{ Name = "Google Kubernetes Engine"; Category = "Compute"; Subcategory = "Containers"; Weight = 20; CostMin = 100; CostMax = 2500 },
            @{ Name = "Cloud SQL"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 700 },
            @{ Name = "Cloud Storage"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 12; CostMin = 5; CostMax = 250 },
            @{ Name = "BigQuery"; Category = "Analytics"; Subcategory = "Data Warehouses"; Weight = 10; CostMin = 20; CostMax = 800 },
            @{ Name = "Cloud Spanner"; Category = "Databases"; Subcategory = "Distributed Databases"; Weight = 5; CostMin = 50; CostMax = 500 },
            @{ Name = "Cloud Run"; Category = "Compute"; Subcategory = "Serverless Containers"; Weight = 3; CostMin = 5; CostMax = 100 },
            @{ Name = "Cloud Functions"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 3; CostMin = 0.10; CostMax = 30 }
        )
        ResourceTypes = @("compute.googleapis.com/Instance", "storage.googleapis.com/Bucket", "sql.googleapis.com/Instance", "container.googleapis.com/Cluster", "bigquery.googleapis.com/Dataset")
        BillingCurrency = "USD"
    }
    DataCenter = @{
        ServiceProviderName = "Internal IT"
        InvoiceIssuerName = "Internal IT"
        HostProviderName = "On-Premises"
        BillingAccountType = "Cost Center"
        SubAccountType = "Business Unit"
        Regions = @(
            @{ Id = "dc-us-east"; Name = "US East Data Center" },
            @{ Id = "dc-eu-west"; Name = "EU West Data Center" },
            @{ Id = "dc-apac"; Name = "APAC Data Center" }
        )
        # Services with weighted distribution for on-prem infrastructure
        Services = @(
            @{ Name = "Physical Servers"; Category = "Compute"; Subcategory = "Bare Metal"; Weight = 30; CostMin = 200; CostMax = 5000 },
            @{ Name = "VMware vSphere"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 25; CostMin = 100; CostMax = 2000 },
            @{ Name = "Oracle Database"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 15; CostMin = 500; CostMax = 10000 },
            @{ Name = "SAN Storage"; Category = "Storage"; Subcategory = "Block Storage"; Weight = 12; CostMin = 50; CostMax = 1500 },
            @{ Name = "Network Infrastructure"; Category = "Networking"; Subcategory = "Network Infrastructure"; Weight = 10; CostMin = 20; CostMax = 500 },
            @{ Name = "Facility Costs"; Category = "Other"; Subcategory = "Other"; Weight = 8; CostMin = 100; CostMax = 800 }
        )
        ResourceTypes = @("server/physical", "storage/san", "database/oracle", "virtualization/vmware")
        BillingCurrency = "USD"
    }
}

# ============================================================================
# Helper Functions
# ============================================================================

function Get-RandomGuid {
    return [guid]::NewGuid().ToString()
}

function Get-RandomDecimal {
    param(
        [decimal]$Min = 0.01,
        [decimal]$Max = 100.00
    )
    return [math]::Round($Min + (Get-Random -Maximum ([int](($Max - $Min) * 100))) / 100, 10)
}

function Get-RandomElement {
    param([array]$Array)
    return $Array[(Get-Random -Maximum $Array.Count)]
}

# Weighted random selection for realistic cost distribution
# Services with higher weights appear more frequently in the data
function Get-WeightedRandomService {
    param([array]$Services)
    
    # Calculate total weight
    $totalWeight = ($Services | ForEach-Object { 
        if ($_.Weight) { $_.Weight } else { 1 } 
    } | Measure-Object -Sum).Sum
    
    # Pick a random number between 0 and total weight
    $randomValue = Get-Random -Maximum $totalWeight
    
    # Find the service that matches this weight
    $cumulative = 0
    foreach ($service in $Services) {
        $weight = if ($service.Weight) { $service.Weight } else { 1 }
        $cumulative += $weight
        if ($randomValue -lt $cumulative) {
            return $service
        }
    }
    
    # Fallback to last service
    return $Services[-1]
}

function Get-IsoDateTime {
    param([datetime]$Date)
    return $Date.ToString("yyyy-MM-ddTHH:mm:ssZ")
}

function New-FocusRow {
    param(
        [string]$Provider,
        [datetime]$ChargeDate,
        [hashtable]$Config,
        [switch]$IncludeCommitments,
        [switch]$IncludeHybridBenefit
    )
    
    # Use weighted selection for realistic service distribution
    $service = Get-WeightedRandomService -Services $Config.Services
    $region = Get-RandomElement -Array $Config.Regions
    $resourceType = Get-RandomElement -Array $Config.ResourceTypes
    
    # Generate costs using service-specific ranges for realistic differentiation
    # Services like VMs and Kubernetes have higher costs than Functions or Storage
    $costMin = if ($service.CostMin) { $service.CostMin } else { 0.10 }
    $costMax = if ($service.CostMax) { $service.CostMax } else { 500.00 }
    $listCost = Get-RandomDecimal -Min $costMin -Max $costMax
    $contractedCost = [math]::Round($listCost * (Get-Random -Minimum 70 -Maximum 100) / 100, 10)
    $billedCost = [math]::Round($contractedCost * (Get-Random -Minimum 95 -Maximum 100) / 100, 10)
    $effectiveCost = $billedCost  # Same for usage without amortization
    
    $pricingQuantity = Get-RandomDecimal -Min 1 -Max 1000
    $consumedQuantity = $pricingQuantity
    
    $chargePeriodStart = $ChargeDate.Date
    $chargePeriodEnd = $ChargeDate.Date.AddDays(1)
    $billingPeriodStart = [datetime]::new($ChargeDate.Year, $ChargeDate.Month, 1)
    $billingPeriodEnd = $billingPeriodStart.AddMonths(1)
    
    # Determine charge category
    $chargeCategory = Get-RandomElement -Array @("Usage", "Usage", "Usage", "Usage", "Purchase")
    
    # === COMMITMENT DISCOUNT SIMULATION ===
    $commitmentDiscountId = $null
    $commitmentDiscountName = $null
    $commitmentDiscountCategory = $null
    $commitmentDiscountType = $null
    $commitmentDiscountStatus = $null
    $commitmentDiscountQuantity = $null
    $commitmentDiscountUnit = $null
    
    # 30% chance of commitment-covered usage (Azure only for now)
    if ($IncludeCommitments -and $Provider -eq "Azure" -and $chargeCategory -eq "Usage" -and (Get-Random -Maximum 100) -lt 30) {
        $commitmentType = Get-RandomElement -Array @("Reservation", "SavingsPlan")
        $commitmentDiscountId = "/providers/Microsoft.Capacity/$commitmentType/$(Get-RandomGuid)"
        $commitmentDiscountName = "$commitmentType-$(Get-Random -Minimum 1000 -Maximum 9999)"
        $commitmentDiscountCategory = if ($commitmentType -eq "Reservation") { "Spend" } else { "Usage" }
        $commitmentDiscountType = $commitmentType
        
        # 85% utilization - most are Used, some are Unused
        if ((Get-Random -Maximum 100) -lt 85) {
            $commitmentDiscountStatus = "Used"
            # Committed usage gets significant discount
            $effectiveCost = [math]::Round($listCost * 0.40, 10)  # 60% savings
            $billedCost = 0  # Prepaid
        } else {
            $commitmentDiscountStatus = "Unused"
            $effectiveCost = [math]::Round($listCost * 0.60, 10)  # Wasted commitment
            $billedCost = $effectiveCost
        }
        
        $commitmentDiscountQuantity = $pricingQuantity
        $commitmentDiscountUnit = "Hours"
    }
    
    # === AZURE HYBRID BENEFIT SIMULATION ===
    $x_SkuMeterCategory = $null
    $x_SkuMeterName = $null
    $x_HybridBenefitType = $null
    $skuCores = $null
    
    if ($IncludeHybridBenefit -and $Provider -eq "Azure" -and $resourceType -eq "microsoft.compute/virtualmachines") {
        # 40% of VMs use Hybrid Benefit
        if ((Get-Random -Maximum 100) -lt 40) {
            $x_HybridBenefitType = Get-RandomElement -Array @("Windows_Server", "Windows_Client", "SUSE_Linux", "RHEL_Linux")
            $x_SkuMeterCategory = "Virtual Machines Licenses"
            $x_SkuMeterName = "$x_HybridBenefitType License"
            $skuCores = Get-RandomElement -Array @(2, 4, 8, 16, 32, 64)
            
            # AHUB provides license cost savings (typically 40-50% of compute cost)
            $licenseSavings = [math]::Round($listCost * 0.45, 10)
            $effectiveCost = [math]::Round($effectiveCost - $licenseSavings, 10)
            if ($effectiveCost -lt 0) { $effectiveCost = 0 }
        }
    }
    
    # === SPOT INSTANCE SIMULATION ===
    # Spot instances offer up to 90% discount but can be evicted
    $pricingCategory = "Standard"
    $x_PricingSubcategory = $null
    $isSpotInstance = $false
    
    # Spot available for VMs, Containers, and similar compute services (not commitment-covered)
    $spotEligibleServices = @("Virtual Machines", "Azure Kubernetes Service", "Amazon EC2", "Amazon EKS", "Compute Engine", "Google Kubernetes Engine", "VMware vSphere")
    if ($chargeCategory -eq "Usage" -and $null -eq $commitmentDiscountId -and $service.Name -in $spotEligibleServices) {
        # 15% of eligible compute usage is Spot
        if ((Get-Random -Maximum 100) -lt 15) {
            $isSpotInstance = $true
            $pricingCategory = "Spot"
            $x_PricingSubcategory = switch ($Provider) {
                "Azure" { "Spot VM" }
                "AWS" { "Spot Instance" }
                "GCP" { "Preemptible VM" }
                default { "Spot" }
            }
            
            # Spot provides 60-90% discount
            $spotDiscount = Get-Random -Minimum 60 -Maximum 90
            $effectiveCost = [math]::Round($listCost * (100 - $spotDiscount) / 100, 10)
            $billedCost = $effectiveCost
            $contractedCost = $effectiveCost
        }
    }
    
    # Build resource ID based on provider
    $resourceId = switch ($Provider) {
        "Azure" { "/subscriptions/$(Get-RandomGuid)/resourceGroups/rg-test/providers/$resourceType/$((Get-RandomGuid).Substring(0,8))" }
        "AWS" { "arn:aws:$(($resourceType -split '::')[1].ToLower()):$($region.Id):123456789012:instance/i-$((Get-RandomGuid).Substring(0,8))" }
        "GCP" { "//$(($resourceType -split '/')[0])/projects/test-project/zones/$($region.Id)-a/instances/vm-$((Get-RandomGuid).Substring(0,8))" }
        "DataCenter" { "dc://$($region.Id)/$resourceType/$((Get-RandomGuid).Substring(0,8))" }
    }
    
    # Build sub account ID
    $subAccountId = switch ($Provider) {
        "Azure" { (Get-RandomGuid) }
        "AWS" { "$(Get-Random -Minimum 100000000000 -Maximum 999999999999)" }
        "GCP" { "test-project-$(Get-Random -Minimum 1000 -Maximum 9999)" }
        "DataCenter" { "BU-$(Get-Random -Minimum 100 -Maximum 999)" }
    }
    
    # Generate tags as JSON - include FinOps Hub tags for Data Ingestion dashboard
    $hubResourceParent = "/subscriptions/$(Get-RandomGuid)/resourceGroups/rg-finops-hub/providers/Microsoft.Storage/storageAccounts/stfinopshub$(Get-Random -Minimum 1000 -Maximum 9999)"
    $tags = @{
        "environment" = Get-RandomElement -Array @("production", "staging", "development", "test")
        "costCenter" = "CC-$(Get-Random -Minimum 1000 -Maximum 9999)"
        "application" = Get-RandomElement -Array @("web-app", "api-service", "data-pipeline", "analytics", "backend")
        "owner" = Get-RandomElement -Array @("team-alpha", "team-beta", "platform", "data-team", "infra")
        # FinOps Hub tags for Data Ingestion dashboard
        "ftk-tool" = "FinOps hubs"
        "ftk-version" = "0.8.0"
        "cm-resource-parent" = $hubResourceParent
    } | ConvertTo-Json -Compress
    
    return [PSCustomObject]@{
        # Mandatory columns
        BilledCost = $billedCost
        BillingAccountId = "BA-$(Get-Random -Minimum 10000 -Maximum 99999)"
        BillingAccountName = "$Provider Enterprise Agreement"
        BillingAccountType = $Config.BillingAccountType
        BillingCurrency = $Config.BillingCurrency
        BillingPeriodEnd = Get-IsoDateTime -Date $billingPeriodEnd
        BillingPeriodStart = Get-IsoDateTime -Date $billingPeriodStart
        ChargeCategory = $chargeCategory
        ChargeClass = $null  # Only set for corrections
        ChargeDescription = "$($service.Name) usage in $($region.Name)"
        ChargeFrequency = "Usage-Based"
        ChargePeriodEnd = Get-IsoDateTime -Date $chargePeriodEnd
        ChargePeriodStart = Get-IsoDateTime -Date $chargePeriodStart
        ContractedCost = $contractedCost
        EffectiveCost = $effectiveCost
        InvoiceIssuerName = $Config.InvoiceIssuerName
        ListCost = $listCost
        PricingQuantity = $pricingQuantity
        PricingUnit = "Hours"
        ServiceProviderName = $Config.ServiceProviderName  # FOCUS 1.3
        
        # Conditional columns
        AvailabilityZone = "$($region.Id)-a"
        CommitmentDiscountCategory = $commitmentDiscountCategory
        CommitmentDiscountId = $commitmentDiscountId
        CommitmentDiscountName = $commitmentDiscountName
        CommitmentDiscountQuantity = $commitmentDiscountQuantity
        CommitmentDiscountStatus = $commitmentDiscountStatus
        CommitmentDiscountType = $commitmentDiscountType
        CommitmentDiscountUnit = $commitmentDiscountUnit
        ConsumedQuantity = $consumedQuantity
        ConsumedUnit = "Hours"
        ContractedUnitPrice = [math]::Round($contractedCost / $pricingQuantity, 10)
        HostProviderName = $Config.HostProviderName  # FOCUS 1.3
        InvoiceId = "INV-$($ChargeDate.ToString('yyyyMM'))-$(Get-Random -Minimum 10000 -Maximum 99999)"
        ListUnitPrice = [math]::Round($listCost / $pricingQuantity, 10)
        PricingCategory = $pricingCategory
        RegionId = $region.Id
        RegionName = $region.Name
        ResourceId = $resourceId
        ResourceName = "resource-$((Get-RandomGuid).Substring(0,8))"
        ResourceType = $resourceType
        ServiceCategory = $service.Category
        ServiceName = $service.Name
        ServiceSubcategory = $service.Subcategory
        SkuId = "SKU-$(Get-Random -Minimum 100000 -Maximum 999999)"
        SkuPriceId = "PRICE-$(Get-Random -Minimum 100000 -Maximum 999999)"
        SubAccountId = $subAccountId
        SubAccountName = "$Provider Test Account"
        SubAccountType = $Config.SubAccountType
        Tags = $tags
        
        # Custom columns (x_ prefix per FOCUS spec)
        x_CloudProvider = $Provider
        x_FocusVersion = $FocusVersion
        x_GeneratedAt = Get-IsoDateTime -Date (Get-Date)
        x_SourceProvider = $Provider  # Used by Hub for provider grouping
        x_PricingSubcategory = $x_PricingSubcategory  # Spot VM, Spot Instance, Preemptible VM
        x_IsSpotInstance = $isSpotInstance
        
        # FinOps Hub required columns
        ProviderName = $Config.ServiceProviderName
        x_BillingAccountId = "BA-$(Get-Random -Minimum 10000 -Maximum 99999)"
        x_BillingProfileId = "BP-$(Get-Random -Minimum 10000 -Maximum 99999)"
        x_ResourceGroupName = "rg-test-$(Get-Random -Minimum 100 -Maximum 999)"
        x_CostCenter = "CC-$(Get-Random -Minimum 1000 -Maximum 9999)"
        x_SkuMeterId = [guid]::NewGuid().ToString()
        x_SkuOfferId = "MS-AZR-0017P"
        x_IngestionTime = Get-IsoDateTime -Date (Get-Date)
        
        # Azure Marketplace indicator (Hub uses x_PublisherCategory for filtering)
        x_PublisherCategory = if ($service.IsMarketplace) { "Marketplace" } else { "Azure" }
        x_PublisherType = if ($service.IsMarketplace) { "Marketplace" } else { "Microsoft" }
        
        # FOCUS standard PublisherName - the entity that produced the service
        PublisherName = if ($service.IsMarketplace) { 
            Get-RandomElement -Array @(
                # Security & Networking
                "Palo Alto Networks",      # Firewalls, threat prevention
                "Fortinet",                # FortiGate NGFW
                "Check Point",             # CloudGuard security
                "Zscaler",                 # Zero trust security
                "Cisco Meraki",            # SD-WAN, networking
                # Data & Analytics
                "Databricks",              # Data lakehouse, Spark
                "Snowflake",               # Cloud data warehouse
                "Confluent",               # Apache Kafka streaming
                # Monitoring & Observability
                "Datadog",                 # Monitoring, APM
                "Elastic",                 # Elasticsearch, observability
                "Dynatrace",               # Application performance
                "New Relic",               # Observability platform
                # DevOps & Infrastructure
                "HashiCorp",               # Terraform, Vault, Consul
                "Red Hat",                 # OpenShift, RHEL
                "SUSE",                    # Linux enterprise
                # SaaS & Productivity
                "Twilio SendGrid",         # Email delivery
                "MongoDB",                 # NoSQL database
                "Salesforce",              # CRM integration
                "ServiceNow"               # ITSM, workflows
            )
        } else { "Microsoft" }
        x_PublisherName = $null  # Deprecated - use PublisherName
        
        # Azure Hybrid Benefit columns
        x_SkuMeterCategory = $x_SkuMeterCategory
        x_SkuMeterName = $x_SkuMeterName
        x_HybridBenefitType = $x_HybridBenefitType
        SkuCores = $skuCores
    }
}

# ============================================================================
# Main Execution
# ============================================================================

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "FinOps Hub Multi-Cloud FOCUS Test Data Generator" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Cloud Provider(s): $CloudProvider"
Write-Host "  FOCUS Version: $FocusVersion"
Write-Host "  Months of Data: $MonthsOfData"
Write-Host "  Date Range: $($StartDate.ToString('yyyy-MM-dd')) to $($EndDate.ToString('yyyy-MM-dd'))"
Write-Host "  Daily Row Count: $DailyRowCount"
Write-Host "  Total Budget: `$$([string]::Format('{0:N0}', $TotalBudget)) USD"
Write-Host "  Output Format: $OutputFormat"
Write-Host "  Output Path: $OutputPath"
Write-Host ""

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Green
}

# Determine which providers to generate
$providers = if ($CloudProvider -eq "All") {
    @("Azure", "AWS", "GCP", "DataCenter")
} else {
    @($CloudProvider)
}

$totalRows = 0
$generatedFiles = @()
$allProviderRows = @{}

# First pass: Generate all rows for all providers
foreach ($provider in $providers) {
    Write-Host ""
    Write-Host "Generating $provider data..." -ForegroundColor Yellow
    
    $config = $ProviderConfigs[$provider]
    $rows = @()
    
    $currentDate = $StartDate
    while ($currentDate -le $EndDate) {
        for ($i = 0; $i -lt $DailyRowCount; $i++) {
            $rows += New-FocusRow -Provider $provider -ChargeDate $currentDate -Config $config -IncludeCommitments -IncludeHybridBenefit
        }
        $currentDate = $currentDate.AddDays(1)
    }
    
    Write-Host "  Generated $($rows.Count) rows" -ForegroundColor Green
    $allProviderRows[$provider] = $rows
    $totalRows += $rows.Count
}

# Calculate total cost across all providers and scale to target budget
$totalGeneratedCost = 0
foreach ($provider in $providers) {
    $totalGeneratedCost += ($allProviderRows[$provider] | Measure-Object -Property EffectiveCost -Sum).Sum
}

$scaleFactor = if ($totalGeneratedCost -gt 0) { $TotalBudget / $totalGeneratedCost } else { 1 }
Write-Host ""
Write-Host "Scaling costs by factor $([math]::Round($scaleFactor, 4)) to achieve target budget of `$$([string]::Format('{0:N0}', $TotalBudget))" -ForegroundColor Cyan

# Second pass: Scale costs and export
foreach ($provider in $providers) {
    $rows = $allProviderRows[$provider]
    
    # Scale all cost columns
    foreach ($row in $rows) {
        $row.BilledCost = [math]::Round($row.BilledCost * $scaleFactor, 10)
        $row.ContractedCost = [math]::Round($row.ContractedCost * $scaleFactor, 10)
        $row.EffectiveCost = [math]::Round($row.EffectiveCost * $scaleFactor, 10)
        $row.ListCost = [math]::Round($row.ListCost * $scaleFactor, 10)
    }
    
    $providerTotal = ($rows | Measure-Object -Property EffectiveCost -Sum).Sum
    
    $baseFileName = "focus-$($provider.ToLower())-$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
    
    # Export to CSV first (needed for Parquet conversion)
    $csvFileName = "$baseFileName.csv"
    $csvFilePath = Join-Path $OutputPath $csvFileName
    $rows | Export-Csv -Path $csvFilePath -NoTypeInformation -Encoding UTF8
    
    Write-Host "  $provider : $($rows.Count) rows, `$$([string]::Format('{0:N2}', $providerTotal)) USD" -ForegroundColor Green
    
    if ($OutputFormat -eq "CSV" -or $OutputFormat -eq "Both") {
        Write-Host "  Saved CSV: $csvFilePath" -ForegroundColor Gray
        $generatedFiles += $csvFilePath
    }
    
    # Generate Parquet using Python (Cost Management export format)
    if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") {
        $parquetFileName = "$baseFileName.parquet"
        $parquetFilePath = Join-Path $OutputPath $parquetFileName
        
        # Use Python to convert CSV to Parquet (requires pandas and pyarrow)
        $pythonScript = @"
import pandas as pd
import sys
try:
    df = pd.read_csv('$($csvFilePath -replace '\\', '/')')
    df.to_parquet('$($parquetFilePath -replace '\\', '/')', engine='pyarrow', compression='snappy')
    print('OK')
except Exception as e:
    print(f'ERROR: {e}')
    sys.exit(1)
"@
        
        $result = $pythonScript | python 2>&1
        if ($result -eq 'OK') {
            Write-Host "  Saved Parquet: $parquetFilePath" -ForegroundColor Gray
            $generatedFiles += $parquetFilePath
            
            # Remove CSV if only Parquet was requested
            if ($OutputFormat -eq "Parquet") {
                Remove-Item $csvFilePath -Force
            }
        } else {
            Write-Host "  Warning: Could not generate Parquet (Python/pandas required). Keeping CSV." -ForegroundColor Yellow
            Write-Host "    $result" -ForegroundColor Yellow
            $generatedFiles += $csvFilePath
        }
    }
    
    # Generate manifest.json for this provider (Cost Management export format)
    $manifestFileName = "manifest.json"
    $manifestFilePath = Join-Path $OutputPath "manifest-$($provider.ToLower()).json"
    
    $dataFile = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { "$baseFileName.parquet" } else { "$baseFileName.csv" }
    $dataFilePath = Join-Path $OutputPath $dataFile
    $fileSize = if (Test-Path $dataFilePath) { (Get-Item $dataFilePath).Length } else { (Get-Item $csvFilePath).Length }
    
    $manifest = @{
        exportConfig = @{
            exportName = "focus-$($provider.ToLower())-export"
            resourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
            dataVersion = "1.0"
            apiVersion = "2023-08-01"
            type = "FocusCost"
            timeFrame = "Custom"
            granularity = "Daily"
        }
        deliveryConfig = @{
            partitionData = $true
            dataOverwriteBehavior = "OverwritePreviousReport"
            fileFormat = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { "Parquet" } else { "Csv" }
            compressionMode = "Snappy"
        }
        blobs = @(
            @{
                blobName = $dataFile
                byteCount = $fileSize
            }
        )
        runInfo = @{
            executionType = "Scheduled"
            submittedTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            runId = [guid]::NewGuid().ToString()
            startDate = $StartDate.ToString("yyyy-MM-ddT00:00:00Z")
            endDate = $EndDate.ToString("yyyy-MM-ddT00:00:00Z")
        }
    } | ConvertTo-Json -Depth 5
    
    $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8
    Write-Host "  Saved manifest: $manifestFilePath" -ForegroundColor Gray
    $generatedFiles += $manifestFilePath
}

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "Generation Complete!" -ForegroundColor Green
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Total Rows Generated: $totalRows"
Write-Host "  Total Cost: `$$([string]::Format('{0:N2}', $TotalBudget)) USD"
Write-Host "  Output Format: $OutputFormat"
Write-Host "  Files Created: $($generatedFiles.Count)"
Write-Host ""
Write-Host "Generated Files:" -ForegroundColor Yellow
foreach ($file in $generatedFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length / 1KB
        Write-Host "  - $file ($([math]::Round($size, 2)) KB)"
    }
}

# Upload to Azure Storage if requested
if ($Upload -and $StorageAccountName) {
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor Cyan
    Write-Host "Uploading to Azure Storage..." -ForegroundColor Yellow
    Write-Host "=" * 70 -ForegroundColor Cyan
    
    $uploadedCount = 0
    $runId = [guid]::NewGuid().ToString()
    $exportTime = (Get-Date).ToString("yyyyMMddHHmm")
    
    foreach ($provider in $providers) {
        $providerLower = $provider.ToLower()
        $baseFileName = "focus-$providerLower-$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
        
        # Determine file extension
        $fileExt = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { ".parquet" } else { ".csv" }
        $dataFile = "$baseFileName$fileExt"
        $dataFilePath = Join-Path $OutputPath $dataFile
        
        if (-not (Test-Path $dataFilePath)) {
            Write-Host "  Warning: $dataFilePath not found, skipping $provider" -ForegroundColor Yellow
            continue
        }
        
        $fileSize = (Get-Item $dataFilePath).Length
        
        # For Azure: Use msexports container with Cost Management export folder structure
        # For AWS/GCP/DataCenter: Use ingestion container directly (no ETL needed, just FOCUS parquet)
        if ($providerLower -eq "azure") {
            # Azure: Use msexports with proper Cost Management export folder structure
            # Path: msexports/{scope-id}/{export-name}/{date-range}/{export-time}/{guid}/{file}
            $container = "msexports"
            $scopeId = "subscriptions/00000000-0000-0000-0000-000000000000"
            $exportName = "focus-cost-export"
            $dateRange = "$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
            $blobFolder = "$scopeId/$exportName/$dateRange/$exportTime/$runId"
            $blobPath = "$blobFolder/$dataFile"
            $manifestBlobPath = "$blobFolder/manifest.json"
            
            # Create proper Cost Management manifest
            $manifest = @{
                manifestVersion = "2024-04-01"
                byteCount = $fileSize
                blobCount = 1
                dataRowCount = $allProviderRows[$provider].Count
                exportConfig = @{
                    exportName = $exportName
                    resourceId = "/$scopeId/providers/Microsoft.CostManagement/exports/$exportName"
                    dataVersion = "1.0r2"
                    apiVersion = "2023-07-01-preview"
                    type = "FocusCost"
                    timeFrame = "Custom"
                    granularity = "Daily"
                }
                deliveryConfig = @{
                    partitionData = $true
                    dataOverwriteBehavior = "OverwritePreviousReport"
                    fileFormat = if ($fileExt -eq ".parquet") { "Parquet" } else { "Csv" }
                    compressionMode = if ($fileExt -eq ".parquet") { "Snappy" } else { "None" }
                    containerUri = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/$StorageAccountName"
                    rootFolderPath = ""
                }
                runInfo = @{
                    executionType = "Scheduled"
                    submittedTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ")
                    runId = $runId
                    startDate = $StartDate.ToString("yyyy-MM-ddT00:00:00")
                    endDate = $EndDate.ToString("yyyy-MM-ddT00:00:00")
                }
                blobs = @(
                    @{
                        blobName = $blobPath
                        byteCount = $fileSize
                        dataRowCount = $allProviderRows[$provider].Count
                    }
                )
            } | ConvertTo-Json -Depth 5
            
            # Save manifest locally
            $manifestFilePath = Join-Path $OutputPath "manifest-$providerLower.json"
            $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8
            
            # Upload data file
            Write-Host "  Uploading $provider to msexports container..." -ForegroundColor Cyan
            az storage blob upload --account-name $StorageAccountName --container-name $container --file $dataFilePath --name $blobPath --auth-mode login --overwrite --only-show-errors
            
            # Upload manifest (this triggers the ADF pipeline)
            az storage blob upload --account-name $StorageAccountName --container-name $container --file $manifestFilePath --name $manifestBlobPath --auth-mode login --overwrite --only-show-errors
            
        } else {
            # AWS/GCP/DataCenter: Upload directly to ingestion container as FOCUS parquet
            # Path: ingestion/Costs/{yyyy}/{mm}/{provider}/{account-id}/{ingestion-id}__{filename}.parquet
            # Note: manifest.json is still needed to trigger ADX ingestion
            $container = "ingestion"
            $scopePath = "$providerLower/test-account"
            $ingestionId = (Get-Date).ToString("yyyyMMddHHmmss")
            $blobFolder = "Costs/$($EndDate.ToString('yyyy'))/$($EndDate.ToString('MM'))/$scopePath"
            $blobPath = "$blobFolder/${ingestionId}__$dataFile"
            $manifestBlobPath = "$blobFolder/manifest.json"
            
            # Simple manifest to trigger ADX ingestion (content doesn't matter, just needs to exist)
            $manifest = @{
                note = "Trigger file for ADX ingestion"
                provider = $providerLower
                timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            } | ConvertTo-Json -Depth 3
            
            $manifestFilePath = Join-Path $OutputPath "manifest-$providerLower.json"
            $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8
            
            # Upload data file
            Write-Host "  Uploading $provider to ingestion container..." -ForegroundColor Cyan
            az storage blob upload --account-name $StorageAccountName --container-name $container --file $dataFilePath --name $blobPath --auth-mode login --overwrite --only-show-errors
            
            # Upload manifest to trigger ADX ingestion
            az storage blob upload --account-name $StorageAccountName --container-name $container --file $manifestFilePath --name $manifestBlobPath --auth-mode login --overwrite --only-show-errors
        }
        
        Write-Host "    Uploaded: $blobPath" -ForegroundColor Green
        Write-Host "    Uploaded: $manifestBlobPath" -ForegroundColor Green
        $uploadedCount++
    }
    
    Write-Host ""
    Write-Host "Upload Complete! $uploadedCount providers uploaded." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Azure data in msexports will be processed by ADF when triggers are started"
    Write-Host "  2. AWS/GCP/DataCenter data in ingestion will be picked up by ADX ingestion pipeline"
    Write-Host "  3. Start ADF triggers: az datafactory trigger start --factory-name <adf> --name msexports_ManifestAdded"
} else {
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Run with -Upload -StorageAccountName <name> to upload automatically"
    Write-Host "  2. Or manually upload:"
    Write-Host "     - Azure data to msexports/{scope}/{export-name}/{date-range}/{time}/{guid}/"
    Write-Host "     - AWS/GCP/DC data to ingestion/Costs/{yyyy}/{mm}/{provider}/{account}/"
    Write-Host "  3. Start ADF triggers to process the data"
}

Write-Host ""
Write-Host "FOCUS Specification Notes:" -ForegroundColor Cyan
Write-Host "  - Data follows FOCUS v$FocusVersion column definitions"
Write-Host "  - ServiceProviderName replaces ProviderName (deprecated in 1.3)"
Write-Host "  - HostProviderName added for multi-cloud visibility"
Write-Host "  - Custom columns use x_ prefix per FOCUS spec"
Write-Host ""
