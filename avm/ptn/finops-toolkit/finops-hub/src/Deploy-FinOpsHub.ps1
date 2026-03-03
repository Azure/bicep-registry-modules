<#
.SYNOPSIS
    Deploys a FinOps Hub using the Bicep template.

.DESCRIPTION
    Helper script to deploy a FinOps Hub with common configurations.
    Validates prerequisites, handles authentication, and configures Cost Management exports.

.PARAMETER HubName
    Required. Name of the FinOps Hub (3-24 characters).

.PARAMETER ResourceGroupName
    Required. Resource group to deploy into (will be created if missing).

.PARAMETER Location
    Required. Azure region for deployment.

.PARAMETER SubscriptionId
    Required. Target subscription ID.

.PARAMETER TenantId
    Required. Azure AD tenant ID.

.PARAMETER DeploymentType
    Optional. Type of deployment: storage-only, adx, or fabric. Default: storage-only

.PARAMETER Configuration
    Optional. Configuration profile: minimal or waf-aligned. Default: minimal

.PARAMETER DataExplorerClusterName
    Optional. ADX cluster name (required if DeploymentType is 'adx').

.PARAMETER ExistingManagedIdentityResourceId
    Optional. Resource ID of an existing managed identity to use.

.PARAMETER EnablePrivateEndpoints
    Optional. Enable private endpoints (requires subnet and DNS zone IDs).

.PARAMETER PrivateEndpointSubnetId
    Optional. Resource ID of subnet for private endpoints.

.PARAMETER SkipPrerequisiteCheck
    Optional. Skip version and module checks.

.EXAMPLE
    # Interactive - prompts for subscription
    .\Deploy-FinOpsHub.ps1 -HubName "myfinopshub" -ResourceGroupName "rg-finops" -Location "eastus" `
        -TenantId "your-tenant-id" -SubscriptionId "your-subscription-id"

.EXAMPLE
    # ADX deployment
    .\Deploy-FinOpsHub.ps1 -HubName "myfinopshub" -ResourceGroupName "rg-finops" -Location "eastus" `
        -TenantId "your-tenant-id" -SubscriptionId "your-subscription-id" `
        -DeploymentType "adx" -DataExplorerClusterName "myfinopsadx"
#>

#Requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateLength(3, 24)]
    [string]$HubName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $true)]
    [string]$TenantId,

    [Parameter(Mandatory = $false)]
    [ValidateSet('storage-only', 'adx', 'fabric')]
    [string]$DeploymentType = 'storage-only',

    [Parameter(Mandatory = $false)]
    [ValidateSet('minimal', 'waf-aligned')]
    [string]$Configuration = 'minimal',

    [Parameter(Mandatory = $false)]
    [string]$DataExplorerClusterName = '',

    [Parameter(Mandatory = $false)]
    [string]$ExistingManagedIdentityResourceId = '',

    [Parameter(Mandatory = $false)]
    [switch]$EnablePrivateEndpoints,

    [Parameter(Mandatory = $false)]
    [string]$PrivateEndpointSubnetId = '',

    [Parameter(Mandatory = $false)]
    [switch]$SkipPrerequisiteCheck,

    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

# ============================================================================
# VERSION REQUIREMENTS
# ============================================================================
$MinPsVersion = [Version]'7.0.0'
$MinAzCliVersion = [Version]'2.61.0'
$MinBicepVersion = [Version]'0.28.0'
$MinAzModuleVersion = [Version]'12.0.0'

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Write-Header {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host '║               FinOps Hub Deployment                          ║' -ForegroundColor Cyan
    Write-Host '║               Powered by Azure Verified Modules              ║' -ForegroundColor Cyan
    Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
}

function Test-Prerequisites {
    Write-Host "`n🔧 Checking prerequisites..." -ForegroundColor Yellow

    $errors = @()

    # Check PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion -lt $MinPsVersion) {
        $errors += "PowerShell $MinPsVersion+ required. Current: $psVersion. Install from https://aka.ms/powershell"
    } else {
        Write-Host "   ✓ PowerShell $psVersion" -ForegroundColor Green
    }

    # Check Azure CLI (required)
    $azCliInstalled = $false
    try {
        $azVersionOutput = az version 2>$null
        if ($azVersionOutput) {
            $azVersionJson = $azVersionOutput | ConvertFrom-Json
            $azVersion = [Version]$azVersionJson.'azure-cli'
            $azCliInstalled = $true
            if ($azVersion -lt $MinAzCliVersion) {
                Write-Host "   ⚠ Azure CLI $azVersion (recommend $MinAzCliVersion+, run: az upgrade)" -ForegroundColor Yellow
            } else {
                Write-Host "   ✓ Azure CLI $azVersion" -ForegroundColor Green
            }
        }
    } catch {}

    if (-not $azCliInstalled) {
        $errors += 'Azure CLI not found. Install from https://aka.ms/installazurecli'
    }

    # Check Bicep CLI (required, only if Azure CLI is installed)
    if ($azCliInstalled) {
        $bicepInstalled = $false
        $bicepVersion = $null

        # Try standalone bicep first
        try {
            $bicepOutput = bicep --version 2>$null
            if ($bicepOutput -match '(\d+\.\d+\.\d+)') {
                $bicepVersion = [Version]$Matches[1]
                $bicepInstalled = $true
            }
        } catch {}

        # Try az bicep as fallback
        if (-not $bicepInstalled) {
            try {
                $azBicepOutput = az bicep version 2>$null
                if ($azBicepOutput -match '(\d+\.\d+\.\d+)') {
                    $bicepVersion = [Version]$Matches[1]
                    $bicepInstalled = $true
                }
            } catch {}
        }

        if ($bicepInstalled) {
            if ($bicepVersion -lt $MinBicepVersion) {
                Write-Host "   ⚠ Bicep CLI $bicepVersion (recommend $MinBicepVersion+, run: az bicep upgrade)" -ForegroundColor Yellow
            } else {
                Write-Host "   ✓ Bicep CLI $bicepVersion" -ForegroundColor Green
            }
        } else {
            Write-Host '   ⚠ Bicep CLI not found, installing...' -ForegroundColor Yellow
            az bicep install 2>&1 | Out-Null
            Write-Host '   ✓ Bicep CLI installed' -ForegroundColor Green
        }
    }

    # Az PowerShell is optional - just show info, no prompts
    $azModule = Get-Module -ListAvailable -Name Az.Accounts | Sort-Object Version -Descending | Select-Object -First 1
    if ($azModule) {
        Write-Host "   ✓ Az PowerShell $($azModule.Version) (optional)" -ForegroundColor Green
    }

    if ($errors.Count -gt 0) {
        Write-Host "`n❌ Prerequisites not met:" -ForegroundColor Red
        $errors | ForEach-Object { Write-Host "   • $_" -ForegroundColor Red }
        throw 'Please install required prerequisites and try again.'
    }

    Write-Host ''
}

