// ============================================================================
// FinOps Hub - Azure Verified Modules Pattern
// ============================================================================
// Deploys a FinOps Hub using AVM for cost visibility across Azure and multi-cloud.
// Supports: Azure Data Explorer, Microsoft Fabric, or storage-only deployments.
// Reference: https://learn.microsoft.com/en-us/cloud-computing/finops/toolkit/hubs/finops-hubs-overview
// ============================================================================

metadata name = 'FinOps Hub'
metadata description = 'Deploys a FinOps Hub for cloud cost analytics using Azure Verified Modules.'
metadata version = '1.0.0'
metadata owner = 'FinOps Team'

targetScope = 'resourceGroup'

// ============================================================================
// AVM COMMON TYPE IMPORTS
// ============================================================================

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Required. Name of the FinOps Hub instance. Used for resource naming.')
@minLength(3)
@maxLength(24)
param hubName string

@description('Optional. Azure region for all resources. Default: resource group location.')
param location string = resourceGroup().location

// --- Deployment Configuration ---
@description('Optional. Deployment configuration profile. "minimal" for lowest cost dev/test, "waf-aligned" for production with HA/DR.')
@allowed([
  'minimal'
  'waf-aligned'
])
param deploymentConfiguration string = 'minimal'

// --- Data Platform Selection ---
@description('Optional. Deployment type: "adx" for Azure Data Explorer, "fabric" for Microsoft Fabric, "storage-only" for basic deployment.')
@allowed([
  'adx'
  'fabric'
  'storage-only'
])
param deploymentType string = 'storage-only'

// --- Azure Data Explorer Options ---
@description('Conditional. Azure Data Explorer cluster name. Required when deploymentType is "adx" and not using existing cluster.')
param dataExplorerClusterName string = ''

@description('Optional. Resource ID of an existing Azure Data Explorer cluster to use. When provided, no new cluster is created.')
param existingDataExplorerClusterId string = ''

@description('Optional. Azure Data Explorer SKU. Leave empty to use configuration default (minimal: Dev SKU, waf-aligned: Standard SKU).')
param dataExplorerSku string = ''

@description('Optional. Number of instances in the Data Explorer cluster. Set to 0 to use configuration default (minimal: 1, waf-aligned: 2).')
param dataExplorerCapacity int = 0

// --- Microsoft Fabric Options ---
@description('Conditional. Microsoft Fabric eventhouse Query URI. Required when deploymentType is "fabric".')
param fabricQueryUri string = ''

@description('Optional. Microsoft Fabric eventhouse ingestion URI. Used for data ingestion pipelines.')
param fabricIngestionUri string = ''

@description('Optional. Microsoft Fabric database name in the eventhouse.')
param fabricDatabaseName string = 'finops'

// --- Managed Identity Options ---
@description('Optional. Resource ID of an existing user-assigned managed identity. When provided, no new identity is created. Use this for strict security policies where identities must be pre-created.')
param existingManagedIdentityResourceId string = ''

@description('Optional. Principal ID of the deployer. Grants Storage Blob Data Contributor (for test data upload) and ADX AllDatabasesAdmin (for cluster management and troubleshooting).')
param deployerPrincipalId string = ''

@description('Optional. Array of additional ADX admin principal IDs (users or groups) to grant AllDatabasesAdmin role.')
param adxAdminPrincipalIds array = []

// --- Cost Management Export Configuration ---
// IMPORTANT: Cost Management exports are only supported for:
// - Enterprise Agreement (EA) subscriptions
// - Microsoft Customer Agreement (MCA) subscriptions  
// - Microsoft Partner Agreement (MPA) subscriptions
// Pay-As-You-Go (PAYGO) and Free Trial subscriptions do NOT support exports.
// For unsupported billing types, use the ingestion container with manual/scripted data uploads.
// See: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-export-acm-data
@description('''Optional. Billing account type hint for Cost Management export compatibility.
- "auto": (Default) Module outputs export configuration but does not create exports. Use FinOps Toolkit PowerShell to create exports after deployment.
- "ea": Enterprise Agreement - full export support
- "mca": Microsoft Customer Agreement - full export support  
- "mpa": Microsoft Partner Agreement - full export support
- "paygo": Pay-As-You-Go - NO export support. Use ingestion container for manual data uploads.
- "csp": Cloud Solution Provider - limited export support (partner-managed)

⚠️ For PAYGO/CSP tenants: Use the "ingestion" container with the FinOps Toolkit test data generator or integrate with 3rd party cost tools.''')
@allowed([
  'auto'
  'ea'
  'mca'
  'mpa'
  'paygo'
  'csp'
])
param billingAccountType string = 'auto'

@description('''Optional. Billing account ID for MACC (Microsoft Azure Consumption Commitment) tracking.
When specified, the module creates ADF pipelines to fetch MACC data from the Azure Consumption API.
Format: The billing account ID from Azure Cost Management (e.g., "12345678" for EA or "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy_yyyy-yy-yy" for MCA).
Prerequisites: ADF Managed Identity needs "Billing Account Reader" or "Enterprise Administrator" role on the billing account.''')
param billingAccountId string = ''

// --- Scope Configuration (Hybrid Mode) ---
// This section enables both Enterprise mode (with exports) and Demo mode (without billing accounts).
// The module generates settings.json for compatibility with the official FinOps Toolkit.
// For tenants without EA/MCA, use the test data scripts in src/ to populate the hub.
@description('''Optional. List of billing scopes to monitor for cost data.

Each scope generates:
- Export configuration guidance (for EA/MCA tenants with export support)
- settings.json entry (for forward compatibility with managed exports)
- PowerShell commands to create exports

SCOPE TYPES and export support:
| Type           | FOCUS Costs | Prices | Reservations | Notes |
|----------------|-------------|--------|--------------|-------|
| ea             | ✅          | ✅     | ✅           | Full support - EA billing account |
| mca            | ✅          | ✅     | ✅           | Full support - MCA billing profile |
| department     | ✅          | ✅     | ⚠️ Limited   | EA department scope |
| subscription   | ✅          | ❌     | ❌           | Costs only, no pricing |
| resourceGroup  | ✅          | ❌     | ❌           | Very limited |
| managementGroup| ✅          | ❌     | ❌           | Aggregated costs only |

DEMO/DEV MODE: For tenants without EA/MCA billing:
- Leave scopesToMonitor empty
- Use src/Test-FinOpsHub.ps1 to generate FOCUS test data
- Upload directly to the 'ingestion' container

Example scopes:
```bicep
scopesToMonitor: [
  { scopeId: '/providers/Microsoft.Billing/billingAccounts/1234567', scopeType: 'ea', displayName: 'Contoso EA' }
  { scopeId: '/subscriptions/aaaa-bbbb-cccc-dddd', scopeType: 'subscription', displayName: 'Dev Subscription' }
]
```''')
param scopesToMonitor array = []

// --- Security & Networking ---
@description('Optional. Enable RBAC authorization for Key Vault (recommended).')
param enableRbacAuthorization bool = true

@description('Optional. Enable Key Vault purge protection. Automatically enabled for waf-aligned.')
param enablePurgeProtection bool = false

@description('Optional. Enable public network access. Automatically disabled for waf-aligned.')
param enablePublicAccess bool = true

