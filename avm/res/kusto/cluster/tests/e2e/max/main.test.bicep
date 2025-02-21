targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-kusto.clusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'kcmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // entraIdGroupName: 'dep-${namePrefix}-group-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}0001'
      location: resourceLocation
      sku: 'Standard_E2ads_v5'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      capacity: 3
      autoScaleMin: 3
      autoScaleMax: 6
      enableAutoScale: true
      principalAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentityClientId
          principalType: 'App'
          role: 'AllDatabasesViewer'
        }
      ]
      allowedFqdnList: [
        'contoso.com'
      ]
      enableAutoStop: true
      enableDiskEncryption: true
      enableDoubleEncryption: true
      enablePublicNetworkAccess: true
      enablePurge: true
      enableStreamingIngest: true
      allowedIpRangeList: [
        '192.168.1.1'
      ]
      acceptedAudiences: [
        {
          value: 'https://contoso.com'
        }
      ]
      enableZoneRedundant: true
      engineType: 'V3'
      publicIPType: 'DualStack'
      enableRestrictOutboundNetworkAccess: true
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          name: 'c2a4b728-c3d0-47f5-afbb-ea45c45859de'
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
      databases: [
        {
          name: 'myReadWriteDatabase'
          kind: 'ReadWrite'
          readWriteProperties: {
            softDeletePeriod: 'P7D'
            hotCachePeriod: 'P1D'
          }
        }
      ]
    }
  }
]
