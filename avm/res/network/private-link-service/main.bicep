metadata name = 'Private Link Services'
metadata description = 'This module deploys a Private Link Service.'

@description('Required. The name of the private link service to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags resourceInput<'Microsoft.Network/privateLinkServices@2025-05-01'>.tags?

@minLength(1)
@description('Required. An array of private link service IP configurations. At least one IP configuration is required on the private link service.')
param ipConfigurations ipConfigurationType[]

@description('Optional. Resource IDs of the Standard Load Balancer frontend IP configurations that the Private Link service is tied to. All traffic destined for the service reaches the load balancer frontend, where SLB rules direct it to backend pools. Mutually exclusive with `destinationIPAddress`.')
param loadBalancerFrontendIpConfigurationResourceIds string[]?

@description('Optional. The extended location of the load balancer.')
param extendedLocation extendedLocationType?

@description('Optional. The list of subscription IDs allowed to automatically approve a connection to the private link service. Use `*` to auto-approve all subscriptions.')
param autoApprovalSubscriptionIds string[]?

@description('Optional. Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.')
param enableProxyProtocol bool = false

@description('Optional. The list of Fqdn.')
param fqdns string[]?

@description('Optional. The list of subscription IDs the private link service is visible to. Service providers can limit exposure to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions by using `*`.')
param visibilitySubscriptionIds string[]?

@description('Optional. The access mode of the private link service. Defaults to "Default" when not specified.')
param accessMode ('Default' | 'Restricted')?

@description('Optional. Privately routable destination IP for Private Link Service Direct Connect mode, used when consumers need direct IP routing instead of load-balancer forwarding (e.g. databases, legacy applications, on-premises endpoints). Mutually exclusive with `loadBalancerFrontendIpConfigurations`.')
param destinationIPAddress string?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  )
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-privatelinkservice.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource privateLinkService 'Microsoft.Network/privateLinkServices@2025-05-01' = {
  name: name
  location: location
  tags: tags
  extendedLocation: extendedLocation
  properties: {
    accessMode: accessMode
    autoApproval: !empty(autoApprovalSubscriptionIds) ? { subscriptions: autoApprovalSubscriptionIds } : null
    destinationIPAddress: destinationIPAddress
    enableProxyProtocol: enableProxyProtocol
    fqdns: fqdns
    ipConfigurations: [
      for ipConfig in ipConfigurations: {
        name: ipConfig.name
        properties: {
          primary: ipConfig.?primary
          privateIPAddressVersion: ipConfig.?privateIPAddressVersion
          privateIPAllocationMethod: ipConfig.?privateIPAllocationMethod
          privateIPAddress: ipConfig.?privateIPAddress
          subnet: {
            id: ipConfig.subnetResourceId
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: !empty(loadBalancerFrontendIpConfigurationResourceIds)
      ? map(loadBalancerFrontendIpConfigurationResourceIds ?? [], resourceId => {
          id: resourceId
        })
      : null
    visibility: !empty(visibilitySubscriptionIds) ? { subscriptions: visibilitySubscriptionIds } : null
  }
}

resource privateLinkService_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: privateLinkService
}

resource privateLinkService_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      privateLinkService.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: privateLinkService
  }
]

@description('The resource group the private link service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the private link service.')
output resourceId string = privateLinkService.id

@description('The name of the private link service.')
output name string = privateLinkService.name

@description('The location the resource was deployed into.')
output location string = privateLinkService.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a private link service IP configuration.')
type ipConfigurationType = {
  @description('Required. The name of the private link service IP configuration.')
  name: string

  @description('Optional. Whether the IP configuration is primary or not.')
  primary: bool?

  @description('Optional. Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4.')
  privateIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The private IP address allocation method.')
  privateIPAllocationMethod: ('Dynamic' | 'Static')?

  @description('Optional. The private IP address of the IP configuration.')
  privateIPAddress: string?

  @description('Required. The resource ID of the subnet to attach the IP configuration to.')
  subnetResourceId: string
}

@export()
@description('The type of the extended location of the load balancer.')
type extendedLocationType = {
  @description('Required. The name of the extended location.')
  name: string

  @description('Required. The type of the extended location.')
  type: 'EdgeZone'
}