// --- Network Isolation (Three-Tier Model) ---
// This provides clear upgrade paths with documented trade-offs:
// - None: Public endpoints (dev/test) - Just redeploy to upgrade
// - Managed: Module creates VNet/PEs/DNS (recommended) - Just redeploy to upgrade
// - BringYourOwn: Customer provides infrastructure (advanced) - You maintain upgrades
@description('''Optional. Network isolation mode for private connectivity.
- "None": Public endpoints (default for dev/test). Just redeploy to upgrade.
- "Managed": Module creates self-contained VNet, private endpoints, and DNS zones (RECOMMENDED for production). Just redeploy to upgrade.
- "BringYourOwn": Customer provides subnet and DNS zone IDs (advanced). ⚠️ You own upgrades - test before deploying new versions.''')
@allowed([
  'None'
  'Managed'
  'BringYourOwn'
])
param networkIsolationMode string = 'None'

@description('Optional. Address prefix for the managed VNet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/24.')
param managedVnetAddressPrefix string = '10.0.0.0/24'

@description('Optional. Address prefix for the private endpoints subnet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/26.')
param managedSubnetAddressPrefix string = '10.0.0.0/26'

// --- BringYourOwn Network Configuration ---
// ⚠️ WARNING: Using BringYourOwn mode means you take ownership of network configuration.
// Module upgrades may require subnet/DNS zone changes. Test in non-production before upgrading.
// For easier upgrades, consider "Managed" mode and have your network team create their own
// Private Endpoints from their VNet to the module's resources (separation of concerns).
@description('Conditional. Resource ID of the subnet for private endpoints. Required when networkIsolationMode is "BringYourOwn".')
param byoSubnetResourceId string = ''

