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
    apiManagementServiceName: 'dep-${namePrefix}-apim-${serviceShort}'
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
          name: 'apiCostCenter'
          schema: '{"type":"string","title":"Cost Center","pattern":"^[A-Z]{2}-[0-9]{4}$"}'
          assignedTo: [
            {
              entity: 'api'
              required: true
            }
            {
              entity: 'environment'
              required: false
            }
          ]
        }
        {
          name: 'apiTeamOwner'
          schema: '{"type":"string","title":"Team Owner","minLength":1,"maxLength":100}'
          assignedTo: [
            {
              entity: 'api'
              required: false
            }
            {
              entity: 'deployment'
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
      environments: [
        {
          name: 'production-apim'
          title: 'Production APIM'
          kind: 'production'
          description: 'Production Azure API Management environment.'
          customProperties: {
            apiCostCenter: 'IT-1234'
          }
          server: {
            type: 'Azure API Management'
            managementPortalUri: [
              'https://portal.azure.com'
            ]
          }
          onboarding: {
            developerPortalUri: [
              'https://developer.contoso.com'
            ]
            instructions: 'Sign up at the developer portal to get started with our APIs.'
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
          customProperties: {
            apiCostCenter: 'IT-1234'
            apiTeamOwner: 'Platform Engineering'
          }
          externalDocumentation: [
            {
              url: 'https://docs.contoso.com/petstore'
              title: 'API Documentation'
              description: 'Full reference documentation for the Petstore API.'
            }
            {
              url: 'https://docs.contoso.com/petstore/getting-started'
              title: 'Getting Started Guide'
            }
          ]
          contacts: [
            {
              name: 'API Team'
              email: 'api-team@contoso.com'
              url: 'https://contoso.com/teams/api'
            }
          ]
          license: {
            name: 'MIT License'
            url: 'https://opensource.org/licenses/MIT'
          }
          termsOfService: {
            url: 'https://contoso.com/terms-of-service'
          }
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
            {
              name: 'v2-0-0-preview'
              title: 'v2.0.0-preview'
              lifecycleStage: 'preview'
              definitions: [
                {
                  name: 'openapi-spec-v2'
                  title: 'OpenAPI Specification v2'
                  description: 'The OpenAPI 3.1 specification for the Petstore API v2.'
                }
              ]
            }
          ]
          deployments: [
            {
              name: 'petstore-prod-deployment'
              title: 'Petstore Production'
              description: 'Production deployment of the Petstore API.'
              state: 'active'
              server: {
                runtimeUri: [
                  'https://petstore.contoso.com/api'
                ]
              }
            }
          ]
        }
        {
          name: 'order-api'
          title: 'Order API'
          kind: 'rest'
          description: 'A REST API for managing customer orders.'
          summary: 'Order management API.'
          customProperties: {
            apiTeamOwner: 'Commerce Team'
          }
          contacts: [
            {
              name: 'Commerce Team'
              email: 'commerce@contoso.com'
            }
          ]
          versions: [
            {
              name: 'v1-0-0'
              title: 'v1.0.0'
              lifecycleStage: 'production'
            }
          ]
        }
        {
          name: 'graphql-api'
          title: 'GraphQL API'
          kind: 'graphql'
          description: 'A sample GraphQL API for querying data.'
          summary: 'GraphQL data query API.'
        }
        {
          name: 'legacy-soap-api'
          title: 'Legacy SOAP API'
          kind: 'soap'
          description: 'A legacy SOAP-based API for backward compatibility.'
        }
        {
          name: 'webhook-notifications'
          title: 'Webhook Notifications'
          kind: 'webhook'
          description: 'A webhook API for event-driven notifications.'
        }
        {
          name: 'grpc-service'
          title: 'gRPC Service'
          kind: 'grpc'
          description: 'A gRPC API for high-performance inter-service communication.'
        }
        {
          name: 'realtime-ws-api'
          title: 'Real-Time WebSocket API'
          kind: 'websocket'
          description: 'A WebSocket API for real-time bidirectional communication.'
        }
      ]
      apiSources: [
        {
          name: 'apim-import-source'
          importSpecification: 'always'
          targetLifecycleStage: 'production'
          azureApiManagementSource: {
            resourceId: nestedDependencies.outputs.apiManagementServiceResourceId
            msiResourceId: nestedDependencies.outputs.managedIdentityResourceId
          }
        }
      ]
    }
  }
]
