@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the AKS cluster to create.')
param clusterName string

@description('Required. The name of the AKS cluster extension to create.')
param clusterExtensionName string

module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.10.0' = {
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

module createManagedIdentityForDeploymentScript 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  scope: resourceGroup()
  name: 'mi-${clusterName}'
  params: {
    location: location
    name: 'mi-${clusterName}'
  }
}

// Role assignment for AKS Cluster Contributor access
resource roleAssignmentAKSClusterContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, createManagedIdentityForDeploymentScript.name, 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8')
  scope: resourceGroup()
  properties: {
    principalId: createManagedIdentityForDeploymentScript.outputs.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
    ) // Azure Kubernetes Service Contributor Role
    principalType: 'ServicePrincipal'
  }
}

// Role assignment for Arc Onboarding
resource roleAssignmentArcOnboarding 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, createManagedIdentityForDeploymentScript.name, '34e09817-6cbe-4d01-b1a2-e0eac5743d41')
  scope: resourceGroup()
  properties: {
    principalId: createManagedIdentityForDeploymentScript.outputs.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '34e09817-6cbe-4d01-b1a2-e0eac5743d41'
    ) // Kubernetes Cluster - Azure Arc Onboarding Role
    principalType: 'ServicePrincipal'
  }
}

// Role assignment for Resource Group Contributor access
resource roleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, createManagedIdentityForDeploymentScript.name, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  scope: resourceGroup()
  properties: {
    principalId: createManagedIdentityForDeploymentScript.outputs.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor Role
    principalType: 'ServicePrincipal'
  }
}

module deploymentScript 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: '${clusterName}-connect-aks-script'
  params: {
    name: '${clusterName}-connect-aks-script'
    kind: 'AzureCLI'
    azCliVersion: '2.50.0'
    cleanupPreference: 'Always'
    location: location
    retentionInterval: 'P1D'
    timeout: 'PT1H'
    runOnce: true
    managedIdentities: {
      userAssignedResourceIds: [
        createManagedIdentityForDeploymentScript.outputs.resourceId
      ]
    }
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
    managedCluster
    roleAssignmentAKSClusterContributor
    roleAssignmentArcOnboarding
    roleAssignmentContributor
  ]
}

resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
  name: clusterName
  scope: resourceGroup()
  dependsOn: [
    deploymentScript
  ]
}

resource extension 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = {
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
