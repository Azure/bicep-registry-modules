targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-purview-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pvawaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

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
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: resourceLocation

  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}001'
    #disable-next-line no-hardcoded-location
    location: 'eastus' // Only available in selected locations: eastus, eastus2, southcentralus, westcentralus, westus, westus2, westus3
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    managedResourceGroupName: '${namePrefix}${serviceShort}001-managed-rg'
    publicNetworkAccess: 'Disabled'
    diagnosticSettings: [
      {
        eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    accountPrivateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.purviewAccountPrivateDNSResourceId
        ]
        service: 'account'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    portalPrivateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.purviewPortalPrivateDNSResourceId
        ]
        service: 'portal'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    storageBlobPrivateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.storageBlobPrivateDNSResourceId
        ]
        service: 'blob'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    storageQueuePrivateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.storageQueuePrivateDNSResourceId
        ]
        service: 'queue'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    eventHubPrivateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.eventHubPrivateDNSResourceId
        ]
        service: 'namespace'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
  }
}]
