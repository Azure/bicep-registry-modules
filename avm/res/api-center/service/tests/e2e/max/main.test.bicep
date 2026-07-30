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
param serviceShort string = 'aacavmmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A temporary per-run suffix to avoid API Center soft-delete name reuse while API Center purge is unavailable.')
param serviceNameSuffix string = take(uniqueString(deployment().name), 5)

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
      name: '${namePrefix}${serviceShort}${serviceNameSuffix}'
      location: resourceLocation
      sku: 'Free'
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'ApiCenterDeleteLock'
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
            apiCostCenter: 'CC-1001'
          }
          server: {
            type: 'Azure API Management'
            managementPortalUri: [
              'https://portal.azure.com'
            ]
          }
          onboarding: {
            developerPortalUri: [
              'https://contoso.com/develop'
            ]
            instructions: 'Sign up using the developer portal to get started with our APIs.'
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
            apiCostCenter: 'CC-2001'
            apiTeamOwner: 'Platform Engineering'
          }
          externalDocumentation: [
            {
              url: 'https://contoso.com/docs/petstore'
              title: 'API Documentation'
              description: 'Full reference documentation for the Petstore API.'
            }
            {
              url: 'https://contoso.com/petstore/getting-started'
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
            identifier: 'mit'
            url: 'https://opensource.org/licenses/MIT'
          }
          termsOfService: {
            url: 'https://contoso.com/terms-of-service'
          }
          versions: [
            {
              name: 'v0-9-0'
              title: 'v0.9.0'
              lifecycleStage: 'retired'
            }
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
                  name: 'openapi-spec'
                  title: 'OpenAPI Specification'
                  description: 'The OpenAPI 3.0 specification for the Petstore API v2.'
                }
              ]
            }
          ]
          deployments: [
            {
              name: 'petstore-staging-deployment'
              title: 'Petstore Staging'
              environment: 'staging-apim'
              version: 'v2-0-0-preview'
              definition: 'openapi-spec'
            }
            {
              name: 'petstore-prod-deployment'
              title: 'Petstore Production'
              description: 'Production deployment of the Petstore API.'
              environment: 'production-apim'
              version: 'v1-0-0'
              definition: 'openapi-spec'
              state: 'active'
              customProperties: {
                apiTeamOwner: 'Platform Engineering'
              }
              server: {
                runtimeUri: [
                  'https://contoso.com/petstore/api'
                ]
              }
            }
          ]
        }
        {
          name: 'graphql-api'
          title: 'GraphQL API'
          kind: 'graphql'
          description: 'A GraphQL API'
          customProperties: {
            apiCostCenter: 'CC-2001'
          }
        }
        {
          name: 'soap-api'
          title: 'SOAP API'
          kind: 'soap'
          description: 'A SOAP-based API'
          customProperties: {
            apiCostCenter: 'CC-3001'
          }
        }
        {
          name: 'webhook-notifications'
          title: 'Webhook Notifications'
          kind: 'webhook'
          description: 'A webhook API'
          customProperties: {
            apiCostCenter: 'CC-4001'
          }
        }
        {
          name: 'grpc-api'
          title: 'gRPC API'
          kind: 'grpc'
          description: 'A gRPC API'
          customProperties: {
            apiCostCenter: 'CC-5001'
          }
        }
        {
          name: 'ws-api'
          title: 'WebSocket API'
          kind: 'websocket'
          description: 'A WebSocket API'
          customProperties: {
            apiCostCenter: 'CC-6001'
          }
        }
      ]
      apiSources: [
        {
          name: 'apim-import-source'
          importSpecification: 'always'
          targetLifecycleStage: 'production'
          targetEnvironment: 'production-apim'
          azureApiManagementSource: {
            resourceId: nestedDependencies.outputs.apiManagementServiceResourceId
            msiResourceId: nestedDependencies.outputs.managedIdentityResourceId
          }
        }
      ]
    }
  }
]
