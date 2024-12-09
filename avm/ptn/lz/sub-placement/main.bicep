metadata name = 'subscription-placement'
metadata description = 'This module allows for placement of subscriptions to management groups '
metadata owner = 'Azure/module-maintainers'

targetScope = 'tenant'

@description('Required. Type definition for management group child containing management group ID and subscription IDs.')
type typMgChild = {
  @description('Required.The ID of the management group.')
  managementGroupId: string
  @description('Required.The list of subscription IDs.')
  subscriptionIds: string[]
}[]

@description('Required. Type definition for management group child containing management group ID and subscription IDs.')
param parSubscriptionPlacement typMgChild = [
  {
    managementGroupId: 'Group1'
    subscriptionIds: ['SUBID1', 'SUBID2']
  }
  {
    managementGroupId: 'Group2'
    subscriptionIds: ['SUBID3']
  }
]

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.lz-subplacement.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module customsubscriptionPlacement './modules/helper.bicep' = [
  for (subscriptionPlacement, index) in parSubscriptionPlacement: {
    name: 'subPlacement${index}'
    params: {
      managementGroupId: subscriptionPlacement.managementGroupId
      subscriptionIds: subscriptionPlacement.subscriptionIds
    }
  }
]

@description('Output of number of management groups that have been configured with subscription placements.')
output subscriptionPlacementSummary string = 'Subscription placements have been configured for ${length(parSubscriptionPlacement)} management groups.'
