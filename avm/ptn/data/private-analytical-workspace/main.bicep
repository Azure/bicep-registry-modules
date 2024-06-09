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

@description('Optional. Enable/Disable usage telemetry for all Resources in the solution.')
param enableTelemetry bool = true

@description('Optional. Enable/Disable Azure Databricks service in the solution.')
param enableDatabricks bool = false

@description('Optional. This option allows the full solution to be connected to a VNET that the customer provides. If you have an existing VNET that was made for this solution and has the same region, you can choose to give it here. This parameter refers to a subnet in the customer provided VNET and the subnet is meant for private endpoints. If you do not use this option, this module will make a new VNET and subnet for you.')
param privateEndpointSubnetResourceId string = ''

@description('Optional. If you already have a Log Analytics Workspace that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Log Analytics Workspace for you.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. If you already have a Key Vault that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Key Vault for you.')
param keyVaultResourceId string = ''

@description('Optional. Additional options that can affect some parts of the solution and how they are configured.')
param advancedOptions advancedOptionsType?

// Constants
var diagnosticSettingsName = '${name}-diagnostic-settings'
var privateDnsZoneNameKv = 'privatelink.vaultcore.azure.net'
var privateDnsZoneNameDbw = 'privatelink.azuredatabricks.net'
var subnetNameDbwContainer = '${name}-dbw-container-subnet'
var subnetNameDbwHost = '${name}-dbw-host-subnet'
var nsgNameDbwContainer = '${name}-nsg-dbw-container'
var nsgNameDbwHost = '${name}-nsg-dbw-host'

var logDefaultDailyQuotaGb = -1
var logDefaultDataRetention = 365

var createNewVNET = empty(privateEndpointSubnetResourceId)
var createNewLog = empty(logAnalyticsWorkspaceResourceId)
var createNewKV = empty(keyVaultResourceId)

var cfg = ({
  privateEndpointSubnetResourceId: createNewVNET ? vnet.outputs.subnetResourceIds[0] : privateEndpointSubnetResourceId // private link subnet should be always available at zero index
})

var logCfg = ({
  logAnalyticsWorkspaceResourceId: createNewLog ? log.outputs.resourceId : logAnalyticsWorkspaceResourceId
})

var privateLinkSubnet = [
  {
    addressPrefix: '192.168.224.0/24'
    name: '${name}-private-link'
  }
]

var subnets = concat(
  privateLinkSubnet,
  // Subnets for service typically in the /22 chunk
  enableDatabricks
    ? [
        // DBW - 192.168.228.0/22
        {
          // a container subnet (sometimes called the private subnet)
          name: subnetNameDbwContainer
          addressPrefix: '192.168.228.0/23'
          networkSecurityGroupResourceId: nsgDbwContainer.outputs.resourceId
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
          // host subnet (sometimes called the public subnet).
          name: subnetNameDbwHost
          addressPrefix: '192.168.230.0/23'
          networkSecurityGroupResourceId: nsgDbwHost.outputs.resourceId
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
        workspaceResourceId: logCfg.logAnalyticsWorkspaceResourceId
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

module nsgDbwContainer 'br/public:avm/res/network/network-security-group:0.2.0' = if (createNewVNET && enableDatabricks) {
  name: nsgNameDbwContainer
  params: {
    // Required parameters
    name: nsgNameDbwContainer
    // Non-required parameters
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.logAnalyticsWorkspaceResourceId
      }
    ]
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    tags: tags
    securityRules: [] // Databricks will add its own rules
  }
}

module nsgDbwHost 'br/public:avm/res/network/network-security-group:0.2.0' = if (createNewVNET && enableDatabricks) {
  name: nsgNameDbwHost
  params: {
    // Required parameters
    name: nsgNameDbwHost
    // Non-required parameters
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.logAnalyticsWorkspaceResourceId
      }
    ]
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    tags: tags
    securityRules: [] // Databricks will add its own rules
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
    //createMode: '' // TODO
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
        workspaceResourceId: logCfg.logAnalyticsWorkspaceResourceId
      }
    ]
    enablePurgeProtection: false // TODO
    enableRbacAuthorization: true
    enableSoftDelete: false // TODO
    enableTelemetry: enableTelemetry
    enableVaultForDeployment: false
    enableVaultForTemplateDeployment: false
    enableVaultForDiskEncryption: false // When enabledForDiskEncryption is true, networkAcls.bypass must include \"AzureServices\
    location: location
    lock: lock
    networkAcls: (!empty(advancedOptions)) && (!empty(advancedOptions.?networkAcls))
      ? {
          bypass: 'None'
          defaultAction: 'Deny'
          virtualNetworkRules: advancedOptions.?networkAcls.?virtualNetworkRules ?? []
          ipRules: advancedOptions.?networkAcls.?ipRules ?? []
        }
      : {
          // New default case that enables the firewall by default
          bypass: 'None'
          defaultAction: 'Deny'
        }

    privateEndpoints: createNewVNET
      ? [
          {
            name: '${name}-kv-pep'
            location: location
            privateDnsZoneResourceIds: [dnsZoneKv.outputs.resourceId]
            tags: tags
            subnetResourceId: cfg.privateEndpointSubnetResourceId
            enableTelemetry: enableTelemetry
            lock: lock
          }
        ]
      : []
    //publicNetworkAccess: createNewVNET ? 'Enabled' : 'Disabled' // TODO - When createNewVNET + ACL
    //roleAssignments: // TODO
    sku: 'premium'
    //softDeleteRetentionInDays: // TODO
    tags: tags
  }
}

