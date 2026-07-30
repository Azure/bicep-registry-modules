metadata name = 'Network Manager Network Group Static Members'
metadata description = '''This module deploys a Network Manager Network Group Static Member.
Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks.'''

@description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@description('Conditional. The name of the parent network group. Required if the template is used in a standalone deployment.')
param networkGroupName string

@description('Required. The name of the static member.')
param name string

@description('Required. Resource ID of the virtual network.')
param resourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-nwmgr-nwgrpstaticmember.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource networkManager 'Microsoft.Network/networkManagers@2025-05-01' existing = {
  name: networkManagerName

  resource networkGroup 'networkGroups' existing = {
    name: networkGroupName
  }
}

resource staticMember 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2025-05-01' = {
  name: name
  parent: networkManager::networkGroup
  properties: {
    resourceId: resourceId
  }
}

@description('The name of the deployed static member.')
output name string = staticMember.name

@description('The resource ID of the deployed static member.')
output resourceId string = staticMember.id

@description('The resource group the static member was deployed into.')
output resourceGroupName string = resourceGroup().name
