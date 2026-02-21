// ============================================================================
// FinOps Hub - Azure Verified Modules Pattern
// ============================================================================
// Deploys a FinOps Hub using AVM for cost visibility across Azure and multi-cloud.
// Supports: Azure Data Explorer, Microsoft Fabric, or storage-only deployments.
// Reference: https://learn.microsoft.com/en-us/cloud-computing/finops/toolkit/hubs/finops-hubs-overview
// ============================================================================

metadata name = 'FinOps Hub'
metadata description = 'Deploys a FinOps Hub for cloud cost analytics using Azure Verified Modules.'
metadata version = '0.2.0'
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
@description('Conditional. Azure Data Explorer cluster name. Required if deploymentType is "adx" and not using existing cluster.')
param dataExplorerClusterName string = ''

@description('Optional. Resource ID of an existing Azure Data Explorer cluster to use. When provided, no new cluster is created.')
param existingDataExplorerClusterId string = ''

@description('Optional. Azure Data Explorer SKU. Leave empty to use configuration default (minimal: Dev SKU, waf-aligned: Standard SKU).')
param dataExplorerSku string = ''

@description('Optional. Number of instances in the Data Explorer cluster. Set to 0 to use configuration default (minimal: 1, waf-aligned: 2).')
param dataExplorerCapacity int = 0

// --- Microsoft Fabric Options ---
@description('Conditional. Microsoft Fabric eventhouse Query URI. Required if deploymentType is "fabric".')
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
@description('Optional. Billing type hint: "ea", "mca", "mpa" support exports; "paygo", "csp" use demo mode. See README for export support matrix.')
@allowed(['auto', 'ea', 'mca', 'mpa', 'paygo', 'csp'])
param billingAccountType string = 'auto'

@description('Optional. Billing account ID for MACC tracking. Requires ADF MI to have Billing Account Reader role.')
param billingAccountId string = ''

// --- Scope Configuration (Hybrid Mode) ---
// This section enables both Enterprise mode (with exports) and Demo mode (without billing accounts).
// The module generates settings.json for compatibility with the official FinOps Toolkit.
// For tenants without EA/MCA, use the test data scripts in src/ to populate the hub.
@description('Optional. Billing scopes to monitor. See README for scope types and export support matrix.')
param scopesToMonitor array = []

// --- Security & Networking ---
@description('Optional. Enable RBAC authorization for Key Vault (recommended).')
param enableRbacAuthorization bool = true

@description('Optional. Enable Key Vault purge protection. Automatically enabled for waf-aligned.')
param enablePurgeProtection bool = false

@description('Optional. Enable public network access. Automatically disabled for waf-aligned.')
param enablePublicAccess bool = true

@description('Optional. Network isolation: "None" (public), "Managed" (module creates VNet/PEs), or "BringYourOwn" (you provide subnet/DNS).')
@allowed(['None', 'Managed', 'BringYourOwn'])
param networkIsolationMode string = 'None'

@description('Optional. Address prefix for the managed VNet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/24.')
param managedVnetAddressPrefix string = '10.0.0.0/24'

@description('Optional. Address prefix for the private endpoints subnet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/26.')
param managedSubnetAddressPrefix string = '10.0.0.0/26'

// --- BringYourOwn Network Configuration ---
@description('Conditional. Subnet resource ID for private endpoints. Required if networkIsolationMode is "BringYourOwn".')
param byoSubnetResourceId string = ''