#disable-next-line no-hardcoded-env-urls
@description('Conditional. Resource ID of the private DNS zone for blob storage (privatelink.blob.core.windows.net). Required when networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoBlobDnsZoneId string = ''

#disable-next-line no-hardcoded-env-urls
@description('Conditional. Resource ID of the private DNS zone for DFS storage (privatelink.dfs.core.windows.net). Required when networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoDfsDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Key Vault (privatelink.vaultcore.azure.net). Required when networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoVaultDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Data Factory (privatelink.datafactory.azure.net). Required when networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoDataFactoryDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Kusto/ADX (privatelink.<region>.kusto.windows.net). Required when networkIsolationMode is "BringYourOwn", deploymentType is "adx", and enablePrivateDnsZoneGroups is true.')
param byoKustoDnsZoneId string = ''

// --- Private Endpoint Options ---
@description('Optional. Enable Data Factory Managed Virtual Network with Managed Integration Runtime. Required for accessing private endpoints from ADF pipelines. Automatically enabled when networkIsolationMode is "Managed" or "BringYourOwn". See enableManagedPeAutoApproval parameter for PE approval options.')
param enableAdfManagedVnet bool = false

@description('Optional. Enable automatic approval of ADF Managed Private Endpoints. When true (Option A), grants ADF control-plane permissions to auto-approve its PE connections to Storage and Key Vault. When false (Option B), PE connections require manual approval via Azure Portal or CLI. Default: true for streamlined deployments.')
param enableManagedPeAutoApproval bool = true

@description('''Optional. Enable DNS zone group creation for private endpoints. Set to false when using Azure Policy to manage Private DNS zone records (ESLZ/CAF pattern). When false, the module creates private endpoints but skips DNS zone group configuration, allowing Azure Policy with "DeployIfNotExists" effect to handle DNS record creation in centralized Private DNS zones. Default: true for Managed mode, often false for BringYourOwn (ESLZ) mode.''')
param enablePrivateDnsZoneGroups bool = true

// --- Legacy Parameters (Deprecated - use networkIsolationMode instead) ---
// These are kept for backward compatibility but will be removed in v2.0
@description('DEPRECATED: Use networkIsolationMode="BringYourOwn" with byoSubnetResourceId instead. Resource ID of the subnet for private endpoints.')
param privateEndpointSubnetId string = ''

@description('DEPRECATED: Use byoBlobDnsZoneId instead.')
param storageBlobPrivateDnsZoneId string = ''

@description('DEPRECATED: Use byoDfsDnsZoneId instead.')
param storageDfsPrivateDnsZoneId string = ''

@description('DEPRECATED: Use byoVaultDnsZoneId instead.')
param keyVaultPrivateDnsZoneId string = ''

@description('DEPRECATED: Use byoDataFactoryDnsZoneId instead.')
param dataFactoryPrivateDnsZoneId string = ''

// --- Tagging ---
@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Resource-specific tags by resource type.')
param tagsByResource object = {}

@description('Optional. Enable AVM telemetry.')
param enableTelemetry bool = false

// --- AVM Standard Interface Parameters ---
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. The diagnostic settings of the service. Applies to Storage Account and Key Vault.')
param diagnosticSettings diagnosticSettingFullType[]?

// --- Deployment Options ---
@description('Optional. Enable automatic trigger management for idempotent deployments. When true, stops triggers before deployment and restarts them after. This allows redeployment without manual intervention. IMPORTANT: Requires a storage account with shared key access enabled for deployment scripts. Default is false to ensure simple deployments work out of the box.')
param enableTriggerManagement bool = false

// ============================================================================
// VARIABLES - Configuration-based defaults
// ============================================================================

// Storage configuration based on deployment profile
// Minimal: Standard_LRS with StorageV2 (~$0.02/GB) - cheapest option
// WAF-aligned: Premium_ZRS with BlockBlobStorage (~$0.15/GB) - best performance + HA
var storageSku = deploymentConfiguration == 'waf-aligned' ? 'Premium_ZRS' : 'Standard_LRS'
var storageKind = deploymentConfiguration == 'waf-aligned' ? 'BlockBlobStorage' : 'StorageV2'

// ADX SKU configuration based on deployment configuration
// FinOps workloads are compute-optimized (analytical queries on structured billing data)
// See: https://learn.microsoft.com/azure/data-explorer/manage-cluster-choose-sku
//
// Recommended SKUs by tier:
// - Dev/Test: 'Dev(No SLA)_Standard_E2a_v4' (AMD v4, 2 vCPUs, 16GB, single node, no markup charges)
// - Production: 'Standard_E2d_v5' (Intel v5, 2 vCPUs, 16GB, min 2 nodes, best regional availability)
//
// Note: Standard SKUs require minimum 2 nodes for SLA. Dev SKUs have no SLA but no ADX markup.
// SKU availability varies by region. Use src/Get-BestAdxSku.ps1 to find the best SKU for your region.
var effectiveAdxSku = !empty(dataExplorerSku) ? dataExplorerSku : 'Standard_E2d_v5'
// Dev SKUs use 'Basic' tier, Standard SKUs use 'Standard' tier
var effectiveAdxTier = startsWith(effectiveAdxSku, 'Dev') ? 'Basic' : 'Standard'
// Dev SKUs support 1 node, Standard SKUs require minimum 2 nodes
var effectiveAdxCapacity = dataExplorerCapacity > 0 ? dataExplorerCapacity : (startsWith(effectiveAdxSku, 'Dev') ? 1 : 2)

// Security settings based on configuration
var effectivePurgeProtection = deploymentConfiguration == 'waf-aligned' ? true : enablePurgeProtection
var effectivePublicAccess = deploymentConfiguration == 'waf-aligned' ? false : enablePublicAccess

// --- Managed Exports Configuration ---
// Only deploy managed export pipelines for billing types that support Cost Management exports.
// PAYGO, CSP, and Free Trial do NOT support exports - these tenants use Demo mode with test data.
// This conditional deployment prevents unnecessary pipeline failures in unsupported environments.
var enableManagedExports = contains(['ea', 'mca', 'mpa'], billingAccountType) && !empty(scopesToMonitor)

// --- Network Isolation Configuration ---
// Determine effective mode: waf-aligned defaults to Managed, legacy param upgrades to BringYourOwn
var effectiveNetworkIsolationMode = deploymentConfiguration == 'waf-aligned' && networkIsolationMode == 'None' 
  ? 'Managed'  // waf-aligned defaults to Managed for private networking
  : (!empty(privateEndpointSubnetId) && networkIsolationMode == 'None'
    ? 'BringYourOwn'  // Legacy parameter detected, upgrade to BringYourOwn
    : networkIsolationMode)

// Private endpoint configuration - enabled for Managed or BringYourOwn modes
var enablePrivateEndpoints = effectiveNetworkIsolationMode != 'None'

// ADF Managed VNet - auto-enable when private endpoints are enabled
var effectiveAdfManagedVnet = enableAdfManagedVnet || enablePrivateEndpoints

// Generate unique suffix for globally unique resource names
var uniqueSuffix = uniqueString(resourceGroup().id, hubName)

// Resource naming following Microsoft Cloud Adoption Framework conventions
// Reference: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
// Pattern: <resource-type-prefix>-<workload>-<unique-suffix>
var storageAccountName = take(toLower('st${replace(hubName, '-', '')}${uniqueSuffix}'), 24)  // st = storage account
var keyVaultName = take('kv-${hubName}-${take(uniqueSuffix, 6)}', 24)                         // kv = key vault
var dataFactoryName = take('adf-${hubName}-${take(uniqueSuffix, 6)}', 63)                     // adf = azure data factory
var managedIdentityName = 'id-${hubName}'                                                      // id = managed identity

// ADX cluster name must be globally unique - add suffix if user provides just a base name
// ADX naming: 4-22 chars, lowercase alphanumeric, start with letter
var adxClusterName = !empty(dataExplorerClusterName) ? take(toLower('${replace(dataExplorerClusterName, '-', '')}${take(uniqueSuffix, 6)}'), 22) : ''

// Deployment flags - determine if we need to CREATE new resources or use existing
var useExistingIdentity = !empty(existingManagedIdentityResourceId)
var useExistingAdx = !empty(existingDataExplorerClusterId)
var createNewAdx = deploymentType == 'adx' && !empty(dataExplorerClusterName) && !useExistingAdx
var useFabric = deploymentType == 'fabric' && !empty(fabricQueryUri)

// Schema deployment - deploy to new ADX or existing ADX when deploymentType is 'adx'
var deployAdxSchema = deploymentType == 'adx' && (createNewAdx || useExistingAdx)

// ADX cluster principal assignments - combine ADF identity with additional admin users
var adxAdminAssignments = [for principalId in adxAdminPrincipalIds: {
  principalId: principalId
  principalType: 'User'
  role: 'AllDatabasesAdmin'
  tenantId: tenant().tenantId
}]

// Deployer admin assignment - grants cluster admin to deployer for troubleshooting/manual operations
var deployerAdminAssignment = !empty(deployerPrincipalId) ? [
  {
    principalId: deployerPrincipalId
    principalType: 'User'
    role: 'AllDatabasesAdmin'
    tenantId: tenant().tenantId
  }
] : []

// Extract existing resource names from resource IDs if provided
var existingIdentityName = useExistingIdentity ? last(split(existingManagedIdentityResourceId, '/')) : ''
var existingAdxClusterName = useExistingAdx ? last(split(existingDataExplorerClusterId, '/')) : ''

// Standard container names per FinOps toolkit
var containers = [
  'config'      // Hub configuration files (settings.json, schemas)
  'msexports'   // Raw Cost Management export data (temporary staging)
  'ingestion'   // Normalized FOCUS-aligned data (final storage for reporting)
]

// Version tags for tracking - update when upgrading
var ftkVersion = '0.7.0'
var hubModuleVersion = '1.0.0'

// Merged tags with FinOps Hub identifier
var allTags = union(tags, {
  'cm-resource-parent': hubName
  'ftk-version': ftkVersion
  'ftk-hub-module': hubModuleVersion
  'deployment-configuration': deploymentConfiguration
})

// ============================================================================
// TELEMETRY
// ============================================================================

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take('46d3xbcp.ptn.finops-hub.${replace('1.0.0', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}', 64)
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

// ============================================================================
// RESOURCES - Using Azure Verified Modules Directly
// ============================================================================

// --- Managed Network (Conditional) ---
// Creates self-contained VNet, subnet, NSG, and Private DNS zones when networkIsolationMode is 'Managed'.
// This is the RECOMMENDED approach - enables clean upgrades without customization.
module managedNetwork 'modules/network.bicep' = if (effectiveNetworkIsolationMode == 'Managed') {
  name: '${uniqueString(deployment().name, location)}-managed-network'
  params: {
    hubName: hubName
    location: location
    vnetAddressPrefix: managedVnetAddressPrefix
    subnetAddressPrefix: managedSubnetAddressPrefix
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// --- Effective Subnet and DNS Zone IDs ---
// Uses Managed network outputs, BringYourOwn params, or legacy params (backward compatibility)
// Note: managedNetwork is only deployed when effectiveNetworkIsolationMode == 'Managed'
#disable-next-line BCP321 // managedNetwork outputs are only accessed when mode is 'Managed'
var effectiveSubnetId = effectiveNetworkIsolationMode == 'Managed' 
  ? managedNetwork!.outputs.subnetResourceId 
  : (effectiveNetworkIsolationMode == 'BringYourOwn' 
    ? (!empty(byoSubnetResourceId) ? byoSubnetResourceId : privateEndpointSubnetId)
    : '')

#disable-next-line BCP321
var effectiveBlobDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.blobDnsZoneId
  : (!empty(byoBlobDnsZoneId) ? byoBlobDnsZoneId : storageBlobPrivateDnsZoneId)

#disable-next-line BCP321
var effectiveDfsDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.dfsDnsZoneId
  : (!empty(byoDfsDnsZoneId) ? byoDfsDnsZoneId : storageDfsPrivateDnsZoneId)

#disable-next-line BCP321
var effectiveVaultDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.vaultDnsZoneId
  : (!empty(byoVaultDnsZoneId) ? byoVaultDnsZoneId : keyVaultPrivateDnsZoneId)

#disable-next-line BCP321
var effectiveDataFactoryDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.dataFactoryDnsZoneId
  : (!empty(byoDataFactoryDnsZoneId) ? byoDataFactoryDnsZoneId : dataFactoryPrivateDnsZoneId)

// Note: Kusto DNS zone is used for ADX private endpoints
#disable-next-line BCP321
var effectiveKustoDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.kustoDnsZoneId
  : byoKustoDnsZoneId

// --- User-Assigned Managed Identity ---
// Reference existing identity if provided
resource existingManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (useExistingIdentity) {
  name: existingIdentityName
}

// Create new identity only if not using existing
module managedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = if (!useExistingIdentity) {
  name: '${uniqueString(deployment().name, location)}-managed-identity'
  params: {
    name: managedIdentityName
    location: location
    tags: contains(tagsByResource, 'Microsoft.ManagedIdentity/userAssignedIdentities')
      ? union(allTags, tagsByResource['Microsoft.ManagedIdentity/userAssignedIdentities'])
      : allTags
    enableTelemetry: enableTelemetry
  }
}

// Effective identity values - use existing or newly created
var effectiveIdentityPrincipalId = useExistingIdentity ? existingManagedIdentity!.properties.principalId : managedIdentity!.outputs.principalId
var effectiveIdentityResourceId = useExistingIdentity ? existingManagedIdentityResourceId : managedIdentity!.outputs.resourceId
var effectiveIdentityName = useExistingIdentity ? existingIdentityName : managedIdentity!.outputs.name

// --- Pre-Deployment: Stop Triggers for Idempotent Updates ---
// This MUST run BEFORE Data Factory resources are updated.
// Without this, ARM fails with "Cannot update enabled Trigger" error on redeployments.
// Note: On first deployment this gracefully handles the case where ADF doesn't exist yet.
// On subsequent deployments, the managed identity already has the required RBAC from previous deploy.
// MOVED: This now runs AFTER storage account is created so we can reuse it for deployment scripts.

// --- Storage Account (ADLS Gen2) ---
// SecurityControl: 'Ignore' tag exempts this storage account from Azure Policies that
// enforce disabling shared key access. This is required because:
// 1. ADF native ingestion uses managed_identity=system which needs the storage accessible
// 2. ADX native ingestion requires storage access for data loading
// 3. Deployment scripts (ACI) require shared key access for mounting storage
module storageAccount 'br/public:avm/res/storage/storage-account:0.31.0' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountName
    location: location
    tags: contains(tagsByResource, 'Microsoft.Storage/storageAccounts')
      ? union(allTags, tagsByResource['Microsoft.Storage/storageAccounts'], { SecurityControl: 'Ignore' })
      : union(allTags, { SecurityControl: 'Ignore' })
    enableTelemetry: enableTelemetry
    kind: storageKind
    skuName: storageSku
    enableHierarchicalNamespace: true // Required for ADLS Gen2
    allowSharedKeyAccess: true
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    publicNetworkAccess: effectivePublicAccess ? 'Enabled' : 'Disabled'
    // Network ACLs: Allow by default for ADF/ADX access; use private endpoints for stricter security
    networkAcls: enablePrivateEndpoints ? {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    } : {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    blobServices: {
      deleteRetentionPolicyDays: deploymentConfiguration == 'waf-aligned' ? 7 : 1 // Shorter retention for minimal
      deleteRetentionPolicyEnabled: true
      containers: [for container in containers: {
        name: container
        publicAccess: 'None'
      }]
    }
    // Least Privilege: User-Assigned MI only needs read access for configuration
    roleAssignments: [
      {
        principalId: effectiveIdentityPrincipalId
        roleDefinitionIdOrName: 'Storage Blob Data Reader' // Least privilege: read-only for config
        principalType: 'ServicePrincipal'
      }
    ]
    // Private endpoints for blob and dfs (ADLS Gen2)
    // When enablePrivateDnsZoneGroups=false (ESLZ/CAF pattern), Azure Policy handles DNS record creation
    privateEndpoints: enablePrivateEndpoints ? [
      {
        name: '${storageAccountName}-blob-pe'
        subnetResourceId: effectiveSubnetId
        service: 'blob'
        privateDnsZoneGroup: enablePrivateDnsZoneGroups && !empty(effectiveBlobDnsZoneId) ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: effectiveBlobDnsZoneId
            }
          ]
        } : null
      }
      {
        name: '${storageAccountName}-dfs-pe'
        subnetResourceId: effectiveSubnetId
        service: 'dfs'
        privateDnsZoneGroup: enablePrivateDnsZoneGroups && !empty(effectiveDfsDnsZoneId) ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: effectiveDfsDnsZoneId
            }
          ]
        } : null
      }
    ] : []
    // AVM Standard Interface
    lock: lock
    diagnosticSettings: diagnosticSettings
  }
}

