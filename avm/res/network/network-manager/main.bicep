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

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Tags of the resource.')
param tags object?

@maxLength(500)
@sys.description('Optional. A description of the Network Manager.')
param description string = ''

@sys.description('Required. Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs.')
param networkManagerScopeAccesses networkManagerScopeAccessType

@sys.description('Required. Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. Must contain at least one management group or subscription.')
param networkManagerScopes networkManagerScopesType

@sys.description('Conditional. Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.')
param networkGroups networkGroupType

@sys.description('Optional. Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.')
param connectivityConfigurations connectivityConfigurationsType

@sys.description('Optional. Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.')
param scopeConnections scopeConnectionType

@sys.description('Optional. Security Admin Configurations, Rule Collections and Rules to create for the network manager. Azure Virtual Network Manager provides two different types of configurations you can deploy across your virtual networks, one of them being a SecurityAdmin configuration. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.')
param securityAdminConfigurations securityAdminConfigurationsType

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'IPAM Pool Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7b3e853f-ad5d-4fb5-a7b8-56a3581c7037'
  )
  'LocalNGFirewallAdministrator role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a8835c7d-b5cb-47fa-b6f0-65ea10ce07a2'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-networkmanager.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkManager 'Microsoft.Network/networkManagers@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    networkManagerScopeAccesses: networkManagerScopeAccesses
    networkManagerScopes: networkManagerScopes
  }
}

module networkManager_networkGroups 'network-group/main.bicep' = [
  for (networkGroup, index) in networkGroups ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-NetworkGroups-${index}'
    params: {
      name: networkGroup.name
      networkManagerName: networkManager.name
      description: networkGroup.?description ?? ''
      staticMembers: networkGroup.?staticMembers
    }
  }
]

module networkManager_connectivityConfigurations 'connectivity-configuration/main.bicep' = [
  for (connectivityConfiguration, index) in connectivityConfigurations ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-ConnectivityConfigurations-${index}'
    params: {
      name: connectivityConfiguration.name
      networkManagerName: networkManager.name
      description: connectivityConfiguration.?description ?? ''
      appliesToGroups: connectivityConfiguration.?appliesToGroups ?? []
      connectivityTopology: connectivityConfiguration.connectivityTopology
      hubs: connectivityConfiguration.?hubs ?? []
      deleteExistingPeering: connectivityConfiguration.?deleteExistingPeering ?? false
      isGlobal: connectivityConfiguration.?isGlobal ?? false
    }
    dependsOn: networkManager_networkGroups
  }
]

module networkManager_scopeConnections 'scope-connection/main.bicep' = [
  for (scopeConnection, index) in scopeConnections ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-ScopeConnections-${index}'
    params: {
      name: scopeConnection.name
      networkManagerName: networkManager.name
      description: scopeConnection.?description ?? ''
      resourceId: scopeConnection.resourceId
      tenantId: scopeConnection.tenantId
    }
  }
]

module networkManager_securityAdminConfigurations 'security-admin-configuration/main.bicep' = [
  for (securityAdminConfiguration, index) in securityAdminConfigurations ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-SecurityAdminConfigurations-${index}'
    params: {
      name: securityAdminConfiguration.name
      networkManagerName: networkManager.name
      description: securityAdminConfiguration.?description ?? ''
      applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.applyOnNetworkIntentPolicyBasedServices
      ruleCollections: securityAdminConfiguration.?ruleCollections ?? []
    }
    dependsOn: networkManager_networkGroups
  }
]

resource networkManager_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkManager
}

resource networkManager_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(networkManager.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkManager
  }
]

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
  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type networkGroupType = {
  @sys.description('Required. The name of the network group.')
  name: string

  @sys.description('Optional. A description of the network group.')
  description: string?

  @sys.description('Optional. Static Members to create for the network group. Contains virtual networks to add to the network group.')
  staticMembers: {
    @sys.description('Required. The name of the static member.')
    name: string

    @sys.description('Required. Resource ID of the virtual network.')
    resourceId: string
  }[]?
}[]?

type networkManagerScopeAccessType = ('Connectivity' | 'SecurityAdmin')[]

