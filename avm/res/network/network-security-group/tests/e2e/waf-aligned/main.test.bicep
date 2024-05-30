targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.networksecuritygroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnsgwaf'

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
    location: resourceLocation
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
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
      securityRules: [
        {
          name: 'deny-hop-outbound'
          properties: {
            priority: 200
            access: 'Deny'
            protocol: 'Tcp'
            direction: 'Outbound'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: '*'
            destinationPortRanges: [
              '3389'
              '22'
            ]
          }
        }
        {
          name: 'Ranges'
          properties: {
            access: 'Allow'
            description: 'Tests Ranges'
            destinationAddressPrefixes: [
              '10.2.0.0/16'
              '10.3.0.0/16'
            ]
            destinationPortRanges: [
              '90'
              '91'
            ]
            direction: 'Inbound'
            priority: 101
            protocol: '*'
            sourceAddressPrefixes: [
              '10.0.0.0/16'
              '10.1.0.0/16'
            ]
            sourcePortRanges: [
              '80'
              '81'
            ]
          }
        }
        {
          name: 'Port_8082'
          properties: {
            access: 'Allow'
            description: 'Allow inbound access on TCP 8082'
            destinationApplicationSecurityGroups: [
              {
                id: nestedDependencies.outputs.applicationSecurityGroupResourceId
              }
            ]
            destinationPortRange: '8082'
            direction: 'Inbound'
            priority: 102
            protocol: '*'
            sourceApplicationSecurityGroups: [
              {
                id: nestedDependencies.outputs.applicationSecurityGroupResourceId
              }
            ]
            sourcePortRange: '*'
          }
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
