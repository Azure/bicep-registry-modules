metadata name = 'Virtual Hub Route Tables'
metadata description = 'This module deploys a Virtual Hub Route Table.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The route table name.')
param name string

@description('Conditional. The name of the parent virtual hub. Required if the template is used in a standalone deployment.')
param virtualHubName string

@description('Optional. List of labels associated with this route table.')
param labels array = []

@description('Optional. List of all routes.')
param routes array = []

resource virtualHub 'Microsoft.Network/virtualHubs@2022-11-01' existing = {
  name: virtualHubName
}

resource hubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2022-11-01' = {
  name: name
  parent: virtualHub
  properties: {
    labels: !empty(labels) ? labels : null
    routes: !empty(routes) ? routes : null
  }
}

@description('The name of the deployed virtual hub route table.')
output name string = hubRouteTable.name

@description('The resource ID of the deployed virtual hub route table.')
output resourceId string = hubRouteTable.id

@description('The resource group the virtual hub route table was deployed into.')
output resourceGroupName string = resourceGroup().name