// --- Key Vault ---
module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: '${uniqueString(deployment().name, location)}-keyvault'
  params: {
    name: keyVaultName
    location: location
    tags: contains(tagsByResource, 'Microsoft.KeyVault/vaults')
      ? union(allTags, tagsByResource['Microsoft.KeyVault/vaults'])
      : allTags
    enableTelemetry: enableTelemetry
    enableRbacAuthorization: enableRbacAuthorization
    enablePurgeProtection: effectivePurgeProtection
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    publicNetworkAccess: effectivePublicAccess ? 'Enabled' : 'Disabled'
    sku: 'standard'
    roleAssignments: enableRbacAuthorization ? [
      {
        principalId: effectiveIdentityPrincipalId
        roleDefinitionIdOrName: 'Key Vault Secrets User'
        principalType: 'ServicePrincipal'
      }
    ] : []
    accessPolicies: !enableRbacAuthorization ? [
      {
        objectId: effectiveIdentityPrincipalId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ] : []
    // Private endpoint for Key Vault
    // When enablePrivateDnsZoneGroups=false (ESLZ/CAF pattern), Azure Policy handles DNS record creation
    privateEndpoints: enablePrivateEndpoints ? [
      {
        name: '${keyVaultName}-pe'
        subnetResourceId: effectiveSubnetId
        service: 'vault'
        privateDnsZoneGroup: enablePrivateDnsZoneGroups && !empty(effectiveVaultDnsZoneId) ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: effectiveVaultDnsZoneId
            }
          ]
        } : null
      }
    ] : []
    // AVM Standard Interface
    lock: lock
    diagnosticSettings: diagnosticSettings
  }
}

