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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'temp-${clusterName}'
  location: location
}

resource aksContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id, 'Azure Kubernetes Service Contributor Role')
  scope: cluster
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
    ) // Azure Kubernetes Service Contributor Role
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource arcContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id, 'Kubernetes Cluster - Azure Arc Onboarding Role')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '34e09817-6cbe-4d01-b1a2-e0eac5743d41'
    ) // Kubernetes Cluster - Azure Arc Onboarding Role
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${clusterName}-connect-script'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.50.0'
    timeout: 'PT60M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
      {
        name: 'RESOURCE_GROUP_NAME'
        value: resourceGroup().name
      }
      {
        name: 'CLUSTER_NAME'
        value: clusterName
      }
    ]
    scriptContent: '''
      # Set subscription
      az account set --subscription "$SUBSCRIPTION_ID"

      # Get AKS credentials
      az aks get-credentials --resource-group "$RESOURCE_GROUP_NAME" --name "$CLUSTER_NAME" --overwrite-existing

      # Connect cluster to Azure Arc
      az connectedk8s connect --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP_NAME"
    '''
  }
  dependsOn: [
    cluster
    aksContributorRoleAssignment
    arcContributorRoleAssignment
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
output clusterName string = clusterName
