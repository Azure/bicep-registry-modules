@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the AKS cluster to create.')
param clusterName string

@description('Required. The name of the AKS cluster extension to create.')
param clusterExtensionName string

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
        availabilityZones: [
          '1'
        ]
      }
    ]
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${clusterName}-connect-script'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azCliVersion: '2.50.0'
    timeout: 'PT60M'
    retentionInterval: 'P1D'
    scriptContent: '''
      # Set subscription
      az account set --subscription ${subscriptionId}

      # Get AKS credentials
      az aks get-credentials --resource-group ${resourceGroupName} --name ${clusterName} --overwrite-existing

      # Connect cluster to Azure Arc
      az connectedk8s connect --name ${clusterName} --resource-group ${resourceGroupName}
    '''
    arguments: '-subscriptionId "${subscription().id}" -resourceGroupName "${resourceGroup().name}" -clusterName "${clusterName}"'
  }
  dependsOn: [
    cluster
  ]
}

resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
  name: clusterName
  scope: resourceGroup()
  dependsOn: [
    deploymentScript
  ]
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
