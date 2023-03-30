param aksName string = 'crtest${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

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
