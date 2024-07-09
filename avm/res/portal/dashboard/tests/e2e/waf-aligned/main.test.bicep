targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-portal.dashboard-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pdwaf'

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
      lenses: [
        {
          order: 0
          parts: [
            {
              position: {
                x: 0
                y: 0
                rowSpan: 4
                colSpan: 6
              }
              metadata: {
                inputs: []
                type: 'Extension/HubsExtension/PartType/VideoPart'
                settings: {
                  content: {
                    src: 'https://www.youtube.com/watch?v=JbIMrJKW5N0'
                    title: 'Azure Verified Modules (AVM) introduction'
                    subtitle: 'Learn more about AVM'
                  }
                }
              }
            }
            {
              position: {
                x: 6
                y: 0
                rowSpan: 2
                colSpan: 2
              }
              metadata: {
                inputs: []
                type: 'Extension/Microsoft_AAD_IAM/PartType/UserManagementSummaryPart'
              }
            }
            {
              position: {
                x: 8
                y: 0
                rowSpan: 2
                colSpan: 2
              }
              metadata: {
                inputs: []
                type: 'Extension/HubsExtension/PartType/ClockPart'
                settings: {
                  content: {}
                }
              }
            }
            {
              position: {
                x: 6
                y: 2
                rowSpan: 2
                colSpan: 2
              }
              metadata: {
                inputs: [
                  {
                    name: 'selectedMenuItemId'
                    isOptional: true
                  }
                ]
                type: 'Extension/HubsExtension/PartType/GalleryTile'
              }
            }
            {
              position: {
                x: 8
                y: 2
                rowSpan: 2
                colSpan: 2
              }
              metadata: {
                inputs: []
                type: 'Extension/HubsExtension/PartType/HelpAndSupportPart'
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
                filteredPartIds: [
                  'StartboardPart-MonitorChartPart-f6c2e060-fabc-4ce5-b031-45f3296510dd'
                ]
              }
            }
          }
        }
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
