@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the AKS cluster to create.')
param clusterName string

@description('Required. The name of the AKS cluster nodes resource group to create.')
param clusterNodeResourceGroupName string

resource cluster 'Microsoft.ContainerService/managedClusters@2022-07-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    nodeResourceGroup: clusterNodeResourceGroupName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

@description('The name of the created AKS cluster.')
output clusterName string = cluster.name
