targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

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
    dataCollectionEndpointName: 'dep-${namePrefix}-dce-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
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
      dataCollectionRuleProperties: {
        kind: 'Windows'
        dataCollectionEndpointResourceId: nestedDependencies.outputs.dataCollectionEndpointResourceId
        description: 'Collecting custom text logs without ingestion-time transformation.'
        dataFlows: [
          {
            streams: [
              'Custom-CustomTableBasic_CL'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
            transformKql: 'source'
            outputStream: 'Custom-CustomTableBasic_CL'
          }
        ]
        dataSources: {
          logFiles: [
            {
              name: 'CustomTableBasic_CL'
              samplingFrequencyInSeconds: 60
              streams: [
                'Custom-CustomTableBasic_CL'
              ]
              filePatterns: [
                'C:\\TestLogsBasic\\TestLog*.log'
              ]
              format: 'text'
              settings: {
                text: {
                  recordStartTimestampFormat: 'ISO 8601'
                }
              }
            }
          ]
        }
        destinations: {
          logAnalytics: [
            {
              workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
              name: nestedDependencies.outputs.logAnalyticsWorkspaceName
            }
          ]
        }
        streamDeclarations: {
          'Custom-CustomTableBasic_CL': {
            columns: [
              {
                name: 'TimeGenerated'
                type: 'datetime'
              }
              {
                name: 'RawData'
                type: 'string'
              }
            ]
          }
        }
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          name: '89a4d6fa-defb-4099-9196-173d94b91d67'
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
        resourceType: 'Data Collection Rules'
        kind: 'Windows'
      }
    }
  }
]
