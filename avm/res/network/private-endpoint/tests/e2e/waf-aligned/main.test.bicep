targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.privateendpoints-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npewaf'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
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
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      privateDnsZoneGroup: {
        privateDnsZoneGroupConfigs: [
          {
            privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
          }
        ]
      }
      ipConfigurations: [
        {
          name: 'myIPconfig'
          properties: {
            groupId: 'vault'
            memberName: 'default'
            privateIPAddress: '10.0.0.10'
          }
        }
      ]
      customNetworkInterfaceName: '${namePrefix}${serviceShort}001nic'
      applicationSecurityGroupResourceIds: [
        nestedDependencies.outputs.applicationSecurityGroupResourceId
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      privateLinkServiceConnections: [
        {
          name: '${namePrefix}${serviceShort}001'
          properties: {
            privateLinkServiceId: nestedDependencies.outputs.keyVaultResourceId
            groupIds: [
              'vault'
            ]
          }
        }
      ]
    }
  }
]
