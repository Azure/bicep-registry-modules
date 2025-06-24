@description('Optional. The location to deploy to.')
param location string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

var subnetName01 = 'private-link-subnet'
var subnetName02 = 'dbw-frontend-subnet'
var subnetName03 = 'dbw-backend-subnet'

var vnetAddressPrefix = '10.0.0.0/20'

var nsgNamePrivateLink = 'nsg-private-link'
var nsgNameDbwFrontend = 'nsg-dbw-frontend'
var nsgNameDbwBackend = 'nsg-dbw-backend'
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
var subnets = [
  {
    name: subnetName01
    addressPrefix: cidrSubnet(vnetAddressPrefix, 24, 0)
    networkSecurityGroupResourceId: nsgPrivateLink.outputs.resourceId
  }
  {
    name: subnetName02
    addressPrefix: cidrSubnet(vnetAddressPrefix, 24, 1)
    networkSecurityGroupResourceId: nsgDbwFrontend.outputs.resourceId
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
    name: subnetName03
    addressPrefix: cidrSubnet(vnetAddressPrefix, 24, 2)
    networkSecurityGroupResourceId: nsgDbwBackend.outputs.resourceId
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

module vnet 'br/public:avm/res/network/virtual-network:0.2.0' = {
  name: virtualNetworkName
  params: {
    // Required parameters
    addressPrefixes: [
      vnetAddressPrefix
    ]
    name: virtualNetworkName
    // Non-required parameters
    dnsServers: []
    location: location
    subnets: subnets
  }
}

module nsgPrivateLink 'br/public:avm/res/network/network-security-group:0.4.0' = {
  name: nsgNamePrivateLink
  params: {
    // Required parameters
    name: nsgNamePrivateLink
    // Non-required parameters
    location: location
    securityRules: nsgRulesPrivateLink
  }
}

module nsgDbwFrontend 'br/public:avm/res/network/network-security-group:0.4.0' = {
  name: nsgNameDbwFrontend
  params: {
    // Required parameters
    name: nsgNameDbwFrontend
    // Non-required parameters
    location: location
    securityRules: nsgRulesDbw
  }
}

module nsgDbwBackend 'br/public:avm/res/network/network-security-group:0.4.0' = {
  name: nsgNameDbwBackend
  params: {
    // Required parameters
    name: nsgNameDbwBackend
    // Non-required parameters
    location: location
    securityRules: nsgRulesDbw
  }
}

module log 'br/public:avm/res/operational-insights/workspace:0.5.0' = {
  name: logAnalyticsWorkspaceName
  params: {
    // Required parameters
    name: logAnalyticsWorkspaceName
    // Non-required parameters
    location: location
  }
}

module kv 'br/public:avm/res/key-vault/vault:0.7.0' = {
  name: keyVaultName
  params: {
    // Required parameters
    name: keyVaultName
    // Non-required parameters
    location: location
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = vnet.outputs.resourceId

@description('The resource IDs of the deployed subnets.')
output subnetResourceIds array = vnet.outputs.subnetResourceIds

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = log.outputs.resourceId

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = kv.outputs.resourceId
