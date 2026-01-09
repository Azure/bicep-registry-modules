targetScope = 'subscription'

metadata name = 'Using Log Analytics Cluster with Customer-Managed-Keys'
metadata description = 'This instance deploys a Log Analytics Cluster with Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity and links the Log Analytics Workspace to it.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-operationalinsights.workspaces-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'oiwmhsmu'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

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
    waitDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-waitForPropagation'
    // Adding base time to make the name unique as soft-deletion is enabled by default
    logAnalyticsClusterName: 'dep-${namePrefix}-lac-${serviceShort}-${uniqueString(baseTime)}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
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
      dailyQuotaGb: '10'
      skuName: 'LACluster'
      linkedServices: [
        {
          name: 'Cluster'
          writeAccessResourceId: nestedDependencies.outputs.logAnalyticsClusterResourceId
        }
      ]
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
    }
  }
]