function Register-RequiredProviders {
    param(
        [string]$SubscriptionId
    )

    Write-Host "`n📦 Checking required resource providers..." -ForegroundColor Yellow

    # List of required providers for FinOps Hub
    $requiredProviders = @(
        'Microsoft.Storage',
        'Microsoft.KeyVault',
        'Microsoft.DataFactory',
        'Microsoft.EventGrid',      # Required for blob event triggers
        'Microsoft.ManagedIdentity',
        'Microsoft.Kusto'           # Required for Azure Data Explorer
    )

    foreach ($provider in $requiredProviders) {
        $state = az provider show --namespace $provider --query 'registrationState' -o tsv 2>$null
        if ($state -ne 'Registered') {
            Write-Host "   ⏳ Registering $provider..." -ForegroundColor Yellow
            az provider register --namespace $provider --wait 2>&1 | Out-Null
            Write-Host "   ✓ $provider registered" -ForegroundColor Green
        } else {
            Write-Host "   ✓ $provider" -ForegroundColor Green
        }
    }

    Write-Host ''
}

function Connect-AzureCLI {
    param(
        [string]$TenantId,
        [string]$SubscriptionId
    )

    Write-Host "`n🔐 Checking Azure authentication..." -ForegroundColor Yellow

    # Check if logged in to the correct tenant
    $account = $null
    try {
        $account = az account show 2>$null | ConvertFrom-Json
    } catch {}

    # Login if not logged in or wrong tenant
    if (-not $account -or $account.tenantId -ne $TenantId) {
        Write-Host "   Logging in to tenant: $TenantId" -ForegroundColor Yellow
        az login --tenant $TenantId --only-show-errors
        $account = az account show | ConvertFrom-Json
    }

    Write-Host "   ✓ Tenant: $($account.tenantId)" -ForegroundColor Green
    Write-Host "   ✓ User:   $($account.user.name)" -ForegroundColor Green

    # Set the subscription
    az account set --subscription $SubscriptionId
    $account = az account show | ConvertFrom-Json
    Write-Host "   ✓ Subscription: $($account.name)" -ForegroundColor Green
    Write-Host "   ✓ Subscription ID: $($account.id)" -ForegroundColor Green

    return $account
}

