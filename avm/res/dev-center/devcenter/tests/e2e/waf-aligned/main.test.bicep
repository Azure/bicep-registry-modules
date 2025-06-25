targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
param resourceGroupName string = 'dep-${namePrefix}-devcenter-devcenter-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dcdcwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Hardcoded because service not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'westeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies1'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    devCenterNetworkConnectionName: 'dep-${namePrefix}-dcnc-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var devcenterName = '${namePrefix}${serviceShort}001'
var devcenterExpectedResourceID = '${resourceGroup.id}/providers/Microsoft.DevCenter/devcenters/${devcenterName}'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: devcenterName
      location: enforcedLocation
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      devboxDefinitions: [
        {
          name: 'test-devbox-definition-builtin-gallery-image'
          imageResourceId: '${devcenterExpectedResourceID}/galleries/Default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
          sku: {
            name: 'general_i_8c32gb512ssd_v2'
          }
          hibernateSupport: 'Enabled'
        }
      ]
      catalogs: [
        {
          name: 'quickstart-catalog'
          gitHub: {
            uri: 'https://github.com/microsoft/devcenter-catalog.git'
            branch: 'main'
            path: 'Environment-Definitions'
          }
          syncType: 'Scheduled'
        }
      ]
      devBoxProvisioningSettings: {
        installAzureMonitorAgentEnableStatus: 'Enabled'
      }
      networkSettings: {
        microsoftHostedNetworkEnableStatus: 'Disabled'
      }
      projectCatalogSettings: {
        catalogItemSyncEnableStatus: 'Enabled'
      }
      projectPolicies: [
        {
          name: 'Default'
          resourcePolicies: [
            {
              action: 'Allow'
              resourceType: 'Images'
            }
            {
              action: 'Allow'
              resourceType: 'Skus'
            }
            {
              action: 'Allow'
              resourceType: 'AttachedNetworks'
            }
          ]
        }
      ]
      attachedNetworks: [
        {
          name: 'test-attached-network'
          networkConnectionResourceId: nestedDependencies.outputs.networkConnectionResourceId
        }
      ]
    }
  }
]
