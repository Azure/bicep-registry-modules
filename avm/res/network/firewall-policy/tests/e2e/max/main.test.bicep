targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.firewallpolicies-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfpmax'

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
      tier: 'Premium'
      mode: 'Alert'
      ruleCollectionGroups: [
        {
          name: '${namePrefix}-rule-001'
          priority: 5000
          ruleCollections: [
            {
              action: {
                type: 'Allow'
              }
              name: 'collection002'
              priority: 5555
              ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
              rules: [
                {
                  destinationAddresses: [
                    '*'
                  ]
                  destinationFqdns: []
                  destinationIpGroups: []
                  destinationPorts: [
                    '80'
                  ]
                  ipProtocols: [
                    'TCP'
                    'UDP'
                  ]
                  name: 'rule002'
                  ruleType: 'NetworkRule'
                  sourceAddresses: [
                    '*'
                  ]
                  sourceIpGroups: []
                }
              ]
            }
          ]
        }
      ]
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      allowSqlRedirect: true
      autoLearnPrivateRanges: 'Enabled'
    }
  }
]
