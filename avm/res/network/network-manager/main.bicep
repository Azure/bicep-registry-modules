metadata name = 'Network Managers'
metadata description = 'This module deploys a Network Manager.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. Name of the Network Manager.')
@minLength(1)
@maxLength(64)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Tags of the resource.')
param tags object?

@maxLength(500)
@sys.description('Optional. A description of the network manager.')
param description string = ''

@sys.description('Required. Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs.')
param networkManagerScopeAccesses array

@sys.description('Required. Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment.')
param networkManagerScopes object

@sys.description('Conditional. Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.')
param networkGroups array = []

@sys.description('Optional. Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.')
param connectivityConfigurations array = []

@sys.description('Optional. Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.')
param scopeConnections array = []

@sys.description('Optional. Security Admin Configurations, Rule Collections and Rules to create for the network manager. Azure Virtual Network Manager provides two different types of configurations you can deploy across your virtual networks, one of them being a SecurityAdmin configuration. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.')
param securityAdminConfigurations array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource networkManager 'Microsoft.Network/networkManagers@2023-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    networkManagerScopeAccesses: networkManagerScopeAccesses
    networkManagerScopes: networkManagerScopes
  }
}

module networkManager_networkGroups 'network-group/main.bicep' = [for (networkGroup, index) in networkGroups: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-NetworkGroups-${index}'
  params: {
    name: networkGroup.name
    networkManagerName: networkManager.name
    description: contains(networkGroup, 'description') ? networkGroup.description : ''
    staticMembers: contains(networkGroup, 'staticMembers') ? networkGroup.staticMembers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module networkManager_connectivityConfigurations 'connectivity-configuration/main.bicep' = [for (connectivityConfiguration, index) in connectivityConfigurations: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-ConnectivityConfigurations-${index}'
  params: {
    name: connectivityConfiguration.name
    networkManagerName: networkManager.name
    description: contains(connectivityConfiguration, 'description') ? connectivityConfiguration.description : ''
    appliesToGroups: connectivityConfiguration.appliesToGroups
    connectivityTopology: connectivityConfiguration.connectivityTopology
    hubs: contains(connectivityConfiguration, 'hubs') ? connectivityConfiguration.hubs : []
    deleteExistingPeering: contains(connectivityConfiguration, 'hubs') && (connectivityConfiguration.connectivityTopology == 'HubAndSpoke') ? connectivityConfiguration.deleteExistingPeering : 'False'
    isGlobal: contains(connectivityConfiguration, 'isGlobal') ? connectivityConfiguration.isGlobal : 'False'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: networkManager_networkGroups
}]

module networkManager_scopeConnections 'scope-connection/main.bicep' = [for (scopeConnection, index) in scopeConnections: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-ScopeConnections-${index}'
  params: {
    name: scopeConnection.name
    networkManagerName: networkManager.name
    description: contains(scopeConnection, 'description') ? scopeConnection.description : ''
    resourceId: scopeConnection.resourceId
    tenantId: scopeConnection.tenantId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module networkManager_securityAdminConfigurations 'security-admin-configuration/main.bicep' = [for (securityAdminConfiguration, index) in securityAdminConfigurations: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-SecurityAdminConfigurations-${index}'
  params: {
    name: securityAdminConfiguration.name
    networkManagerName: networkManager.name
    description: contains(securityAdminConfiguration, 'description') ? securityAdminConfiguration.description : ''
    applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.applyOnNetworkIntentPolicyBasedServices
    ruleCollections: contains(securityAdminConfiguration, 'ruleCollections') ? securityAdminConfiguration.ruleCollections : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: networkManager_networkGroups
}]

resource networkManager_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkManager
}

resource networkManager_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(networkManager.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: networkManager
}]

@sys.description('The resource group the network manager was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the network manager.')
output resourceId string = networkManager.id

@sys.description('The name of the network manager.')
output name string = networkManager.name

@sys.description('The location the resource was deployed into.')
output location string = networkManager.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