module dnsZoneKv 'br/public:avm/res/network/private-dns-zone:0.3.0' = if (createNewVNET) {
  name: privateDnsZoneNameKv
  params: {
    // Required parameters
    name: privateDnsZoneNameKv
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

module dbw 'br/public:avm/res/databricks/workspace:0.4.0' = if (enableDatabricks) {
  name: '${name}-dbw'
  params: {
    // Required parameters
    name: '${name}-dbw'
    // Non-required parameters
    customPrivateSubnetName: createNewVNET
      ? filter(subnets, item => item.name == subnetNameDbwContainer)[0].name // TODO
      : advancedOptions.?databricks.?subnetNameDbwContainer // TODO validace
    customPublicSubnetName: createNewVNET
      ? filter(subnets, item => item.name == subnetNameDbwHost)[0].name // TODO
      : advancedOptions.?databricks.?subnetNameDbwHost // TODO validace
    customVirtualNetworkResourceId: createNewVNET
      ? vnet.outputs.resourceId // TODO
      : split(advancedOptions.?databricks.?subnetNameDbwContainer, '/subnets/')[0] // TODO
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        workspaceResourceId: logCfg.logAnalyticsWorkspaceResourceId
      }
    ]
    disablePublicIp: true // TODO
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    managedResourceGroupResourceId: null // TODO
    prepareEncryption: true // TODO
    privateEndpoints: [] // TODO
    publicIpName: null // TODO
    publicNetworkAccess: null // TODO
    requiredNsgRules: null // TODO
    roleAssignments: [] // TODO
    skuName: 'premium'
    storageAccountName: null // TODO
    storageAccountSkuName: null // TODO
    tags: tags
    vnetAddressPrefix: null // VNET will be always provided (either as param or VNET cration module)
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

// Add your outputs here

@description('The resource ID of the resource.')
output resourceId string = log.outputs.resourceId // TODO

@description('The name of the resource.')
output name string = log.outputs.name // TODO

@description('The location the resource was deployed into.')
output location string = log.outputs.location // TODO

@description('The name of the managed resource group.')
output resourceGroupName string = log.outputs.resourceGroupName // TODO

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type logAnalyticsWorkspaceType = {
  @description('Optional. Number of days data will be retained for. The dafult value is: 365')
  @minValue(0)
  @maxValue(730)
  dataRetention: int?

  @description('Optional. The workspace daily quota for ingestion. The dafult value is: -1 (not limited)')
  @minValue(-1)
  dailyQuotaGb: int?
}

type networkAclsType = {
  @description('Optional. Sets the virtual network rules.')
  virtualNetworkRules: array?

  @description('Optional. Sets the IP ACL rules.')
  ipRules: array?
}

type databricksType = {
  @description('Optional. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.')
  subnetNameDbwContainer: string?
  @description('Optional. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.')
  subnetNameDbwHost: string?
}

type advancedOptionsType = {
  @description('Optional. This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the logAnalyticsWorkspaceResourceId parameter is empty.')
  logAnalyticsWorkspace: logAnalyticsWorkspaceType?

  @description('Optional. Rules governing the accessibility of the solution and its components from specific network locations. Contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.')
  networkAcls: networkAclsType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Databricks if you set the enableDatabricks parameter to true.')
  databricks: databricksType?
}
