metadata name = 'private-analytical-workspace'
metadata description = 'This pattern module enables you to use Azure services that are typical for data analytics solutions. The goal is to help data scientists establish an environment for data analysis simply. It is secure by default for enterprise use. Data scientists should not spend much time on how to build infrastructure solution. They should mainly concentrate on the data analytics components they require for the solution.'

@description('Required. Name of the private analytical workspace solution and its components. Used to ensure unique resource names.')
param name string

@description('Optional. Location for all Resources in the solution.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings for all Resources in the solution.')
param lock lockType?

@description('Optional. Tags for all Resources in the solution.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable/Disable Azure Databricks service within the solution.')
param enableDatabricks bool = false

@description('Optional. This option allows the solution to be connected to a VNET that the customer provides. If you have an existing VNET that was made for this solution, you can specify it here. If you do not use this option, this module will make a new VNET for you.')
param virtualNetworkResourceId string?

@description('Optional. If you already have a Log Analytics Workspace that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Log Analytics Workspace for you.')
param logAnalyticsWorkspaceResourceId string?

@description('Optional. If you already have a Key Vault that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Key Vault for you.')
param keyVaultResourceId string?

@description('Optional. Array of users or groups who are in charge of the solution.')
param solutionAdministrators userGroupRoleAssignmentType[]?

@description('Optional. Additional options that can affect some components of the solution and how they are configured.')
param advancedOptions advancedOptionsType?

// ============== //
// Variables      //
// ============== //

var diagnosticSettingsName = 'avm-diagnostic-settings'

var vnetName = '${name}-vnet'
var vnetDefaultAddressPrefix = '192.168.224.0/19'
var subnetPrivateLinkDefaultAddressPrefix = cidrSubnet(vnetDefaultAddressPrefix, 24, 0) // 192.168.224.0/24
// DBW - 192.168.228.0/22
var subnetDbwFrontendDefaultAddressPrefix = cidrSubnet(vnetDefaultAddressPrefix, 23, 2) // 192.168.228.0/23
var subnetDbwBackendDefaultAddressPrefix = cidrSubnet(vnetDefaultAddressPrefix, 23, 3) // 192.168.230.0/23

