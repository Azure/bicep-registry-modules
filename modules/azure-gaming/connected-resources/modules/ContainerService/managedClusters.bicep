@description('Deployment Location')
param location string
param name string = 'horde-storage-k8-cluster'
param agentPoolCount int = 3
param agentPoolName string = 'k8agent'
param vmSize string = 'Standard_L16s_v2'
param nodeLabels string = 'horde-storage'
param assignRole bool = false
param dnsPrefix string = 'k8-${take(uniqueString(name), 5)}'
param kubernetesVersion string = '1.22.11'
param availabilityZones array = [
  '1'
  '2'
  '3'
]
@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

@description('Subject for Federated Credential. Ex: system:serviceaccount:ucddc-tests:workload-identity-sa')
param subject string = ''

param clusterUserName string = 'k8-${take(uniqueString(location, name), 15)}'

resource clusterUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (newOrExisting == 'new') {
  name: clusterUserName
  location: location
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-07-02-preview' = if (newOrExisting == 'new') {
  name: take(name, 80)
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${clusterUser.id}': {} }
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    oidcIssuerProfile: {
      enabled: true
    }
    dnsPrefix: dnsPrefix
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: agentPoolName
        count: agentPoolCount
        vmSize: vmSize
        osType: 'Linux'
        mode: 'System'
        nodeLabels: { type: nodeLabels }
        availabilityZones: isZoneRedundant ? availabilityZones : null
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

resource existingUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (newOrExisting == 'existing') { name: 'k8-${take(uniqueString(location, name), 15)}' }
resource existingAksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' existing = if (newOrExisting == 'existing') { name: name }

resource federatedId 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2022-01-31-preview' = if (newOrExisting == 'new' && subject != '') {
  name: 'federated-k8-${take(uniqueString(location, name), 15)}'
  parent: clusterUser
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aksCluster.properties.oidcIssuerProfile.issuerURL
    subject: subject
  }
}


@description('This is the built-in Network Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource networkContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4d97b98b-1d4f-4787-a291-c67834d212e7'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = if (assignRole) {
  name: guid(resourceGroup().id, clusterUser.id, networkContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: networkContributorRoleDefinition.id
    principalId: clusterUser.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output nodeResourceGroup string = newOrExisting == 'new' ? aksCluster.properties.nodeResourceGroup : existingAksCluster.properties.nodeResourceGroup
output clusterUserObjectId string = newOrExisting == 'new' ? clusterUser.properties.principalId : existingUser.properties.principalId
output clusterUrl string = newOrExisting == 'new' ? aksCluster.properties.fqdn : existingAksCluster.properties.fqdn