// --- Data Factory ---
module dataFactory 'br/public:avm/res/data-factory/factory:0.11.0' = {
  name: '${uniqueString(deployment().name, location)}-datafactory'
  params: {
    name: dataFactoryName
    location: location
    tags: contains(tagsByResource, 'Microsoft.DataFactory/factories')
      ? union(allTags, tagsByResource['Microsoft.DataFactory/factories'])
      : allTags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: effectivePublicAccess ? 'Enabled' : 'Disabled'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        effectiveIdentityResourceId
      ]
    }
    globalParameters: {
      hubName: {
        type: 'String'
        value: hubName
      }
      storageAccountName: {
        type: 'String'
        value: storageAccountName
      }
    }
    // Private endpoint for Data Factory
    // When enablePrivateDnsZoneGroups=false (ESLZ/CAF pattern), Azure Policy handles DNS record creation
    privateEndpoints: enablePrivateEndpoints ? [
      {
        name: '${dataFactoryName}-pe'
        subnetResourceId: effectiveSubnetId
        service: 'dataFactory'
        privateDnsZoneGroup: enablePrivateDnsZoneGroups && !empty(effectiveDataFactoryDnsZoneId) ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: effectiveDataFactoryDnsZoneId
            }
          ]
        } : null
      }
    ] : []
    // Managed Virtual Network - required for ADF to access private endpoints
    // Creates managed private endpoints inside ADF's isolated network
    // NOTE: ADX managed PE is created separately via adxManagedPrivateEndpoint module (after ADX exists)
    // This avoids circular dependency since ADX needs ADF's MI for admin access
    managedVirtualNetwork: effectiveAdfManagedVnet ? {
      name: 'default'
      managedPrivateEndpoints: [
        // Managed PE for Storage (blob) - allows ADF pipelines to access private storage
        {
          name: '${storageAccountName}-blob-mpe'
          groupId: 'blob'
          fqdns: [
            '${storageAccountName}.blob.${environment().suffixes.storage}'
          ]
          privateLinkResourceId: storageAccount.outputs.resourceId
        }
        // Managed PE for Key Vault - allows ADF to access secrets in private Key Vault
        {
          name: '${keyVaultName}-vault-mpe'
          groupId: 'vault'
          fqdns: [
            '${keyVaultName}${environment().suffixes.keyvaultDns}'
          ]
          privateLinkResourceId: keyVault.outputs.resourceId
        }
      ]
    } : null
    // Managed Integration Runtime - uses the Managed VNet for pipeline execution
    integrationRuntimes: effectiveAdfManagedVnet ? [
      {
        name: 'FinOpsHubManagedIR'
        type: 'Managed'
        managedVirtualNetworkName: 'default'
        typeProperties: {
          computeProperties: {
            location: 'AutoResolve'
          }
        }
      }
    ] : null
    // AVM Standard Interface
    lock: lock
    diagnosticSettings: diagnosticSettings
  }
}

// --- Data Factory Resources (Linked Services, Datasets, Pipelines, Triggers) ---

// Pre-Deployment: Stop Triggers for Idempotent Updates
// Placed here because it needs the storage account to exist for deployment scripts
// Uses the FinOps Hub storage account (no additional resources needed)
module stopTriggers 'modules/triggerManagement.bicep' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-stop-triggers'
  dependsOn: [
    identityStorageRoleAssignment  // Identity needs storage access for deployment scripts
  ]
  params: {
    dataFactoryName: dataFactoryName  // The EXPECTED name (may not exist yet on first deploy)
    resourceGroupName: resourceGroup().name
    location: location
    managedIdentityResourceId: effectiveIdentityResourceId
    storageAccountResourceId: storageAccount.outputs.resourceId  // Reuse FinOps Hub storage
    operation: 'stop'
  }
}

module dataFactoryResources 'modules/dataFactoryResources.bicep' = {
  name: '${uniqueString(deployment().name, location)}-adf-resources'
  dependsOn: [
    adfStorageRoleAssignment  // Ensure ADF has storage access before creating resources
    adfKeyVaultRoleAssignment // Ensure ADF has key vault access
    stopTriggers              // Ensure triggers are stopped before updating ADF resources
  ]
  params: {
    dataFactoryName: dataFactory.outputs.name
    storageAccountName: storageAccount.outputs.name
    keyVaultName: keyVault.outputs.name
    dataExplorerEndpoint: createNewAdx && dataExplorer != null 
      ? 'https://${dataExplorer!.outputs.name}.${location}.kusto.windows.net' 
      : (useExistingAdx ? 'https://${existingAdxClusterName}.${location}.kusto.windows.net' : '')
    // ADX system MI principal ID - needed to set managed identity policy for NativeIngestion
    // This allows the ingestion command with managed_identity=system to work
    dataExplorerPrincipalId: createNewAdx && dataExplorer != null
      ? dataExplorer!.outputs.systemAssignedMIPrincipalId!
      : ''  // For existing ADX or no ADX, leave empty (policy must be set externally)
    fabricQueryUri: useFabric ? fabricQueryUri : ''
    ftkVersion: ftkVersion
    // Integration runtime for managed VNet - ensures linked services use private endpoints
    integrationRuntimeName: effectiveAdfManagedVnet ? 'FinOpsHubManagedIR' : ''
    // MACC tracking - requires billing account ID and ADX
    billingAccountId: billingAccountId
  }
}

// --- Managed Exports Pipelines (Conditional) ---
// Only deployed when billing type supports Cost Management exports (EA/MCA/MPA).
// For PAYGO/CSP tenants, these pipelines are NOT created - use Demo mode instead.
module managedExportsPipelines 'modules/managedExportsPipelines.bicep' = if (enableManagedExports) {
  name: '${uniqueString(deployment().name, location)}-managed-exports'
  dependsOn: [
    dataFactoryResources  // Core ADF resources must exist first
  ]
  params: {
    dataFactoryName: dataFactory.outputs.name
    storageAccountName: storageAccount.outputs.name
    hubName: hubName
    ftkVersion: ftkVersion
    integrationRuntimeName: effectiveAdfManagedVnet ? 'FinOpsHubManagedIR' : ''
  }
}

// --- Azure Data Explorer (Conditional) ---
module dataExplorer 'br/public:avm/res/kusto/cluster:0.9.0' = if (createNewAdx) {
  name: '${uniqueString(deployment().name, location)}-adx'
  dependsOn: effectiveNetworkIsolationMode == 'Managed' ? [
    managedNetwork  // Ensure DNS zones exist before creating ADX with private endpoints
  ] : []
  params: {
    name: adxClusterName
    location: location
    tags: contains(tagsByResource, 'Microsoft.Kusto/clusters')
      ? union(allTags, tagsByResource['Microsoft.Kusto/clusters'])
      : allTags
    enableTelemetry: enableTelemetry
    sku: effectiveAdxSku
    tier: effectiveAdxTier
    capacity: effectiveAdxCapacity
    enableAutoScale: deploymentConfiguration == 'waf-aligned' // Auto-scale for production
    enableAutoStop: deploymentConfiguration == 'minimal' // Save costs in minimal config
    enablePublicNetworkAccess: !enablePrivateEndpoints  // Disable public access when using private endpoints
    publicIPType: 'IPv4'  // Required when private endpoints are used
    managedIdentities: {
      systemAssigned: true
    }
    // FinOps Hub databases - Hub for queries, Ingestion for raw data processing
    databases: [
      {
        name: 'Hub'
        kind: 'ReadWrite'
        readWriteProperties: {}
        databasePrincipalAssignments: []  // Required by AVM module even if empty
      }
      {
        name: 'Ingestion'
        kind: 'ReadWrite'
        readWriteProperties: {}
        databasePrincipalAssignments: []  // Required by AVM module even if empty
      }
    ]
    clusterPrincipalAssignments: concat(
      // Data Factory managed identity - required for pipeline operations
      [
        {
          principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
          principalType: 'App'
          role: 'AllDatabasesAdmin'
          tenantId: tenant().tenantId
        }
      ],
      // Deployment script managed identity - required to run cluster policy commands (managed identity policy)
      [
        {
          principalId: effectiveIdentityPrincipalId
          principalType: 'App'
          role: 'AllDatabasesAdmin'
          tenantId: tenant().tenantId
        }
      ],
      // Deployer principal - grants cluster admin for troubleshooting and manual operations
      deployerAdminAssignment,
      // Additional admin users/groups provided via parameter
      adxAdminAssignments
    )
    // Private endpoints for ADX cluster access
    privateEndpoints: enablePrivateEndpoints ? [
      {
        name: '${adxClusterName}-pe'
        subnetResourceId: effectiveSubnetId
        service: 'cluster'
        privateDnsZoneGroup: enablePrivateDnsZoneGroups && !empty(effectiveKustoDnsZoneId) ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: effectiveKustoDnsZoneId
            }
          ]
        } : null
      }
    ] : []
    // AVM Standard Interface
    lock: lock
    diagnosticSettings: diagnosticSettings
  }
}

