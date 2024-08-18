targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-data-privateanalyticalworkspace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpawmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      //solutionAdministrators: [
      //  {
      //    principalId: '<EntraGroupId>'
      //    principalType: 'Group'
      //  }
      //]
      tags: {
        Owner: 'Contoso'
        CostCenter: '123-456-789'
      }
      enableTelemetry: true
      enableDatabricks: true
      //virtualNetworkResourceId: null
      //logAnalyticsWorkspaceResourceId: null
      //keyVaultResourceId: null
      advancedOptions: {
        //networkAcls: { ipRules: [<AllowedPublicIPAddress>] }
        logAnalyticsWorkspace: { dataRetention: 35, dailyQuotaGb: 1 }
        keyVault: {
          createMode: 'default'
          sku: 'standard'
          enableSoftDelete: false
          softDeleteRetentionInDays: 7
          enablePurgeProtection: true
        }
      }
    }
  }
]
