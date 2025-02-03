targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerregistry.registries-${serviceShort}-rg'

// @description('Optional. The location to deploy resources to.')
// param resourceLocation string = deployment().location

#disable-next-line no-hardcoded-location // testing
var enforcedLocation = 'uaenorth'
var enforcedLocation2 = 'uaecentral'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crrwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-msi-ds-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      acrAdminUserEnabled: false
      acrSku: 'Premium'
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      exportPolicyStatus: 'enabled'
      azureADAuthenticationAsArmPolicyStatus: 'enabled'
      softDeletePolicyStatus: 'disabled'
      softDeletePolicyDays: 7
      quarantinePolicyStatus: 'enabled'
      replications: [
        {
          // location: nestedDependencies.outputs.pairedRegionName
          // name: nestedDependencies.outputs.pairedRegionName
          location: enforcedLocation2
          name: enforcedLocation2
          zoneRedundancy: 'Enabled'
        }
      ]
      trustPolicyStatus: 'enabled'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
    }
  }
]
