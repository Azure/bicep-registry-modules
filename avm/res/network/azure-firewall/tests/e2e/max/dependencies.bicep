@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Public IP to create.')
param publicIPName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Maintenance Configuration to create.')
param maintenanceConfigurationName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
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
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 26, 0)
        }
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  name: maintenanceConfigurationName
  location: location
  properties: {
    maintenanceScope: 'Resource'
    extensionProperties: {
      maintenanceSubScope: 'NetworkSecurity'
    }
    maintenanceWindow: {
      startDateTime: '2025-03-01 00:00'
      expirationDateTime: null
      duration: '05:00'
      timeZone: 'Pacific Standard Time'
      recurEvery: 'Day'
    }
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Maintenance Configuration.')
output maintenanceConfigurationResourceId string = maintenanceConfiguration.id
