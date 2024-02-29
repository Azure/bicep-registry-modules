targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-network.hub-networking-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'nhnmax'

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

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    // You parameters go here
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    hubVirtualNetworks: {
      hub1: {
        name: 'hub1'
        addressPrefixes: [ '10.0.0.0/16' ]
        enableTelemetry: true
        flowTimeoutInMinutes: 30
        ddosProtectionPlanResourceId: ''
        dnsServers: [ '10.0.1.4', '10.0.1.5' ]
        diagnosticSettings: []
        location: 'westeurope'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        peeringEnabled: false
        peerings: [
          {
            name: 'hub1-to-hub2'
            remoteVirtualNetworkId: 'hub2'
            allowForwardedTraffic: false
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            useRemoteGateways: false }
        ]
        roleAssignments: []
        subnets: [
          {
            name: 'subnet1'
            addressPrefix: '10.0.1.0/24'
          }
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        vnetEncryption: false
        vnetEncryptionEnforcement: 'AllowUnencrypted'
      }
      hub2: {
        name: 'hub2'
        addressPrefixes: [ '10.1.0.0/16' ]
        enableTelemetry: false
        flowTimeoutInMinutes: 10
        dnsServers: []
        diagnosticSettings: []
        location: 'westus2'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        peeringEnabled: false
        roleAssignments: []
        subnets: [
          {
            name: 'subnet2'
            addressPrefix: '10.1.1.0/24'
          }
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        vnetEncryption: false
        vnetEncryptionEnforcement: 'AllowUnencrypted'
      }
    }
  }
}]
