targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-portal.dashboard-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pdmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
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
      roleAssignments: [
        {
          name: '15e2e690-5c9f-4cbf-9716-94ee73efab8b'
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
      lenses: [
        {
          order: 0
          parts: [
            {
              position: {
                x: 0
                y: 0
                rowSpan: 3
                colSpan: 2
              }
              metadata: {
                inputs: []
                type: 'Extension/Microsoft_Azure_Security/PartType/SecurityMetricGalleryTileViewModel'
              }
            }
            {
              position: {
                x: 2
                y: 0
                rowSpan: 3
                colSpan: 9
              }
              metadata: {
                inputs: [
                  {
                    name: 'isShared'
                    isOptional: true
                  }
                  {
                    name: 'queryId'
                    isOptional: true
                  }
                  {
                    name: 'formatResults'
                    isOptional: true
                  }
                  {
                    name: 'partTitle'
                    value: 'Query 1'
                    isOptional: true
                  }
                  {
                    name: 'chartType'
                    value: 1
                    isOptional: true
                  }
                  {
                    name: 'queryScope'
                    value: {
                      scope: 0
                      values: []
                    }
                    isOptional: true
                  }
                  {
                    name: 'query'
                    value: 'summarize ResourceCount=count() by type\n| order by ResourceCount desc\n| take 5\n| project ["Resource Type"]=type, ["Resource Count"]=ResourceCount'
                    isOptional: true
                  }
                ]
                type: 'Extension/HubsExtension/PartType/ArgQueryChartTile'
                settings: {}
                partHeader: {
                  title: 'Top 5 resource types'
                  subtitle: ''
                }
              }
            }
          ]
        }
      ]
      metadata: {
        model: {
          timeRange: {
            value: {
              relative: {
                duration: 24
                timeUnit: 1
              }
            }
            type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
          }
          filterLocale: {
            value: 'en-us'
          }
          filters: {
            value: {
              MsPortalFx_TimeRange: {
                model: {
                  format: 'utc'
                  granularity: 'auto'
                  relative: '24h'
                }
                displayCache: {
                  name: 'UTC Time'
                  value: 'Past 24 hours'
                }
                filteredPartIds: []
              }
            }
          }
        }
      }
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
