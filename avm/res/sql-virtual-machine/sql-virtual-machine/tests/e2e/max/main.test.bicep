targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = '''This instance deploys the module with most of its features enabled.
Key Vault credential settings are not covered as they require an Entra ID service principal secret, and SQL virtual machine group / WSFC settings are not covered as they require a domain-joined Windows Server Failover Cluster.'''

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sqlvirtualmachine.sqlvirtualmachines-${serviceShort}-rg'

// Capacity constraints for the SQL Server VM size used by the test dependencies
#disable-next-line no-hardcoded-location
var resourceLocation = 'eastus2'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'svmmax'

@description('Optional. The administrator password for the virtual machine.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

var storageAccountName = 'dep${namePrefix}sa${serviceShort}01'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualMachineName: '${namePrefix}${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: storageAccountName
    adminPassword: password
    location: resourceLocation
  }
}

resource backupStorageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  scope: resourceGroup
  name: storageAccountName
  // Ensure the key lookup only happens after the storage account was deployed
  dependsOn: [
    nestedDependencies
  ]
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: last(split(nestedDependencies.outputs.virtualMachineResourceId, '/'))
      location: resourceLocation
      virtualMachineResourceId: nestedDependencies.outputs.virtualMachineResourceId
      sqlServerLicenseType: 'PAYG'
      sqlManagement: 'Full'
      assessmentSettings: {
        enable: true
        runImmediately: false
        schedule: {
          dayOfWeek: 'Sunday'
          enable: true
          startTime: '02:00'
          weeklyInterval: 1
        }
      }
      autoBackupSettings: {
        enable: true
        backupScheduleType: 'Manual'
        backupSystemDbs: true
        fullBackupFrequency: 'Weekly'
        daysOfWeek: [
          'Sunday'
        ]
        fullBackupStartTime: 2
        fullBackupWindowHours: 4
        logBackupFrequency: 60
        retentionPeriod: 7
        enableEncryption: false
        storageAccountUrl: nestedDependencies.outputs.storageAccountBlobEndpoint
        storageAccessKey: backupStorageAccount.listKeys().keys[0].value
      }
      autoPatchingSettings: {
        additionalVmPatch: 'MicrosoftUpdate'
        dayOfWeek: 'Sunday'
        enable: true
        maintenanceWindowDuration: 60
        maintenanceWindowStartingHour: 2
      }
      enableAutomaticUpgrade: true
      leastPrivilegeMode: 'Enabled'
      serverConfigurationsManagementSettings: {
        sqlConnectivityUpdateSettings: {
          connectivityType: 'PRIVATE'
          port: 1433
        }
        sqlInstanceSettings: {
          isIfiEnabled: true
          isLpimEnabled: true
          isOptimizeForAdHocWorkloadsEnabled: true
          maxDop: 0
        }
      }
      storageConfigurationSettings: {
        diskConfigurationType: 'NEW'
        storageWorkloadType: 'OLTP'
        sqlDataSettings: {
          luns: [
            0
          ]
          defaultFilePath: 'F:\\SQLData'
        }
        sqlLogSettings: {
          luns: [
            1
          ]
          defaultFilePath: 'G:\\SQLLog'
        }
        sqlTempDbSettings: {
          luns: [
            2
          ]
          defaultFilePath: 'H:\\SQLTemp'
        }
        sqlSystemDbOnDataDisk: false
      }
      sqlImageOffer: 'SQL2022-WS2022'
      sqlImageSku: 'Developer'
      virtualMachineIdentitySettings: {
        type: 'SystemAssigned'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: '7f6e9b2a-3c1d-4e8f-9a0b-1c2d3e4f5a6b'
          roleDefinitionIdOrName: 'Virtual Machine Contributor'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
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
    }
  }
]