// --- Azure Data Explorer Schema Setup (Conditional) ---
// Deploys all KQL scripts to create tables, functions, and ingestion mappings
// This runs AFTER the ADX cluster and databases are created (or uses existing cluster)
// NOTE: The managed identity policy for ingestion is now configured via adxManagedIdentityPolicy module
module adxSchemaSetup 'modules/adxSchemaSetup.bicep' = if (deployAdxSchema) {
  name: '${uniqueString(deployment().name, location)}-adx-schema'
  dependsOn: createNewAdx ? [
    dataExplorer  // Cluster and databases must exist first (only for new deployments)
  ] : []
  params: {
    // Use new cluster name or existing cluster name
    clusterName: createNewAdx ? dataExplorer!.outputs.name : existingAdxClusterName
    rawRetentionInDays: 30  // Keep raw ingestion data for 30 days
    continueOnErrors: true  // Continue even if some objects already exist
  }
}

// --- Data Factory Storage Access (read/write for pipeline operations) ---
module adfStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: '${uniqueString(deployment().name, location)}-adf-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Contributor
    principalType: 'ServicePrincipal'
  }
}

// --- ADX Storage Access (read for native ingestion) ---
// ADX cluster needs Storage Blob Data Reader to ingest data from storage via native ingestion
#disable-next-line BCP321 // dataExplorer is guaranteed to exist when createNewAdx is true
module adxStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (createNewAdx) {
  name: '${uniqueString(deployment().name, location)}-adx-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    #disable-next-line BCP321 // systemAssignedMIPrincipalId is guaranteed to exist when createNewAdx is true
    principalId: dataExplorer!.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1') // Storage Blob Data Reader
    principalType: 'ServicePrincipal'
  }
}

// --- Data Factory Key Vault Access (read secrets) ---
module adfKeyVaultRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableRbacAuthorization) {
  name: '${uniqueString(deployment().name, location)}-adf-kv-role'
  params: {
    resourceId: keyVault.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

// --- ADF Managed Private Endpoint Auto-Approval (Option A) ---
// These role assignments grant ADF control-plane permissions to auto-approve its managed PE connections.
// Storage Account Contributor includes Microsoft.Storage/storageAccounts/privateEndpointConnectionsApproval/action
// Key Vault Contributor includes Microsoft.KeyVault/vaults/privateEndpointConnectionsApproval/action
// Only enabled when ADF Managed VNet is used AND auto-approval is enabled.

module adfStoragePeApprovalRole 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (effectiveAdfManagedVnet && enableManagedPeAutoApproval) {
  name: '${uniqueString(deployment().name, location)}-adf-storage-pe-approval'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab') // Storage Account Contributor
    principalType: 'ServicePrincipal'
  }
}

module adfKeyVaultPeApprovalRole 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (effectiveAdfManagedVnet && enableManagedPeAutoApproval) {
  name: '${uniqueString(deployment().name, location)}-adf-kv-pe-approval'
  params: {
    resourceId: keyVault.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395') // Key Vault Contributor
    principalType: 'ServicePrincipal'
  }
}

// --- ADX Managed Private Endpoint (ADF Managed VNet to ADX) ---
// Creates a managed private endpoint from ADF's managed VNet to the ADX cluster.
// This allows ADF pipelines to reach ADX when publicNetworkAccess is disabled.
// Pattern from FinOps Toolkit: deployed AFTER both ADF and ADX exist to avoid circular dependency.
#disable-next-line BCP321 // dataExplorer is guaranteed to exist when createNewAdx is true
module adxManagedPrivateEndpoint 'modules/adxManagedPrivateEndpoint.bicep' = if (createNewAdx && effectiveAdfManagedVnet) {
  name: '${uniqueString(deployment().name, location)}-adx-mpe'
  // Dependencies are implicit via outputs used in params
  params: {
    dataFactoryName: dataFactory.outputs.name
    adxClusterName: dataExplorer!.outputs.name
    adxClusterResourceId: dataExplorer!.outputs.resourceId
    location: location
  }
}

// --- ADX Managed PE Connection Approval - Step 1: Get pending connections ---
// Query the ADX cluster for pending private endpoint connections
#disable-next-line BCP321 // dataExplorer is guaranteed to exist when createNewAdx is true
module getAdxPendingConnections 'modules/adxPrivateEndpointApproval.bicep' = if (createNewAdx && effectiveAdfManagedVnet) {
  name: '${uniqueString(deployment().name, location)}-adx-pe-get'
  dependsOn: [
    adxManagedPrivateEndpoint  // Wait for the managed PE to be created
  ]
  params: {
    adxClusterName: dataExplorer!.outputs.name
  }
}

// --- ADX Managed PE Connection Approval - Step 2: Approve pending connections ---
// Approve the pending managed PE connection from ADF
#disable-next-line BCP321 // dataExplorer is guaranteed to exist when createNewAdx is true
module approveAdxManagedPeConnections 'modules/adxPrivateEndpointApproval.bicep' = if (createNewAdx && effectiveAdfManagedVnet) {
  name: '${uniqueString(deployment().name, location)}-adx-pe-approve'
  params: {
    adxClusterName: dataExplorer!.outputs.name
    #disable-next-line BCP321 // getAdxPendingConnections is guaranteed to exist when createNewAdx && effectiveAdfManagedVnet is true
    privateEndpointConnections: getAdxPendingConnections!.outputs.privateEndpointConnections
  }
}

// --- Managed Identity Storage Access (for deployment scripts) ---
// Deployment scripts need Storage File Data Privileged Contributor to store script files
module identityStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-identity-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: effectiveIdentityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69566ab7-960f-475b-8e7c-b3118f30c6bd') // Storage File Data Privileged Contributor
    principalType: 'ServicePrincipal'
  }
}

// --- Managed Identity Data Factory Contributor (for trigger management deployment scripts) ---
// This allows the deployment scripts to start/stop triggers during deployment
module identityAdfRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-identity-adf-role'
  params: {
    resourceId: dataFactory.outputs.resourceId
    principalId: effectiveIdentityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '673868aa-7521-48a0-acc6-0f60742d39f5') // Data Factory Contributor
    principalType: 'ServicePrincipal'
  }
}

// --- Deployer Storage Access (for test data upload) ---
module deployerStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(deployerPrincipalId)) {
  name: '${uniqueString(deployment().name, location)}-deployer-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: deployerPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Contributor
    principalType: 'User'
  }
}

