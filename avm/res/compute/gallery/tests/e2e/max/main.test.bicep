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
              name: '4ef8d3d3-54be-4522-92c3-284977292d87'
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
        }
      ]
      images: [
        {
          name: '${namePrefix}-az-imgd-ws-001'
          hyperVGeneration: 'V1'
          identifier: {
            publisher: 'MicrosoftWindowsServer'
            offer: 'WindowsServer'
            sku: '2022-datacenter-azure-edition'
          }
          osType: 'Windows'
          osState: 'Generalized'
          eula: 'test Eula'
          architecture: 'x64'
          description: 'testDescription'
          privacyStatementUri: 'https://testPrivacyStatementUri.com'
          excludedDiskTypes: ['Standard_LRS']
          purchasePlan: {
            name: 'testPlanName1'
            product: 'testProduct1'
            publisher: 'testPublisher1'
          }
          endOfLife: '2033-01-01'
          releaseNoteUri: 'https://testReleaseNoteUri.com'
        }
        {
          name: '${namePrefix}-az-imgd-ws-002'
          hyperVGeneration: 'V2'
          identifier: {
            publisher: 'MicrosoftWindowsServer'
            offer: 'WindowsServer'
            sku: '2022-datacenter-azure-edition-hibernate'
          }
          osType: 'Windows'
          vCPUs: {
            min: 2
            max: 8
          }
          memory: {
            min: 4
            max: 16
          }

          osState: 'Generalized'
          isHibernateSupported: true
          isAcceleratedNetworkSupported: false
        }
        {
          name: '${namePrefix}-az-imgd-wdtl-003'
          securityType: 'TrustedLaunch'
          osType: 'Windows'
          osState: 'Generalized'
          hyperVGeneration: 'V2'
          identifier: {
            publisher: 'MicrosoftWindowsDesktop'
            offer: 'WindowsDesktop'
            sku: 'Win11-21H2'
          }
          memory: {
            min: 4
            max: 16
          }
          vCPUs: {
            min: 2
            max: 8
          }
          purchasePlan: {
            name: 'testPlanName'
            product: 'testProduct'
            publisher: 'testPublisher'
          }
        }
        {
          name: '${namePrefix}-az-imgd-us-004'
          osType: 'Linux'
          osState: 'Generalized'
          hyperVGeneration: 'V2'
          identifier: {
            publisher: 'canonical'
            offer: '0001-com-ubuntu-minimal-focal'
            sku: '22_04-lts-gen2'
          }
          memory: {
            min: 4
            max: 32
          }
          vCPUs: {
            min: 1
            max: 4
          }
          isAcceleratedNetworkSupported: false
        }
        {
          name: '${namePrefix}-az-imgd-us-005'
          osType: 'Linux'
          osState: 'Generalized'
          hyperVGeneration: 'V2'
          identifier: {
            publisher: 'canonical'
            offer: '0001-com-ubuntu-minimal-focal'
            sku: '20_04-lts-gen2'
          }
          memory: {
            min: 4
            max: 32
          }
          vCPUs: {
            min: 1
            max: 4
          }
          isAcceleratedNetworkSupported: true
        }
        {
          name: '${namePrefix}-az-imgd-us-006'
          description: 'testDescription'
          osType: 'Linux'
          osState: 'Generalized'
          hyperVGeneration: 'V2'
          identifier: {
            publisher: 'canonical'
            offer: '0001-com-ubuntu-server-focal'
            sku: '20_04-lts-gen2'
          }
          memory: {
            min: 4
            max: 32
          }
          vCPUs: {
            min: 1
            max: 4
          }
          securityType: 'TrustedLaunch'
          architecture: 'x64'
          endOfLife: '2033-01-01'
          eula: 'test Eula'
          excludedDiskTypes: ['Standard_LRS']
          isHibernateSupported: true
          privacyStatementUri: 'https://testPrivacyStatementUri.com'
          purchasePlan: {
            name: 'testPlanName'
            product: 'testProduct'
            publisher: 'testPublisher'
          }
          releaseNoteUri: 'https://testReleaseNoteUri.com'
          isAcceleratedNetworkSupported: false
        }
      ]
      roleAssignments: [
        {
          name: '3bd58a78-108d-4f87-b404-0a03e49303d8'
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
    dependsOn: [
      nestedDependencies
    ]
  }
]
