metadata name = 'private-analytical-workspace'
metadata description = 'This pattern module enables you to use Azure services that are typical for data analytics solutions. The goal is to help data scientists establish an environment for data analysis simply. It is secure by default for enterprise use. Data scientists should not spend much time on how to build infrastructure solution. They should mainly concentrate on the data analytics components they require for the solution.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private analytical workspace solution and its components. Used to ensure unique resource names.')
param name string

@description('Optional. Location for all Resources in the solution.')
param location string = resourceGroup().location

@description('Optional. The lock settings for all Resources in the solution.')
param lock lockType

@description('Optional. Tags for all Resources in the solution.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable/Disable Azure Databricks service in the solution.')
param enableDatabricks bool = false

@description('Optional. This option allows the solution to be connected to a VNET that the customer provides. If you have an existing VNET that was made for this solution, you can specify it here. If you do not use this option, this module will make a new VNET for you.')
param virtualNetworkResourceId string?

@description('Optional. If you already have a Log Analytics Workspace that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Log Analytics Workspace for you.')
param logAnalyticsWorkspaceResourceId string?

@description('Optional. If you already have a Key Vault that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Key Vault for you.')
param keyVaultResourceId string?

@description('Optional. Additional options that can affect some parts of the solution and how they are configured.')
param advancedOptions advancedOptionsType?

// ============== //
// Variables      //
// ============== //

var diagnosticSettingsName = '${name}-diagnostic-settings'
var privateDnsZoneNameKv = 'privatelink.vaultcore.azure.net'
var privateDnsZoneNameDbw = 'privatelink.azuredatabricks.net'
var subnetNamePrivateLink = 'private-link-subnet'
var subnetNameDbwControlPlane = 'dbw-control-plane-subnet'
var subnetNameDbwComputePlane = 'dbw-compute-plane-subnet'
var nsgNameDbwControlPlane = '${name}-nsg-dbw-control-plane'
var nsgNameDbwComputePlane = '${name}-nsg-dbw-compute-plane'

var logDefaultDailyQuotaGb = -1
var logDefaultDataRetention = 365

var kvDefaultCreateMode = 'default'
var kvDefaultEnableSoftDelete = true
var kvDefaultSoftDeleteRetentionInDays = 90
var kvDefaultEnablePurgeProtection = true
var kvDefaultSku = 'premium'

var createNewVNET = empty(virtualNetworkResourceId)
var createNewLog = empty(logAnalyticsWorkspaceResourceId)
var createNewKV = empty(keyVaultResourceId)

var vnetCfg = ({
  resourceId: createNewVNET ? vnet.outputs.resourceId : vnetExisting.id
  name: createNewVNET ? vnet.outputs.name : vnetExisting.name
  location: createNewVNET ? vnet.outputs.location : vnetExisting.location
  resourceGroupName: createNewVNET ? vnet.outputs.resourceGroupName : split(vnetExisting.id, '/')[4]

  subnetResourceIdPrivateLink: createNewVNET
    ? vnet.outputs.subnetResourceIds[0] // private link subnet should be always available at zero index
    : vnetExisting::subnetPrivateLink.id
  subnetNameDbwControlPlane: createNewVNET
    ? filter(subnets, item => item.name == subnetNameDbwControlPlane)[0].name
    : vnetExisting::subnetDbwControlPlane.name
  subnetNameDbwComputePlane: createNewVNET
    ? filter(subnets, item => item.name == subnetNameDbwComputePlane)[0].name
    : vnetExisting::subnetDbwComputePlane.name
})

var logCfg = ({
  resourceId: createNewLog ? log.outputs.resourceId : logExisting.id
  name: createNewLog ? log.outputs.name : logExisting.name
  location: createNewLog ? log.outputs.location : logExisting.location
  resourceGroupName: createNewLog ? log.outputs.resourceGroupName : split(logExisting.id, '/')[4]
})

var privateLinkSubnet = [
  {
    name: subnetNamePrivateLink
    addressPrefix: '192.168.224.0/24'
  }
]

