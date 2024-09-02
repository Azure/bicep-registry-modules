metadata name = 'Network Manager Connectivity Configurations'
metadata description = '''This module deploys a Network Manager Connectivity Configuration.
Connectivity configurations define hub-and-spoke or mesh topologies applied to one or more network groups.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the connectivity configuration.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the connectivity configuration.')
param description string?

@sys.description('Required. Network Groups for the configuration. A connectivity configuration must be associated to at least one network group.')
param appliesToGroups appliesToGroupsType

@allowed([
  'HubAndSpoke'
  'Mesh'
])
@sys.description('Required. Connectivity topology type.')
param connectivityTopology string

@sys.description('Conditional. List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke".')
param hubs hubsType

@sys.description('Optional. Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke".')
param deleteExistingPeering bool = false

@sys.description('Optional. Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions.')
param isGlobal bool = false

resource networkManager 'Microsoft.Network/networkManagers@2023-11-01' existing = {
  name: networkManagerName
}

resource connectivityConfiguration 'Microsoft.Network/networkManagers/connectivityConfigurations@2023-11-01' = {
  name: name
  parent: networkManager
  properties: {
    appliesToGroups: map(appliesToGroups, (group) => {
      groupConnectivity: group.groupConnectivity
      isGlobal: string(group.isGlobal) ?? 'false'
      networkGroupId: any(group.networkGroupResourceId)
      useHubGateway: string(group.useHubGateway) ?? 'false'
    })
    connectivityTopology: connectivityTopology
    deleteExistingPeering: connectivityTopology == 'HubAndSpoke' ? string(deleteExistingPeering) : 'false'
    description: description ?? ''
    hubs: connectivityTopology == 'HubAndSpoke' ? hubs : []
    isGlobal: string(isGlobal)
  }
}

@sys.description('The name of the deployed connectivity configuration.')
output name string = connectivityConfiguration.name

@sys.description('The resource ID of the deployed connectivity configuration.')
output resourceId string = connectivityConfiguration.id

@sys.description('The resource group the connectivity configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type appliesToGroupsType = {
  @sys.description('Required. Group connectivity type.')
  groupConnectivity: ('DirectlyConnected' | 'None')

  @sys.description('Optional. Flag if global is supported.')
  isGlobal: bool?

  @sys.description('Required. Resource Id of the network group.')
  networkGroupResourceId: string

  @sys.description('Optional. Flag if use hub gateway.')
  useHubGateway: bool?
}[]

type hubsType = {
  @sys.description('Required. Resource Id of the hub.')
  resourceId: string

  @sys.description('Required. Resource type of the hub.')
  resourceType: 'Microsoft.Network/virtualNetworks'
}[]?
