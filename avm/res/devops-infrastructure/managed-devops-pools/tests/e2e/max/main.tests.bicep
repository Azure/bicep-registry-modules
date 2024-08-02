targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-di.mdp-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mdpmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ========= //
// Variables //
// ========= //
var azureDevOpsOrganizationName = 'contoso'
var azureDevOpsProjectName = 'ContosoProject'

// ============ //
// Dependencies //
// ============ //
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    devCenterName: 'dep-${namePrefix}-dc-${serviceShort}'
    devCenterProjectName: 'dep-${namePrefix}-dcp-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      agentProfile: {
        kind: 'Stateless'
        resourcePredictions: {
          timeZone: 'Central Europe Standard Time'
          daysData: [
            {
              '09:00:00': 1
              '17:00:00': 0
            }
            {}
            {}
            {}
            {}
            {}
            {}
          ]
        }
        resourcePredictionsProfile: {
          kind: 'Automatic'
          predictionPreference: 'Balanced'
        }
      }
      concurrency: 1
      devCenterProjectResourceId: nestedDependencies.outputs.devCenterProjectResourceId
      images: [
        {
          aliases: [
            'windows-2022'
          ]
          buffer: '*'
          wellKnownImageName: 'windows-2022/latest'
        }
      ]
      fabricProfileSkuName: 'Standard_DS2_v2'
      organizationProfile: {
        kind: 'AzureDevOps'
        organizations: [
          {
            url: 'https://dev.azure.com/${azureDevOpsOrganizationName}'
            parallelism: 1
            projects: [
              azureDevOpsProjectName
            ]
          }
        ]
        permissionProfile: {
          kind: 'CreatorOnly'
        }
      }
      dataDisks: [
        {
          caching: 'ReadWrite'
          diskSizeGiB: 100
          driveLetter: 'B'
          storageAccountType: 'Standard_LRS'
        }
      ]
      logonType: 'Interactive'
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
      osDiskStorageAccount: 'Standard'
      secretsManagementSettings: {
        keyExportable: true
        observedCertificates: [
          ''
        ]
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
