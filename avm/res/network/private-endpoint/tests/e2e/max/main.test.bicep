targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.privateendpoints-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npemax'

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
        name: 'default'
        privateDnsZoneGroupConfigs: [
          {
            name: 'config'
            privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
          }
        ]
      }
      roleAssignments: [
        {
          name: '6804f270-b4e9-455f-a11b-7f2a64e38f7c'
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
      customDnsConfigs: [
        {
          fqdn: 'abc.keyvault.com'
          ipAddresses: [
            '10.0.0.10'
          ]
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
            requestMessage: 'Hey there'
          }
        }
      ]
    }
  }
]
