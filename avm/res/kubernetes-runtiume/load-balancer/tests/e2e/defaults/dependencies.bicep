@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the AKS cluster to create.')
param clusterName string

module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.10.1' = {
  name: '${uniqueString(deployment().name, location)}-managedCluster'
  scope: resourceGroup()
  params: {
    name: clusterName
    kubernetesVersion: '1.32.6'
    publicNetworkAccess: 'Enabled'
    azurePolicyEnabled: false
    disableLocalAccounts: false
    managedIdentities: {
      systemAssigned: true
    }
    aadProfile: null
    primaryAgentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        availabilityZones: [
          1
        ]
      }
    ]
  }
}

@description('The resource ID of the created managed cluster.')
output resourceId string = managedCluster.outputs.resourceId

@description('The name of the created managed cluster.')
output clusterName string = managedCluster.outputs.name
