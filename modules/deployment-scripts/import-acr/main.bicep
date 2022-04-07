@description('The name of the Azure Container Registry')
param acrName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('Version of the Azure CLI to use')
param azCliVersion string = '2.30.0'

@description('Deployment Script timeout')
param timeout string = 'PT30M'

@description('The retention period for the deployment script')
param retention string = 'P1D'

@description('An array of Azure RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor is needed to import ACR
]

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-ContainerRegistryImport'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('An array of fully qualified images names to import')
param images array

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '30s'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' existing = {
  name: acrName
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
  name: guid(acr.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: acr
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

resource createImportImage 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for image in images: {
  name: 'ACR-Import-${acr.name}-${replace(replace(image,':',''),'/','-')}'
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
    azCliVersion: azCliVersion
    timeout: timeout
    retentionInterval: retention
    environmentVariables: [
      {
        name: 'acrName'
        value: acrName
      }
      {
        name: 'imageName'
        value: image
      }
      {
        name: 'initialDelay'
        value: initialScriptDelay
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on RBAC replication ($initialDelay)"
      sleep $initialDelay

      echo "Importing Image: $imageName into ACR: $acrName"
      az acr import -n $acrName --source $imageName --force
    '''
    cleanupPreference: cleanupPreference
  }
}]