var privateDnsZoneNameSaBlob = 'privatelink.blob.${environment().suffixes.storage}'
var privateDnsZoneNameKv = 'privatelink.vaultcore.azure.net'
var privateDnsZoneNameDbw = 'privatelink.azuredatabricks.net'
var subnetNamePrivateLink = 'private-link-subnet'
var subnetNameDbwFrontend = 'dbw-frontend-subnet'
var subnetNameDbwBackend = 'dbw-backend-subnet'
var nsgNamePrivateLink = '${name}-nsg-private-link'
var nsgRulesPrivateLink = [
  {
    name: 'PrivateLinkDenyAllOutbound'
    properties: {
      description: 'Private Link subnet should not initiate any Outbound Connections'
      access: 'Deny'
      direction: 'Outbound'
      priority: 100
      protocol: '*'
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '*'
    }
  }
]
var nsgNameDbwFrontend = '${name}-nsg-dbw-frontend'
var nsgNameDbwBackend = '${name}-nsg-dbw-backend'
var nsgRulesDbw = [
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
    properties: {
      description: 'Required for worker nodes communication within a cluster'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-webapp'
    properties: {
      description: 'Required for workers communication with Databricks Webapp'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'AzureDatabricks'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
    properties: {
      description: 'Required for workers communication with Azure SQL services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3306'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Sql'
      access: 'Allow'
      priority: 101
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
    properties: {
      description: 'Required for workers communication with Azure Storage services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Storage'
      access: 'Allow'
      priority: 102
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
    properties: {
      description: 'Required for worker nodes communication within a cluster.'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 103
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
    properties: {
      description: 'Required for worker communication with Azure Eventhub services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '9093'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'EventHub'
      access: 'Allow'
      priority: 104
      direction: 'Outbound'
    }
  }
  {
    name: 'deny-hop-outbound'
    properties: {
      description: 'Subnet should not initiate any management Outbound Connections'
      priority: 200
      access: 'Deny'
      protocol: 'Tcp'
      direction: 'Outbound'
      sourceAddressPrefix: 'VirtualNetwork'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRanges: [
        '3389'
        '22'
      ]
    }
  }
]

var logName = '${name}-log'
var logDefaultDailyQuotaGb = -1
var logDefaultDataRetention = 365

var kvName = '${name}-kv'
var kvDefaultCreateMode = 'default'
var kvDefaultEnableSoftDelete = true
var kvDefaultSoftDeleteRetentionInDays = 90
var kvDefaultEnablePurgeProtection = true
var kvDefaultSku = 'premium'

var dbwName = '${name}-dbw'
var dbwAccessConnectorName = '${name}-dbw-acc'

var createNewVNET = empty(virtualNetworkResourceId)
var createNewLog = empty(logAnalyticsWorkspaceResourceId)
var createNewKV = empty(keyVaultResourceId)

var ownerRoleAssignments = [
  for (item, i) in empty(solutionAdministrators) ? [] : solutionAdministrators!: {
    roleDefinitionIdOrName: 'Owner'
    principalId: item.principalId
    principalType: item.principalType
    description: 'Full access to manage this resource, including the ability to assign roles in Azure RBAC.'
  }
]

var vnetCfg = ({
  resourceId: createNewVNET ? vnet.outputs.resourceId : vnetExisting.id
  name: createNewVNET ? vnet.outputs.name : vnetExisting.name
  location: createNewVNET ? vnet.outputs.location : vnetExisting.location
  resourceGroupName: createNewVNET ? vnet.outputs.resourceGroupName : split(vnetExisting.id, '/')[4]

  subnetResourceIdPrivateLink: createNewVNET
    ? vnet.outputs.subnetResourceIds[0] // private link subnet should be always available at zero index
    : vnetExisting::subnetPrivateLink.id
  subnetNameDbwFrontend: createNewVNET ? subnetNameDbwFrontend : vnetExisting::subnetDbwFrontend.name
  subnetNameDbwBackend: createNewVNET ? subnetNameDbwBackend : vnetExisting::subnetDbwBackend.name
})

var logCfg = ({
  resourceId: createNewLog ? log.outputs.resourceId : logExisting.id
  name: createNewLog ? log.outputs.name : logExisting.name
  location: createNewLog ? log.outputs.location : logExisting.location
  resourceGroupName: createNewLog ? log.outputs.resourceGroupName : split(logExisting.id, '/')[4]
})

var kvCfg = ({
  resourceId: createNewKV ? kv.outputs.resourceId : kvExisting.id
  name: createNewKV ? kv.outputs.name : kvExisting.name
  location: createNewKV ? kv.outputs.location : kvExisting.location
  resourceGroupName: createNewKV ? kv.outputs.resourceGroupName : split(kvExisting.id, '/')[4]
})

var kvIpRules = [
  for (item, i) in empty(advancedOptions.?networkAcls.?ipRules) ? [] : advancedOptions!.networkAcls!.ipRules!: {
    value: item
  }
]

var kvRoleAssignments = [
  for (item, i) in empty(solutionAdministrators) ? [] : solutionAdministrators!: {
    roleDefinitionIdOrName: 'Key Vault Administrator'
    principalId: item.principalId
    principalType: item.principalType
    description: 'Perform all data plane operations on a key vault and all objects in it, including certificates, keys, and secrets.'
  }
]

var kvMultipleRoleAssignments = concat(ownerRoleAssignments, kvRoleAssignments)

var dbwIpRules = [
  for (item, i) in empty(advancedOptions.?networkAcls.?ipRules) ? [] : advancedOptions!.networkAcls!.ipRules!: {
    value: item
  }
]

var privateLinkSubnet = [
  {
    name: subnetNamePrivateLink
    addressPrefix: subnetPrivateLinkDefaultAddressPrefix
    networkSecurityGroupResourceId: nsgPrivateLink.outputs.resourceId
  }
]

var subnets = concat(
  privateLinkSubnet,
  // Subnets for service typically in the /22 chunk
  enableDatabricks
    ? [
        {
          // a host subnet (sometimes called the public subnet)
          name: subnetNameDbwFrontend
          addressPrefix: subnetDbwFrontendDefaultAddressPrefix
          networkSecurityGroupResourceId: nsgDbwFrontend.outputs.resourceId
          delegation: 'Microsoft.Databricks/workspaces'
        }
        {
          // a container subnet (sometimes called the private subnet)
          name: subnetNameDbwBackend
          addressPrefix: subnetDbwBackendDefaultAddressPrefix
          networkSecurityGroupResourceId: nsgDbwBackend.outputs.resourceId
          delegation: 'Microsoft.Databricks/workspaces'
        }
      ]
    : []
)

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
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
  name: createNewVNET ? 'dummyName' : last(split(virtualNetworkResourceId!, '/'))
  scope: resourceGroup(
    createNewVNET ? subscription().id : (split(virtualNetworkResourceId!, '/')[2]),
    createNewVNET ? resourceGroup().id : (split(virtualNetworkResourceId!, '/')[4])
  )

  resource subnetPrivateLink 'subnets@2023-11-01' existing = if (!empty(advancedOptions.?virtualNetwork.?subnetNamePrivateLink)) {
    name: advancedOptions.?virtualNetwork.?subnetNamePrivateLink ?? 'dummyName'
  }

  resource subnetDbwFrontend 'subnets@2023-11-01' existing = if (enableDatabricks && !empty(advancedOptions.?databricks.?subnetNameFrontend)) {
    name: advancedOptions.?databricks.?subnetNameFrontend ?? 'dummyName'
  }

  resource subnetDbwBackend 'subnets@2023-11-01' existing = if (enableDatabricks && !empty(advancedOptions.?databricks.?subnetNameBackend)) {
    name: advancedOptions.?databricks.?subnetNameBackend ?? 'dummyName'
  }
}

resource logExisting 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = if (!createNewLog) {
  name: createNewLog ? 'dummyName' : last(split(logAnalyticsWorkspaceResourceId!, '/'))
  scope: resourceGroup(
    createNewLog ? subscription().id : (split(logAnalyticsWorkspaceResourceId!, '/')[2]),
    createNewLog ? resourceGroup().id : (split(logAnalyticsWorkspaceResourceId!, '/')[4])
  )
}

resource kvExisting 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!createNewKV) {
  name: createNewKV ? 'dummyName' : last(split(keyVaultResourceId!, '/'))
  scope: resourceGroup(
    createNewKV ? subscription().id : (split(keyVaultResourceId!, '/')[2]),
    createNewKV ? resourceGroup().id : (split(keyVaultResourceId!, '/')[4])
  )
}

module vnet 'br/public:avm/res/network/virtual-network:0.5.0' = if (createNewVNET) {
  name: '${uniqueString(deployment().name, location)}-vnet-${vnetName}'
  params: {
    // Required parameters
    addressPrefixes: [
      vnetDefaultAddressPrefix
    ]
    name: vnetName
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
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    lock: lock
    subnets: subnets
    tags: tags
  }
}

module nsgPrivateLink 'br/public:avm/res/network/network-security-group:0.5.0' = if (createNewVNET) {
  name: '${uniqueString(deployment().name, location)}-nsg-${nsgNamePrivateLink}'
  params: {
    // Required parameters
    name: nsgNamePrivateLink
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
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    lock: lock
    tags: tags
    securityRules: nsgRulesPrivateLink
  }
}

module nsgDbwFrontend 'br/public:avm/res/network/network-security-group:0.5.0' = if (createNewVNET && enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-nsg-${nsgNameDbwFrontend}'
  params: {
    // Required parameters
    name: nsgNameDbwFrontend
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
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    lock: lock
    tags: tags
    securityRules: nsgRulesDbw
  }
}

module nsgDbwBackend 'br/public:avm/res/network/network-security-group:0.5.0' = if (createNewVNET && enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-nsg-${nsgNameDbwBackend}'
  params: {
    // Required parameters
    name: nsgNameDbwBackend
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
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    lock: lock
    tags: tags
    securityRules: nsgRulesDbw
  }
}

module dnsZoneSaBlob 'br/public:avm/res/network/private-dns-zone:0.5.0' = if (createNewVNET && enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-zone-${privateDnsZoneNameSaBlob}'
  params: {
    // Required parameters
    name: privateDnsZoneNameSaBlob
    // Non-required parameters
    enableTelemetry: enableTelemetry
    location: 'global'
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
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

module log 'br/public:avm/res/operational-insights/workspace:0.7.1' = if (createNewLog) {
  name: '${uniqueString(deployment().name, location)}-law-${logName}'
  params: {
    // Required parameters
    name: logName
    // Non-required parameters
    dailyQuotaGb: advancedOptions.?logAnalyticsWorkspace.?dailyQuotaGb ?? logDefaultDailyQuotaGb
    dataRetention: advancedOptions.?logAnalyticsWorkspace.?dataRetention ?? logDefaultDataRetention
    diagnosticSettings: []
    enableTelemetry: enableTelemetry
    location: location
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    lock: lock
    skuName: 'PerGB2018'
    tags: tags
  }
}

module kv 'br/public:avm/res/key-vault/vault:0.9.0' = if (createNewKV) {
  name: '${uniqueString(deployment().name, location)}-vault-${kvName}'
  params: {
    // Required parameters
    name: kvName
    // Non-required parameters
    createMode: advancedOptions.?keyVault.?createMode ?? kvDefaultCreateMode
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
    enablePurgeProtection: advancedOptions.?keyVault.?enablePurgeProtection ?? kvDefaultEnablePurgeProtection
    enableRbacAuthorization: true
    enableSoftDelete: advancedOptions.?keyVault.?enableSoftDelete ?? kvDefaultEnableSoftDelete
    enableTelemetry: enableTelemetry
    enableVaultForDeployment: false
    enableVaultForTemplateDeployment: false
    enableVaultForDiskEncryption: false // When enabledForDiskEncryption is true, networkAcls.bypass must include 'AzureServices'
    location: location
    lock: lock
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: kvIpRules
    }
    privateEndpoints: [
      // Private endpoint for Key Vault only for new VNET
      {
        name: '${name}-kv-pep'
        location: location
        subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
        privateDnsZoneGroup: createNewVNET
          ? {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: dnsZoneKv.outputs.resourceId
                }
              ]
            }
          : null
        tags: tags
        enableTelemetry: enableTelemetry
        lock: lock
        roleAssignments: empty(ownerRoleAssignments) ? [] : ownerRoleAssignments
      }
    ]
    publicNetworkAccess: empty(kvIpRules) ? 'Disabled' : 'Enabled'
    roleAssignments: empty(kvMultipleRoleAssignments) ? [] : kvMultipleRoleAssignments
    sku: advancedOptions.?keyVault.?sku == 'standard' ? 'standard' : kvDefaultSku
    softDeleteRetentionInDays: advancedOptions.?keyVault.?softDeleteRetentionInDays ?? kvDefaultSoftDeleteRetentionInDays
    tags: tags
  }
}

module dnsZoneKv 'br/public:avm/res/network/private-dns-zone:0.6.0' = if (createNewVNET && createNewKV) {
  name: '${uniqueString(deployment().name, location)}-zone-${privateDnsZoneNameKv}'
  params: {
    // Required parameters
    name: privateDnsZoneNameKv
    // Non-required parameters
    enableTelemetry: enableTelemetry
    location: 'global'
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
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

module accessConnector 'br/public:avm/res/databricks/access-connector:0.3.0' = if (enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-connector-${dbwAccessConnectorName}'
  params: {
    // Required parameters
    name: dbwAccessConnectorName
    // Non-required parameters
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    managedIdentities: {
      systemAssigned: true
    }
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    tags: tags
  }
}

module dbw 'br/public:avm/res/databricks/workspace:0.8.5' = if (enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-workspace-${dbwName}'
  params: {
    // Required parameters
    name: dbwName
    // Conditional parameters
    accessConnectorResourceId: accessConnector.outputs.resourceId
    // Non-required parameters
    customPublicSubnetName: createNewVNET ? subnetNameDbwFrontend : advancedOptions.?databricks.?subnetNameFrontend
    customPrivateSubnetName: createNewVNET ? subnetNameDbwBackend : advancedOptions.?databricks.?subnetNameBackend
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
    // With secure cluster connectivity enabled, customer virtual networks have no open ports and Databricks Runtime cluster nodes have no public IP addresses.
    disablePublicIp: true // true means Secure Cluster Connectivity is enabled
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    managedResourceGroupResourceId: null // Maybe in the future we can support custom RG
    prepareEncryption: true
    privateEndpoints: [
      {
        name: '${name}-dbw-ui-pep'
        location: location
        service: 'databricks_ui_api'
        subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
        privateDnsZoneGroup: createNewVNET
          ? {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: dnsZoneDbw.outputs.resourceId
                }
              ]
            }
          : null
        tags: tags
        enableTelemetry: enableTelemetry
        lock: lock
        roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
      }
      {
        name: '${name}-dbw-auth-pep'
        location: location
        service: 'browser_authentication'
        subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
        privateDnsZoneGroup: createNewVNET
          ? {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: dnsZoneDbw.outputs.resourceId
                }
              ]
            }
          : null
        tags: tags
        enableTelemetry: enableTelemetry
        lock: lock
        roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
      }
    ]
    privateStorageAccount: 'Enabled'
    // Allow Public Network Access
    // Enabled means You can connect to your Databricks workspace either publicly, via the public IP addresses, or privately, using a private endpoint.
    publicNetworkAccess: empty(dbwIpRules) ? 'Disabled' : 'Enabled'
    // Select No Azure Databricks Rules if you are using back-end Private Link,
    // which means that your workspace data plane does not need network security group rules
    // to connect to the Azure Databricks control plane. Otherwise, select All Rules.
    requiredNsgRules: empty(dbwIpRules) ? 'NoAzureDatabricksRules' : 'AllRules' // In some environments with 'NoAzureDatabricksRules' cluster cannot be created
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
    skuName: 'premium' // We need premium to use VNET injection, Private Connectivity (Requires Premium Plan)
    storageAccountName: null // TODO add existing one (maybe with PEP) - https://learn.microsoft.com/en-us/azure/databricks/security/network/storage/firewall-support
    storageAccountPrivateEndpoints: [
      {
        name: '${name}-sa-blob-pep'
        location: location
        service: 'blob'
        subnetResourceId: vnetCfg.subnetResourceIdPrivateLink
        privateDnsZoneGroup: createNewVNET
          ? {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: dnsZoneSaBlob.outputs.resourceId
                }
              ]
            }
          : null
        tags: tags
        enableTelemetry: enableTelemetry
        lock: lock
        roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
      }
    ]
    tags: tags
  }
}

