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

@description('Optional. If set, the `Contributor` role will be granted to the managed identity (passed by the `managedIdentities` parameter or create with the name specified in parameter `managedIdentityName`), which is needed to import images into the Azure Container Registry. Defaults to `true`.')
param assignRbacRole bool = true

@description('Conditional. The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`.')
param managedIdentities managedIdentitiesType?

@description('Conditional. Name of the Managed Identity resource to create. Required if `assignRbacRole` is `true` and `managedIdentities` is `null`. Defaults to `id-ContainerRegistryImport`.')
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
param subnetResourceIds string[]?

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

// needed to "convert" resourceIds to principalId
resource existingManagedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = [
  for resourceId in (managedIdentities.?userAssignedResourcesIds ?? []): if (assignRbacRole) {
    name: last(split(resourceId, '/'))
    scope: resourceGroup(split(resourceId, '/')[2], split(resourceId, '/')[4]) // get the resource group from the managed identity, as it could be in another resource group
  }
]

resource newManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (!useExistingManagedIdentity && assignRbacRole) {
  name: managedIdentityName ?? 'id-ContainerRegistryImport'
  location: location
  tags: tags
}

// assign the Contributor role to the managed identity (new or existing) to import images into the ACR
resource acrRoleAssignmentExistingManagedIdentities 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for i in range(0, length(assignRbacRole ? (managedIdentities.?userAssignedResourcesIds ?? []) : [])): if (useExistingManagedIdentity && assignRbacRole) {
    name: guid('roleAssignment-acr-${existingManagedIdentities[i].name}')
    scope: acr
    properties: {
      principalId: existingManagedIdentities[i].properties.principalId
      roleDefinitionId: subscriptionResourceId(
        'Microsoft.Authorization/roleDefinitions',
        'b24988ac-6180-42a0-ab88-20f7382dd24c'
      ) // Contributor role
      principalType: 'ServicePrincipal' // See https://docs.microsoft.com/azure/role-based-access-control/role-assignments-template#new-service-principal to understand why this property is included.
    }
  }
]
resource acrRoleAssignmentNewManagedIdentity 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!useExistingManagedIdentity && assignRbacRole) {
  name: guid('roleAssignment-acr-${newManagedIdentity.id}')
  scope: acr
  properties: {
    principalId: newManagedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor role
    principalType: 'ServicePrincipal' // See https://docs.microsoft.com/azure/role-based-access-control/role-assignments-template#new-service-principal to understand why this property is included.
  }
}

module imageImport 'br/public:avm/res/resources/deployment-script:0.2.3' = {
  name: name ?? 'ACR-Import-${last(split(replace(image,':','-'),'/'))}'
  scope: resourceGroup()
  params: {
    name: name
    location: location
    tags: tags
    managedIdentities: useExistingManagedIdentity
      ? managedIdentities
      : { userAssignedResourcesIds: [newManagedIdentity.id] }
    kind: 'AzureCLI'
    runOnce: runOnce
    azCliVersion: '2.61.0' // available tags are listed here: https://mcr.microsoft.com/v2/azure-cli/tags/list
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
    subnetResourceIds: subnetResourceIds
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
        az acr import -n $acrName --source $imageName --force
      else
        az acr import -n $acrName --source $imageName
      fi

      sleep $retrySleep
      retryLoopCount=$((retryLoopCount+1))
    done

    echo "done\n"'''
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The script output of each image import.')
output deploymentScriptOutput string[] = imageImport.outputs.deploymentScriptLogs

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
}
