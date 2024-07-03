metadata name = 'import-image-to-acr'
metadata description = 'This modules deployes an image to an Azure Container Registry.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the deployment script resource.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The name of the Azure Container Registry.')
param acrName string

@description('Optional. How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time.')
param runOnce bool = false

@description('Optional. The RoleDefinitionId required for the DeploymentScript resource to import images. If not set, an existing managed identity should have the appropriate role assigned. Defaults to Contributor.')
param rbacRole string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor is needed to import ACR

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType?

@description('Conditional. Name of the Managed Identity resource to create. Required if `managedIdentities` is `null`. Defaults to `id-ContainerRegistryImport`.')
param managedIdentityName string?

@description('Required. A fully qualified image name to import.')
@metadata({
  example: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
})
param image string

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
@description('Optional. When the script resource is cleaned up. Default is OnExpiration and the cleanup time is after 1h.')
param cleanupPreference string = 'OnExpiration'

@description('Optional. The resource id of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script.')
param storageAccountResourceId string = ''

@description('Optional. The subnet ids to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script.')
param subnetIds string[]?

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

// ============== //
// Variables      //
// ============== //

var useExistingManagedIdentity = length(managedIdentities.?userAssignedResourcesIds ?? []) > 0

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
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

// needed to "convert" resourceids to objectids
resource existingManagedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = [
  for resourceId in (managedIdentities.?userAssignedResourcesIds ?? []): {
    name: last(split(resourceId, '/'))
  }
]

resource newManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (!useExistingManagedIdentity) {
  name: managedIdentityName ?? 'id-ContainerRegistryImport'
  location: location
  tags: tags
}

// rbac assignment for existing managed identities
resource deploymentScript_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (resourceId, i) in (useExistingManagedIdentity && !empty(rbacRole)
    ? (managedIdentities.?userAssignedResourcesIds ?? [])
    : []): {
    name: guid(resourceId, rbacRole)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', rbacRole)
      principalId: existingManagedIdentities[i].properties.principalId
    }
    scope: resourceGroup()
  }
]

module imageImport 'br/public:avm/res/resources/deployment-script:0.2.1' = {
  name: name ?? 'ACR-Import-${last(split(replace(image,':','-'),'/'))}'
  scope: resourceGroup()
  params: {
    // assign new managed identities rbac roles here, as we have the objectid
    roleAssignments: !useExistingManagedIdentity && !empty(rbacRole)
      ? [
          {
            principalId: newManagedIdentity.id
            roleDefinitionIdOrName: rbacRole
          }
        ]
      : []
    name: name
    location: location
    tags: tags
    managedIdentities: managedIdentities
    kind: 'AzureCLI'
    runOnce: runOnce
    azCliVersion: '2.59.0'
    timeout: 'PT30M' // set timeout to 30m
    retentionInterval: 'PT1H' // cleanup after 1h
    environmentVariables: {
      secureList: [
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
    }
    cleanupPreference: cleanupPreference
    storageAccountResourceId: storageAccountResourceId
    containerGroupName: '${resourceGroup().name}-infrastructure'
    subnetResourceIds: subnetIds
    scriptContent: '''#!/bin/bash
set -e

echo "Waiting on RBAC replication ($initialDelay)\n"
sleep $initialDelay

# retry loop to catch errors (usually RBAC delays, but 'Error copying blobs' is also not unheard of)
retryLoopCount=0
until [ $retryLoopCount -ge $retryMax ]
do
  echo "Importing Image ($retryLoopCount): $imageName into ACR: $acrName\n"
  if [ $overwriteExistingImage = 'true' ]; then
    az acr import -n $acrName --source $imageName --force && break
  else
    az acr import -n $acrName --source $imageName && break
  fi

  sleep $retrySleep
  retryLoopCount=$((retryLoopCount+1))
done

echo "done\n"'''
  }
}

resource imageImportScript 'Microsoft.Resources/deploymentScripts@2023-08-01' existing = {
  name: imageImport.name
  resource logs 'logs' existing = {
    name: 'default'
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The script output of each image import.')
output deploymentScriptOutput string[] = split(imageImportScript::logs.properties.log, '\n')

@description('An array of the imported images.')
output importedImage importedImageType = {
  originalImage: image
  acrHostedImage: '${acr.properties.loginServer}${string(skip(image, indexOf(image,'/')))}'
}

// ================ //
// Definitions      //
// ================ //

type importedImageType = {
  @description('Required. The original image name.')
  originalImage: string

  @description('Required. The image name in the Azure Container Registry.')
  acrHostedImage: string
}

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourcesIds: string[]
}?
