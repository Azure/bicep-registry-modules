param aksName string =  'crtest${uniqueString(resourceGroup().name)}'
param location string = resourceGroup().location
param publicIpSku object = {
  name: 'Standard'
  tier: 'Regional'
}
param publicIpDns string = 'pubip${uniqueString(resourceGroup().id)}'

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'pubip-${uniqueString(resourceGroup().id)}'
  sku: publicIpSku
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: publicIpDns
    }
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2022-01-02-preview' = {
  location: location
  name: aksName
  properties: {
    dnsPrefix: aksName
    enableRBAC: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    agentPoolProfiles: [
      {
        name: 'np01'
        mode: 'System'
        vmSize: 'Standard_DS2_v2'
        count: 2
      }
    ]
    nodeResourceGroup: 'mc_${aksName}'
  }
  identity: {
    type: 'SystemAssigned'
  }
}
output aksName string = aks.name
output public_ip string = publicIP.properties.ipAddress
