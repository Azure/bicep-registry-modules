@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Maintenance Configuration to create.')
param maintenanceConfigurationName string

@description('Generated. Do not provide a value. Time used as a basis for e.g. the maintenance window start date.')
param baseTime string = utcNow('u')

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: maintenanceConfigurationName
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '${dateTimeAdd(baseTime, 'PT0S', 'yyyy-MM-dd')} 00:00'
      expirationDateTime: '${dateTimeAdd(baseTime, 'P1M', 'yyyy-MM-dd')} 00:00'
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
