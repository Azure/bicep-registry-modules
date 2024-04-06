metadata name = 'Network Manager Scope Connections'
metadata description = '''This module deploys a Network Manager Scope Connection.
Create a cross-tenant connection to manage a resource from another tenant.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the scope connection.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the scope connection.')
param description string?

@sys.description('Required. Enter the subscription or management group resource ID that you want to add to this network manager\'s scope.')
param resourceId string

@sys.description('Required. Tenant ID of the subscription or management group that you want to manage.')
param tenantId string

resource networkManager 'Microsoft.Network/networkManagers@2023-04-01' existing = {
  name: networkManagerName
}

resource scopeConnection 'Microsoft.Network/networkManagers/scopeConnections@2023-04-01' = {
  name: name
  parent: networkManager
  properties: {
    description: description ?? ''
    resourceId: resourceId
    tenantId: tenantId
  }
}

@sys.description('The name of the deployed scope connection.')
output name string = scopeConnection.name

@sys.description('The resource ID of the deployed scope connection.')
output resourceId string = scopeConnection.id

@sys.description('The resource group the scope connection was deployed into.')
output resourceGroupName string = resourceGroup().name
