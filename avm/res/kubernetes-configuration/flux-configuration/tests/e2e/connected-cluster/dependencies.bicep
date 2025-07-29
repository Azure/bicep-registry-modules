@description('Required. The name of the AKS cluster to create.')
param clusterName string

@description('Required. The name of the AKS cluster extension to create.')
param clusterExtensionName string

// Reference to the connected cluster
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
  name: clusterName
  scope: resourceGroup()
}

resource extension 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' = {
  scope: connectedCluster
  name: clusterExtensionName
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
  }
}

@description('The name of the created AKS cluster.')
output clusterName string = connectedCluster.name
