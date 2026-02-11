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
    - Persistent resources across days (realistic trending)
    - Consistent billing and sub-account identities per provider
    - Multi-cloud commitment discounts (Azure/AWS/GCP)
    - Azure Hybrid Benefit simulation
    - Azure Marketplace charges
    - Spot/Preemptible instances (60-90% discounts)
    - Realistic weighted service distribution
    - Service-specific pricing units (Hours, GB, Requests, etc.)
    - Provider-specific tags
    - ChargeClass corrections/adjustments
    - ChargeFrequency variation (Usage-Based, Recurring, One-Time)
    - AvailabilityZone variation (a, b, c)
    - Budget scaling to target total cost

.PARAMETER OutputPath
    Directory to save generated files. Default: ./test-data

.PARAMETER CloudProvider
    Which cloud provider data to generate. Options: Azure, AWS, GCP, DataCenter, All
    Default: All

.PARAMETER MonthsOfData
    Number of months of historical data to generate, ending at today.
    Default: 6 (generates 6 months ending today)

.PARAMETER StartDate
    Start date for generated data. Overrides MonthsOfData if specified.

.PARAMETER EndDate
    End date for generated data. Default: Today

.PARAMETER TotalRowTarget
    Target total rows across all providers and days. Default: 500000
    Rows are distributed: ~60% Azure, ~20% AWS, ~15% GCP, ~5% DataCenter

.PARAMETER TotalBudget
    Target total cost in USD for all generated data. Default: 500000 ($500K)
    Costs are scaled proportionally to achieve this target.

.PARAMETER FocusVersion
    FOCUS specification version. Options: 1.0, 1.1, 1.2, 1.3
    Default: 1.3

.PARAMETER OutputFormat
    Output file format. Options: Parquet, CSV, Both
    Default: Parquet

.PARAMETER StorageAccountName
    Azure Storage account name for upload.

.PARAMETER ResourceGroupName
    Resource group containing the storage account (required for key-based auth).

.PARAMETER AdfName
    Azure Data Factory name for starting triggers.

.PARAMETER Upload
    Upload generated files to Azure Storage.

.PARAMETER StartTriggers
    Start ADF triggers before upload so BlobCreated events are captured.

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1
    # Generates 6 months of data for all providers, 500K rows, $500K total budget

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1 -MonthsOfData 3 -TotalRowTarget 100000 -TotalBudget 100000
    # Generates 3 months of data, 100K rows, $100K total budget

.EXAMPLE
    .\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "stfinopshub" -ResourceGroupName "rg-finopshub" -AdfName "adf-finopshub" -StartTriggers
    # Generates data, ensures ADF triggers are running, then uploads to trigger processing

.NOTES
    FOCUS Specification Reference: https://focus.finops.org/focus-specification/v1-3/

    Author: FinOps Hub Team
    Version: 2.0.0
#>

[CmdletBinding()]
param(
    [string]$OutputPath = "./test-data",

    [ValidateSet("Azure", "AWS", "GCP", "DataCenter", "All")]
    [string]$CloudProvider = "All",

    [int]$MonthsOfData = 6,

    [datetime]$StartDate,

    [datetime]$EndDate = (Get-Date),

    [int]$TotalRowTarget = 500000,

    [decimal]$TotalBudget = 500000,

    [ValidateSet("1.0", "1.1", "1.2", "1.3")]
    [string]$FocusVersion = "1.3",

    [ValidateSet("Parquet", "CSV", "Both")]
    [string]$OutputFormat = "Parquet",

    [string]$StorageAccountName,

    [string]$ResourceGroupName,

    [string]$AdfName,

    [switch]$Upload,

    [switch]$StartTriggers
)

# Calculate StartDate from MonthsOfData if not explicitly provided
if (-not $PSBoundParameters.ContainsKey('StartDate')) {
    $StartDate = (Get-Date -Day 1).AddMonths(-$MonthsOfData + 1)
}

# Ensure EndDate is today max
if ($EndDate -gt (Get-Date)) {
    $EndDate = Get-Date
}

# ============================================================================
# Provider-Specific Configuration
# ============================================================================
# Weight = probability of selection (higher = more rows)
# CostMin/CostMax = daily cost range per resource in USD
# PricingUnit/ConsumedUnit = service-specific units (not always Hours)

