targetScope = 'subscription'

metadata name = 'Web App with Azure Storage Accounts Configuration'
metadata description = 'This instance deploys the module as Web App with azurestorageaccounts configuration demonstrating the correct structure for mounting Azure Storage Accounts.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsazstor'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Note, we enforce the location due to quota restrictions in other regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'swedencentral'
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
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
    primaryStorageAccountName: 'dep${namePrefix}st${serviceShort}01'
    secondaryStorageAccountName: 'dep${namePrefix}st${serviceShort}02'
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
      kind: 'app'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId

      // =====================================================================================
      // AZURE STORAGE ACCOUNTS CONFIGURATION EXAMPLE
      // =====================================================================================
      // This demonstrates the correct structure for azurestorageaccounts configuration.
      // Key points:
      // 1. name: 'azurestorageaccounts' - specifies the configuration type
      // 2. properties: contains a dictionary of storage mount configurations
      // 3. Each key in properties is a custom name for the storage mount
      // 4. accountName is a STRING field within each mount configuration (NOT an object)
      // =====================================================================================
      configs: [
        {
          name: 'azurestorageaccounts'
          properties: {
            // Mount 1: Configuration files storage (Azure Files)
            'config-storage': {
              accountName: nestedDependencies.outputs.primaryStorageAccountName // ✅ STRING field
              accessKey: nestedDependencies.outputs.primaryStorageAccountKey
              shareName: 'config-share'
              mountPath: '\\mounts\\config'
              type: 'AzureFiles'
              protocol: 'Smb'
            }
            // Mount 2: Logs storage (Azure Files)
            'logs-storage': {
              accountName: nestedDependencies.outputs.primaryStorageAccountName // ✅ STRING field
              accessKey: nestedDependencies.outputs.primaryStorageAccountKey
              shareName: 'logs-share'
              mountPath: '\\mounts\\logs'
              type: 'AzureFiles'
              protocol: 'Smb'
            }
            // Mount 3: Data storage from secondary account (Azure Files)
            'data-storage': {
              accountName: nestedDependencies.outputs.secondaryStorageAccountName // ✅ STRING field
              accessKey: nestedDependencies.outputs.secondaryStorageAccountKey
              shareName: 'data-share'
              mountPath: '\\mounts\\data'
              type: 'AzureFiles'
              protocol: 'Smb'
            }
            // Note: Azure Blob storage mounting is not supported in Windows App Service plans
          }
        }
        {
          // Additional configuration to show azurestorageaccounts works with other configs
          name: 'appsettings'
          properties: {
            STORAGE_CONFIG_MOUNT: '\\mounts\\config'
            STORAGE_LOGS_MOUNT: '\\mounts\\logs'
            STORAGE_DATA_MOUNT: '\\mounts\\data'
          }
        }
      ]
    }
  }
]
