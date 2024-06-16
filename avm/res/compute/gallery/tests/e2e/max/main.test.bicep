targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.galleries-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cgmax'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      applications: [
        {
          name: '${namePrefix}-${serviceShort}-appd-001'
          supportedOSType: 'Linux'
        }
        {
          name: '${namePrefix}-${serviceShort}-appd-002'
          supportedOSType: 'Windows'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
      images: [
        {
          properties: {
            hyperVGeneration: 'V1'
            identifier: {
              publisher: 'MicrosoftWindowsServer'
              offer: 'WindowsServer'
              sku: '2022-datacenter-azure-edition'
            }
            osState: 'Windows'
          }
          name: '${namePrefix}-az-imgd-ws-001'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: '${namePrefix}-az-imgd-ws-002'
          properties: {
            hyperVGeneration: 'V2'
            identifier: {
              publisher: 'MicrosoftWindowsServer'
              offer: 'WindowsServer'
              sku: '2022-datacenter-azure-edition-hibernate'
            }
            osState: 'Windows'
            recommended: {
              memory: {
                min: 4
                max: 16
              }
              vCPUs: {
                min: 2
                max: 8
              }
            }
            osType: 'Generalized'
          }
          isHibernateSupported: true
          isAcceleratedNetworkSupported: false
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          hyperVGeneration: 'V2'
          securityType: 'TrustedLaunch'
          properties: {
            osState: 'Windows'
            osType: 'Generalized'
            identifier: {
              publisher: 'MicrosoftWindowsDesktop'
              offer: 'WindowsDesktop'
              sku: 'Win11-21H2'
            }
            recommended: {
              memory: {
                min: 4
                max: 16
              }
              vCPUs: {
                min: 2
                max: 8
              }
            }
          }
          name: '${namePrefix}-az-imgd-wdtl-001'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: '${namePrefix}-az-imgd-us-001'
          hyperVGeneration: 'V2'
          properties: {
            osState: 'Linux'
            osType: 'Generalized'
            identifier: {
              publisher: 'canonical'
              offer: '0001-com-ubuntu-server-focal'
              sku: '20_04-lts-gen2'
            }
            recommended: {
              memory: {
                min: 4
                max: 32
              }
              vCPUs: {
                min: 1
                max: 4
              }
            }
          }
          isAcceleratedNetworkSupported: false
        }
        {
          name: '${namePrefix}-az-imgd-us-001'
          hyperVGeneration: 'V2'
          properties: {
            osState: 'Linux'
            osType: 'Generalized'
            identifier: {
              publisher: 'canonical'
              offer: '0001-com-ubuntu-server-focal'
              sku: '20_04-lts-gen2'
            }
            recommended: {
              memory: {
                min: 4
                max: 32
              }
              vCPUs: {
                min: 1
                max: 4
              }
            }
          }
          isAcceleratedNetworkSupported: true
        }
        {
          name: '${namePrefix}-az-imgd-us-001'
          properties: {
            osState: 'Linux'
            osType: 'Generalized'
            identifier: {
              publisher: 'canonical'
              offer: '0001-com-ubuntu-server-focal'
              sku: '20_04-lts-gen2'
            }
            recommended: {
              memory: {
                min: 4
                max: 32
              }
              vCPUs: {
                min: 1
                max: 4
              }
            }
          }
          hyperVGeneration: 'V2'
          isAcceleratedNetworkSupported: false
        }
        // testing deprecated parameters
        {
          hyperVGeneration: 'V2'
          maxRecommendedMemory: 32
          maxRecommendedvCPUs: 4
          minRecommendedMemory: 4
          minRecommendedvCPUs: 1
          isAcceleratedNetworkSupported: true
          name: '${namePrefix}-az-imgd-us-001'
          offer: '0001-com-ubuntu-server-focal'
          osState: 'Generalized'
          osType: 'Linux'
          publisher: 'canonical'
          sku: '20_04-lts-gen2'
        }
      ]
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
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
    dependsOn: [
      nestedDependencies
    ]
  }
]
