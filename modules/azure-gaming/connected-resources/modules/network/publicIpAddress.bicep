@description('Deployment Location')
param location string

@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('PublicIP Resource Name')
param name string = 'pubip${uniqueString(resourceGroup().id)}'

@allowed([ 'new', 'existing' ])
@description('Create new or use existing resource selection. new/existing')
param newOrExisting string = 'new'

param publicIpSku object = {
  name: 'Standard'
  tier: 'Regional'
}
param publicIpAllocationMethod string = 'Static'
param publicIpDns string = 'dns-${uniqueString(resourceGroup().id, name)}'

resource newPublicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = if (newOrExisting == 'new') {
  name: name
  sku: publicIpSku
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
    dnsSettings: {
      domainNameLabel: toLower(publicIpDns)
    }
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = if (newOrExisting != 'new') {
  name: name
  scope: resourceGroup(resourceGroupName)
}

output name string = newOrExisting == 'new' ? newPublicIP.name : publicIP.name
output id string = newOrExisting == 'new' ? newPublicIP.id : publicIP.id
output ipAddress string = newOrExisting == 'new' ? newPublicIP.properties.ipAddress : publicIP.properties.ipAddress
