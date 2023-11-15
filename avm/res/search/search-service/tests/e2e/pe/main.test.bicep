targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-search.searchservices-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssspe'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    privateDnsZoneName: 'privatelink.search.windows.net'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    publicNetworkAccess: 'disabled'
    privateEndpoints: [
      {
        applicationSecurityGroupResourceIds: [
          nestedDependencies.outputs.applicationSecurityGroupResourceId
        ]
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    sharedPrivateLinkResources: [
      {
        privateLinkResourceId: nestedDependencies.outputs.storageAccountResourceId
        groupId: 'blob'
        resourceRegion: nestedDependencies.outputs.storageAccountLocation
        requestMessage: 'Please approve this request'
      }
      {
        privateLinkResourceId: nestedDependencies.outputs.keyVaultResourceId
        groupId: 'vault'
        requestMessage: 'Please approve this request'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
