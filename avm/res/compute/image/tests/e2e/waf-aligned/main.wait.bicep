@description('Optional. The location to deploy to.')
param resourceLocation string = resourceGroup().location

param waitTimeInSeconds string

resource deployDelay 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-wait'
  location: resourceLocation
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '11.0'
    cleanupPreference: 'Always'
    scriptContent: 'write-output "Sleeping for ${waitTimeInSeconds}"; start-sleep -Seconds ${waitTimeInSeconds}'
  }
}
