targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dev-ops-infrastructure.pool-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mdpmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Name of the Azure DevOps organization. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDevOpsOrganizationName\'.')
@secure()
param azureDevOpsOrganizationName string = ''

@description('Required. Name of the Azure DevOps Max Project. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDevOpsProjectName\'.')
@secure()
param azureDevOpsProjectName string = ''

@description('Required. The object ID of the Entra ID-provided DevOpsInfrastructure principal. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-DevOpsInfrastructureObjectID\'.')
@secure()
param devOpsInfrastructureObjectID string = ''

// The Managed DevOps Pools resource is not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    devCenterName: 'dep-${namePrefix}-dc-${serviceShort}'
    devCenterProjectName: 'dep-${namePrefix}-dcp-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    devOpsInfrastructureObjectID: devOpsInfrastructureObjectID
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      agentProfile: {
        kind: 'Stateless'
        resourcePredictions: {
          timeZone: 'Central Europe Standard Time'
          daysData: [
            // Monday
            {
              '09:00:00': 1
              '17:00:00': 0
            }
            // Tuesday
            {}
            // Wednesday
            {}
            // Thursday
            {}
            // Friday
            {
              '09:00:00': 1
              '17:00:00': 0
            }
            // Saturday
            {}
            // Sunday
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
      fabricProfileSkuName: 'Standard_D2_v2'
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
      storageProfile: {
        osDiskStorageAccountType: 'Standard'
        dataDisks: [
          {
            caching: 'ReadWrite'
            diskSizeGiB: 100
            driveLetter: 'B'
            storageAccountType: 'Standard_LRS'
          }
        ]
      }
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
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
