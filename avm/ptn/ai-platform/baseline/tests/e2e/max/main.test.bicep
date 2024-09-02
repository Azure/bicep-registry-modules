targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-aiplatform-baseline-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aipbmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}'
      managedIdentitySettings: {
        name: '${namePrefix}-id-${serviceShort}'
      }
      logAnalyticsSettings: {
        name: '${namePrefix}-log-${serviceShort}'
      }
      keyVaultSettings: {
        name: '${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
        enablePurgeProtection: false
      }
      storageAccountSettings: {
        name: '${namePrefix}st${serviceShort}'
        sku: 'Standard_GRS'
        allowSharedKeyAccess: true
      }
      containerRegistrySettings: {
        name: '${namePrefix}cr${serviceShort}'
        trustPolicyStatus: 'disabled'
      }
      applicationInsightsSettings: {
        name: '${namePrefix}-appi-${serviceShort}'
      }
      workspaceHubSettings: {
        name: '${namePrefix}-hub-${serviceShort}'
        computes: [
          {
            computeType: 'ComputeInstance'
            name: 'compute-${substring(uniqueString(baseTime), 0, 3)}'
            description: 'Default'
            location: resourceLocation
            properties: {
              vmSize: 'STANDARD_DS11_V2'
            }
            sku: 'Standard'
          }
        ]
        networkIsolationMode: 'AllowOnlyApprovedOutbound'
        networkOutboundRules: {
          rule1: {
            type: 'FQDN'
            destination: 'pypi.org'
            category: 'UserDefined'
          }
        }
      }
    }
  }
]