// --- Post-Deployment: Start Triggers ---
// This runs AFTER all resources are deployed to restart the triggers.
// Ensures the hub is fully operational after deployment completes.
module startTriggers 'modules/triggerManagement.bicep' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-start-triggers'
  dependsOn: [
    dataFactoryResources  // All ADF resources must be deployed first
    adxSchemaSetup        // ADX schema should be ready (if applicable)
    adxManagedIdentityPolicy // ADX policy must be configured before ingestion can work
    approveAdxManagedPeConnections // ADX managed PE must be approved before pipelines can reach ADX
  ]
  params: {
    dataFactoryName: dataFactory.outputs.name
    resourceGroupName: resourceGroup().name
    location: location
    managedIdentityResourceId: effectiveIdentityResourceId
    storageAccountResourceId: storageAccount.outputs.resourceId  // Reuse FinOps Hub storage
    operation: 'start'
  }
}

// --- ADX Managed Identity Policy (Required for Native Ingestion) ---
// This configures the ADX cluster's managed identity policy to allow native ingestion.
// --- ADX Managed Identity Policy (DEPRECATED - now set inline in pipeline) ---
// The policy is now set dynamically in the ingestion_ETL_dataExplorer pipeline
// using the 'Set Ingestion Policy' activity, following the FinOps Toolkit pattern.
// This deployment script is kept as a backup for initial setup but the pipeline
// will also set the policy on each run to ensure it's always configured correctly.
// The ADX cluster's system-assigned identity is used for ingestion (managed_identity=system).
// This MUST be configured before any data can be ingested via ADF pipelines.
// Note: This uses a deployment script because cluster-level KQL commands cannot be run
// via database scripts (which are limited to database-scoped commands only).
// IMPORTANT: This runs for ALL new ADX clusters, not just when enableTriggerManagement is true.
// Without this policy, ADF pipelines will fail with ManagedIdentityNotAllowedByPolicyException.
// NOTE: The deployment script identity is granted AllDatabasesAdmin via clusterPrincipalAssignments
// in the dataExplorer module, not via Azure RBAC (ADX uses Kusto-level permissions).
module adxManagedIdentityPolicy 'modules/adxManagedIdentityPolicy.bicep' = if (createNewAdx) {
  name: '${uniqueString(deployment().name, location)}-adx-mi-policy'
  dependsOn: [
    // Note: dataExplorer is implicitly required via clusterName reference to outputs
    adxSchemaSetup          // Schema should be deployed first
    // Identity is granted AllDatabasesAdmin via dataExplorer.clusterPrincipalAssignments
  ]
  params: {
    clusterName: dataExplorer!.outputs.name
    location: location
    managedIdentityResourceId: effectiveIdentityResourceId
    tags: allTags
    // Note: The module creates a dedicated storage account with:
    // - allowSharedKeyAccess: true (required for ACI - platform limitation)
    // - SecurityControl: 'Ignore' tag (exempt from shared key policies)
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Name of the deployed FinOps Hub.')
output hubName string = hubName

@description('Azure region where resources were deployed.')
output location string = location

@description('Resource group name.')
output resourceGroupName string = resourceGroup().name

// Storage outputs
@description('Storage account name.')
output storageAccountName string = storageAccount.outputs.name

@description('Storage account resource ID.')
output storageAccountId string = storageAccount.outputs.resourceId

@description('Storage account primary blob endpoint.')
output storageBlobEndpoint string = storageAccount.outputs.primaryBlobEndpoint

@description('URL for Power BI connection to ingestion container.')
output storageUrlForPowerBI string = 'https://${storageAccountName}.dfs.${environment().suffixes.storage}/ingestion'

// Key Vault outputs
@description('Key Vault name.')
output keyVaultName string = keyVault.outputs.name

@description('Key Vault resource ID.')
output keyVaultId string = keyVault.outputs.resourceId

@description('Key Vault URI.')
output keyVaultUri string = keyVault.outputs.uri

// Data Factory outputs
@description('Data Factory name.')
output dataFactoryName string = dataFactory.outputs.name

@description('Data Factory resource ID.')
output dataFactoryId string = dataFactory.outputs.resourceId

@description('Data Factory managed identity principal ID (for configuring managed exports).')
output dataFactoryPrincipalId string = dataFactory.outputs.systemAssignedMIPrincipalId!

// Managed Identity outputs
@description('User-assigned managed identity name.')
output managedIdentityName string = effectiveIdentityName

@description('User-assigned managed identity resource ID.')
output managedIdentityResourceId string = effectiveIdentityResourceId

@description('User-assigned managed identity principal ID.')
output managedIdentityPrincipalId string = effectiveIdentityPrincipalId

@description('Azure AD tenant ID (for configuring managed exports).')
output tenantId string = tenant().tenantId

// Data Explorer / Fabric outputs (conditional)
@description('Data Explorer cluster name. Returns existing cluster name if using existing, or new cluster name if created.')
output dataExplorerName string = useExistingAdx 
  ? existingAdxClusterName 
  : (createNewAdx && dataExplorer != null ? dataExplorer!.outputs.name : '')

@description('Data Explorer cluster endpoint. For Fabric, returns the Eventhouse query URI.')
output dataExplorerEndpoint string = useExistingAdx 
  ? 'https://${existingAdxClusterName}.${location}.kusto.windows.net'
  : (createNewAdx && dataExplorer != null 
    ? 'https://${dataExplorer!.outputs.name}.${location}.kusto.windows.net' 
    : (useFabric ? fabricQueryUri : ''))

@description('Data Explorer cluster resource ID. Returns existing cluster ID if using existing.')
output dataExplorerResourceId string = useExistingAdx 
  ? existingDataExplorerClusterId 
  : (createNewAdx && dataExplorer != null ? dataExplorer!.outputs.resourceId : '')

// Fabric-specific outputs
@description('Fabric eventhouse query URI. Empty if not using Fabric.')
output fabricEventhouseQueryUri string = useFabric ? fabricQueryUri : ''

@description('Fabric eventhouse ingestion URI. Empty if not using Fabric.')
output fabricEventhouseIngestionUri string = useFabric ? fabricIngestionUri : ''

@description('Fabric database name. Empty if not using Fabric.')
output fabricDatabase string = useFabric ? fabricDatabaseName : ''

// Data Factory pipeline outputs
@description('List of core Data Factory pipelines (msexports, ingestion).')
output dataFactoryPipelines array = dataFactoryResources.outputs.pipelineNames

@description('List of core Data Factory triggers.')
output dataFactoryTriggers array = dataFactoryResources.outputs.triggerNames

// Managed Exports outputs (conditional)
@description('Indicates whether managed export pipelines are deployed. Only true for EA/MCA/MPA with scopes.')
output managedExportsEnabled bool = enableManagedExports

@description('List of managed export pipelines. Empty if not using managed exports.')
#disable-next-line BCP321 // Null safety - module only exists when enableManagedExports is true  
output managedExportsPipelines array = enableManagedExports ? managedExportsPipelines!.outputs.pipelineNames : []

@description('List of managed export triggers. Empty if not using managed exports.')
#disable-next-line BCP321 // Null safety - module only exists when enableManagedExports is true
output managedExportsTriggers array = enableManagedExports ? managedExportsPipelines!.outputs.triggerNames : []

@description('Analytics platform configured (adx, fabric, or none).')
output analyticsPlatform string = dataFactoryResources.outputs.analyticsPlatform

@description('Indicates whether MACC (Microsoft Azure Consumption Commitment) tracking is enabled.')
output maccEnabled bool = dataFactoryResources.outputs.maccEnabled

// ADX Schema deployment outputs
@description('Indicates whether ADX schema was deployed.')
output adxSchemaDeployed bool = deployAdxSchema

@description('List of schema components deployed to ADX. Empty if schema not deployed.')
#disable-next-line BCP318 // Null safety - module only exists when deployAdxSchema is true
output adxSchemaComponents array = deployAdxSchema && adxSchemaSetup != null ? adxSchemaSetup!.outputs.deployedComponents : []

// Network isolation outputs
@description('Network isolation mode used for this deployment.')
output networkIsolationMode string = effectiveNetworkIsolationMode

@description('VNet resource ID. Only populated when networkIsolationMode is "Managed".')
#disable-next-line BCP321 // Null safety - managedNetwork only exists when mode is Managed
output vnetResourceId string = effectiveNetworkIsolationMode == 'Managed' ? managedNetwork!.outputs.vnetResourceId : ''

@description('Private endpoint subnet resource ID. Empty when networkIsolationMode is "None".')
output privateEndpointSubnetResourceId string = effectiveSubnetId

// ============================================================================
// SCOPE MONITORING & EXPORT CONFIGURATION OUTPUTS
// ============================================================================
// These outputs provide guidance for both Enterprise mode (EA/MCA with exports)
// and Demo mode (PAYGO/CSP without export support).

@description('Billing account type specified or detected. Use to determine export support.')
output billingAccountTypeHint string = billingAccountType

@description('Indicates whether Cost Management exports are supported for the specified billing type. PAYGO and Free Trial do NOT support exports.')
output exportSupported bool = contains(['ea', 'mca', 'mpa', 'auto'], billingAccountType)

@description('Scopes configured for monitoring. Empty array indicates Demo mode.')
output configuredScopes array = scopesToMonitor

@description('Number of scopes configured for monitoring.')
output scopeCount int = length(scopesToMonitor)

@description('''Deployment mode based on configuration:
- "enterprise": EA/MCA billing with export support configured
- "demo": No scopes or PAYGO billing - use test data scripts
- "hybrid": Mixed configuration with some export-capable scopes''')
output deploymentMode string = empty(scopesToMonitor) || billingAccountType == 'paygo' || billingAccountType == 'csp'
  ? 'demo'
  : contains(['ea', 'mca', 'mpa'], billingAccountType) ? 'enterprise' : 'hybrid'

@description('Cost Management export configuration for FinOps Toolkit PowerShell.')
output exportConfiguration object = {
  storageAccountId: storageAccount.outputs.resourceId
  storageAccountName: storageAccount.outputs.name
  msexportsContainer: 'msexports'
  ingestionContainer: 'ingestion'
  configContainer: 'config'
  exportSupported: contains(['ea', 'mca', 'mpa', 'auto'], billingAccountType)
  billingType: billingAccountType
  scopeCount: length(scopesToMonitor)
  
  // Generic export command template - users substitute their scope
  exportCommandTemplate: 'New-FinOpsCostExport -Name "FinOpsHub-${hubName}" -Scope "<YOUR-SCOPE-ID>" -StorageAccountId "${storageAccount.outputs.resourceId}" -StorageContainer "msexports" -Dataset FocusCost -Execute -Backfill 3'
  
  // Demo mode commands  
  demoCommands: {
    generateTestData: '.\\src\\Test-FinOpsHub.ps1 -StorageAccountName "${storageAccount.outputs.name}" -TargetMonthlySpend 10000 -MonthsOfData 3'
    generateMultiCloudData: '.\\src\\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "${storageAccount.outputs.name}" -TotalBudget 100000'
  }
}

// Use variables to build arrays that can then be used in outputs
var settingsJsonScopes = [for scope in scopesToMonitor: {
  scope: scope.?scopeId ?? ''
  displayName: scope.?displayName ?? ''
  tenantId: scope.?tenantId ?? tenant().tenantId
}]

@description('''Settings.json content for the config container. 
This file is used by the FinOps Toolkit for managed exports (future feature).
Currently, it provides forward compatibility and documents configured scopes.''')
output settingsJson object = {
  '$schema': 'https://aka.ms/finops/hubs/settings-schema'
  type: 'HubInstance'
  version: '1.0.0'
  hubName: hubName
  learnMore: 'https://aka.ms/finops/hubs'
  scopes: settingsJsonScopes
  deployment: {
    mode: empty(scopesToMonitor) || billingAccountType == 'paygo' ? 'demo' : 'enterprise'
    billingType: billingAccountType
    exportSupported: contains(['ea', 'mca', 'mpa', 'auto'], billingAccountType)
    storageAccount: storageAccount.outputs.name
    resourceGroup: resourceGroup().name
    location: location
  }
}

// Build ADX endpoint for outputs
var adxEndpointUrl = useExistingAdx 
  ? 'https://${existingAdxClusterName}.${location}.kusto.windows.net'
  : (createNewAdx && dataExplorer != null ? 'https://${dataExplorer!.outputs.name}.${location}.kusto.windows.net' : 'N/A')

@description('''Getting started guide based on deployment mode.
Provides step-by-step instructions for both Enterprise and Demo modes.''')
output gettingStartedGuide object = {
  mode: empty(scopesToMonitor) || billingAccountType == 'paygo' || billingAccountType == 'csp' ? 'demo' : 'enterprise'
  
  demoModeSteps: [
    '1. Navigate to the src/ folder in this module'
    '2. Run: .\\Test-FinOpsHub.ps1 -StorageAccountName "${storageAccount.outputs.name}"'
    '3. Wait ~5 minutes for ADF pipelines to process the data'
    '4. Query data in ADX: Hub database > Costs table'
    'Note: Demo mode generates realistic FOCUS 1.0r2 test data (~$10K/month)'
  ]
  
  enterpriseModeSteps: [
    '1. Install FinOps Toolkit: Install-Module FinOpsToolkit -Force'
    '2. Create exports for each scope using the exportCommandTemplate'
    '3. Wait for first export to run (can take up to 24 hours for initial export)'
    '4. ADF pipelines will automatically process data as it arrives'
    '5. Query data in ADX: Hub database > Costs table'
    'Note: Backfill historical data with -Backfill parameter (up to 13 months)'
  ]
  
  commonSteps: [
    'Connect Power BI using the Data Explorer endpoint: ${adxEndpointUrl}'
    'Create ADX dashboard for cost visualization'
    'Set up alerts using ADX alerting or Azure Monitor'
  ]
  
  troubleshooting: {
    noData: 'Check ADF pipeline runs in Data Factory Studio > Monitor'
    exportErrors: 'Verify ADF managed identity has Cost Management Reader on billing scope'
    testDataUpload: 'Ensure your IP is allowed in storage firewall, or use -SkipFirewallConfig'
  }
  
  exportSupportMatrix: {
    ea: 'Full support: FOCUS Costs, Prices, Reservation Details/Recommendations/Transactions'
    mca: 'Full support: FOCUS Costs, Prices, Reservation Details/Recommendations/Transactions'
    subscription: 'Limited: FOCUS Costs only (no pricing or reservation data)'
    resourceGroup: 'Very limited: Resource group costs only'
    paygo: 'Not supported: Use Demo mode with test data scripts'
  }
}

