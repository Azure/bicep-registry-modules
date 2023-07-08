@description('The delay script resource name')
param scriptName string = '${deployment().name}-Delay'

@minValue(1)
@maxValue(180)
@description('The number of seconds to wait for')
param waitSeconds int

@description('The location to deploy the resources to')
param location string = resourceGroup().location

resource deployDelay 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: scriptName
  location: location
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '10.0'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'waitSeconds'
        value: '${waitSeconds}'
      }
    ]
    scriptContent: 'write-output "Sleeping for $Env:waitSeconds"; start-sleep -Seconds $Env:waitSeconds'
  }
}
