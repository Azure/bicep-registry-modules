targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'Deploys Premium with system-assigned identity and references the service-provisioned default workspace.'

@description('Optional. Test resource group name.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.aigateway-${serviceShort}-rg'
@description('Optional. A region with AI Gateway preview availability.')
param resourceLocation string = deployment().location
@description('Optional. Short test scenario identifier.')
param serviceShort string = 'aigwmin'
@description('Optional. Resource-name token substituted by the AVM test harness. Use lowercase alphanumeric characters.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    scope: resourceGroup
    params: {
      name: '${namePrefix}${serviceShort}001'
    }
  }
]