var subnets = concat(
  privateLinkSubnet,
  // Subnets for service typically in the /22 chunk
  enableDatabricks
    ? [
        // DBW - 192.168.228.0/22
        {
          // a container subnet (sometimes called the private subnet, control plane)
          name: subnetNameDbwControlPlane
          addressPrefix: '192.168.228.0/23'
          networkSecurityGroupResourceId: nsgDbwControlPlane.outputs.resourceId
          delegations: [
            {
              name: 'Microsoft.Databricks/workspaces'
              properties: {
                serviceName: 'Microsoft.Databricks/workspaces'
              }
            }
          ]
        }
        {
          // host subnet (sometimes called the public subnet, compute plane).
          name: subnetNameDbwComputePlane
          addressPrefix: '192.168.230.0/23'
          networkSecurityGroupResourceId: nsgDbwComputePlane.outputs.resourceId
          delegations: [
            {
              name: 'Microsoft.Databricks/workspaces'
              properties: {
                serviceName: 'Microsoft.Databricks/workspaces'
              }
            }
          ]
        }
      ]
    : []
)

var securityRulesDbw = []

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.data-privateanalyticalworkspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

//
// Add your resources here
//

resource vnetExisting 'Microsoft.Network/virtualNetworks@2023-11-01' existing = if (!createNewVNET) {
  name: empty(virtualNetworkResourceId) ? 'dummyName' : last(split(virtualNetworkResourceId!, '/'))
  scope: empty(virtualNetworkResourceId)
    ? resourceGroup()
    : resourceGroup(split(virtualNetworkResourceId!, '/')[2], split(virtualNetworkResourceId!, '/')[4])

  resource subnetPrivateLink 'subnets@2023-11-01' existing = if (!empty(advancedOptions) && !empty(advancedOptions.?virtualNetwork.?subnetNamePrivateLink)) {
    name: advancedOptions.?virtualNetwork.?subnetNamePrivateLink ?? 'dummyName'
  }

  resource subnetDbwControlPlane 'subnets@2023-11-01' existing = if (enableDatabricks && !empty(advancedOptions) && !empty(advancedOptions.?databricks.?subnetNameControlPlane)) {
    name: advancedOptions.?databricks.?subnetNameControlPlane ?? 'dummyName'
  }

  resource subnetDbwComputePlane 'subnets@2023-11-01' existing = if (enableDatabricks && !empty(advancedOptions) && !empty(advancedOptions.?databricks.?subnetNameComputePlane)) {
    name: advancedOptions.?databricks.?subnetNameComputePlane ?? 'dummyName'
  }
}

resource logExisting 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = if (!createNewLog) {
  name: empty(logAnalyticsWorkspaceResourceId) ? 'dummyName' : last(split(logAnalyticsWorkspaceResourceId!, '/'))
  scope: empty(logAnalyticsWorkspaceResourceId)
    ? resourceGroup()
    : resourceGroup(split(logAnalyticsWorkspaceResourceId!, '/')[2], split(logAnalyticsWorkspaceResourceId!, '/')[4])
}

resource kvExisting 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!createNewKV) {
  name: empty(keyVaultResourceId) ? 'dummyName' : last(split(keyVaultResourceId!, '/'))
  scope: empty(keyVaultResourceId)
    ? resourceGroup()
    : resourceGroup(split(keyVaultResourceId!, '/')[2], split(keyVaultResourceId!, '/')[4])
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.0' = if (createNewVNET) {
  name: '${name}-vnet'
  params: {
    // Required parameters
    addressPrefixes: [
      '192.168.224.0/19'
    ]
    name: '${name}-vnet'
    // Non-required parameters
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        workspaceResourceId: logCfg.resourceId
      }
    ]
    dnsServers: []
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    subnets: subnets
    tags: tags
  }
}

module nsgDbwControlPlane 'br/public:avm/res/network/network-security-group:0.2.0' = if (createNewVNET && enableDatabricks) {
  name: nsgNameDbwControlPlane
  params: {
    // Required parameters
    name: nsgNameDbwControlPlane
    // Non-required parameters
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    tags: tags
    securityRules: securityRulesDbw
  }
}

module nsgDbwComputePlane 'br/public:avm/res/network/network-security-group:0.2.0' = if (createNewVNET && enableDatabricks) {
  name: nsgNameDbwComputePlane
  params: {
    // Required parameters
    name: nsgNameDbwComputePlane
    // Non-required parameters
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    tags: tags
    securityRules: securityRulesDbw
  }
}

