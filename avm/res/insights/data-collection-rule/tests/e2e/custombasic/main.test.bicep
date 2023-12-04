targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrcusbas'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    dataCollectionEndpointName: 'dep-${namePrefix}-dce-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    dataCollectionEndpointId: resourceGroupResources.outputs.dataCollectionEndpointResourceId
    description: 'Collecting custom text logs without ingestion-time transformation.'
    dataFlows: [
      {
        streams: [
          'Custom-CustomTableBasic_CL'
        ]
        destinations: [
          resourceGroupResources.outputs.logAnalyticsWorkspaceName
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
          workspaceResourceId: resourceGroupResources.outputs.logAnalyticsWorkspaceResourceId
          name: resourceGroupResources.outputs.logAnalyticsWorkspaceName
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
    enableDefaultTelemetry: enableDefaultTelemetry
    kind: 'Windows'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: resourceGroupResources.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Data Collection Rules'
      kind: 'Windows'
    }
  }
}]
