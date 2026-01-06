@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Maintenance Configuration to create.')
param maintenanceConfigurationName string

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: maintenanceConfigurationName
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2025-01-09 00:00'
      expirationDateTime: '2026-01-08 00:00'
      duration: '03:00'
      timeZone: 'UTC'
      recurEvery: 'Week'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'AlwaysReboot'
      windowsParameters: {
        kbNumbersToExclude: [
          'KB123456'
          'KB3654321'
        ]
        kbNumbersToInclude: [
          'KB111111'
          'KB222222'
        ]
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

@description('The resource ID of the maintenance configuration.')
output maintenanceConfigurationResourceId string = maintenanceConfiguration.id