module log 'br/public:avm/res/operational-insights/workspace:0.3.0' = if (createNewLog) {
  name: '${name}-log'
  params: {
    // Required parameters
    name: '${name}-log'
    // Non-required parameters
    dailyQuotaGb: empty(advancedOptions)
      ? logDefaultDailyQuotaGb
      : advancedOptions.?logAnalyticsWorkspace.?dailyQuotaGb ?? logDefaultDailyQuotaGb
    dataRetention: empty(advancedOptions)
      ? logDefaultDataRetention
      : advancedOptions.?logAnalyticsWorkspace.?dataRetention ?? logDefaultDataRetention
    diagnosticSettings: []
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    skuName: 'PerGB2018'
    tags: tags
  }
}

module kv 'br/public:avm/res/key-vault/vault:0.6.0' = if (createNewKV) {
  name: '${name}-kv'
  params: {
    // Required parameters
    name: '${name}-kv'
    // Non-required parameters
    createMode: empty(advancedOptions)
      ? kvDefaultCreateMode
      : advancedOptions.?keyVault.?createMode ?? kvDefaultCreateMode
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        logCategoriesAndGroups: [
          {
            categoryGroup: 'audit'
          }
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.resourceId
      }
    ]
    enablePurgeProtection: empty(advancedOptions)
      ? kvDefaultEnablePurgeProtection
      : advancedOptions.?keyVault.?enablePurgeProtection ?? kvDefaultEnablePurgeProtection
    enableRbacAuthorization: true
    enableSoftDelete: empty(advancedOptions)
      ? kvDefaultEnableSoftDelete
      : advancedOptions.?keyVault.?enableSoftDelete ?? kvDefaultEnableSoftDelete
    enableTelemetry: enableTelemetry
    enableVaultForDeployment: false
    enableVaultForTemplateDeployment: false
    enableVaultForDiskEncryption: false // When enabledForDiskEncryption is true, networkAcls.bypass must include \"AzureServices\
    location: location
    lock: lock
    //publicNetworkAccess: createNewVNET ? 'Enabled' : 'Disabled' // TODO - When createNewVNET + ACL
    publicNetworkAccess: 'Disabled'
    sku: empty(advancedOptions)
      ? kvDefaultSku
      : (advancedOptions.?keyVault.?sku == 'standard' ? 'standard' : kvDefaultSku)
    softDeleteRetentionInDays: empty(advancedOptions)
      ? kvDefaultSoftDeleteRetentionInDays
      : advancedOptions.?keyVault.?softDeleteRetentionInDays ?? kvDefaultSoftDeleteRetentionInDays
    tags: tags
  }
}

module dbw 'br/public:avm/res/databricks/workspace:0.4.0' = if (enableDatabricks) {
  name: '${name}-dbw'
  params: {
    // Required parameters
    name: '${name}-dbw'
    // Non-required parameters
    customPrivateSubnetName: createNewVNET
      ? filter(subnets, item => item.name == subnetNameDbwControlPlane)[0].name
      : empty(advancedOptions) ? null : advancedOptions.?databricks.?subnetNameControlPlane // If not provided correctly, this will fail during deployment
    customPublicSubnetName: createNewVNET
      ? filter(subnets, item => item.name == subnetNameDbwComputePlane)[0].name
      : empty(advancedOptions) ? null : advancedOptions.?databricks.?subnetNameComputePlane // If not provided correctly, this will fail during deployment
    customVirtualNetworkResourceId: vnetCfg.resourceId
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.resourceId
      }
    ]
    disablePublicIp: true // For now only private, in the future maybe we can add public + ACL
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    managedResourceGroupResourceId: null // Maybe in the future we can support custom RG
    prepareEncryption: true
    privateEndpoints: createNewVNET
      ? [
          {
            name: '${name}-dbw-ui-pep'
            location: location
            service: 'databricks_ui_api'
            subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
            privateDnsZoneResourceIds: [dnsZoneDbw.outputs.resourceId]
            tags: tags
            enableTelemetry: enableTelemetry
            lock: lock
          }
          {
            name: '${name}-dbw-auth-pep'
            location: location
            service: 'browser_authentication'
            subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
            privateDnsZoneResourceIds: [dnsZoneDbw.outputs.resourceId]
            tags: tags
            enableTelemetry: enableTelemetry
            lock: lock
          }
        ]
      : [] // In customer provided VNET, customer must create PEPs on their own
    publicNetworkAccess: 'Disabled' // Disabled to access workspace only via private link, in the future maybe we can add public + ACL
    requiredNsgRules: 'NoAzureDatabricksRules' // NoAzureDatabricksRules for full private, AllRules for public
    // roleAssignments: [] // Maybe in the next iteration
    skuName: 'premium' // We need premium to use VNET injection, Private Connectivity (Requires Premium Plan)
    storageAccountName: null // TODO add existing one (maybe with PEP) - https://learn.microsoft.com/en-us/azure/databricks/security/network/storage/firewall-support
    tags: tags
  }
}

