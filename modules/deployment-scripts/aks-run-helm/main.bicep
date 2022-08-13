@description('The name of the Azure Kubernetes Service')
param aksName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('An array of Azure RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor
  '7f6c6a51-bcf8-42ba-9220-52d62157d7db' //Azure Kubernetes Service RBAC Reader
]

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-AksRunCommandProxy'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('Public Helm Repo Name')
param helmRepo string = 'azure-marketplace'

@description('Public Helm Repo URL')
param helmRepoURL string = 'https://marketplace.azurecr.io/helm/v1/repo'

@description('Helm Apps {helmApp: \'azure-marketplace/wordpress\', helmAppName: \'my-wordpress\'}')
param helmApps array  = []

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

resource aks 'Microsoft.ContainerService/managedClusters@2022-01-02-preview' existing = {
  name: aksName
}

resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for roleDefId in rbacRolesNeeded: {
  name: guid(aks.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: aks
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

@batchSize(1)
resource runAksCommand 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for (app, i) in helmApps: {
  name: 'AKS-Run-${aks.name}-${deployment().name}-${i}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbac
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: '2.35.0'
    timeout: 'PT10M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'RESOURCEGROUP'
        secureValue: resourceGroup().name
      }
      {
        name: 'CLUSTER_NAME'
        secureValue: aksName
      }
      {
        name: 'HELM_REPO'
        secureValue: helmRepo
      }
      {
        name: 'HELM_REPO_URL'
        secureValue: helmRepoURL
      }
      {
        name: 'HELM_APP'
        secureValue: app.helmApp
      }
      {
        name: 'HELM_APP_NAME'
        secureValue: app.helmAppName
      }
      {
        name: 'HELM_PARAMS'
        value: '--set global.imagePullSecrets={emptysecret}'
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      if [ "$loopIndex" == "0" ] && [ "$initialDelay" != "0" ]
      then
        echo "Waiting on RBAC replication ($initialDelay)"
        sleep $initialDelay

        #Force RBAC refresh
        az logout
        az login --identity
      fi
      
      # Download and install Helm
      wget -O helm.tgz https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz
      tar -zxvf helm.tgz
      mv linux-amd64/helm /usr/local/bin/helm
      # Install kubectl
      az aks install-cli
      
      # Get cluster credentials
      az aks get-credentials -g $RESOURCEGROUP -n $CLUSTER_NAME
      
      # Install Simple Helm Chart https://github.com/bitnami/azure-marketplace-charts      
      helm repo add \
          $HELM_REPO \
          $HELM_REPO_URL
      
      helm search repo \
          $HELM_REPO
      
      helm install \
          $HELM_APP_NAME \
          $HELM_APP \
          $HELM_PARAMS
      
      echo \{\"Status\":\"Complete\"\} > $AZ_SCRIPTS_OUTPUT_PATH
    '''
    cleanupPreference: cleanupPreference
  }
}]

@description('Array of command output from each Deployment Script AKS run command')
output commandOutput array = [for (app, i) in helmApps: {
  Index: i
  Name: runAksCommand[i].name
  CommandOutput: runAksCommand[i].properties.outputs
}]
