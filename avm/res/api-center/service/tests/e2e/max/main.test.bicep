targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apicenter.services-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acsmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: '73ec30e0-2e25-475f-beec-d90cab332eb7'
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
      metadataSchemas: [
        {
          name: 'apiLifecycleStage'
          schema: '{"type":"string","title":"API Lifecycle Stage","enum":["design","development","testing","preview","production","deprecated","retired"]}'
          assignedTo: [
            {
              entity: 'api'
              required: true
            }
          ]
        }
        {
          name: 'apiCostCenter'
          schema: '{"type":"string","title":"Cost Center","pattern":"^[A-Z]{2}-[0-9]{4}$"}'
          assignedTo: [
            {
              entity: 'api'
              required: false
            }
            {
              entity: 'environment'
              required: false
            }
          ]
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      workspaces: [
        {
          name: 'default'
          title: 'Default Workspace'
          description: 'The default workspace for API governance.'
          environments: [
            {
              name: 'production-apim'
              title: 'Production APIM'
              kind: 'production'
              description: 'Production Azure API Management environment.'
              server: {
                type: 'Azure API Management'
              }
            }
            {
              name: 'staging-apim'
              title: 'Staging APIM'
              kind: 'staging'
              description: 'Staging Azure API Management environment.'
              server: {
                type: 'Azure API Management'
              }
            }
          ]
          apis: [
            {
              name: 'petstore-api'
              title: 'Petstore API'
              kind: 'rest'
              description: 'A sample REST API for managing pets.'
              summary: 'Petstore management API.'
              contacts: [
                {
                  name: 'API Team'
                  email: 'api-team@contoso.com'
                }
              ]
              versions: [
                {
                  name: 'v1-0-0'
                  title: 'v1.0.0'
                  lifecycleStage: 'production'
                  definitions: [
                    {
                      name: 'openapi-spec'
                      title: 'OpenAPI Specification'
                      description: 'The OpenAPI 3.0 specification for the Petstore API v1.'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  }
]
