targetScope = 'subscription'

metadata name = 'Using defaults'
metadata description = 'This instance deploys the module with minimal required parameters.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-security.insights-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the bit of the deployment.')
param serviceShort string = 'sidcmin'

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

// Deployment for Log Analytics Workspace
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-dependencies'
  params: {
    location: resourceLocation
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'MicrosoftThreatIntelligence'
      workspaceResourceId: nestedDependencies.outputs.workspaceResourceId
      properties: {
        kind: 'MicrosoftThreatIntelligence'
        properties: {
          dataTypes: {
            microsoftEmergingThreatFeed: {
              lookbackPeriod: '2025-01-01T00:00:00Z'
              state: 'Enabled'
            }
          }
          tenantId: tenant().tenantId
        }
      }
    }
  }
]
