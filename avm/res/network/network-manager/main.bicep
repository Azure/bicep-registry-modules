metadata name = 'Network Managers'
metadata description = 'This module deploys a Network Manager.'

@sys.description('Required. Name of the Network Manager.')
@minLength(1)
@maxLength(64)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@sys.description('Optional. Tags of the resource.')
param tags object?

@maxLength(500)
@sys.description('Optional. A description of the Network Manager.')
param description string = ''

@sys.description('Optional. Scope Access (Also known as features). String array containing any of "Connectivity", "SecurityAdmin", or "Routing". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs. The routing feature allows you to describe your desired routing behavior and orchestrate user-defined routes (UDRs) to create and maintain the desired routing behavior. If none of the features are required, then this parameter does not need to be specified, which then only enables features like "IPAM" and "Virtual Network Verifier".')
param networkManagerScopeAccesses networkManagerScopeAccessType

@sys.description('Required. Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. Must contain at least one management group or subscription.')
param networkManagerScopes networkManagerScopesType

@sys.description('Conditional. Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.')
param networkGroups networkGroupType

@sys.description('Optional. Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.')
param connectivityConfigurations connectivityConfigurationsType

@sys.description('Optional. Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.')
param scopeConnections scopeConnectionType

@sys.description('Optional. Security Admin Configurations requires enabling the "SecurityAdmin" feature on Network Manager. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.')
param securityAdminConfigurations securityAdminConfigurationsType

@sys.description('Optional. Routing Configurations requires enabling the "Routing" feature on Network Manager. A routing configuration contains a set of rule collections. Each rule collection contains one or more routing rules.')
param routingConfigurations routingConfigurationsType

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'IPAM Pool User': subscriptionResourceId(
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

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
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

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' = {
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
      description: networkGroup.?description
      staticMembers: networkGroup.?staticMembers
      memberType: networkGroup.?memberType ?? 'VirtualNetwork'
    }
  }
]

module networkManager_connectivityConfigurations 'connectivity-configuration/main.bicep' = [
  for (connectivityConfiguration, index) in connectivityConfigurations ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-ConnectivityConfigurations-${index}'
    params: {
      name: connectivityConfiguration.name
      networkManagerName: networkManager.name
      description: connectivityConfiguration.?description
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
      description: scopeConnection.?description
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
      description: securityAdminConfiguration.?description
      applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.applyOnNetworkIntentPolicyBasedServices
      ruleCollections: securityAdminConfiguration.?ruleCollections ?? []
    }
    dependsOn: networkManager_networkGroups
  }
]

module networkManager_routingConfigurations 'routing-configuration/main.bicep' = [
  for (routingConfiguration, index) in routingConfigurations ?? []: {
    name: '${uniqueString(deployment().name, location)}-NetworkManager-RoutingConfigurations-${index}'
    params: {
      name: routingConfiguration.name
      networkManagerName: networkManager.name
      description: routingConfiguration.?description
      ruleCollections: routingConfiguration.?ruleCollections ?? []
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
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(networkManager.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
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

import { staticMembersType } from 'network-group/main.bicep'
type networkGroupType = {
  @sys.description('Required. The name of the network group.')
  name: string

  @sys.description('Optional. A description of the network group.')
  description: string?

  @sys.description('Optional. The type of the group member. Subnet member type is used for routing configurations.')
  memberType: ('Subnet' | 'VirtualNetwork')?

  @sys.description('Optional. Static Members to create for the network group. Contains virtual networks to add to the network group.')
  staticMembers: staticMembersType?
}[]?

type networkManagerScopeAccessType = ('Connectivity' | 'SecurityAdmin' | 'Routing')[]?

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

import { appliesToGroupsType, hubsType } from 'connectivity-configuration/main.bicep'
type connectivityConfigurationsType = {
  @sys.description('Required. The name of the connectivity configuration.')
  name: string

  @sys.description('Optional. A description of the connectivity configuration.')
  description: string?

  @sys.description('Required. Network Groups for the configuration. A connectivity configuration must be associated to at least one network group.')
  appliesToGroups: appliesToGroupsType

  @sys.description('Required. The connectivity topology to apply the configuration to.')
  connectivityTopology: ('HubAndSpoke' | 'Mesh')

  @sys.description('Optional. The hubs to apply the configuration to.')
  hubs: hubsType?

  @sys.description('Optional. Delete existing peering connections.')
  deleteExistingPeering: bool?

  @sys.description('Optional. Is global configuration.')
  isGlobal: bool?
}[]?

import { applyOnNetworkIntentPolicyBasedServicesType, securityAdminConfigurationRuleCollectionType } from 'security-admin-configuration/main.bicep'
type securityAdminConfigurationsType = {
  @sys.description('Required. The name of the security admin configuration.')
  name: string

  @sys.description('Optional. A description of the security admin configuration.')
  description: string?

  @sys.description('Required. Apply on network intent policy based services.')
  applyOnNetworkIntentPolicyBasedServices: applyOnNetworkIntentPolicyBasedServicesType

  @sys.description('Optional. Rule collections to create for the security admin configuration.')
  ruleCollections: securityAdminConfigurationRuleCollectionType?
}[]?

import { routingConfigurationRuleCollectionType } from 'routing-configuration/main.bicep'
type routingConfigurationsType = {
  @sys.description('Required. The name of the routing configuration.')
  name: string

  @sys.description('Optional. A description of the routing configuration.')
  description: string?

  @sys.description('Optional. Rule collections to create for the routing configuration.')
  ruleCollections: routingConfigurationRuleCollectionType?
}[]?
