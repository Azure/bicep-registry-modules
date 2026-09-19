targetScope = 'subscription'

metadata name = 'Using Dedicated Windows hosting'
metadata description = 'This instance deploys a Windows Function App on a Dedicated plan with managed-identity runtime storage access.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.function-app-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. An identifier for this test invocation. The generated portion isolates resources from earlier runs while remaining stable for deployment retries.')
param serviceShort string = 'afa${uniqueString(baseTime, resourceLocation, 'dedicated')}ded'

@description('Generated. Used as a basis for unique resource names. The pipeline supplies a fixed value for all retries.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  // Test groups are intentionally unique per invocation; CI fixes baseTime across retries.
  #disable-next-line use-stable-resource-identifiers
  name: resourceGroupName
  location: resourceLocation
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      functionAppName: '${namePrefix}${serviceShort}001'
      appServicePlanSkuName: 'B1'
      functionAppKind: 'functionapp'
      functionWorkerRuntime: 'dotnet-isolated'
      runtimeVersion: '8.0'
    }
  }
]