#disable-next-line no-hardcoded-env-urls
@description('Conditional. Resource ID of the private DNS zone for blob storage (privatelink.blob.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoBlobDnsZoneId string = ''

#disable-next-line no-hardcoded-env-urls
@description('Conditional. Resource ID of the private DNS zone for DFS storage (privatelink.dfs.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoDfsDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Key Vault (privatelink.vaultcore.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoVaultDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Data Factory (privatelink.datafactory.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.')
param byoDataFactoryDnsZoneId string = ''

@description('Conditional. Resource ID of the private DNS zone for Kusto/ADX (privatelink.<region>.kusto.windows.net). Required if networkIsolationMode is "BringYourOwn", deploymentType is "adx", and enablePrivateDnsZoneGroups is true.')
param byoKustoDnsZoneId string = ''

// --- Private Endpoint Options ---
@description('Optional. Enable Data Factory Managed Virtual Network with Managed Integration Runtime. Required for accessing private endpoints from ADF pipelines. Automatically enabled when networkIsolationMode is "Managed" or "BringYourOwn". See enableManagedPeAutoApproval parameter for PE approval options.')
param enableAdfManagedVnet bool = false

@description('Optional. Enable automatic approval of ADF Managed Private Endpoints. When true (Option A), grants ADF control-plane permissions to auto-approve its PE connections to Storage and Key Vault. When false (Option B), PE connections require manual approval via Azure Portal or CLI. Default: true for streamlined deployments.')
param enableManagedPeAutoApproval bool = true

@description('Optional. Create DNS zone groups for private endpoints. Set false when Azure Policy manages DNS records (ESLZ pattern).')
param enablePrivateDnsZoneGroups bool = true

// --- Legacy Parameters (Deprecated - use networkIsolationMode instead) ---
// These are kept for backward compatibility but will be removed in v1.0
@description('Optional. Note: This is a deprecated property, please use `networkIsolationMode="BringYourOwn"` with `byoSubnetResourceId` instead. Resource ID of the subnet for private endpoints.')
param privateEndpointSubnetId string = ''

@description('Optional. Note: This is a deprecated property, please use `byoBlobDnsZoneId` instead.')
param storageBlobPrivateDnsZoneId string = ''

@description('Optional. Note: This is a deprecated property, please use `byoDfsDnsZoneId` instead.')
param storageDfsPrivateDnsZoneId string = ''

@description('Optional. Note: This is a deprecated property, please use `byoVaultDnsZoneId` instead.')
param keyVaultPrivateDnsZoneId string = ''

@description('Optional. Note: This is a deprecated property, please use `byoDataFactoryDnsZoneId` instead.')
param dataFactoryPrivateDnsZoneId string = ''

// --- Tagging ---
@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Resource-specific tags by resource type.')
param tagsByResource object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// --- AVM Standard Interface Parameters ---
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. The diagnostic settings of the service. Applies to Storage Account and Key Vault.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable automatic trigger start/stop for idempotent redeployments. Requires shared key access on storage.')
param enableTriggerManagement bool = false

// ============================================================================
// VARIABLES
// ============================================================================

// Storage configuration: minimal=Standard_LRS, waf-aligned=Premium_ZRS
var storageSku = deploymentConfiguration == 'waf-aligned' ? 'Premium_ZRS' : 'Standard_LRS'
var storageKind = deploymentConfiguration == 'waf-aligned' ? 'BlockBlobStorage' : 'StorageV2'

// ADX SKU: Dev SKUs (no SLA, 1 node), Standard SKUs (SLA, min 2 nodes)
var effectiveAdxSku = !empty(dataExplorerSku) ? dataExplorerSku : 'Standard_E2d_v5'
var effectiveAdxTier = startsWith(effectiveAdxSku, 'Dev') ? 'Basic' : 'Standard'
var effectiveAdxCapacity = dataExplorerCapacity > 0 ? dataExplorerCapacity : (startsWith(effectiveAdxSku, 'Dev') ? 1 : 2)

// Security settings
var effectivePurgeProtection = deploymentConfiguration == 'waf-aligned' ? true : enablePurgeProtection
var effectivePublicAccess = deploymentConfiguration == 'waf-aligned' ? false : enablePublicAccess

// Managed exports: only for billing types that support Cost Management exports
var enableManagedExports = contains(['ea', 'mca', 'mpa'], billingAccountType) && !empty(scopesToMonitor)

// Network isolation: waf-aligned defaults to Managed, legacy params upgrade to BringYourOwn
var effectiveNetworkIsolationMode = deploymentConfiguration == 'waf-aligned' && networkIsolationMode == 'None' 
  ? 'Managed'
  : (!empty(privateEndpointSubnetId) && networkIsolationMode == 'None'
    ? 'BringYourOwn'
    : networkIsolationMode)

// Private endpoint configuration - enabled for Managed or BringYourOwn modes
var enablePrivateEndpoints = effectiveNetworkIsolationMode != 'None'

// ADF Managed VNet - auto-enable when private endpoints are enabled
var effectiveAdfManagedVnet = enableAdfManagedVnet || enablePrivateEndpoints

// Resource naming (CAF conventions)
var uniqueSuffix = uniqueString(resourceGroup().id, hubName)
var storageAccountName = take(toLower('st${replace(hubName, '-', '')}${uniqueSuffix}'), 24)
var keyVaultName = take('kv-${hubName}-${take(uniqueSuffix, 6)}', 24)
var dataFactoryName = take('adf-${hubName}-${take(uniqueSuffix, 6)}', 63)
var managedIdentityName = 'id-${hubName}'

// ADX cluster: globally unique, 4-22 chars, lowercase alphanumeric
var adxClusterName = !empty(dataExplorerClusterName) ? take(toLower('${replace(dataExplorerClusterName, '-', '')}${take(uniqueSuffix, 6)}'), 22) : ''

// Deployment flags
var useExistingIdentity = !empty(existingManagedIdentityResourceId)
var useExistingAdx = !empty(existingDataExplorerClusterId)
var createNewAdx = deploymentType == 'adx' && !empty(dataExplorerClusterName) && !useExistingAdx
var useFabric = deploymentType == 'fabric' && !empty(fabricQueryUri)
var deployAdxSchema = deploymentType == 'adx' && (createNewAdx || useExistingAdx)

// ADX admin principal assignments
var adxAdminAssignments = [for principalId in adxAdminPrincipalIds: {
  principalId: principalId
  principalType: 'User'
  role: 'AllDatabasesAdmin'
  tenantId: tenant().tenantId
}]

var deployerAdminAssignment = !empty(deployerPrincipalId) ? [
  {
    principalId: deployerPrincipalId
    principalType: 'User'
    role: 'AllDatabasesAdmin'
    tenantId: tenant().tenantId
  }
] : []

// Extract names from existing resource IDs
var existingIdentityName = useExistingIdentity ? last(split(existingManagedIdentityResourceId, '/')) : ''
var existingAdxClusterName = useExistingAdx ? last(split(existingDataExplorerClusterId, '/')) : ''

// Standard FinOps Hub containers
var containers = ['config', 'msexports', 'ingestion']

// Version tracking
var ftkVersion = '0.7.0'
var hubModuleVersion = '0.2.0'

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
  name: '46d3xbcp.ptn.finopstoolkit-finopshub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
// RESOURCES
// ============================================================================

// --- Managed Network (when networkIsolationMode is 'Managed') ---
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
#disable-next-line BCP321
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

#disable-next-line BCP321
var effectiveKustoDnsZoneId = effectiveNetworkIsolationMode == 'Managed'
  ? managedNetwork!.outputs.kustoDnsZoneId
  : byoKustoDnsZoneId

// --- User-Assigned Managed Identity ---
resource existingManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (useExistingIdentity) {
  name: existingIdentityName
}

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

// Effective identity values
var effectiveIdentityPrincipalId = useExistingIdentity ? existingManagedIdentity!.properties.principalId : managedIdentity!.outputs.principalId
var effectiveIdentityClientId = useExistingIdentity ? existingManagedIdentity!.properties.clientId : managedIdentity!.outputs.clientId
var effectiveIdentityResourceId = useExistingIdentity ? existingManagedIdentityResourceId : managedIdentity!.outputs.resourceId
var effectiveIdentityName = useExistingIdentity ? existingIdentityName : managedIdentity!.outputs.name

// --- Storage Account (ADLS Gen2) ---
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
    // Storage role assignment: Reader for config access
    roleAssignments: [
      {
        principalId: effectiveIdentityPrincipalId
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        principalType: 'ServicePrincipal'
      }
    ]
    // Private endpoints for blob and dfs
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
    // Managed Virtual Network for ADF to access private endpoints
    managedVirtualNetwork: effectiveAdfManagedVnet ? {
      name: 'default'
      managedPrivateEndpoints: [
        {
          name: '${storageAccountName}-blob-mpe'
          groupId: 'blob'
          fqdns: [
            '${storageAccountName}.blob.${environment().suffixes.storage}'
          ]
          privateLinkResourceId: storageAccount.outputs.resourceId
        }
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
    // Managed Integration Runtime
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

// --- Data Factory Resources ---

// Stop triggers before updating ADF resources (idempotent redeployment)
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
    adfStorageRoleAssignment
    adfKeyVaultRoleAssignment
    stopTriggers
  ]
  params: {
    dataFactoryName: dataFactory.outputs.name
    storageAccountName: storageAccount.outputs.name
    keyVaultName: keyVault.outputs.name
    dataExplorerEndpoint: createNewAdx && dataExplorer != null 
      ? 'https://${dataExplorer!.outputs.name}.${location}.kusto.windows.net' 
      : (useExistingAdx ? 'https://${existingAdxClusterName}.${location}.kusto.windows.net' : '')
    dataExplorerPrincipalId: createNewAdx && dataExplorer != null
      ? dataExplorer!.outputs.systemAssignedMIPrincipalId!
      : ''
    fabricQueryUri: useFabric ? fabricQueryUri : ''
    ftkVersion: ftkVersion
    integrationRuntimeName: effectiveAdfManagedVnet ? 'FinOpsHubManagedIR' : ''
    billingAccountId: billingAccountId
  }
}

// --- Managed Exports Pipelines (EA/MCA/MPA only) ---
module managedExportsPipelines 'modules/managedExportsPipelines.bicep' = if (enableManagedExports) {
  name: '${uniqueString(deployment().name, location)}-managed-exports'
  dependsOn: [dataFactoryResources]
  params: {
    dataFactoryName: dataFactory.outputs.name
    storageAccountName: storageAccount.outputs.name
    hubName: hubName
    ftkVersion: ftkVersion
    integrationRuntimeName: effectiveAdfManagedVnet ? 'FinOpsHubManagedIR' : ''
  }
}

// --- Azure Data Explorer ---
module dataExplorer 'br/public:avm/res/kusto/cluster:0.9.1' = if (createNewAdx) {
  name: '${uniqueString(deployment().name, location)}-adx'
  dependsOn: effectiveNetworkIsolationMode == 'Managed' ? [managedNetwork] : []
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
    enableAutoScale: deploymentConfiguration == 'waf-aligned'
    enableAutoStop: deploymentConfiguration == 'minimal'
    enableDiskEncryption: true  // WAF: AZR-000013 - disk encryption for ADX clusters
    enablePublicNetworkAccess: !enablePrivateEndpoints
    publicIPType: 'IPv4'
    managedIdentities: {
      systemAssigned: true
    }
    // FinOps Hub databases
    databases: [
      {
        name: 'Hub'
        kind: 'ReadWrite'
        readWriteProperties: {}
        databasePrincipalAssignments: []
      }
      {
        name: 'Ingestion'
        kind: 'ReadWrite'
        readWriteProperties: {}
        databasePrincipalAssignments: []
      }
    ]
    clusterPrincipalAssignments: concat(
      // ADF managed identity
      [
        {
          principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
          principalType: 'App'
          role: 'AllDatabasesAdmin'
          tenantId: tenant().tenantId
        }
      ],
      // Deployment script managed identity - use clientId (applicationId) for ADX 'App' principalType
      [
        {
          principalId: effectiveIdentityClientId
          principalType: 'App'
          role: 'AllDatabasesAdmin'
          tenantId: tenant().tenantId
        }
      ],
      deployerAdminAssignment,
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

// --- ADX Schema Setup ---
module adxSchemaSetup 'modules/adxSchemaSetup.bicep' = if (deployAdxSchema) {
  name: '${uniqueString(deployment().name, location)}-adx-schema'
  dependsOn: createNewAdx ? [dataExplorer] : []
  params: {
    clusterName: createNewAdx ? dataExplorer!.outputs.name : existingAdxClusterName
    rawRetentionInDays: 30
    continueOnErrors: true
  }
}

// --- Role Assignments ---

// ADF -> Storage (read/write for pipelines)
module adfStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: '${uniqueString(deployment().name, location)}-adf-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// ADX -> Storage (read for native ingestion)
#disable-next-line BCP321
module adxStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (createNewAdx) {
  name: '${uniqueString(deployment().name, location)}-adx-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    #disable-next-line BCP321
    principalId: dataExplorer!.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// ADF -> Key Vault (read secrets)
module adfKeyVaultRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableRbacAuthorization) {
  name: '${uniqueString(deployment().name, location)}-adf-kv-role'
  params: {
    resourceId: keyVault.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// --- ADF Managed PE Auto-Approval ---
// Grants ADF permissions to auto-approve its managed PE connections
module adfStoragePeApprovalRole 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (effectiveAdfManagedVnet && enableManagedPeAutoApproval) {
  name: '${uniqueString(deployment().name, location)}-adf-storage-pe-approval'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab') // Storage Account Contributor
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module adfKeyVaultPeApprovalRole 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (effectiveAdfManagedVnet && enableManagedPeAutoApproval) {
  name: '${uniqueString(deployment().name, location)}-adf-kv-pe-approval'
  params: {
    resourceId: keyVault.outputs.resourceId
    principalId: dataFactory.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395') // Key Vault Contributor
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// --- ADX Managed Private Endpoint ---
#disable-next-line BCP321
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

// --- ADX PE Connection Approval ---
#disable-next-line BCP321
module getAdxPendingConnections 'modules/adxPrivateEndpointApproval.bicep' = if (createNewAdx && effectiveAdfManagedVnet) {
  name: '${uniqueString(deployment().name, location)}-adx-pe-get'
  dependsOn: [adxManagedPrivateEndpoint]
  params: {
    adxClusterName: dataExplorer!.outputs.name
  }
}

#disable-next-line BCP321
module approveAdxManagedPeConnections 'modules/adxPrivateEndpointApproval.bicep' = if (createNewAdx && effectiveAdfManagedVnet) {
  name: '${uniqueString(deployment().name, location)}-adx-pe-approve'
  params: {
    adxClusterName: dataExplorer!.outputs.name
    #disable-next-line BCP321
    privateEndpointConnections: getAdxPendingConnections!.outputs.privateEndpointConnections
  }
}

// --- Managed Identity Permissions ---
module identityStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-identity-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: effectiveIdentityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69566ab7-960f-475b-8e7c-b3118f30c6bd') // Storage File Data Privileged Contributor
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module identityAdfRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-identity-adf-role'
  params: {
    resourceId: dataFactory.outputs.resourceId
    principalId: effectiveIdentityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '673868aa-7521-48a0-acc6-0f60742d39f5') // Data Factory Contributor
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// --- Deployer Permissions ---
module deployerStorageRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(deployerPrincipalId)) {
  name: '${uniqueString(deployment().name, location)}-deployer-storage-role'
  params: {
    resourceId: storageAccount.outputs.resourceId
    principalId: deployerPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Contributor
    principalType: 'User'
    enableTelemetry: enableTelemetry
  }
}

// --- Post-Deployment: Start Triggers ---
module startTriggers 'modules/triggerManagement.bicep' = if (enableTriggerManagement) {
  name: '${uniqueString(deployment().name, location)}-start-triggers'
  dependsOn: [
    dataFactoryResources  // All ADF resources must be deployed first
    adxSchemaSetup        // ADX schema should be ready (if applicable)
    // Note: ADX MI policy is now set at runtime via ADF pipeline activity (Set Ingestion Policy)
    // in ingestion_ETL_dataExplorer pipeline, matching the upstream FinOps toolkit approach
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

// --- ADX Managed Identity Policy ---
// NOTE: The managed identity policy for native ingestion (managed_identity=system) is now
// configured at runtime via an ADF pipeline activity ("Set Ingestion Policy") in the
// ingestion_ETL_dataExplorer pipeline (see dataFactoryResources.bicep). This matches the
// upstream FinOps toolkit approach. Setting the policy during ARM deployment is unreliable
// due to permission propagation delays between the ARM control plane and ADX data plane.
// See adx-pg-message.txt for the full analysis sent to the Kusto product group.

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

@description('User-assigned managed identity principal ID (object ID).')
output managedIdentityPrincipalId string = effectiveIdentityPrincipalId

@description('User-assigned managed identity client ID (application ID).')
output managedIdentityClientId string = effectiveIdentityClientId

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

// --- Scope Monitoring Outputs ---

@description('Billing account type. Use to determine export support.')
output billingAccountTypeHint string = billingAccountType

@description('Whether Cost Management exports are supported.')
output exportSupported bool = contains(['ea', 'mca', 'mpa', 'auto'], billingAccountType)

@description('Scopes configured for monitoring.')
output configuredScopes array = scopesToMonitor

@description('Number of scopes configured for monitoring.')
output scopeCount int = length(scopesToMonitor)

@description('Deployment mode: enterprise, demo, or hybrid.')
output deploymentMode string = empty(scopesToMonitor) || billingAccountType == 'paygo' || billingAccountType == 'csp'
  ? 'demo'
  : contains(['ea', 'mca', 'mpa'], billingAccountType) ? 'enterprise' : 'hybrid'

@description('Cost Management export configuration.')
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
    generateTestData: '.\\src\\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "${storageAccount.outputs.name}" -CloudProvider Azure -TotalBudget 30000 -MonthsOfData 3'
    generateMultiCloudData: '.\\src\\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "${storageAccount.outputs.name}" -TotalBudget 100000'
  }
}

// Use variables to build arrays that can then be used in outputs
var settingsJsonScopes = [for scope in scopesToMonitor: {
  scope: scope.?scopeId ?? ''
  displayName: scope.?displayName ?? ''
  tenantId: scope.?tenantId ?? tenant().tenantId
}]

@description('Settings.json content for the config container.')
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

@description('Getting started guide based on deployment mode.')
output gettingStartedGuide object = {
  mode: empty(scopesToMonitor) || billingAccountType == 'paygo' || billingAccountType == 'csp' ? 'demo' : 'enterprise'
  
  demoModeSteps: [
    '1. Navigate to the src/ folder in this module'
    '2. Run: .\\Generate-MultiCloudTestData.ps1 -Upload -StorageAccountName "${storageAccount.outputs.name}"'
    '3. Wait ~5 minutes for ADF pipelines to process the data'
    '4. Query data in ADX: Hub database > Costs table'
    'Note: Demo mode generates realistic FOCUS 1.0-1.3 test data (~$100K total across 3 months)'
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