function Test-RoleAssignments {
    param(
        [string]$SubscriptionId
    )

    Write-Host "`n🔑 Checking permissions..." -ForegroundColor Yellow

    try {
        $currentUser = az ad signed-in-user show 2>$null | ConvertFrom-Json
        if ($currentUser) {
            $roles = az role assignment list `
                --assignee $currentUser.id `
                --scope "/subscriptions/$SubscriptionId" `
                --query '[].roleDefinitionName' -o json 2>$null | ConvertFrom-Json

            $hasContributor = $roles -contains 'Contributor' -or $roles -contains 'Owner'
            $hasRbacAdmin = $roles -contains 'Role Based Access Control Administrator' -or
            $roles -contains 'Owner' -or
            $roles -contains 'User Access Administrator'

            if ($hasContributor -and $hasRbacAdmin) {
                Write-Host '   ✓ Sufficient permissions for deployment' -ForegroundColor Green
            } elseif ($hasContributor) {
                Write-Host '   ⚠ Has Contributor, may need RBAC admin for role assignments' -ForegroundColor Yellow
            } else {
                Write-Host '   ⚠ Verify you have: Contributor + Role Based Access Control Administrator' -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host '   ℹ Could not verify permissions (will attempt deployment)' -ForegroundColor Gray
    }
}

function Show-CostEstimate {
    param([string]$DeploymentType, [string]$Configuration)

    Write-Host "`n💰 Estimated Monthly Cost:" -ForegroundColor Yellow

    $estimates = @{
        'storage-only' = @{ 'minimal' = '$5-10'; 'waf-aligned' = '$20-50' }
        'adx'          = @{ 'minimal' = '$50-150 (auto-stop)'; 'waf-aligned' = '$800-1200' }
        'fabric'       = @{ 'minimal' = '$5-10 + Fabric capacity'; 'waf-aligned' = '$20-50 + Fabric capacity' }
    }

    $estimate = $estimates[$DeploymentType][$Configuration]
    Write-Host "   $DeploymentType ($Configuration): $estimate" -ForegroundColor Cyan
    Write-Host '   (Actual costs depend on data volume and query usage)' -ForegroundColor Gray
}

function Show-FinOpsTips {
    Write-Host "`n💡 FinOps Best Practices:" -ForegroundColor Magenta
    Write-Host '   • Use FOCUS format exports for standardized, multi-cloud data'
    Write-Host '   • Enable daily exports (or hourly for real-time monitoring)'
    Write-Host '   • Tag all resources: CostCenter, Owner, Environment, Application'
    Write-Host '   • Set up budget alerts at 50%, 80%, 100% thresholds'
    Write-Host '   • Review anomaly detection weekly in Power BI'
}

function Start-DataFactoryTriggers {
    param(
        [string]$ResourceGroupName,
        [string]$DataFactoryName,
        [string]$DeploymentType
    )

    Write-Host "`n🚀 Starting Data Factory triggers..." -ForegroundColor Yellow

    # Define triggers based on deployment type
    $triggers = @('msexports_ManifestAdded')
    if ($DeploymentType -in @('adx', 'fabric')) {
        $triggers += 'ingestion_ManifestAdded'
    }

    $allStarted = $true
    foreach ($triggerName in $triggers) {
        try {
            $startResult = az datafactory trigger start `
                --resource-group $ResourceGroupName `
                --factory-name $DataFactoryName `
                --name $triggerName `
                --only-show-errors 2>&1

            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✓ Started: $triggerName" -ForegroundColor Green
            } else {
                Write-Host "   ⚠️  Could not start $triggerName" -ForegroundColor Yellow
                Write-Host "      $startResult" -ForegroundColor Gray
                $allStarted = $false
            }
        } catch {
            Write-Host "   ⚠️  Error starting $triggerName : $_" -ForegroundColor Yellow
            $allStarted = $false
        }
    }

    if (-not $allStarted) {
        Write-Host "`n   To manually start triggers, run:" -ForegroundColor Yellow
        foreach ($t in $triggers) {
            Write-Host "   az datafactory trigger start -g $ResourceGroupName --factory-name $DataFactoryName --name $t" -ForegroundColor Cyan
        }
    }

    return $allStarted
}

function Send-HubSettings {
    param(
        [string]$StorageAccountName,
        [string]$SubscriptionId,
        [string]$SettingsTemplatePath
    )

    Write-Host "`n⚙️  Uploading hub settings..." -ForegroundColor Yellow

    if (-not (Test-Path $SettingsTemplatePath)) {
        Write-Host "   ⚠️  Settings template not found at: $SettingsTemplatePath" -ForegroundColor Yellow
        return $false
    }

    try {
        # Read and update settings.json
        $settings = Get-Content $SettingsTemplatePath -Raw | ConvertFrom-Json
        $settings.created = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        $settings.updated = $settings.created
        $settings.scopes = @("/subscriptions/$SubscriptionId")

        # Write to temp file
        $tempSettings = Join-Path $env:TEMP 'settings.json'
        $settings | ConvertTo-Json -Depth 10 | Out-File $tempSettings -Encoding utf8NoBOM

        # Upload to storage
        $uploadResult = az storage blob upload `
            --account-name $StorageAccountName `
            --container-name 'config' `
            --name 'settings.json' `
            --file $tempSettings `
            --auth-mode login `
            --overwrite `
            --only-show-errors 2>&1

        Remove-Item $tempSettings -Force -ErrorAction SilentlyContinue

        if ($LASTEXITCODE -eq 0) {
            Write-Host '   ✓ settings.json uploaded to config container' -ForegroundColor Green
            return $true
        } else {
            Write-Host '   ⚠️  Could not upload settings.json' -ForegroundColor Yellow
            Write-Host "      Error: $uploadResult" -ForegroundColor Gray
            Write-Host "      You may need 'Storage Blob Data Contributor' role" -ForegroundColor Gray
            return $false
        }
    } catch {
        Write-Host "   ⚠️  Error uploading settings: $_" -ForegroundColor Yellow
        return $false
    }
}

function Get-DeploymentTypeInteractive {
    param(
        [string]$CurrentType,
        [string]$CurrentClusterName,
        [string]$CurrentConfiguration
    )

    Write-Host "`n🎯 Deployment Type Selection:" -ForegroundColor Yellow
    Write-Host ''
    Write-Host '   [1] Storage Only (Power BI)' -ForegroundColor White
    Write-Host '       Best for: Small to medium organizations, Power BI reporting' -ForegroundColor Gray
    Write-Host ''
    Write-Host '   [2] Azure Data Explorer (ADX)' -ForegroundColor White
    Write-Host '       Best for: Large datasets, KQL queries, real-time analytics' -ForegroundColor Gray
    Write-Host ''
    Write-Host '   [3] Microsoft Fabric' -ForegroundColor White
    Write-Host '       Best for: Organizations already using Fabric, unified analytics' -ForegroundColor Gray
    Write-Host ''

    $selection = Read-Host '   Select deployment type [1-3] (default: 1)'

    $deployType = switch ($selection) {
        '2' { 'adx' }
        '3' { 'fabric' }
        default { 'storage-only' }
    }

    $clusterName = ''
    $useExisting = $false

    if ($deployType -eq 'adx') {
        Write-Host ''
        $hasExisting = Read-Host '   Do you have an existing ADX cluster to use? [y/N]'
        if ($hasExisting -eq 'y') {
            $useExisting = $true
            $clusterName = Read-Host '   Enter existing ADX cluster name'
        } else {
            $clusterName = Read-Host '   Enter name for new ADX cluster (3-22 chars, lowercase)'
            if ([string]::IsNullOrEmpty($clusterName)) {
                $clusterName = "adx-finops-$(Get-Random -Maximum 9999)"
                Write-Host "   Using generated name: $clusterName" -ForegroundColor Gray
            }
        }
    } elseif ($deployType -eq 'fabric') {
        Write-Host ''
        $hasExisting = Read-Host '   Do you have an existing Fabric workspace? [y/N]'
        if ($hasExisting -eq 'y') {
            $useExisting = $true
            Write-Host "   ℹ You'll connect your existing Fabric workspace after deployment" -ForegroundColor Gray
        } else {
            Write-Host '   ℹ A new Fabric workspace reference will be configured' -ForegroundColor Gray
        }
    }

    # Configuration selection
    Write-Host "`n⚙️  Configuration Profile:" -ForegroundColor Yellow
    Write-Host ''
    Write-Host '   [1] Minimal (Dev/Test)' -ForegroundColor White
    Write-Host '       • Lowest cost, single region, no redundancy' -ForegroundColor Gray
    Write-Host '       • Standard_LRS storage, Dev SKU for ADX' -ForegroundColor Gray
    Write-Host ''
    Write-Host '   [2] WAF-Aligned (Production)' -ForegroundColor White
    Write-Host '       • High availability, zone redundant' -ForegroundColor Gray
    Write-Host '       • Premium_ZRS storage, purge protection enabled' -ForegroundColor Gray
    Write-Host ''

    $configSelection = Read-Host '   Select configuration [1-2] (default: 1)'
    $configProfile = if ($configSelection -eq '2') { 'waf-aligned' } else { 'minimal' }

    # Security options
    Write-Host "`n🔐 Security Options:" -ForegroundColor Yellow

    # Existing Identity
    Write-Host ''
    $useExistingIdentity = Read-Host '   Do you have an existing managed identity to use? [y/N]'
    $existingIdentityId = ''
    if ($useExistingIdentity -eq 'y') {
        $existingIdentityId = Read-Host '   Enter the managed identity resource ID'
        if ([string]::IsNullOrEmpty($existingIdentityId)) {
            Write-Host '   ⚠ No ID provided, will create new identity' -ForegroundColor Yellow
        }
    }

    # Private Endpoints
    Write-Host ''
    $enablePrivateEp = Read-Host '   Do you want to enable private endpoints? [y/N]'
    $privateSubnetId = ''
    if ($enablePrivateEp -eq 'y') {
        $privateSubnetId = Read-Host '   Enter the subnet resource ID for private endpoints'
        if ([string]::IsNullOrEmpty($privateSubnetId)) {
            Write-Host '   ⚠ No subnet ID provided, private endpoints will be disabled' -ForegroundColor Yellow
            $enablePrivateEp = 'n'
        } else {
            Write-Host "   ℹ Note: You'll also need private DNS zones for blob, dfs, keyvault, and datafactory" -ForegroundColor Gray
        }
    }

    # Show cost estimate based on selections
    Write-Host "`n💰 Estimated Monthly Cost:" -ForegroundColor Yellow
    $costTable = @{
        'storage-only' = @{ 'minimal' = '$5-10'; 'waf-aligned' = '$20-50' }
        'adx'          = @{ 'minimal' = '$250-400 (2-node Standard)'; 'waf-aligned' = '$800-1,200 (Standard SKU, HA)' }
        'fabric'       = @{ 'minimal' = '$5-10 + Fabric capacity'; 'waf-aligned' = '$20-50 + Fabric capacity' }
    }
    Write-Host "   $deployType ($configProfile): $($costTable[$deployType][$configProfile])" -ForegroundColor Cyan
    Write-Host '   (Actual costs depend on data volume and query usage)' -ForegroundColor Gray

    return @{
        Type                    = $deployType
        ClusterName             = $clusterName
        UseExisting             = $useExisting
        Configuration           = $configProfile
        ExistingIdentityId      = $existingIdentityId
        PrivateEndpointSubnetId = $privateSubnetId
        EnablePrivateEndpoints  = ($enablePrivateEp -eq 'y')
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Header

# Get script directory for template path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$templatePath = Join-Path (Split-Path -Parent $scriptDir) 'main.bicep'

if (-not (Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
}

# Prerequisites check
if (-not $SkipPrerequisiteCheck) {
    Test-Prerequisites
}

# Azure authentication with tenant/subscription handling
$account = Connect-AzureCLI -TenantId $TenantId -SubscriptionId $SubscriptionId

# Permission check
Test-RoleAssignments -SubscriptionId $account.id

# Register required resource providers (prevents trigger startup issues)
if (-not $SkipPrerequisiteCheck) {
    Register-RequiredProviders -SubscriptionId $account.id
}

# Interactive deployment type selection (unless already specified via parameter)
$finalDeploymentType = $DeploymentType
$finalClusterName = $DataExplorerClusterName
$finalConfiguration = $Configuration
$useExistingResource = $false
$finalExistingIdentityId = $ExistingManagedIdentityResourceId
$finalPrivateSubnetId = $PrivateEndpointSubnetId
$finalEnablePrivateEndpoints = $EnablePrivateEndpoints.IsPresent

if ($DeploymentType -eq 'storage-only' -and [string]::IsNullOrEmpty($DataExplorerClusterName)) {
    # User didn't specify - show interactive wizard
    $deployConfig = Get-DeploymentTypeInteractive -CurrentType $DeploymentType -CurrentClusterName $DataExplorerClusterName -CurrentConfiguration $Configuration
    $finalDeploymentType = $deployConfig.Type
    $finalClusterName = $deployConfig.ClusterName
    $useExistingResource = $deployConfig.UseExisting
    $finalConfiguration = $deployConfig.Configuration
    $finalExistingIdentityId = $deployConfig.ExistingIdentityId
    $finalPrivateSubnetId = $deployConfig.PrivateEndpointSubnetId
    $finalEnablePrivateEndpoints = $deployConfig.EnablePrivateEndpoints
}

# Validate ADX requirements
if ($finalDeploymentType -eq 'adx' -and [string]::IsNullOrEmpty($finalClusterName)) {
    throw 'ADX cluster name is required for ADX deployment type'
}

# Display configuration
Write-Host "`n📋 Deployment Configuration:" -ForegroundColor Yellow
Write-Host "   Hub Name:       $HubName"
Write-Host "   Resource Group: $ResourceGroupName"
Write-Host "   Location:       $Location"
Write-Host "   Type:           $finalDeploymentType"
Write-Host "   Configuration:  $finalConfiguration"
Write-Host "   Subscription:   $($account.name)"
if ($finalDeploymentType -eq 'adx') {
    $adxStatus = if ($useExistingResource) { '(existing)' } else { '(new)' }
    Write-Host "   ADX Cluster:    $finalClusterName $adxStatus"
}
if ($finalDeploymentType -eq 'fabric') {
    $fabricStatus = if ($useExistingResource) { '(will connect existing)' } else { '(new reference)' }
    Write-Host "   Fabric:         $fabricStatus"
}
if (-not [string]::IsNullOrEmpty($finalExistingIdentityId)) {
    Write-Host '   Identity:       Using existing' -ForegroundColor Cyan
}
if ($finalEnablePrivateEndpoints) {
    Write-Host '   Private Endpoints: Enabled' -ForegroundColor Cyan
}

# Confirm deployment
if (-not $WhatIf) {
    $confirm = Read-Host "`n   Proceed with deployment? [Y/n]"
    if ($confirm -and $confirm.ToLower() -ne 'y') {
        Write-Host '   Deployment cancelled.' -ForegroundColor Yellow
        exit 0
    }
}

# Create resource group if needed
Write-Host "`n📦 Checking resource group..." -ForegroundColor Yellow
$rgExists = az group exists --name $ResourceGroupName 2>$null
if ($rgExists -ne 'true') {
    Write-Host "   Creating resource group '$ResourceGroupName' in '$Location'..."
    $createResult = az group create `
        --name $ResourceGroupName `
        --location $Location `
        --tags "finops-hub=$HubName" 'created-by=finops-deploy-script' "created-date=$(Get-Date -Format 'yyyy-MM-dd')" `
        --only-show-errors 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Host '❌ Failed to create resource group' -ForegroundColor Red
        Write-Host "   $createResult" -ForegroundColor Red
        exit 1
    }
    Write-Host '   ✓ Resource group created' -ForegroundColor Green
} else {
    Write-Host '   ✓ Resource group exists' -ForegroundColor Green
}

# Build parameters
$params = @(
    "hubName=$HubName"
    "location=$Location"
    "deploymentType=$finalDeploymentType"
    "deploymentConfiguration=$finalConfiguration"
)

if ($finalDeploymentType -eq 'adx' -and -not [string]::IsNullOrEmpty($finalClusterName)) {
    $params += "dataExplorerClusterName=$finalClusterName"
    if ($useExistingResource) {
        $params += 'useExistingDataExplorer=true'
    }
}

# Add existing identity if specified
if (-not [string]::IsNullOrEmpty($finalExistingIdentityId)) {
    $params += "existingManagedIdentityResourceId=$finalExistingIdentityId"
}

# Add private endpoint configuration if enabled
if ($finalEnablePrivateEndpoints -and -not [string]::IsNullOrEmpty($finalPrivateSubnetId)) {
    $params += "privateEndpointSubnetId=$finalPrivateSubnetId"
}

# Get deployer's principal ID for storage access (enables test data upload)
Write-Host "`n🔑 Getting deployer identity for storage access..." -ForegroundColor Yellow
try {
    $deployerPrincipalId = az ad signed-in-user show --query id -o tsv 2>$null
    if ($LASTEXITCODE -eq 0 -and $deployerPrincipalId) {
        $params += "deployerPrincipalId=$deployerPrincipalId"
        Write-Host '   ✓ Will grant deployer Storage Blob Data Contributor role' -ForegroundColor Green
    } else {
        Write-Host '   ⚠️  Could not get deployer ID. You may need to manually assign storage role for test data upload.' -ForegroundColor Yellow
    }
} catch {
    Write-Host '   ⚠️  Could not get deployer ID. You may need to manually assign storage role for test data upload.' -ForegroundColor Yellow
}

# Deploy
$deploymentName = "finops-hub-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

if ($WhatIf) {
    Write-Host "`n🔍 Running what-if analysis..." -ForegroundColor Yellow
    az deployment group what-if `
        --name $deploymentName `
        --resource-group $ResourceGroupName `
        --template-file $templatePath `
        --parameters $params
} else {
    Write-Host "`n🚀 Deploying FinOps Hub..." -ForegroundColor Yellow
    Write-Host '   This typically takes 5-15 minutes (ADX may take longer)...' -ForegroundColor Gray
    $startTime = Get-Date

    $resultJson = az deployment group create `
        --name $deploymentName `
        --resource-group $ResourceGroupName `
        --template-file $templatePath `
        --parameters $params `
        --output json 2>&1

    $duration = (Get-Date) - $startTime

    if ($LASTEXITCODE -eq 0) {
        $result = $resultJson | ConvertFrom-Json

        Write-Host "`n✅ Deployment successful! (Duration: $($duration.ToString('mm\:ss')))" -ForegroundColor Green

        Write-Host "`n📊 Deployment Outputs:" -ForegroundColor Yellow
        Write-Host "   Storage Account:     $($result.properties.outputs.storageAccountName.value)"
        Write-Host "   Storage URL (BI):    $($result.properties.outputs.storageUrlForPowerBI.value)"
        Write-Host "   Key Vault:           $($result.properties.outputs.keyVaultName.value)"
        Write-Host "   Data Factory:        $($result.properties.outputs.dataFactoryName.value)"
        Write-Host "   ADF Principal ID:    $($result.properties.outputs.dataFactoryPrincipalId.value)"

        if ($finalDeploymentType -eq 'adx' -and $result.properties.outputs.dataExplorerEndpoint.value) {
            Write-Host "   ADX Endpoint:        $($result.properties.outputs.dataExplorerEndpoint.value)"
        }

        # Show pipelines and triggers created
        if ($result.properties.outputs.dataFactoryPipelines -and $result.properties.outputs.dataFactoryPipelines.value) {
            Write-Host "   Pipelines:           $($result.properties.outputs.dataFactoryPipelines.value -join ', ')"
        }
        if ($result.properties.outputs.dataFactoryTriggers -and $result.properties.outputs.dataFactoryTriggers.value) {
            Write-Host "   Triggers:            $($result.properties.outputs.dataFactoryTriggers.value -join ', ')"
        }

        # Save outputs
        $outputFile = "finops-hub-$HubName-outputs.json"
        $result.properties.outputs | ConvertTo-Json -Depth 5 | Out-File $outputFile
        Write-Host "`n   📤 Outputs saved to: $outputFile" -ForegroundColor Gray

        # ============================================================================
        # POST-DEPLOYMENT: Upload settings.json and start triggers
        # ============================================================================
        $storageAccountName = $result.properties.outputs.storageAccountName.value
        $dataFactoryName = $result.properties.outputs.dataFactoryName.value

        # Upload settings.json to config container
        $settingsPath = Join-Path (Split-Path -Parent $scriptDir) 'data/config/settings.json'
        Send-HubSettings -StorageAccountName $storageAccountName -SubscriptionId $SubscriptionId -SettingsTemplatePath $settingsPath

        # Start Data Factory triggers
        Start-DataFactoryTriggers -ResourceGroupName $ResourceGroupName -DataFactoryName $dataFactoryName -DeploymentType $finalDeploymentType

        # Next steps
        Write-Host "`n📖 Next Steps:" -ForegroundColor Yellow
        Write-Host ''
        Write-Host '   1. Grant Data Factory access to billing scope:' -ForegroundColor White
        Write-Host '      az role assignment create \' -ForegroundColor Gray
        Write-Host "        --assignee $($result.properties.outputs.dataFactoryPrincipalId.value) \" -ForegroundColor Gray
        Write-Host "        --role 'Cost Management Reader' \" -ForegroundColor Gray
        Write-Host "        --scope '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}'" -ForegroundColor Gray

        Write-Host ''
        Write-Host '   2. Create Cost Management exports via Azure Portal:' -ForegroundColor White
        Write-Host '      a. Go to: Cost Management > Exports > + Create' -ForegroundColor Gray
        Write-Host "      b. Select 'All data' template (creates FOCUS + Actual + Amortized)" -ForegroundColor Gray
        Write-Host '      c. On Destination tab, configure:' -ForegroundColor Gray
        Write-Host "         • Storage account: $($result.properties.outputs.storageAccountName.value)" -ForegroundColor Cyan
        Write-Host '         • Container: msexports (will be created automatically)' -ForegroundColor Cyan
        Write-Host '         • Format: Parquet | Compression: Snappy' -ForegroundColor Cyan
        Write-Host '         • File partitioning: Enabled (default)' -ForegroundColor Cyan
        Write-Host '         • Overwrite data: Enabled (recommended)' -ForegroundColor Cyan
        Write-Host "      d. Click 'Create' and optionally 'Run now'" -ForegroundColor Gray
        Write-Host ''
        Write-Host '      📚 Guide: https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-improved-exports' -ForegroundColor Gray

        Write-Host ''
        Write-Host '   3. Connect Power BI:' -ForegroundColor White
        Write-Host '      https://learn.microsoft.com/en-us/cloud-computing/finops/toolkit/power-bi/setup'
        Write-Host "      Use: $($result.properties.outputs.storageUrlForPowerBI.value)"

        # FinOps tips
        Show-FinOpsTips

        # ============================================================================
        # TEST DATA - Offer to generate and upload test data
        # ============================================================================
        Write-Host "`n" -NoNewline
        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor DarkGray
        Write-Host '📊 TEST DATA' -ForegroundColor Cyan
        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor DarkGray

        Write-Host "`nWould you like to generate test data to validate the hub?" -ForegroundColor White
        Write-Host "   [1] Small  - `$10,000 (~100 rows, quick validation)" -ForegroundColor Gray
        Write-Host "   [2] Medium - `$100,000 (~1,000 rows, standard test)" -ForegroundColor Gray
        Write-Host "   [3] Large  - `$1,000,000 (~10,000 rows, full test)" -ForegroundColor Gray
        Write-Host '   [n] Skip   - No test data' -ForegroundColor Gray

        $testSize = Read-Host "`nSelect option [1-3 or n, default: n]"

        if ($testSize -in @('1', '2', '3')) {
            $totalCost = switch ($testSize) {
                '1' { 10000 }
                '2' { 100000 }
                '3' { 1000000 }
            }

            $storageAccountName = $result.properties.outputs.storageAccountName.value
            $testDataScript = Join-Path $PSScriptRoot 'Generate-TestData.ps1'

            if (Test-Path $testDataScript) {
                Write-Host "`n📊 Generating `$$($totalCost.ToString('N0')) of test cost data..." -ForegroundColor Yellow

                # Run test data generation (without auto-upload since permissions may be an issue)
                $testDataResult = & $testDataScript `
                    -TotalCost $totalCost `
                    -SubscriptionId $SubscriptionId

                if ($testDataResult -or $LASTEXITCODE -eq 0) {
                    $msexportsPath = $testDataResult.MsExportsPath
                    if (-not $msexportsPath) {
                        $msexportsPath = Join-Path $PSScriptRoot '../data/testData/msexports'
                    }

                    Write-Host "`n✅ Test data generated locally!" -ForegroundColor Green
                    Write-Host "`n📤 To upload to FinOps Hub, run:" -ForegroundColor Yellow
                    Write-Host "   az storage blob upload-batch -d msexports -s `"$msexportsPath`" --account-name $storageAccountName --overwrite --auth-mode login" -ForegroundColor Cyan
                    Write-Host "`n   Note: You need 'Storage Blob Data Contributor' role on the storage account." -ForegroundColor Gray
                    Write-Host '   Or upload via: Azure Portal > Storage Account > Storage Browser > msexports' -ForegroundColor Gray
                    Write-Host "`n   Once uploaded, Data Factory will process and move data to 'ingestion' container." -ForegroundColor Gray
                } else {
                    Write-Host "`n⚠️  Test data generation had issues. Check output above." -ForegroundColor Yellow
                }
            } else {
                Write-Host "   ⚠️  Generate-TestData.ps1 not found at: $testDataScript" -ForegroundColor Yellow
            }
        } else {
            Write-Host "`n   ℹ️  Skipping test data generation." -ForegroundColor Gray
            Write-Host '   You can generate test data later with:' -ForegroundColor Gray
            Write-Host '   .\scripts\Generate-TestData.ps1 -TotalCost 10000' -ForegroundColor Cyan
        }

    } else {
        Write-Host "`n❌ Deployment failed" -ForegroundColor Red
        Write-Host "   $resultJson" -ForegroundColor Red
        Write-Host "`n   View logs: az deployment group show -g $ResourceGroupName -n $deploymentName --query properties.error" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ''
