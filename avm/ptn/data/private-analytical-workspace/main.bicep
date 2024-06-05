metadata name = 'private-analytical-workspace'
metadata description = 'Using this pattern module, you can combine Azure services that frequently help with data analytics solutions.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private analytical workspace solution and its components. Used to ensure unique resource names.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable/Disable Azure Databricks service in the solution.')
param enableDatabricks bool = false

@description('Optional. You may provide a Virtual Network resource ID that already exists in the given region if you have a suitable VNET there. Otherwise, this module will make a new one for you.')
param vNetResourceId string = ''

@description('Optional. You can specify an existing Log Analytics Workspace if you have one. If not, this module will create a new one for you.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. You can specify an existing Key Vault if you have one. If not, this module will create a new one for you.')
param keyVaultResourceId string = ''

@description('Optional. Rules governing the accessibility of the private analytical workspace solution and its components from specific network locations. Contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls networkAclsType?

var diagnosticSettingsName = 'paw-diagnostic-settings'

var logCfg = ({
  logAnalyticsWorkspaceResourceId: empty(logAnalyticsWorkspaceResourceId)
    ? log.outputs.resourceId
    : logAnalyticsWorkspaceResourceId
})

var dbwSubnets = [
  // Subnets for service typically in the /22 chunk
  // DBW - 192.168.228.0/22
  {
    addressPrefix: '192.168.228.0/23'
    name: 'dbw-control-plane'
  }
  {
    addressPrefix: '192.168.228.0/23'
    name: 'dbw-data-plane'
  }
]

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

module log 'br/public:avm/res/operational-insights/workspace:0.3.0' = if (empty(logAnalyticsWorkspaceResourceId)) {
  name: '${name}-log'
  params: {
    // Required parameters
    name: '${name}-log'
    // Non-required parameters
    dailyQuotaGb: -1 // TODO
    dataRetention: 365 // TODO
    diagnosticSettings: []
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    skuName: 'PerGB2018'
    tags: tags
    // TODO - Network Isolation PL, networkAcls
  }
}

module kv 'br/public:avm/res/key-vault/vault:0.6.0' = if (empty(keyVaultResourceId)) {
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
    networkAcls: !empty(networkAcls)
      ? {
          bypass: 'None'
          defaultAction: 'Deny'
          virtualNetworkRules: networkAcls.?virtualNetworkRules ?? []
          ipRules: networkAcls.?ipRules ?? []
        }
      : {
          // New default case that enables the firewall by default
          bypass: 'None'
          defaultAction: 'Deny'
        }

    //privateEndpoints: []
    //publicNetworkAccess: false
    //roleAssignments: // TODO
    sku: 'premium'
    //softDeleteRetentionInDays: // TODO
    tags: tags
    // TODO - Network Isolation PL, networkAcls, RBAC for user
  }
}

module dbw 'br/public:avm/res/databricks/workspace:0.4.0' = if (false /*!!! TODO !!!*/) {
  name: '${name}-dbw'
  params: {
    // Required parameters
    name: '${name}-dbw'
    // Non-required parameters
    customPrivateSubnetName: null // TODO
    customPublicSubnetName: null // TODO
    customVirtualNetworkResourceId: null // TODO
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
    vnetAddressPrefix: null // TODO
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.0' = if (empty(vNetResourceId)) {
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
    subnets: [
      for subnet in dbwSubnets: enableDatabricks
        ? {
            addressPrefix: subnet.addressPrefix
            name: subnet.name
          }
        : null
    ]
    tags: tags
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

type networkAclsType = {
  @description('Optional. Sets the virtual network rules.')
  virtualNetworkRules: array?

  @description('Optional. Sets the IP ACL rules.')
  ipRules: array?
}
