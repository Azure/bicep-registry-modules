metadata name = 'import-image-to-acr'
metadata description = 'This modules deployes an image to an Azure Container Registry.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the deployment script resource.')
param name string

@description('Required. The name of the Azure Container Registry.')
param acrName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time.')
param forceUpdateTag string = utcNow()

@description('Optional. Azure RoleId that are required for the DeploymentScript resource to import images. Default is Contributor, which is needed to import into an ACR.')
param rbacRoleNeeded string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor is needed to import ACR

@description('Optional. Does the Managed Identity already exists, or should be created. Default is true.')
param useExistingManagedIdentity bool = true

@description('Conditional. Name of the Managed Identity resource to create. Required if `useExistingManagedIdentity` is `true`. Defaults to `id-ContainerRegistryImport`.')
param managedIdentityName string = 'id-ContainerRegistryImport'

@description('Conditional. For an existing Managed Identity, the Subscription Id it is located in. Default is the current subscription. Required if `useExistingManagedIdentity` is `true`. Defaults to the curent subscription.')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('Conditional. For an existing Managed Identity, the Resource Group it is located in. Default is the current resource group. Required if `useExistingManagedIdentity` is `true`. Defaults to the current resource group.')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('Required. An array of fully qualified images names to import.')
@metadata({
  example: [
    'mcr.microsoft.com/azuredocs/aks-helloworld:latest'
    'mcr.microsoft.com/azuredocs/aks-helloworld:v2'
  ]
})
param images string[]

@description('Optional. The image will be overwritten if it already exists in the ACR with the same tag. Default is false.')
param overwriteExistingImage bool = false

@description('Optional. A delay in seconds before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate. Default is 30s.')
param initialScriptDelay int = 30

@description('Optional. The maximum number of retries for the script import operation. Default is 3.')
param retryMax int = 3

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('Optional. When the script resource is cleaned up. Default is OnExpiration.')
param cleanupPreference string = 'OnExpiration'

@description('Optional. The name of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script.')
param storageAccountName string = ''

@description('Optional. The subnet id to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script.')
param subnetId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.deploymentscript-importimagetoacr.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

//
// Add your resources here
//

resource newManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (useExistingManagedIdentity) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (!empty(rbacRoleNeeded)) {
  name: guid(acr.id, rbacRoleNeeded, useExistingManagedIdentity ? existingManagedIdentity.id : newManagedIdentity.id)
  scope: acr
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRoleNeeded)
    principalId: useExistingManagedIdentity
      ? existingManagedIdentity.properties.principalId
      : newManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource createImportImage 'Microsoft.Resources/deploymentScripts@2023-08-01' = [
  for image in images: {
    name: 'ACR-Import-${name}-${last(split(replace(image,':',''),'/'))}'
    location: location
    identity: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        '${useExistingManagedIdentity ? existingManagedIdentity.id : newManagedIdentity.id}': {}
      }
    }
    kind: 'AzureCLI'
    dependsOn: [rbac]
    properties: {
      forceUpdateTag: forceUpdateTag
      azCliVersion: '2.52.0'
      timeout: 'PT30M'
      retentionInterval: 'PT1H' // cleanup after 1h
      storageAccountSettings: (storageAccountName != '')
        ? {
            storageAccountName: storageAccountName
          }
        : {}
      containerSettings: (subnetId != '')
        ? {
            // an existing subnet is needed, if PrivateLink is going to be used
            subnetIds: [
              {
                id: subnetId
              }
            ]
          }
        : {}
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
          name: 'overwriteExistingImage'
          value: toLower(string(overwriteExistingImage))
        }
        {
          name: 'initialDelay'
          value: '${string(initialScriptDelay)}s'
        }
        {
          name: 'retryMax'
          value: string(retryMax)
        }
        {
          name: 'retrySleep'
          value: '5s'
        }
      ]
      scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on RBAC replication ($initialDelay)"
      sleep $initialDelay

      #Retry loop to catch errors (usually RBAC delays, but 'Error copying blobs' is also not unheard of)
      retryLoopCount=0
      until [ $retryLoopCount -ge $retryMax ]
      do
        echo "Importing Image: $imageName into ACR: $acrName"
        if [ overwriteExistingImage == 'true' ]; then
          az acr import -n $acrName --source $imageName --force \
            && break
        else
          az acr import -n $acrName --source $imageName \
            && break
        fi

        sleep $retrySleep
        retryLoopCount=$((retryLoopCount+1))
      done

    '''
      cleanupPreference: cleanupPreference
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('An array of the imported images.')
output importedImages importedImageType[] = [
  for image in images: {
    originalImage: image
    acrHostedImage: '${acr.properties.loginServer}${string(skip(image, indexOf(image,'/')))}'
  }
]

// ================ //
// Definitions      //
// ================ //

type importedImageType = {
  originalImage: string
  acrHostedImage: string
}
