@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Log Analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the User-Assigned Managed Identity to create (used to exercise the BYO-UAMI code path).')
param managedIdentityName string

var addressPrefix = '10.0.0.0/16'

// Private DNS Zones for the Function App (sites) and the Storage Account services exercised
// by the module's WAF-aligned baseline. These are created so that the `privateDnsZoneResourceIds`
// parameter can be exercised end-to-end. They are intentionally NOT linked to the test VNet —
// link establishment is not required for the Private Endpoint / DNS Zone Group association to succeed.
var privateDnsZoneNames = [
  'privatelink.azurewebsites.net'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.table.${environment().suffixes.storage}'
]

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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2024-06-01' = [
  for zoneName in privateDnsZoneNames: {
    name: zoneName
    location: 'global'
  }
]

@description('The resource ID of the subnet for Function App regional VNet integration.')
output functionAppSubnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the subnet for Private Endpoints.')
output privateEndpointSubnetResourceId string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the Log Analytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the User-Assigned Managed Identity (used to exercise the BYO-UAMI parameter).')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the Private DNS Zone for the Function App (`privatelink.azurewebsites.net`).')
output sitesPrivateDnsZoneResourceId string = privateDnsZones[0].id

@description('The resource ID of the Private DNS Zone for the Storage blob endpoint.')
output blobPrivateDnsZoneResourceId string = privateDnsZones[1].id

@description('The resource ID of the Private DNS Zone for the Storage file endpoint.')
output filePrivateDnsZoneResourceId string = privateDnsZones[2].id

@description('The resource ID of the Private DNS Zone for the Storage queue endpoint.')
output queuePrivateDnsZoneResourceId string = privateDnsZones[3].id

@description('The resource ID of the Private DNS Zone for the Storage table endpoint.')
output tablePrivateDnsZoneResourceId string = privateDnsZones[4].id
