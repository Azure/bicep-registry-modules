targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.networkmanagers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnmwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnetSpoke1-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var networkManagerName = '${namePrefix}${serviceShort}001'
var networkManagerExpecetedResourceID = '${resourceGroup.id}/providers/Microsoft.Network/networkManagers/${networkManagerName}'

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    name: networkManagerName
    location: resourceLocation
    networkManagerScopeAccesses: [
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      subscriptions: [
        subscription().id
      ]
    }
    networkGroups: [
      {
        name: 'network-group-spokes'
        description: 'network-group-spokes description'
        staticMembers: [
          {
            name: 'virtualNetwork'
            resourceId: nestedDependencies.outputs.virtualNetworkResourceId
          }
        ]
      }
    ]
    securityAdminConfigurations: [
      {
        name: 'test-security-admin-config'
        description: 'description of the security admin config'
        applyOnNetworkIntentPolicyBasedServices: [
          'AllowRulesOnly'
        ]
        ruleCollections: [
          {
            name: 'test-rule-collection-1'
            description: 'test-rule-collection-description'
            appliesToGroups: [
              {
                networkGroupId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes'
              }
            ]
            rules: [
              {
                name: 'test-inbound-allow-rule-1'
                description: 'test-inbound-allow-rule-1-description'
                access: 'Allow'
                direction: 'Inbound'
                priority: 150
                protocol: 'Tcp'
              }
              {
                name: 'test-outbound-deny-rule-2'
                description: 'test-outbound-deny-rule-2-description'
                access: 'Deny'
                direction: 'Outbound'
                priority: 200
                protocol: 'Tcp'
                sourcePortRanges: [
                  '80'
                  '442-445'
                ]
                sources: [
                  {
                    addressPrefix: 'AppService.WestEurope'
                    addressPrefixType: 'ServiceTag'
                  }
                ]
              }
            ]
          }
          {
            name: 'test-rule-collection-2'
            description: 'test-rule-collection-description'
            appliesToGroups: [
              {
                networkGroupId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes'
              }
            ]
            rules: [
              {
                name: 'test-inbound-allow-rule-3'
                description: 'test-inbound-allow-rule-3-description'
                access: 'Allow'
                direction: 'Inbound'
                destinationPortRanges: [
                  '80'
                  '442-445'
                ]
                destinations: [
                  {
                    addressPrefix: '192.168.20.20'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                priority: 250
                protocol: 'Tcp'
              }
              {
                name: 'test-inbound-allow-rule-4'
                description: 'test-inbound-allow-rule-4-description'
                access: 'Allow'
                direction: 'Inbound'
                sources: [
                  {
                    addressPrefix: '10.0.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '100.100.100.100'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                destinations: [
                  {
                    addressPrefix: '172.16.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '172.16.1.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                priority: 260
                protocol: 'Tcp'
              }
            ]
          }
        ]
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}]