type networkManagerScopesType = {
  @sys.description('Conditional.  List of fully qualified IDs of management groups to assign to the network manager to manage. Required if `subscriptions` is not provided. Fully qualified ID format: \'/providers/Microsoft.Management/managementGroups/{managementGroupId}\'.')
  managementGroups: string[]?

  @sys.description('Conditional. List of fully qualified IDs of Subscriptions to assign to the network manager to manage. Required if `managementGroups` is not provided. Fully qualified ID format: \'/subscriptions/{subscriptionId}\'.')
  subscriptions: string[]?
}

type scopeConnectionType = {
  @sys.description('Required. The name of the scope connection.')
  name: string

  @sys.description('Optional. A description of the scope connection.')
  description: string?

  @sys.description('Required. Enter the subscription or management group resource ID that you want to add to this network manager\'s scope.')
  resourceId: string

  @sys.description('Required. Tenant ID of the subscription or management group that you want to manage.')
  tenantId: string
}[]?

type connectivityConfigurationsType = {
  @sys.description('Required. The name of the connectivity configuration.')
  name: string

  @sys.description('Optional. A description of the connectivity configuration.')
  description: string?

  @sys.description('Required. Network Groups for the configuration. A connectivity configuration must be associated to at least one network group.')
  appliesToGroups: {
    @sys.description('Required. Group connectivity type.')
    groupConnectivity: ('DirectlyConnected' | 'None')

    @sys.description('Optional. Flag if global is supported.')
    isGlobal: bool?

    @sys.description('Required. Resource Id of the network group.')
    networkGroupResourceId: string

    @sys.description('Optional. Flag if use hub gateway.')
    useHubGateway: bool?
  }[]

  @sys.description('Required. The connectivity topology to apply the configuration to.')
  connectivityTopology: ('HubAndSpoke' | 'Mesh')

  @sys.description('Optional. The hubs to apply the configuration to.')
  hubs: {
    @sys.description('Required. Resource Id of the hub.')
    resourceId: string

    @sys.description('Required. Resource type of the hub.')
    resourceType: 'Microsoft.Network/virtualNetworks'
  }[]?

  @sys.description('Optional. Delete existing peering connections.')
  deleteExistingPeering: bool?

  @sys.description('Optional. Is global configuration.')
  isGlobal: bool?
}[]?

type securityAdminConfigurationsType = {
  @sys.description('Required. The name of the security admin configuration.')
  name: string

  @sys.description('Optional. A description of the security admin configuration.')
  description: string?

  @sys.description('Required. Apply on network intent policy based services.')
  applyOnNetworkIntentPolicyBasedServices: ('None' | 'All' | 'AllowRulesOnly')[]

  @sys.description('Optional. Rule collections to create for the security admin configuration.')
  ruleCollections: {
    @sys.description('Required. The name of the admin rule collection.')
    name: string

    @sys.description('Optional. A description of the admin rule collection.')
    description: string?

    @sys.description('Required. List of network groups for configuration. An admin rule collection must be associated to at least one network group.')
    appliesToGroups: {
      @sys.description('Required. The resource ID of the network group.')
      networkGroupResourceId: string
    }[]

    @sys.description('Optional. List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.')
    rules: {
      @sys.description('Required. The name of the rule.')
      name: string

      @sys.description('Required. Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs.')
      access: 'Allow' | 'AlwaysAllow' | 'Deny'

      @sys.description('Optional. A description of the rule.')
      description: string?

      @sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
      destinationPortRanges: string[]?

      @sys.description('Optional. The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.')
      destinations: {
        @sys.description('Required. Address prefix type.')
        addressPrefixType: 'IPPrefix' | 'ServiceTag'

        @sys.description('Required. Address prefix.')
        addressPrefix: string
      }[]?

      @sys.description('Required. Indicates if the traffic matched against the rule in inbound or outbound.')
      direction: 'Inbound' | 'Outbound'

      @minValue(1)
      @maxValue(4096)
      @sys.description('Required. The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
      priority: int

      @sys.description('Required. Network protocol this rule applies to.')
      protocol: 'Ah' | 'Any' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp'

      @sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
      sourcePortRanges: string[]?

      @sys.description('Optional. The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.')
      sources: {
        @sys.description('Required. Address prefix type.')
        addressPrefixType: 'IPPrefix' | 'ServiceTag'

        @sys.description('Required. Address prefix.')
        addressPrefix: string
      }[]?
    }[]?
  }[]?
}[]?