module dnsZoneDbw 'br/public:avm/res/network/private-dns-zone:0.6.0' = if (createNewVNET && enableDatabricks) {
  name: '${uniqueString(deployment().name, location)}-zone-${privateDnsZoneNameDbw}'
  params: {
    // Required parameters
    name: privateDnsZoneNameDbw
    // Non-required parameters
    enableTelemetry: enableTelemetry
    location: 'global'
    roleAssignments: !empty(ownerRoleAssignments) ? ownerRoleAssignments : []
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
output resourceId string = vnetCfg.resourceId

@description('The name of the resource.')
output name string = vnetCfg.name

@description('The location the resource was deployed into.')
output location string = vnetCfg.location

@description('The name of the managed resource group.')
output resourceGroupName string = vnetCfg.resourceGroupName

@description('The resource ID of the Azure Virtual Network.')
output virtualNetworkResourceId string = vnetCfg.resourceId

@description('The name of the Azure Virtual Network.')
output virtualNetworkName string = vnetCfg.name

@description('The location of the Azure Virtual Network.')
output virtualNetworkLocation string = vnetCfg.location

@description('The name of the Azure Virtual Network resource group.')
output virtualNetworkResourceGroupName string = vnetCfg.resourceGroupName

@description('The resource ID of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logCfg.resourceId

@description('The name of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceName string = logCfg.name

@description('The location of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceLocation string = logCfg.location

@description('The name of the Azure Log Analytics Workspace resource group.')
output logAnalyticsWorkspaceResourceGroupName string = logCfg.resourceGroupName

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = kvCfg.resourceId

@description('The name of the Azure Key Vault.')
output keyVaultName string = kvCfg.name

@description('The location of the Azure Key Vault.')
output keyVaultLocation string = kvCfg.location

@description('The name of the Azure Key Vault resource group.')
output keyVaultResourceGroupName string = kvCfg.resourceGroupName

@description('Conditional. The resource ID of the Azure Databricks when `enableDatabricks` is `true`.')
output databricksResourceId string = enableDatabricks ? dbw.outputs.resourceId : ''

@description('Conditional. The name of the Azure Databricks when `enableDatabricks` is `true`.')
output databricksName string = enableDatabricks ? dbw.outputs.name : ''

@description('Conditional. The location of the Azure Databricks when `enableDatabricks` is `true`.')
output databricksLocation string = enableDatabricks ? dbw.outputs.location : ''

@description('Conditional. The name of the Azure Databricks resource group when `enableDatabricks` is `true`.')
output databricksResourceGroupName string = enableDatabricks ? dbw.outputs.resourceGroupName : ''

// ================ //
// Definitions      //
// ================ //

@export()
type userGroupRoleAssignmentType = {
  @description('Required. The principal ID of the principal (user/group) to assign the role to.')
  principalId: string

  @description('Required. The principal type of the assigned principal ID.')
  principalType: ('Group' | 'User')
}

@export()
type networkAclsType = {
  @description('Optional. Sets the public IP addresses or ranges that are allowed to access resources in the solution.')
  ipRules: string[]?
}

@export()
type virtualNetworkType = {
  @description('Optional. The name of the existing Private Link Subnet within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNamePrivateLink: string?
}

@export()
type logAnalyticsWorkspaceType = {
  @description('Optional. Number of days data will be retained for. The default value is: \'365\'.')
  @minValue(0)
  @maxValue(730)
  dataRetention: int?

  @description('Optional. The workspace daily quota for ingestion. The default value is: \'-1\' (not limited).')
  @minValue(-1)
  dailyQuotaGb: int?
}

@export()
type keyVaultType = {
  @description('Optional. The vault\'s create mode to indicate whether the vault need to be recovered or not. The default value is: \'default\'.')
  createMode: ('default' | 'recover')?

  @description('Optional. Specifies the SKU for the vault. The default value is: \'premium\'.')
  sku: ('standard' | 'premium')?

  @description('Optional. Switch to enable/disable Key Vault\'s soft delete feature. The default value is: \'true\'.')
  enableSoftDelete: bool?

  @description('Optional. Soft delete data retention days. It accepts >=7 and <=90. The default value is: \'90\'.')
  softDeleteRetentionInDays: int?

  @description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature. The default value is: \'true\'.')
  enablePurgeProtection: bool?
}

@export()
type databricksType = {
  // must be providied when DBW is going to be enabled and VNET is provided
  @description('Optional. The name of the existing frontend Subnet for Azure Databricks within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNameFrontend: string?

  @description('Optional. The name of the existing backend Subnet for Azure Databricks within the Virtual Network in the parameter: \'virtualNetworkResourceId\'.')
  subnetNameBackend: string?
}

@export()
type advancedOptionsType = {
  @description('Optional. You can use this parameter to integrate the solution with an existing Azure Virtual Network if the \'virtualNetworkResourceId\' parameter is not empty.')
  virtualNetwork: virtualNetworkType?

  @description('Optional. Networks Access Control Lists. This value has public IP addresses or ranges that are allowed to access resources in the solution.')
  networkAcls: networkAclsType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the \'logAnalyticsWorkspaceResourceId\' parameter is empty.')
  logAnalyticsWorkspace: logAnalyticsWorkspaceType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Key Vault if the \'keyVaultResourceId\' parameter is empty.')
  keyVault: keyVaultType?

  @description('Optional. This parameter allows you to specify additional settings for Azure Databricks if you set the \'enableDatabricks\' parameter to \'true\'.')
  databricks: databricksType?
}