$ProviderConfigs = @{
    Azure = @{
        ServiceProviderName = "Microsoft"
        InvoiceIssuerName   = "Microsoft"
        HostProviderName    = "Microsoft"
        BillingAccountType  = "Billing Profile"
        SubAccountType      = "Subscription"
        BillingCurrency     = "USD"
        Regions = @(
            @{ Id = "swedencentral"; Name = "Sweden Central" },
            @{ Id = "westeurope"; Name = "West Europe" },
            @{ Id = "eastus"; Name = "East US" },
            @{ Id = "westus2"; Name = "West US 2" }
        )
        Services = @(
            @{ Name = "Virtual Machines"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Azure Kubernetes Service"; Category = "Compute"; Subcategory = "Containers"; Weight = 20; CostMin = 100; CostMax = 3000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Azure SQL Database"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 800; PricingUnit = "Hours"; ConsumedUnit = "DTUs" },
            @{ Name = "Cosmos DB"; Category = "Databases"; Subcategory = "NoSQL Databases"; Weight = 8; CostMin = 20; CostMax = 500; PricingUnit = "RUs"; ConsumedUnit = "Request Units" },
            @{ Name = "Storage"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 10; CostMin = 5; CostMax = 200; PricingUnit = "GB"; ConsumedUnit = "GB" },
            @{ Name = "Azure Data Explorer"; Category = "Analytics"; Subcategory = "Analytics Platforms"; Weight = 5; CostMin = 50; CostMax = 600; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "App Service"; Category = "Compute"; Subcategory = "Web Apps"; Weight = 4; CostMin = 10; CostMax = 300; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Key Vault"; Category = "Security"; Subcategory = "Key Management"; Weight = 2; CostMin = 1; CostMax = 50; PricingUnit = "Operations"; ConsumedUnit = "10K Operations" },
            @{ Name = "Virtual Network"; Category = "Networking"; Subcategory = "Virtual Networks"; Weight = 2; CostMin = 5; CostMax = 100; PricingUnit = "GB"; ConsumedUnit = "GB" },
            @{ Name = "Azure Functions"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 2; CostMin = 0.10; CostMax = 30; PricingUnit = "Executions"; ConsumedUnit = "1M Executions" },
            @{ Name = "Azure Marketplace"; Category = "Marketplace"; Subcategory = "Third Party"; Weight = 5; CostMin = 10; CostMax = 500; PricingUnit = "Hours"; ConsumedUnit = "Hours"; IsMarketplace = $true }
        )
        ResourceTypes = @("microsoft.compute/virtualmachines", "microsoft.storage/storageaccounts", "microsoft.sql/servers", "microsoft.kusto/clusters", "microsoft.containerservice/managedclusters", "microsoft.documentdb/databaseaccounts", "microsoft.web/sites", "microsoft.keyvault/vaults", "microsoft.network/virtualnetworks")
    }
    AWS = @{
        ServiceProviderName = "Amazon Web Services"
        InvoiceIssuerName   = "Amazon Web Services"
        HostProviderName    = "Amazon Web Services"
        BillingAccountType  = "Management Account"
        SubAccountType      = "Member Account"
        BillingCurrency     = "USD"
        Regions = @(
            @{ Id = "us-east-1"; Name = "US East (N. Virginia)" },
            @{ Id = "us-west-2"; Name = "US West (Oregon)" },
            @{ Id = "eu-west-1"; Name = "Europe (Ireland)" },
            @{ Id = "ap-southeast-1"; Name = "Asia Pacific (Singapore)" }
        )
        Services = @(
            @{ Name = "Amazon EC2"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Amazon EKS"; Category = "Compute"; Subcategory = "Containers"; Weight = 18; CostMin = 100; CostMax = 2500; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Amazon RDS"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 800; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Amazon S3"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 12; CostMin = 5; CostMax = 300; PricingUnit = "GB"; ConsumedUnit = "GB" },
            @{ Name = "Amazon Redshift"; Category = "Analytics"; Subcategory = "Data Warehouses"; Weight = 8; CostMin = 50; CostMax = 1000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Amazon DynamoDB"; Category = "Databases"; Subcategory = "NoSQL Databases"; Weight = 6; CostMin = 10; CostMax = 400; PricingUnit = "RCUs"; ConsumedUnit = "Read Capacity Units" },
            @{ Name = "Amazon CloudFront"; Category = "Networking"; Subcategory = "Content Delivery"; Weight = 4; CostMin = 5; CostMax = 150; PricingUnit = "GB"; ConsumedUnit = "GB" },
            @{ Name = "AWS Lambda"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 3; CostMin = 0.10; CostMax = 30; PricingUnit = "Requests"; ConsumedUnit = "1M Requests" },
            @{ Name = "Amazon SQS"; Category = "Integration"; Subcategory = "Messaging"; Weight = 2; CostMin = 0.50; CostMax = 20; PricingUnit = "Requests"; ConsumedUnit = "1M Requests" }
        )
        ResourceTypes = @("AWS::EC2::Instance", "AWS::S3::Bucket", "AWS::RDS::DBInstance", "AWS::EKS::Cluster", "AWS::DynamoDB::Table", "AWS::Lambda::Function")
    }
    GCP = @{
        ServiceProviderName = "Google Cloud"
        InvoiceIssuerName   = "Google Cloud"
        HostProviderName    = "Google Cloud"
        BillingAccountType  = "Billing Account"
        SubAccountType      = "Project"
        BillingCurrency     = "USD"
        Regions = @(
            @{ Id = "us-central1"; Name = "Iowa" },
            @{ Id = "us-east1"; Name = "South Carolina" },
            @{ Id = "europe-west1"; Name = "Belgium" },
            @{ Id = "asia-east1"; Name = "Taiwan" }
        )
        Services = @(
            @{ Name = "Compute Engine"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 35; CostMin = 50; CostMax = 2000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Google Kubernetes Engine"; Category = "Compute"; Subcategory = "Containers"; Weight = 20; CostMin = 100; CostMax = 2500; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Cloud SQL"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 12; CostMin = 30; CostMax = 700; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Cloud Storage"; Category = "Storage"; Subcategory = "Object Storage"; Weight = 12; CostMin = 5; CostMax = 250; PricingUnit = "GB"; ConsumedUnit = "GB" },
            @{ Name = "BigQuery"; Category = "Analytics"; Subcategory = "Data Warehouses"; Weight = 10; CostMin = 20; CostMax = 800; PricingUnit = "TB Scanned"; ConsumedUnit = "TB" },
            @{ Name = "Cloud Spanner"; Category = "Databases"; Subcategory = "Distributed Databases"; Weight = 5; CostMin = 50; CostMax = 500; PricingUnit = "Node-Hours"; ConsumedUnit = "Node Hours" },
            @{ Name = "Cloud Run"; Category = "Compute"; Subcategory = "Serverless Containers"; Weight = 3; CostMin = 5; CostMax = 100; PricingUnit = "vCPU-Seconds"; ConsumedUnit = "vCPU Seconds" },
            @{ Name = "Cloud Functions"; Category = "Compute"; Subcategory = "Serverless Compute"; Weight = 3; CostMin = 0.10; CostMax = 30; PricingUnit = "Invocations"; ConsumedUnit = "1M Invocations" }
        )
        ResourceTypes = @("compute.googleapis.com/Instance", "storage.googleapis.com/Bucket", "sql.googleapis.com/Instance", "container.googleapis.com/Cluster", "bigquery.googleapis.com/Dataset")
    }
    DataCenter = @{
        ServiceProviderName = "Internal IT"
        InvoiceIssuerName   = "Internal IT"
        HostProviderName    = "On-Premises"
        BillingAccountType  = "Cost Center"
        SubAccountType      = "Business Unit"
        BillingCurrency     = "USD"
        Regions = @(
            @{ Id = "dc-us-east"; Name = "US East Data Center" },
            @{ Id = "dc-eu-west"; Name = "EU West Data Center" },
            @{ Id = "dc-apac"; Name = "APAC Data Center" }
        )
        Services = @(
            @{ Name = "Physical Servers"; Category = "Compute"; Subcategory = "Bare Metal"; Weight = 30; CostMin = 200; CostMax = 5000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "VMware vSphere"; Category = "Compute"; Subcategory = "Virtual Machines"; Weight = 25; CostMin = 100; CostMax = 2000; PricingUnit = "Hours"; ConsumedUnit = "Hours" },
            @{ Name = "Oracle Database"; Category = "Databases"; Subcategory = "Relational Databases"; Weight = 15; CostMin = 500; CostMax = 10000; PricingUnit = "Processor Licenses"; ConsumedUnit = "Processor Licenses" },
            @{ Name = "SAN Storage"; Category = "Storage"; Subcategory = "Block Storage"; Weight = 12; CostMin = 50; CostMax = 1500; PricingUnit = "TB"; ConsumedUnit = "TB" },
            @{ Name = "Network Infrastructure"; Category = "Networking"; Subcategory = "Network Infrastructure"; Weight = 10; CostMin = 20; CostMax = 500; PricingUnit = "Ports"; ConsumedUnit = "Ports" },
            @{ Name = "Facility Costs"; Category = "Other"; Subcategory = "Other"; Weight = 8; CostMin = 100; CostMax = 800; PricingUnit = "kWh"; ConsumedUnit = "kWh" }
        )
        ResourceTypes = @("server/physical", "storage/san", "database/oracle", "virtualization/vmware")
    }
}

# ============================================================================
# Helper Functions
# ============================================================================

function Get-RandomDecimal {
    param(
        [decimal]$Min = 0.01,
        [decimal]$Max = 100.00
    )
    return [math]::Round($Min + (Get-Random -Maximum ([int](($Max - $Min) * 100 + 1))) / 100, 10)
}

function Get-RandomElement {
    param([array]$Array)
    return $Array[(Get-Random -Maximum $Array.Count)]
}

function Get-WeightedRandomService {
    param([array]$Services)

    $totalWeight = ($Services | ForEach-Object {
        if ($_.Weight) { $_.Weight } else { 1 }
    } | Measure-Object -Sum).Sum

    $randomValue = Get-Random -Maximum $totalWeight
    $cumulative = 0
    foreach ($service in $Services) {
        $weight = if ($service.Weight) { $service.Weight } else { 1 }
        $cumulative += $weight
        if ($randomValue -lt $cumulative) {
            return $service
        }
    }
    return $Services[-1]
}

function Get-IsoDateTime {
    param([datetime]$Date)
    return $Date.ToString("yyyy-MM-ddTHH:mm:ssZ")
}

# ============================================================================
# Persistent Identity Generation
# ============================================================================
# Pre-generate stable identities so the same resources, accounts, and
# billing entities appear across all days - critical for trending/grouping.

function New-ProviderIdentities {
    param(
        [string]$Provider,
        [hashtable]$Config
    )

    # 2-3 Billing Accounts per provider
    $billingAccountCount = Get-Random -Minimum 2 -Maximum 4
    $billingAccounts = @()
    for ($i = 1; $i -le $billingAccountCount; $i++) {
        $baId = switch ($Provider) {
            "Azure"      { [guid]::NewGuid().ToString() }
            "AWS"        { "$(Get-Random -Minimum 100000000000 -Maximum 999999999999)" }
            "GCP"        { "ABCDEF-$((Get-Random -Minimum 100000 -Maximum 999999))-$((Get-Random -Minimum 100000 -Maximum 999999))" }
            "DataCenter" { "CC-$(Get-Random -Minimum 10000 -Maximum 99999)" }
        }
        $baName = switch ($Provider) {
            "Azure"      { "Contoso EA $i" }
            "AWS"        { "AWS Org Account $i" }
            "GCP"        { "GCP Billing Account $i" }
            "DataCenter" { "IT Cost Center $i" }
        }
        $billingAccounts += @{ Id = $baId; Name = $baName }
    }

    # 4-8 Sub-Accounts per provider with realistic names
    $subAccountNames = switch ($Provider) {
        "Azure"      { @("Production Subscription", "Staging Subscription", "Development Subscription", "Shared Services Subscription", "Data Platform Subscription", "Security Subscription", "Networking Subscription", "App Team A Subscription") }
        "AWS"        { @("prod-workloads", "staging-env", "dev-sandbox", "shared-services", "data-lake", "security-tools", "networking", "app-team-b") }
        "GCP"        { @("prod-services", "staging-services", "dev-playground", "shared-infra", "analytics-platform", "ml-experiments", "networking", "frontend-apps") }
        "DataCenter" { @("Engineering", "Finance", "Operations", "Research", "Marketing", "IT Infrastructure", "Human Resources", "Executive") }
    }
    $subAccountCount = Get-Random -Minimum 4 -Maximum ([math]::Min(9, $subAccountNames.Count + 1))
    $subAccounts = @()
    $usedNames = @()
    for ($i = 0; $i -lt $subAccountCount; $i++) {
        # Pick a unique name
        $saName = $subAccountNames[$i]
        $saId = switch ($Provider) {
            "Azure"      { [guid]::NewGuid().ToString() }
            "AWS"        { "$(Get-Random -Minimum 100000000000 -Maximum 999999999999)" }
            "GCP"        { "proj-$($Provider.ToLower())-$(Get-Random -Minimum 10000 -Maximum 99999)" }
            "DataCenter" { "BU-$(Get-Random -Minimum 100 -Maximum 999)" }
        }
        $subAccounts += @{ Id = $saId; Name = $saName; BillingAccount = $billingAccounts[$i % $billingAccounts.Count] }
    }

    # Billing profile IDs (consistent per provider)
    $billingProfileIds = @()
    for ($i = 1; $i -le 3; $i++) {
        $billingProfileIds += "BP-$(Get-Random -Minimum 10000 -Maximum 99999)"
    }

    # Resource Groups
    $resourceGroups = @("rg-production-001", "rg-staging-001", "rg-development-001", "rg-data-platform",
                        "rg-shared-services", "rg-networking", "rg-security", "rg-analytics",
                        "rg-app-team-a", "rg-app-team-b", "rg-ml-training", "rg-monitoring")

    # Pre-generate a pool of persistent resources
    $resourceCount = Get-Random -Minimum 150 -Maximum 400
    $resources = @()
    for ($i = 1; $i -le $resourceCount; $i++) {
        $service = Get-WeightedRandomService -Services $Config.Services
        $region = Get-RandomElement -Array $Config.Regions
        $resourceType = Get-RandomElement -Array $Config.ResourceTypes
        $subAccount = Get-RandomElement -Array $subAccounts
        $rg = Get-RandomElement -Array $resourceGroups
        $shortId = ([guid]::NewGuid().ToString()).Substring(0, 8)

        $resourceId = switch ($Provider) {
            "Azure"      { "/subscriptions/$($subAccount.Id)/resourceGroups/$rg/providers/$resourceType/$shortId" }
            "AWS"        { "arn:aws:$(($resourceType -split '::')[1].ToLower()):$($region.Id):$($subAccount.Id):instance/i-$shortId" }
            "GCP"        { "//$(($resourceType -split '/')[0])/projects/$($subAccount.Id)/zones/$($region.Id)-$(Get-RandomElement -Array @('a','b','c'))/instances/vm-$shortId" }
            "DataCenter" { "dc://$($region.Id)/$resourceType/$shortId" }
        }

        $resourceName = "$($service.Name.ToLower() -replace ' ','-')-$shortId"

        # Provider-specific tags
        $tagHash = @{
            "environment" = Get-RandomElement -Array @("production", "staging", "development", "test")
            "costCenter"  = "CC-$(Get-Random -Minimum 1000 -Maximum 9999)"
            "application" = Get-RandomElement -Array @("web-app", "api-service", "data-pipeline", "analytics", "backend", "frontend", "ml-training", "batch-jobs")
            "owner"       = Get-RandomElement -Array @("team-alpha", "team-beta", "platform", "data-team", "infra", "security-team", "devops", "sre")
        }

        # Azure-specific FinOps Hub tags
        if ($Provider -eq "Azure") {
            $hubStorageSuffix = Get-Random -Minimum 1000 -Maximum 9999
            $tagHash["ftk-tool"] = "FinOps hubs"
            $tagHash["ftk-version"] = "0.8.0"
            $tagHash["cm-resource-parent"] = "/subscriptions/$($subAccount.Id)/resourceGroups/rg-finops-hub/providers/Microsoft.Storage/storageAccounts/stfinopshub$hubStorageSuffix"
        }

        # AWS-specific tags
        if ($Provider -eq "AWS") {
            $tagHash["aws:createdBy"] = Get-RandomElement -Array @("CloudFormation", "Terraform", "CDK", "Console")
        }

        # GCP-specific tags
        if ($Provider -eq "GCP") {
            $tagHash["goog-dm"] = Get-RandomElement -Array @("deployment-mgr", "terraform", "gcloud-cli")
        }

        # Determine a base daily cost for this specific resource (varies +/-20% daily)
        $baseDailyCost = Get-RandomDecimal -Min $service.CostMin -Max $service.CostMax

        # SKU IDs (stable per resource)
        $skuId = "SKU-$(Get-Random -Minimum 100000 -Maximum 999999)"
        $skuPriceId = "PRICE-$(Get-Random -Minimum 100000 -Maximum 999999)"
        $skuMeterId = [guid]::NewGuid().ToString()

        $resources += @{
            ResourceId    = $resourceId
            ResourceName  = $resourceName
            ResourceType  = $resourceType
            Service       = $service
            Region        = $region
            SubAccount    = $subAccount
            ResourceGroup = $rg
            Tags          = $tagHash
            BaseDailyCost = $baseDailyCost
            SkuId         = $skuId
            SkuPriceId    = $skuPriceId
            SkuMeterId    = $skuMeterId
        }
    }

    # Pre-generate commitment discounts (multi-cloud)
    $commitments = @()
    $commitmentCount = switch ($Provider) {
        "Azure"      { Get-Random -Minimum 8 -Maximum 16 }
        "AWS"        { Get-Random -Minimum 5 -Maximum 12 }
        "GCP"        { Get-Random -Minimum 3 -Maximum 8 }
        "DataCenter" { 0 }
    }
    for ($i = 1; $i -le $commitmentCount; $i++) {
        $commitType = Get-RandomElement -Array @("Reservation", "SavingsPlan")
        $commitId = switch ($Provider) {
            "Azure" { "/providers/Microsoft.Capacity/$commitType/$([guid]::NewGuid().ToString())" }
            "AWS"   { "arn:aws:savingsplans::$(Get-Random -Minimum 100000000000 -Maximum 999999999999):savingsplan/sp-$([guid]::NewGuid().ToString().Substring(0,8))" }
            "GCP"   { "projects/test-project/commitments/$([guid]::NewGuid().ToString().Substring(0,8))" }
            default { "" }
        }
        $commitments += @{
            Id       = $commitId
            Name     = "$commitType-$(Get-Random -Minimum 1000 -Maximum 9999)"
            Type     = $commitType
            # FOCUS spec: Reservation = "Usage" (uses up committed usage), SavingsPlan = "Spend" (uses up committed spend)
            Category = if ($commitType -eq "Reservation") { "Usage" } else { "Spend" }
        }
    }

    # Invoice IDs per billing period (populated lazily)
    $invoiceIds = @{}

    # Marketplace publishers
    $marketplacePublishers = @(
        "Palo Alto Networks", "Fortinet", "Check Point", "Zscaler", "Cisco Meraki",
        "Databricks", "Snowflake", "Confluent",
        "Datadog", "Elastic", "Dynatrace", "New Relic",
        "HashiCorp", "Red Hat", "SUSE",
        "Twilio SendGrid", "MongoDB", "Salesforce", "ServiceNow"
    )

    return @{
        BillingAccounts       = $billingAccounts
        SubAccounts           = $subAccounts
        BillingProfileIds     = $billingProfileIds
        ResourceGroups        = $resourceGroups
        Resources             = $resources
        Commitments           = $commitments
        InvoiceIds            = $invoiceIds
        MarketplacePublishers = $marketplacePublishers
    }
}

# ============================================================================
# Row Generation
# ============================================================================

function New-FocusRow {
    param(
        [string]$Provider,
        [datetime]$ChargeDate,
        [hashtable]$Config,
        [hashtable]$Identity,
        [switch]$IncludeCommitments,
        [switch]$IncludeHybridBenefit
    )

    # Pick a persistent resource
    $res = Get-RandomElement -Array $Identity.Resources
    $service = $res.Service
    $region = $res.Region
    $subAccount = $res.SubAccount
    $billingAccount = $subAccount.BillingAccount

    # Daily cost variation: base +/- 20% with slight upward trend over months
    $monthIndex = (($ChargeDate.Year - $StartDate.Year) * 12 + $ChargeDate.Month - $StartDate.Month)
    $trendFactor = 1.0 + ($monthIndex * 0.02)  # 2% growth per month
    $jitter = 0.80 + (Get-Random -Maximum 41) / 100.0  # 0.80 to 1.20
    $listCost = [math]::Round($res.BaseDailyCost * $trendFactor * $jitter, 10)
    if ($listCost -lt 0.01) { $listCost = 0.01 }

    $contractedCost = [math]::Round($listCost * (Get-Random -Minimum 70 -Maximum 100) / 100, 10)
    $billedCost = [math]::Round($contractedCost * (Get-Random -Minimum 95 -Maximum 100) / 100, 10)
    $effectiveCost = $billedCost

    $pricingQuantity = Get-RandomDecimal -Min 1 -Max 1000
    $consumedQuantity = $pricingQuantity

    $chargePeriodStart = $ChargeDate.Date
    $chargePeriodEnd = $ChargeDate.Date.AddDays(1)
    $billingPeriodStart = [datetime]::new($ChargeDate.Year, $ChargeDate.Month, 1)
    $billingPeriodEnd = $billingPeriodStart.AddMonths(1)

    # Charge category distribution: 80% Usage, 10% Purchase, 5% Tax, 3% Credit, 2% Adjustment
    $catRoll = Get-Random -Maximum 100
    $chargeCategory = if ($catRoll -lt 80) { "Usage" }
                      elseif ($catRoll -lt 90) { "Purchase" }
                      elseif ($catRoll -lt 95) { "Tax" }
                      elseif ($catRoll -lt 98) { "Credit" }
                      else { "Adjustment" }

    # ChargeClass: mostly null, ~3% are corrections
    $chargeClass = $null
    if ((Get-Random -Maximum 100) -lt 3) {
        $chargeClass = "Correction"
    }

    # ChargeFrequency based on ChargeCategory
    $chargeFrequency = switch ($chargeCategory) {
        "Purchase" { Get-RandomElement -Array @("One-Time", "Recurring") }
        "Tax"      { "Recurring" }
        "Credit"   { "One-Time" }
        default    { "Usage-Based" }
    }

    # Credits and Adjustments are negative
    if ($chargeCategory -in @("Credit", "Adjustment")) {
        $listCost = -[math]::Abs($listCost) * 0.1  # Credits are ~10% of normal costs
        $contractedCost = $listCost
        $billedCost = $listCost
        $effectiveCost = $listCost
    }

    # AvailabilityZone: vary a/b/c
    $az = "$($region.Id)-$(Get-RandomElement -Array @('a', 'b', 'c'))"

    # === COMMITMENT DISCOUNT SIMULATION (multi-cloud) ===
    $commitmentDiscountId = $null
    $commitmentDiscountName = $null
    $commitmentDiscountCategory = $null
    $commitmentDiscountType = $null
    $commitmentDiscountStatus = $null
    $commitmentDiscountQuantity = $null
    $commitmentDiscountUnit = $null

    # 30% chance of commitment-covered usage (Azure/AWS/GCP - not DataCenter)
    if ($IncludeCommitments -and $Provider -ne "DataCenter" -and $chargeCategory -eq "Usage" -and
        $Identity.Commitments.Count -gt 0 -and (Get-Random -Maximum 100) -lt 30) {

        $commitment = Get-RandomElement -Array $Identity.Commitments
        $commitmentDiscountId = $commitment.Id
        $commitmentDiscountName = $commitment.Name
        $commitmentDiscountCategory = $commitment.Category
        $commitmentDiscountType = $commitment.Type

        # 85% utilization - most are Used, some Unused
        if ((Get-Random -Maximum 100) -lt 85) {
            $commitmentDiscountStatus = "Used"
            $effectiveCost = [math]::Round($listCost * 0.40, 10)  # 60% savings
            $billedCost = 0  # Prepaid
        } else {
            $commitmentDiscountStatus = "Unused"
            $effectiveCost = [math]::Round($listCost * 0.60, 10)  # Wasted commitment
            $billedCost = $effectiveCost
        }

        $commitmentDiscountQuantity = $pricingQuantity
        $commitmentDiscountUnit = $service.PricingUnit
    }

    # === AZURE HYBRID BENEFIT SIMULATION ===
    $x_SkuMeterCategory = $null
    $x_SkuMeterName = $null
    $x_HybridBenefitType = $null
    $skuCores = $null

    if ($IncludeHybridBenefit -and $Provider -eq "Azure" -and $res.ResourceType -eq "microsoft.compute/virtualmachines") {
        if ((Get-Random -Maximum 100) -lt 40) {
            $x_HybridBenefitType = Get-RandomElement -Array @("Windows_Server", "Windows_Client", "SUSE_Linux", "RHEL_Linux")
            $x_SkuMeterCategory = "Virtual Machines Licenses"
            $x_SkuMeterName = "$x_HybridBenefitType License"
            $skuCores = Get-RandomElement -Array @(2, 4, 8, 16, 32, 64)

            # AHUB savings (cap to prevent negative EffectiveCost)
            $licenseSavings = [math]::Round([math]::Abs($effectiveCost) * 0.40, 10)
            $effectiveCost = [math]::Max(0, [math]::Round($effectiveCost - $licenseSavings, 10))
        }
    }

    # === SPOT INSTANCE SIMULATION ===
    $pricingCategory = "Standard"
    $x_PricingSubcategory = $null

    $spotEligibleServices = @("Virtual Machines", "Azure Kubernetes Service", "Amazon EC2", "Amazon EKS", "Compute Engine", "Google Kubernetes Engine", "VMware vSphere")
    if ($chargeCategory -eq "Usage" -and $null -eq $commitmentDiscountId -and $service.Name -in $spotEligibleServices) {
        if ((Get-Random -Maximum 100) -lt 15) {
            $pricingCategory = "Spot"
            $x_PricingSubcategory = switch ($Provider) {
                "Azure"      { "Spot VM" }
                "AWS"        { "Spot Instance" }
                "GCP"        { "Preemptible VM" }
                default      { "Spot" }
            }

            $spotDiscount = Get-Random -Minimum 60 -Maximum 90
            $effectiveCost = [math]::Round($listCost * (100 - $spotDiscount) / 100, 10)
            $billedCost = $effectiveCost
            $contractedCost = $effectiveCost
        }
    }

    # Invoice ID: stable per billing period
    $invoiceKey = "$($billingAccount.Id)-$($billingPeriodStart.ToString('yyyyMM'))"
    if (-not $Identity.InvoiceIds.ContainsKey($invoiceKey)) {
        $Identity.InvoiceIds[$invoiceKey] = "INV-$($billingPeriodStart.ToString('yyyyMM'))-$(Get-Random -Minimum 10000 -Maximum 99999)"
    }
    $invoiceId = $Identity.InvoiceIds[$invoiceKey]

    # Tags as JSON
    $tagsJson = ($res.Tags | ConvertTo-Json -Compress)

    # Publisher info
    $isMarketplace = [bool]$service.IsMarketplace
    $publisherName = if ($isMarketplace) { Get-RandomElement -Array $Identity.MarketplacePublishers } else { $Config.ServiceProviderName }

    $costCenter = $res.Tags["costCenter"]

    return [PSCustomObject]@{
        # Mandatory FOCUS columns
        BilledCost           = $billedCost
        BillingAccountId     = $billingAccount.Id
        BillingAccountName   = $billingAccount.Name
        BillingAccountType   = $Config.BillingAccountType
        BillingCurrency      = $Config.BillingCurrency
        BillingPeriodEnd     = Get-IsoDateTime -Date $billingPeriodEnd
        BillingPeriodStart   = Get-IsoDateTime -Date $billingPeriodStart
        ChargeCategory       = $chargeCategory
        ChargeClass          = $chargeClass
        ChargeDescription    = "$($service.Name) usage in $($region.Name)"
        ChargeFrequency      = $chargeFrequency
        ChargePeriodEnd      = Get-IsoDateTime -Date $chargePeriodEnd
        ChargePeriodStart    = Get-IsoDateTime -Date $chargePeriodStart
        ContractedCost       = $contractedCost
        EffectiveCost        = $effectiveCost
        InvoiceIssuerName    = $Config.InvoiceIssuerName
        ListCost             = $listCost
        PricingQuantity      = $pricingQuantity
        PricingUnit          = $service.PricingUnit
        ServiceProviderName  = $Config.ServiceProviderName

        # Conditional FOCUS columns
        AvailabilityZone              = $az
        CommitmentDiscountCategory    = $commitmentDiscountCategory
        CommitmentDiscountId          = $commitmentDiscountId
        CommitmentDiscountName        = $commitmentDiscountName
        CommitmentDiscountQuantity    = $commitmentDiscountQuantity
        CommitmentDiscountStatus      = $commitmentDiscountStatus
        CommitmentDiscountType        = $commitmentDiscountType
        CommitmentDiscountUnit        = $commitmentDiscountUnit
        ConsumedQuantity              = $consumedQuantity
        ConsumedUnit                  = $service.ConsumedUnit
        ContractedUnitPrice           = if ($pricingQuantity -ne 0) { [math]::Round($contractedCost / $pricingQuantity, 10) } else { 0 }
        HostProviderName              = $Config.HostProviderName
        InvoiceId                     = $invoiceId
        ListUnitPrice                 = if ($pricingQuantity -ne 0) { [math]::Round($listCost / $pricingQuantity, 10) } else { 0 }
        PricingCategory               = $pricingCategory
        RegionId                      = $region.Id
        RegionName                    = $region.Name
        ResourceId                    = $res.ResourceId
        ResourceName                  = $res.ResourceName
        ResourceType                  = $res.ResourceType
        ServiceCategory               = $service.Category
        ServiceName                   = $service.Name
        ServiceSubcategory            = $service.Subcategory
        SkuId                         = $res.SkuId
        SkuPriceId                    = $res.SkuPriceId
        SubAccountId                  = $subAccount.Id
        SubAccountName                = $subAccount.Name
        SubAccountType                = $Config.SubAccountType
        Tags                          = $tagsJson

        # Custom columns (x_ prefix per FOCUS spec)
        x_CloudProvider       = $Provider
        x_FocusVersion        = $FocusVersion
        x_GeneratedAt         = Get-IsoDateTime -Date (Get-Date)
        x_SourceProvider      = $Provider
        x_PricingSubcategory  = $x_PricingSubcategory
        x_IsSpotInstance      = ($pricingCategory -eq "Spot")

        # FinOps Hub required columns
        ProviderName          = $Config.ServiceProviderName
        x_BillingAccountId    = $billingAccount.Id
        x_BillingProfileId    = Get-RandomElement -Array $Identity.BillingProfileIds
        x_ResourceGroupName   = $res.ResourceGroup
        x_CostCenter          = $costCenter
        x_SkuMeterId          = $res.SkuMeterId
        x_SkuOfferId          = if ($Provider -eq "Azure") { "MS-AZR-0017P" } else { $null }
        x_IngestionTime       = Get-IsoDateTime -Date (Get-Date)

        # Publisher
        PublisherName         = $publisherName
        x_PublisherCategory   = if ($isMarketplace) { "Marketplace" } else { $Provider }
        x_PublisherType       = if ($isMarketplace) { "Marketplace" } else { $Config.ServiceProviderName }
        x_PublisherName       = $null  # Deprecated

        # Azure Hybrid Benefit columns
        x_SkuMeterCategory    = $x_SkuMeterCategory
        x_SkuMeterName        = $x_SkuMeterName
        x_HybridBenefitType   = $x_HybridBenefitType
        SkuCores              = $skuCores

        # Sub-account unique name for dashboard grouping
        SubAccountNameUnique  = "$($subAccount.Name) ($($subAccount.Id))"
    }
}

# ============================================================================
# Main Execution
# ============================================================================

Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "FinOps Hub Multi-Cloud FOCUS Test Data Generator v2.0" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

# Determine providers and row distribution
$providers = if ($CloudProvider -eq "All") {
    @("Azure", "AWS", "GCP", "DataCenter")
} else {
    @($CloudProvider)
}

# Row distribution: ~60% Azure, ~20% AWS, ~15% GCP, ~5% DataCenter
$providerWeights = @{
    "Azure"      = 0.60
    "AWS"        = 0.20
    "GCP"        = 0.15
    "DataCenter" = 0.05
}

# If single provider, 100% goes to it
if ($providers.Count -eq 1) {
    $providerWeights = @{ $providers[0] = 1.0 }
}

# Calculate total days
$totalDays = [math]::Max(1, (New-TimeSpan -Start $StartDate -End $EndDate).Days + 1)

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Cloud Provider(s): $($providers -join ', ')"
Write-Host "  FOCUS Version: $FocusVersion"
Write-Host "  Date Range: $($StartDate.ToString('yyyy-MM-dd')) to $($EndDate.ToString('yyyy-MM-dd')) ($totalDays days)"
Write-Host "  Total Row Target: $([string]::Format('{0:N0}', $TotalRowTarget))"
Write-Host "  Total Budget: `$$([string]::Format('{0:N0}', $TotalBudget)) USD"
Write-Host "  Output Format: $OutputFormat"
Write-Host "  Output Path: $OutputPath"
Write-Host ""

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Green
}

# Pre-generate identities for each provider
Write-Host "Pre-generating persistent identities..." -ForegroundColor Yellow
$providerIdentities = @{}
foreach ($provider in $providers) {
    $providerIdentities[$provider] = New-ProviderIdentities -Provider $provider -Config $ProviderConfigs[$provider]
    $resCount = $providerIdentities[$provider].Resources.Count
    $saCount = $providerIdentities[$provider].SubAccounts.Count
    $baCount = $providerIdentities[$provider].BillingAccounts.Count
    $cdCount = $providerIdentities[$provider].Commitments.Count
    Write-Host "  $provider : $resCount resources, $saCount sub-accounts, $baCount billing accounts, $cdCount commitments" -ForegroundColor Gray
}
Write-Host ""

$totalRows = 0
$allProviderCosts = @{}       # Running sum of EffectiveCost per provider
$allProviderRowCounts = @{}   # Row count per provider
$allProviderCsvPaths = @{}    # Path to raw CSV per provider

# Generate rows for each provider — streaming to CSV to avoid OOM
foreach ($provider in $providers) {
    $weight = if ($providerWeights.ContainsKey($provider)) { $providerWeights[$provider] } else { 1.0 / $providers.Count }
    $providerTotalRows = [math]::Max(1, [int]($TotalRowTarget * $weight))
    $dailyRowCount = [math]::Max(1, [int]($providerTotalRows / $totalDays))

    Write-Host "Generating $provider data ($([string]::Format('{0:N0}', $providerTotalRows)) rows, ~$dailyRowCount/day)..." -ForegroundColor Yellow

    $config = $ProviderConfigs[$provider]
    $identity = $providerIdentities[$provider]
    $providerCsvPath = Join-Path $OutputPath "_raw_$($provider.ToLower()).csv"
    $providerCostSum = [double]0
    $headerWritten = $false

    $currentDate = $StartDate
    $rowsGenerated = 0
    $lastPct = -1

    while ($currentDate -le $EndDate -and $rowsGenerated -lt $providerTotalRows) {
        # Vary daily count slightly (+/- 10%) for realism
        $variance = [int]($dailyRowCount * 0.1)
        if ($variance -lt 1) { $variance = 1 }
        $todayCount = [math]::Max(1, $dailyRowCount + (Get-Random -Minimum (-$variance) -Maximum ($variance + 1)))

        # Don't exceed target
        if ($rowsGenerated + $todayCount -gt $providerTotalRows) {
            $todayCount = $providerTotalRows - $rowsGenerated
        }

        # Generate one day's rows in a small batch
        $dayRows = [System.Collections.Generic.List[PSCustomObject]]::new($todayCount)
        for ($i = 0; $i -lt $todayCount; $i++) {
            $row = New-FocusRow -Provider $provider -ChargeDate $currentDate -Config $config -Identity $identity -IncludeCommitments -IncludeHybridBenefit
            $providerCostSum += $row.EffectiveCost
            $dayRows.Add($row)
        }

        # Append daily batch to CSV (stream to disk, free memory)
        if (-not $headerWritten) {
            $dayRows | Export-Csv -Path $providerCsvPath -NoTypeInformation -Encoding UTF8
            $headerWritten = $true
        } else {
            $dayRows | Export-Csv -Path $providerCsvPath -NoTypeInformation -Encoding UTF8 -Append
        }
        $dayRows.Clear()
        $dayRows = $null

        $rowsGenerated += $todayCount
        $currentDate = $currentDate.AddDays(1)

        # Progress indicator every 10%
        $pct = [math]::Floor($rowsGenerated / $providerTotalRows * 100)
        if ($pct -ge $lastPct + 10) {
            $lastPct = $pct
            Write-Host "  $provider : $pct% ($([string]::Format('{0:N0}', $rowsGenerated)) rows)" -ForegroundColor Gray
        }
    }

    Write-Host "  $provider : Generated $([string]::Format('{0:N0}', $rowsGenerated)) rows" -ForegroundColor Green
    $allProviderCosts[$provider] = $providerCostSum
    $allProviderRowCounts[$provider] = $rowsGenerated
    $allProviderCsvPaths[$provider] = $providerCsvPath
    $totalRows += $rowsGenerated

    # Force GC between providers to reclaim memory
    [System.GC]::Collect()
}

# ============================================================================
# Budget Scaling (calculated from tracked sums, applied via Python/pandas)
# ============================================================================

$totalGeneratedCost = 0
foreach ($provider in $providers) {
    $totalGeneratedCost += $allProviderCosts[$provider]
}

$scaleFactor = if ($totalGeneratedCost -gt 0) { $TotalBudget / $totalGeneratedCost } else { 1 }
Write-Host ""
Write-Host "Scaling costs by factor $([math]::Round($scaleFactor, 4)) to target budget `$$([string]::Format('{0:N0}', $TotalBudget))" -ForegroundColor Cyan

# ============================================================================
# Export — Budget scaling + Parquet conversion via Python/pandas (memory-safe)
# ============================================================================

$generatedFiles = @()

foreach ($provider in $providers) {
    $rawCsvPath = $allProviderCsvPaths[$provider]
    $providerRowCount = $allProviderRowCounts[$provider]
    $providerScaledCost = [math]::Round($allProviderCosts[$provider] * $scaleFactor, 2)

    $baseFileName = "focus-$($provider.ToLower())-$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
    $csvFileName = "$baseFileName.csv"
    $csvFilePath = Join-Path $OutputPath $csvFileName
    $parquetFileName = "$baseFileName.parquet"
    $parquetFilePath = Join-Path $OutputPath $parquetFileName

    Write-Host "  $provider : $([string]::Format('{0:N0}', $providerRowCount)) rows, `$$([string]::Format('{0:N2}', $providerScaledCost)) USD" -ForegroundColor Green

    # Use Python/pandas to: apply budget scaling, output CSV/Parquet
    $rawCsvPy = ($rawCsvPath -replace '\\', '/')
    $csvOutPy = ($csvFilePath -replace '\\', '/')
    $parquetOutPy = ($parquetFilePath -replace '\\', '/')

    $pythonScript = @"
import pandas as pd, sys
try:
    df = pd.read_csv('$rawCsvPy', low_memory=False)
    sf = $scaleFactor
    for col in ['BilledCost','ContractedCost','EffectiveCost','ListCost','ContractedUnitPrice','ListUnitPrice']:
        if col in df.columns:
            df[col] = (df[col] * sf).round(10)
    fmt = '$OutputFormat'
    if fmt in ('CSV','Both'):
        df.to_csv('$csvOutPy', index=False)
        print('CSV_OK')
    if fmt in ('Parquet','Both'):
        df.to_parquet('$parquetOutPy', engine='pyarrow', compression='snappy', index=False)
        print('PARQUET_OK')
    if fmt == 'Parquet':
        df.to_parquet('$parquetOutPy', engine='pyarrow', compression='snappy', index=False)
        print('PARQUET_OK')
    print('DONE')
except Exception as e:
    print(f'ERROR: {e}')
    sys.exit(1)
"@

    $result = ($pythonScript | python 2>&1) -join "`n"
    if ($result -match 'DONE') {
        if ($result -match 'PARQUET_OK') {
            Write-Host "  Saved Parquet: $parquetFilePath" -ForegroundColor Gray
            $generatedFiles += $parquetFilePath
        }
        if ($result -match 'CSV_OK') {
            Write-Host "  Saved CSV: $csvFilePath" -ForegroundColor Gray
            $generatedFiles += $csvFilePath
        }
        if ($OutputFormat -eq "Parquet" -and -not ($result -match 'CSV_OK')) {
            # Parquet-only: no final CSV needed
        } elseif ($OutputFormat -eq "Parquet" -and (Test-Path $csvFilePath)) {
            # If we accidentally wrote CSV in Parquet mode, keep it as fallback
        }
    } else {
        Write-Host "  Warning: Python scaling failed. Using raw CSV without scaling." -ForegroundColor Yellow
        Write-Host "    $result" -ForegroundColor Yellow
        # Fall back: rename raw CSV as final CSV
        Copy-Item $rawCsvPath $csvFilePath -Force
        $generatedFiles += $csvFilePath
    }

    # Clean up raw CSV (intermediate file)
    if (Test-Path $rawCsvPath) { Remove-Item $rawCsvPath -Force }

    # Generate manifest.json
    $manifestFilePath = Join-Path $OutputPath "manifest-$($provider.ToLower()).json"

    $dataFile = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { "$baseFileName.parquet" } else { "$baseFileName.csv" }
    $dataFilePath = Join-Path $OutputPath $dataFile
    $fileSize = if (Test-Path $dataFilePath) { (Get-Item $dataFilePath).Length } else { 0 }

    $manifest = @{
        exportConfig = @{
            exportName   = "focus-$($provider.ToLower())-export"
            resourceId   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
            dataVersion  = "1.0"
            apiVersion   = "2023-08-01"
            type         = "FocusCost"
            timeFrame    = "Custom"
            granularity  = "Daily"
        }
        deliveryConfig = @{
            partitionData            = $true
            dataOverwriteBehavior    = "OverwritePreviousReport"
            fileFormat               = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { "Parquet" } else { "Csv" }
            compressionMode          = "Snappy"
        }
        blobs = @(
            @{
                blobName  = $dataFile
                byteCount = $fileSize
            }
        )
        runInfo = @{
            executionType = "Scheduled"
            submittedTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            runId         = [guid]::NewGuid().ToString()
            startDate     = $StartDate.ToString("yyyy-MM-ddT00:00:00Z")
            endDate       = $EndDate.ToString("yyyy-MM-ddT00:00:00Z")
        }
    } | ConvertTo-Json -Depth 5

    $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8
    Write-Host "  Saved manifest: $manifestFilePath" -ForegroundColor Gray
    $generatedFiles += $manifestFilePath
}

# ============================================================================
# Summary
# ============================================================================

Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "Generation Complete!" -ForegroundColor Green
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Total Rows Generated: $([string]::Format('{0:N0}', $totalRows))"
Write-Host "  Total Cost: `$$([string]::Format('{0:N2}', $TotalBudget)) USD"
Write-Host "  Output Format: $OutputFormat"
Write-Host "  Files Created: $($generatedFiles.Count)"
Write-Host ""
Write-Host "Provider Breakdown:" -ForegroundColor Yellow
foreach ($provider in $providers) {
    $providerScaledCost = [math]::Round($allProviderCosts[$provider] * $scaleFactor, 2)
    $providerRowCount = $allProviderRowCounts[$provider]
    Write-Host "  $provider : $([string]::Format('{0:N0}', $providerRowCount)) rows | `$$([string]::Format('{0:N2}', $providerScaledCost))"
}
Write-Host ""
Write-Host "Generated Files:" -ForegroundColor Yellow
foreach ($file in $generatedFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length / 1MB
        Write-Host "  - $file ($([math]::Round($size, 2)) MB)"
    }
}

# ============================================================================
# Upload to Azure Storage
# ============================================================================

if ($Upload -and $StorageAccountName) {
    Write-Host ""
    Write-Host ("=" * 70) -ForegroundColor Cyan
    Write-Host "Uploading to Azure Storage..." -ForegroundColor Yellow
    Write-Host ("=" * 70) -ForegroundColor Cyan

    # Get storage account key
    $storageKey = $null
    if ($ResourceGroupName) {
        Write-Host "  Getting storage account key..." -ForegroundColor Gray
        $storageKey = (az storage account keys list --account-name $StorageAccountName --resource-group $ResourceGroupName --query "[0].value" -o tsv 2>$null)
        if (-not $storageKey) {
            Write-Host "  Warning: Could not get storage key, falling back to default auth" -ForegroundColor Yellow
        }
    }

    # Start ADF triggers BEFORE uploading data
    if ($StartTriggers -and $AdfName -and $ResourceGroupName) {
        Write-Host ""
        Write-Host ("=" * 70) -ForegroundColor Cyan
        Write-Host "Ensuring ADF Triggers are running (BEFORE upload)..." -ForegroundColor Yellow
        Write-Host ("=" * 70) -ForegroundColor Cyan

        $triggers = @("msexports_ManifestAdded", "ingestion_ManifestAdded")
        foreach ($trigger in $triggers) {
            $state = (az datafactory trigger show --factory-name $AdfName --resource-group $ResourceGroupName --name $trigger --query "properties.runtimeState" -o tsv 2>$null)
            if ($state -eq "Started") {
                Write-Host "  $trigger already running" -ForegroundColor Gray
            } else {
                Write-Host "  Starting $trigger..." -ForegroundColor Cyan
                az datafactory trigger start --factory-name $AdfName --resource-group $ResourceGroupName --name $trigger --only-show-errors 2>$null
                Write-Host "  $trigger started" -ForegroundColor Green
            }
        }

        Write-Host "  Waiting 5 seconds for triggers to become active..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
        Write-Host ""
    }

    $uploadedCount = 0
    $runId = [guid]::NewGuid().ToString()
    $exportTime = (Get-Date).ToString("yyyyMMddHHmm")

    foreach ($provider in $providers) {
        $providerLower = $provider.ToLower()
        $baseFileName = "focus-$providerLower-$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"

        $fileExt = if ($OutputFormat -eq "Parquet" -or $OutputFormat -eq "Both") { ".parquet" } else { ".csv" }
        $dataFile = "$baseFileName$fileExt"
        $dataFilePath = Join-Path $OutputPath $dataFile

        if (-not (Test-Path $dataFilePath)) {
            Write-Host "  Warning: $dataFilePath not found, skipping $provider" -ForegroundColor Yellow
            continue
        }

        $fileSize = (Get-Item $dataFilePath).Length

        if ($providerLower -eq "azure") {
            # Azure: msexports with Cost Management folder structure
            $container = "msexports"
            $scopeId = "subscriptions/00000000-0000-0000-0000-000000000000"
            $exportName = "focus-cost-export"
            $dateRange = "$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
            $blobFolder = "$scopeId/$exportName/$dateRange/$exportTime/$runId"
            $blobPath = "$blobFolder/$dataFile"
            $manifestBlobPath = "$blobFolder/manifest.json"

            $manifest = @{
                manifestVersion = "2024-04-01"
                byteCount       = $fileSize
                blobCount       = 1
                dataRowCount    = $allProviderRowCounts[$provider]
                exportConfig = @{
                    exportName  = $exportName
                    resourceId  = "/$scopeId/providers/Microsoft.CostManagement/exports/$exportName"
                    dataVersion = "1.0r2"
                    apiVersion  = "2023-07-01-preview"
                    type        = "FocusCost"
                    timeFrame   = "Custom"
                    granularity = "Daily"
                }
                deliveryConfig = @{
                    partitionData            = $true
                    dataOverwriteBehavior    = "OverwritePreviousReport"
                    fileFormat               = if ($fileExt -eq ".parquet") { "Parquet" } else { "Csv" }
                    compressionMode          = if ($fileExt -eq ".parquet") { "Snappy" } else { "None" }
                    containerUri             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/$StorageAccountName"
                    rootFolderPath           = ""
                }
                runInfo = @{
                    executionType = "Scheduled"
                    submittedTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ")
                    runId         = $runId
                    startDate     = $StartDate.ToString("yyyy-MM-ddT00:00:00")
                    endDate       = $EndDate.ToString("yyyy-MM-ddT00:00:00")
                }
                blobs = @(
                    @{
                        blobName     = $blobPath
                        byteCount    = $fileSize
                        dataRowCount = $allProviderRowCounts[$provider]
                    }
                )
            } | ConvertTo-Json -Depth 5

            $manifestFilePath = Join-Path $OutputPath "manifest-$providerLower.json"
            $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8

            Write-Host "  Uploading $provider to msexports container..." -ForegroundColor Cyan
            if ($storageKey) {
                az storage blob upload --account-name $StorageAccountName --account-key $storageKey --container-name $container --file $dataFilePath --name $blobPath --overwrite --only-show-errors 2>$null
                az storage blob upload --account-name $StorageAccountName --account-key $storageKey --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
            } else {
                az storage blob upload --account-name $StorageAccountName --container-name $container --file $dataFilePath --name $blobPath --overwrite --only-show-errors 2>$null
                az storage blob upload --account-name $StorageAccountName --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
            }

        } else {
            # AWS/GCP/DataCenter: ingestion container
            $container = "ingestion"
            $scopePath = "$providerLower/test-account"
            $ingestionId = (Get-Date).ToString("yyyyMMddHHmmss")
            $blobFolder = "Costs/$($EndDate.ToString('yyyy'))/$($EndDate.ToString('MM'))/$scopePath"
            $blobPath = "$blobFolder/${ingestionId}__$dataFile"
            $manifestBlobPath = "$blobFolder/manifest.json"

            $manifest = @{
                note      = "Trigger file for ADX ingestion"
                provider  = $providerLower
                timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            } | ConvertTo-Json -Depth 3

            $manifestFilePath = Join-Path $OutputPath "manifest-$providerLower.json"
            $manifest | Out-File -FilePath $manifestFilePath -Encoding UTF8

            Write-Host "  Uploading $provider to ingestion container..." -ForegroundColor Cyan
            if ($storageKey) {
                az storage blob upload --account-name $StorageAccountName --account-key $storageKey --container-name $container --file $dataFilePath --name $blobPath --overwrite --only-show-errors 2>$null
                az storage blob upload --account-name $StorageAccountName --account-key $storageKey --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
            } else {
                az storage blob upload --account-name $StorageAccountName --container-name $container --file $dataFilePath --name $blobPath --overwrite --only-show-errors 2>$null
                az storage blob upload --account-name $StorageAccountName --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
            }
        }

        Write-Host "    Uploaded: $blobPath" -ForegroundColor Green
        Write-Host "    Uploaded: $manifestBlobPath" -ForegroundColor Green
        $uploadedCount++
    }

    Write-Host ""
    Write-Host "Upload Complete! $uploadedCount providers uploaded." -ForegroundColor Green

    # Verify ADF pipeline execution
    if ($StartTriggers -and $AdfName -and $ResourceGroupName) {
        Write-Host ""
        Write-Host ("=" * 70) -ForegroundColor Cyan
        Write-Host "Verifying ADF Pipeline Execution..." -ForegroundColor Yellow
        Write-Host ("=" * 70) -ForegroundColor Cyan

        Write-Host "  Waiting 15 seconds for blob events to propagate..." -ForegroundColor Gray
        Start-Sleep -Seconds 15

        $now = (Get-Date).ToUniversalTime()
        $checkFrom = $now.AddMinutes(-5).ToString("yyyy-MM-ddTHH:mm:ssZ")
        $checkTo = $now.AddMinutes(5).ToString("yyyy-MM-ddTHH:mm:ssZ")

        $pipelineRuns = az datafactory pipeline-run query-by-factory --factory-name $AdfName --resource-group $ResourceGroupName --last-updated-after $checkFrom --last-updated-before $checkTo -o json 2>$null | ConvertFrom-Json

        if ($pipelineRuns.value.Count -gt 0) {
            Write-Host "  ADF pipelines triggered successfully!" -ForegroundColor Green
            foreach ($run in $pipelineRuns.value) {
                Write-Host "    $($run.pipelineName) | $($run.status)" -ForegroundColor Gray
            }
        } else {
            Write-Host "  Warning: No pipeline runs detected. Re-uploading manifests as safety net..." -ForegroundColor Yellow

            foreach ($provider in $providers) {
                $providerLower = $provider.ToLower()
                $manifestFilePath = Join-Path $OutputPath "manifest-$providerLower.json"
                if (-not (Test-Path $manifestFilePath)) { continue }

                if ($providerLower -eq "azure") {
                    $container = "msexports"
                    $scopeId = "subscriptions/00000000-0000-0000-0000-000000000000"
                    $exportName = "focus-cost-export"
                    $dateRange = "$($StartDate.ToString('yyyyMMdd'))-$($EndDate.ToString('yyyyMMdd'))"
                    $blobFolder = "$scopeId/$exportName/$dateRange/$exportTime/$runId"
                    $manifestBlobPath = "$blobFolder/manifest.json"
                } else {
                    $container = "ingestion"
                    $scopePath = "$providerLower/test-account"
                    $blobFolder = "Costs/$($EndDate.ToString('yyyy'))/$($EndDate.ToString('MM'))/$scopePath"
                    $manifestBlobPath = "$blobFolder/manifest.json"
                }

                Write-Host "    Re-uploading $container/$manifestBlobPath" -ForegroundColor Cyan
                if ($storageKey) {
                    az storage blob upload --account-name $StorageAccountName --account-key $storageKey --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
                } else {
                    az storage blob upload --account-name $StorageAccountName --container-name $container --file $manifestFilePath --name $manifestBlobPath --overwrite --only-show-errors 2>$null
                }
            }
            Write-Host "  Manifests re-uploaded. Pipelines should trigger shortly." -ForegroundColor Green
        }

        Write-Host ""
        Write-Host "ADF triggers are running. Data will be processed automatically." -ForegroundColor Green
    } elseif ($StartTriggers) {
        Write-Host ""
        Write-Host "Warning: -StartTriggers requires -AdfName and -ResourceGroupName" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "Next Steps:" -ForegroundColor Yellow
        Write-Host "  1. Ensure ADF triggers are started BEFORE uploading data:"
        Write-Host "     az datafactory trigger start --factory-name <adf> --resource-group <rg> --name msexports_ManifestAdded"
        Write-Host "     az datafactory trigger start --factory-name <adf> --resource-group <rg> --name ingestion_ManifestAdded"
        Write-Host "  2. Then upload data (manifest upload fires BlobCreated event)"
        Write-Host "  3. Or re-run with -StartTriggers -AdfName <name> -ResourceGroupName <rg>"
    }
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
Write-Host "  - CommitmentDiscountCategory: Reservation=Usage, SavingsPlan=Spend (per FOCUS)"
Write-Host ""
