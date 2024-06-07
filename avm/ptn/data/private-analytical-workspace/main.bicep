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

@description('Optional. If you already have an existing subnet resource ID in the region that is suitable for private endpoint, you can optionally provide it here. Otherwise, this module will create a new subnet for you.')
param privateEndpointSubnetResourceId string = ''

@description('Optional. You can specify an existing Log Analytics Workspace if you have one. If not, this module will create a new one for you.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. You can specify an existing Key Vault if you have one. If not, this module will create a new one for you.')
param keyVaultResourceId string = ''

@description('Optional. Rules governing the accessibility of the private analytical workspace solution and its components from specific network locations. Contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls networkAclsType?

@description('Optional. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.') // TODO
param databricks databricksType?

// Constants
var diagnosticSettingsName = '${name}-diagnostic-settings'
var privateDnsZoneNameKv = 'privatelink.vaultcore.azure.net'
var privateDnsZoneNameDbw = 'privatelink.azuredatabricks.net'
var dbwSubnetNameControlPlane = '${name}-dbw-control-plane'
var dbwSubnetNameDataPlane = '${name}-dbw-data-plane'

var existingVNET = !empty(privateEndpointSubnetResourceId)

var cfg = ({
  privateEndpointSubnetResourceId: empty(privateEndpointSubnetResourceId)
    ? vnet.outputs.subnetResourceIds[0] // private link subnet should be always available and zero index
    : privateEndpointSubnetResourceId
})

var logCfg = ({
  logAnalyticsWorkspaceResourceId: empty(logAnalyticsWorkspaceResourceId)
    ? log.outputs.resourceId
    : logAnalyticsWorkspaceResourceId
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
          addressPrefix: '192.168.228.0/23'
          name: dbwSubnetNameControlPlane
        }
        {
          addressPrefix: '192.168.228.0/23'
          name: dbwSubnetNameDataPlane
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

module vnet 'br/public:avm/res/network/virtual-network:0.1.0' = if (!existingVNET) {
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

    privateEndpoints: existingVNET
      ? []
      : [
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
    //publicNetworkAccess: existingVNET ? 'Disabled' : 'Enabled' // TODO - When existingVNET + ACL
    //roleAssignments: // TODO
    sku: 'premium'
    //softDeleteRetentionInDays: // TODO
    tags: tags
  }
}

module dnsZoneKv 'br/public:avm/res/network/private-dns-zone:0.3.0' = if (!existingVNET) {
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
        registrationEnabled: true
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
    customPrivateSubnetName: existingVNET
      ? databricks.?dbwSubnetNameControlPlane // TODO validace
      : filter(subnets, item => item.productPrice == dbwSubnetNameControlPlane)[0] // TODO
    customPublicSubnetName: existingVNET
      ? databricks.?dbwSubnetNameDataPlane // TODO validace
      : filter(subnets, item => item.productPrice == dbwSubnetNameDataPlane)[0] // TODO
    customVirtualNetworkResourceId: existingVNET
      ? split(databricks.?dbwSubnetNameControlPlane, '/subnets/')[0]
      : vnet.outputs.resourceId // TODO
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

module dnsZoneDbw 'br/public:avm/res/network/private-dns-zone:0.3.0' = if ((!existingVNET) && enableDatabricks) {
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
        registrationEnabled: true
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

type networkAclsType = {
  @description('Optional. Sets the virtual network rules.')
  virtualNetworkRules: array?

  @description('Optional. Sets the IP ACL rules.')
  ipRules: array?
}

type databricksType = {
  @description('Optional. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.')
  dbwSubnetNameControlPlane: string?
  @description('Optional. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.')
  dbwSubnetNameDataPlane: string?
}
