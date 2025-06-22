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
    serverName: '${namePrefix}${serviceShort}002'
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
      name: '${namePrefix}${serviceShort}001'
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
          name: '${namePrefix}-${serviceShort}-fg-geo'
          databases: [
            '${namePrefix}-${serviceShort}-db1'
          ]
          partnerServers: [
            nestedDependencies.outputs.secondaryServerName
          ]
          readWriteEndpoint: {
            failoverPolicy: 'Manual'
          }
          secondaryType: 'Geo'
        }
        // Standby failover group
        {
          name: '${namePrefix}-${serviceShort}-fg-standby'
          databases: [
            '${namePrefix}-${serviceShort}-db2'
          ]
          partnerServers: [
            nestedDependencies.outputs.secondaryServerName
          ]
          readWriteEndpoint: {
            failoverPolicy: 'Automatic'
            failoverWithDataLossGracePeriodMinutes: 60
          }
          secondaryType: 'Standby'
        }
        // Geo failover group with read-write AND read-only endpoint failover policy
        {
          name: '${namePrefix}-${serviceShort}-fg-readonly'
          databases: [
            '${namePrefix}-${serviceShort}-db3'
          ]
          partnerServers: [
            nestedDependencies.outputs.secondaryServerName
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
