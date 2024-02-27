metadata name = 'DevTest Lab Virtual Networks'
metadata description = '''This module deploys a DevTest Lab Virtual Network.

Lab virtual machines must be deployed into a virtual network. This resource type allows configuring the virtual network and subnet settings used for the lab virtual machines.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@sys.description('Required. The name of the virtual network.')
param name string

@sys.description('Required. The resource ID of the virtual network.')
param externalProviderResourceId string

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Optional. The description of the virtual network.')
param description string = ''

@sys.description('Optional. The allowed subnets of the virtual network.')
param allowedSubnets array = []

@sys.description('Optional. The subnet overrides of the virtual network.')
param subnetOverrides array = []

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource virtualNetwork 'Microsoft.DevTestLab/labs/virtualnetworks@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    description: description
    externalProviderResourceId: externalProviderResourceId
    allowedSubnets: allowedSubnets
    subnetOverrides: subnetOverrides
  }
}

@sys.description('The name of the lab virtual network.')
output name string = virtualNetwork.name

@sys.description('The resource ID of the lab virtual network.')
output resourceId string = virtualNetwork.id

@sys.description('The name of the resource group the lab virtual network was created in.')
output resourceGroupName string = resourceGroup().name
