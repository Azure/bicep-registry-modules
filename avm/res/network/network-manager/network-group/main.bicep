metadata name = 'Network Manager Network Groups'
metadata description = '''This module deploys a Network Manager Network Group.
A network group is a collection of same-type network resources that you can associate with network manager configurations. You can add same-type network resources after you create the network group.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the network group.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the network group.')
param description string?

@sys.description('Optional. Static Members to create for the network group. Contains virtual networks to add to the network group.')
param staticMembers staticMembersType

resource networkManager 'Microsoft.Network/networkManagers@2023-04-01' existing = {
  name: networkManagerName
}

resource networkGroup 'Microsoft.Network/networkManagers/networkGroups@2023-04-01' = {
  name: name
  parent: networkManager
  properties: {
    description: description ?? ''
  }
}

module networkGroup_staticMembers 'static-member/main.bicep' = [
  for (staticMember, index) in staticMembers ?? []: {
    name: '${uniqueString(deployment().name)}-NetworkGroup-StaticMembers-${index}'
    params: {
      networkManagerName: networkManager.name
      networkGroupName: networkGroup.name
      name: staticMember.name
      resourceId: staticMember.resourceId
    }
  }
]

@sys.description('The name of the deployed network group.')
output name string = networkGroup.name

@sys.description('The resource ID of the deployed network group.')
output resourceId string = networkGroup.id

@sys.description('The resource group the network group was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type staticMembersType = {
  @sys.description('Required. The name of the static member.')
  name: string

  @sys.description('Required. Resource ID of the virtual network.')
  resourceId: string
}[]?
