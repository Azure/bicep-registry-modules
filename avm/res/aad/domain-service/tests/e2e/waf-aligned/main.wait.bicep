@description('Optional. The location to deploy to.')
param resourceLocation string = resourceGroup().location

param serviceShort string

param waitTimeInSeconds string

param tags object

resource deployDelay 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wait-${serviceShort}'
  location: resourceLocation
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '11.0'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'waitSeconds'
        value: waitTimeInSeconds
      }
    ]
    scriptContent: 'write-output "Sleeping for $Env:waitSeconds"; start-sleep -Seconds $Env:waitSeconds'
  }
  tags: tags
}