module dnsZoneDbw 'br/public:avm/res/network/private-dns-zone:0.3.0' = if (createNewVNET && enableDatabricks) {
  name: privateDnsZoneNameDbw
  params: {
    // Required parameters
    name: privateDnsZoneNameDbw
    // Non-required parameters
    enableTelemetry: enableTelemetry
    location: 'global'
    lock: lock
    tags: tags
    virtualNetworkLinks: [
      {
        registrationEnabled: false
        virtualNetworkResourceId: vnet.outputs.resourceId
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the resource.')
output resourceId string = logCfg.resourceId

@description('The name of the resource.')
output name string = logCfg.name

@description('The location the resource was deployed into.')
output location string = logCfg.location

@description('The name of the managed resource group.')
output resourceGroupName string = logCfg.resourceGroupName

@description('The resource ID of the Azure Virtual Network.')
output virtualNetworkResourceId string = logCfg.resourceId

@description('The name of the Azure Virtual Network.')
output virtualNetworkName string = logCfg.name

@description('The location of the Azure Virtual Network.')
output virtualNetworkLocation string = logCfg.location

@description('The name of the Azure Virtual Network resource group.')
output virtualNetworkResourceGroupName string = logCfg.resourceGroupName

@description('The resource ID of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logCfg.resourceId

@description('The name of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceName string = logCfg.name

@description('The location of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceLocation string = logCfg.location

@description('The name of the Azure Log Analytics Workspace resource group.')
output logAnalyticsWorkspaceResourceGroupName string = logCfg.resourceGroupName

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = logCfg.resourceId

@description('The name of the Azure Key Vault.')
output keyVaultName string = logCfg.name

@description('The location of the Azure Key Vault.')
output keyVaultLocation string = logCfg.location

@description('The name of the Azure Key Vault resource group.')
output keyVaultResourceGroupName string = logCfg.resourceGroupName

// ================ //
// Definitions      //
// ================ //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type virtualNetworkType = {
  @description('Optional. The name of the existing Private Link Subnet within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNamePrivateLink: string?
}

type logAnalyticsWorkspaceType = {
  @description('Optional. Number of days data will be retained for. The dafult value is: \'365\'.')
  @minValue(0)
  @maxValue(730)
  dataRetention: int?

  @description('Optional. The workspace daily quota for ingestion. The dafult value is: \'-1\' (not limited).')
  @minValue(-1)
  dailyQuotaGb: int?
}

type keyVaultType = {
  @description('Optional. The vault\'s create mode to indicate whether the vault need to be recovered or not. - \'recover\' or \'default\'. The dafult value is: \'default\'.')
  createMode: string?

  @description('Optional. Specifies the SKU for the vault. - \'premium\' or \'standard\'. The dafult value is: \'premium\'.')
  sku: string?

  @description('Optional. Switch to enable/disable Key Vault\'s soft delete feature. The dafult value is: \'true\'.')
  enableSoftDelete: bool?

  @description('Optional. Soft delete data retention days. It accepts >=7 and <=90. The dafult value is: \'90\'.')
  softDeleteRetentionInDays: int?

  @description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature. The dafult value is: \'true\'.')
  enablePurgeProtection: bool?
}

type databricksType = {
  // must be providied when DBW is going to be enabled and VNET is provided
  @description('Optional. The name of the existing Control Plane Subnet within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNameControlPlane: string?
  @description('Optional. The name of the existing Compute Plane Subnet within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNameComputePlane: string?
}

type advancedOptionsType = {
  @description('Optional. You can use this parameter to integrate the solution with an existing Azure Virtual Network if the \'virtualNetworkResourceId\' parameter is not empty.')
  virtualNetwork: virtualNetworkType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the \'logAnalyticsWorkspaceResourceId\' parameter is empty.')
  logAnalyticsWorkspace: logAnalyticsWorkspaceType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Key Vault if the \'keyVaultResourceId\' parameter is empty.')
  keyVault: keyVaultType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Databricks if you set the \'enableDatabricks\' parameter to \'true\'.')
  databricks: databricksType?
}
