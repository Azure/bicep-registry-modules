targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.imagetemplates-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'vmiitmax'

@description('Optional. The version of the Azure Compute Gallery Image Definition to be added.')
param sigImageVersion string = utcNow('yyyy.MM.dd')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    imageManagedIdentityName: 'dep-${namePrefix}-imsi-${serviceShort}'
    deploymentScriptManagedIdentityName: 'dep-${namePrefix}-dmsi-${serviceShort}'
    sigImageDefinitionName: 'dep-${namePrefix}-imgd-${serviceShort}'
    galleryName: 'dep${namePrefix}sig${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    assetStorageAccountkName: 'dep${namePrefix}ast${serviceShort}'
    deploymentScriptStorageAccountkName: 'dep${namePrefix}dst${serviceShort}'
    storageDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
// No idempotency test as the resource is, by design, not idempotent.
module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    stagingResourceGroup: '${subscription().id}/resourcegroups/${resourceGroupName}-staging'
    customizationSteps: [
      {
        type: 'Shell'
        name: 'PowerShell installation'
        scriptUri: '${nestedDependencies.outputs.assetsStorageAccountNameBlobEndpoint}${nestedDependencies.outputs.assetsStorageAccountContainerName}/Install-LinuxPowerShell.sh'
      }
      {
        type: 'File'
        name: 'Initialize-LinuxSoftware'
        sourceUri: '${nestedDependencies.outputs.assetsStorageAccountNameBlobEndpoint}${nestedDependencies.outputs.assetsStorageAccountContainerName}/Initialize-LinuxSoftware.ps1'
        destination: 'Initialize-LinuxSoftware.ps1'
      }
      {
        type: 'Shell'
        name: 'Software installation'
        inline: [
          'pwsh \'Initialize-LinuxSoftware.ps1\''
        ]
      }
    ]
    validationProcess: {
      continueDistributeOnFailure: true
      sourceValidationOnly: false
      inVMValidations: [
        {
          type: 'Shell'
          name: 'Validate-Software'
          inline: [
            'echo "Software validation successful."'
          ]
        }
      ]
    }
    optimizeVmBoot: 'Enabled'
    imageSource: {
      type: 'PlatformImage'
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    buildTimeoutInMinutes: 60
    subnetResourceId: nestedDependencies.outputs.subnetResourceId
    osDiskSizeGB: 127
    vmSize: 'Standard_D2s_v3'
    distributions: [
      {
        type: 'ManagedImage'
        imageName: '${namePrefix}-mi-${serviceShort}-001'
      }
      {
        type: 'VHD'
        imageName: '${namePrefix}-umi-${serviceShort}-001'
      }
      {
        type: 'SharedImage'
        sharedImageGalleryImageDefinitionResourceId: nestedDependencies.outputs.sigImageDefinitionId
        sharedImageGalleryImageDefinitionTargetVersion: sigImageVersion
        replicationRegions: [
          resourceLocation
        ]
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    vmUserAssignedIdentities: [
      nestedDependencies.outputs.managedIdentityResourceId
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'bb257a92-dc06-4831-9b74-ee5442d8ce0f'
        roleDefinitionIdOrName: 'Owner'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        name: guid('Custom seed ${namePrefix}${serviceShort}')
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId(
          'Microsoft.Authorization/roleDefinitions',
          'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        )
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

@description('The generated name of the image template.')
output imageTemplateName string = testDeployment.outputs.name
