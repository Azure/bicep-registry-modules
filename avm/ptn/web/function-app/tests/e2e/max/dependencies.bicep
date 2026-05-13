@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Log Analytics workspace to create.')
param logAnalyticsWorkspaceName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'functionAppIntegrationSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          delegations: [
            {
              name: 'Microsoft.Web.serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      {
        name: 'privateEndpointSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
        }
      }
    ]
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

@description('The resource ID of the subnet for Function App regional VNet integration.')
output functionAppSubnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the subnet for Private Endpoints.')
output privateEndpointSubnetResourceId string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the Log Analytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id
