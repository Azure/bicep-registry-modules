import { uniqueResourceName } from '../../../../../../../utilities/e2e-template-assets/functions/unique-resource-name.bicep'

targetScope = 'subscription'

metadata name = 'Using failover groups'
metadata description = 'This instance deploys the module with failover groups.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssfog'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Use paired regions
// https://learn.microsoft.com/en-us/azure/reliability/cross-region-replication-azure
var locationPrimary = 'eastasia'
var locationSecondary = 'southeastasia'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: locationPrimary
}

// Create a secondary server for the failover group
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, locationSecondary)}-nestedDependencies'
  params: {
    serverName: uniqueResourceName('${namePrefix}${serviceShort}002', resourceGroup.id, 63)
    location: locationSecondary
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, locationPrimary)}-test-${serviceShort}-${iteration}'
    params: {
      name: uniqueResourceName('${namePrefix}${serviceShort}001', resourceGroup.id, 63)
      location: locationPrimary
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      databases: [
        {
          name: '${namePrefix}-${serviceShort}-db1'
          sku: {
            name: 'S1'
            tier: 'Standard'
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          availabilityZone: -1
        }
        {
          name: '${namePrefix}-${serviceShort}-db2'
          sku: {
            name: 'GP_Gen5'
            tier: 'GeneralPurpose'
            capacity: 2
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          availabilityZone: -1
        }
        {
          name: '${namePrefix}-${serviceShort}-db3'
          sku: {
            name: 'S1'
            tier: 'Standard'
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          availabilityZone: -1
        }
      ]
      failoverGroups: [
        // Geo failover group with read-write endpoint failover
        {
          name: uniqueResourceName('${namePrefix}-${serviceShort}-fg-geo', resourceGroup.id, 63)
          databases: [
            '${namePrefix}-${serviceShort}-db1'
          ]
          partnerServerResourceIds: [
            nestedDependencies.outputs.secondaryServerResourceId
          ]
          readWriteEndpoint: {
            failoverPolicy: 'Manual'
          }
          secondaryType: 'Geo'
        }
        // Standby failover group
        {
          name: uniqueResourceName('${namePrefix}-${serviceShort}-fg-standby', resourceGroup.id, 63)
          databases: [
            '${namePrefix}-${serviceShort}-db2'
          ]
          partnerServerResourceIds: [
            nestedDependencies.outputs.secondaryServerResourceId
          ]
          readWriteEndpoint: {
            failoverPolicy: 'Automatic'
            failoverWithDataLossGracePeriodMinutes: 60
          }
          secondaryType: 'Standby'
        }
        // Geo failover group with read-write AND read-only endpoint failover policy
        {
          name: uniqueResourceName('${namePrefix}-${serviceShort}-fg-readonly', resourceGroup.id, 63)
          databases: [
            '${namePrefix}-${serviceShort}-db3'
          ]
          partnerServerResourceIds: [
            nestedDependencies.outputs.secondaryServerResourceId
          ]
          readWriteEndpoint: {
            failoverPolicy: 'Manual'
          }
          readOnlyEndpoint: {
            failoverPolicy: 'Enabled'
            targetServer: nestedDependencies.outputs.secondaryServerName
          }
          secondaryType: 'Geo'
        }
      ]
    }
  }
]
