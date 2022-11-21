@description('Deployment Location')
param location string
param name string = 'horde-storage-k8-cluster'
param agentPoolCount int = 3
param agentPoolName string = 'k8agent'
param vmSize string = 'Standard_L16s_v2'
param assignRole bool = false

resource clusterUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'k8-user-${take(uniqueString(name), 10)}'
  location: location
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${clusterUser.id}': {}
    }
  }
  properties: {
    kubernetesVersion: '1.22.6'
    dnsPrefix: 'k8-${take(uniqueString(name), 5)}'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: agentPoolName
        count: agentPoolCount
        vmSize: vmSize
        osType: 'Linux'
        mode: 'System'
        nodeLabels: {
          type: 'horde-storage'
        }
      }
    ]
    identityProfile: {
      assignedIdentity: {
        clientId: clusterUser.properties.clientId
        resourceId: clusterUser.id
        objectId: clusterUser.properties.principalId
      }
      kubeletAssignedIdentity: {
        clientId: clusterUser.properties.clientId
        resourceId: clusterUser.id
        objectId: clusterUser.properties.principalId
      }
    }
  }
}

@description('This is the built-in Network Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource networkContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4d97b98b-1d4f-4787-a291-c67834d212e7'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = if(assignRole) {
  name: guid(resourceGroup().id, clusterUser.id, networkContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: networkContributorRoleDefinition.id
    principalId: clusterUser.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output nodeResourceGroup string = aksCluster.properties.nodeResourceGroup
output clusterUserObjectId string = clusterUser.properties.principalId
output clusterUrl string = aksCluster.properties.fqdn
