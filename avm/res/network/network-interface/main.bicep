metadata name = 'Network Interface'
metadata description = 'This module deploys a Network Interface.'

@description('Required. The name of the network interface.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Indicates whether IP forwarding is enabled on this network interface.')
param enableIPForwarding bool = false

@description('Optional. If the network interface is accelerated networking enabled.')
param enableAcceleratedNetworking bool = false

@description('Optional. List of DNS servers IP addresses. Use \'AzureProvidedDNS\' to switch to azure provided DNS resolution. \'AzureProvidedDNS\' value cannot be combined with other IPs, it must be the only value in dnsServers collection.')
param dnsServers string[] = []

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

@allowed([
  'Floating'
  'MaxConnections'
  'None'
])
@description('Optional. Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.')
param auxiliaryMode string = 'None'

@allowed([
  'A1'
  'A2'
  'A4'
  'A8'
  'None'
])
@description('Optional. Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.')
param auxiliarySku string = 'None'

@description('Optional. Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true.')
param disableTcpStateTracking bool = false

@description('Required. A list of IPConfigurations of the network interface.')
param ipConfigurations networkInterfaceIPConfigurationType[]

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

// =========== //
// Variables   //
// =========== //

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DNS Resolver Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d'
  )
  'DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'befefa01-2a29-4197-83a8-272ff33ce314'
  )
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

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' existing = [
  for (ipConfiguration, index) in ipConfigurations: if (contains(ipConfiguration, 'publicIPAddressResourceId') && (ipConfiguration.?publicIPAddressResourceId != null)) {
    name: last(split(ipConfiguration.?publicIPAddressResourceId ?? '', '/'))
    scope: resourceGroup(split(ipConfiguration.?publicIPAddressResourceId ?? '', '/')[4])
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-networkinterface.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    auxiliaryMode: auxiliaryMode
    auxiliarySku: auxiliarySku
    disableTcpStateTracking: disableTcpStateTracking
    dnsSettings: !empty(dnsServers)
      ? {
          dnsServers: dnsServers
        }
      : null
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableIPForwarding: enableIPForwarding
    networkSecurityGroup: !empty(networkSecurityGroupResourceId)
      ? {
          id: networkSecurityGroupResourceId
        }
      : null
    ipConfigurations: [
      for (ipConfiguration, index) in ipConfigurations: {
        name: ipConfiguration.?name ?? 'ipconfig${padLeft((index + 1), 2, '0')}'
        properties: {
          primary: index == 0 ? true : false
          privateIPAllocationMethod: ipConfiguration.?privateIPAllocationMethod
          privateIPAddress: ipConfiguration.?privateIPAddress
          publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId')
            ? (ipConfiguration.?publicIPAddressResourceId != null
                ? {
                    #disable-next-line use-resource-id-functions // the resource id is provided via a parameter
                    id: ipConfiguration.?publicIPAddressResourceId
                  }
                : null)
            : null
          subnet: {
            #disable-next-line use-resource-id-functions // the resource id is provided via a parameter
            id: ipConfiguration.subnetResourceId
          }
          loadBalancerBackendAddressPools: ipConfiguration.?loadBalancerBackendAddressPools
          applicationSecurityGroups: ipConfiguration.?applicationSecurityGroups
          applicationGatewayBackendAddressPools: ipConfiguration.?applicationGatewayBackendAddressPools
          gatewayLoadBalancer: ipConfiguration.?gatewayLoadBalancer
          loadBalancerInboundNatRules: ipConfiguration.?loadBalancerInboundNatRules
          privateIPAddressVersion: ipConfiguration.?privateIPAddressVersion
          virtualNetworkTaps: ipConfiguration.?virtualNetworkTaps
        }
      }
    ]
  }
}

resource networkInterface_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkInterface
}

resource networkInterface_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: networkInterface
  }
]

resource networkInterface_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(networkInterface.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkInterface
  }
]

// =========== //
// Outputs     //
// =========== //
@description('The name of the deployed resource.')
output name string = networkInterface.name

@description('The resource ID of the deployed resource.')
output resourceId string = networkInterface.id

@description('The resource group of the deployed resource.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = networkInterface.location

@description('The list of IP configurations of the network interface.')
output ipConfigurations networkInterfaceIPConfigurationOutputType[] = [
  for (ipConfiguration, index) in ipConfigurations: {
    name: networkInterface.properties.ipConfigurations[index].name
    privateIP: networkInterface.properties.ipConfigurations[index].properties.?privateIPAddress ?? ''
    publicIP: (contains(ipConfiguration, 'publicIPAddressResourceId') && (ipConfiguration.?publicIPAddressResourceId != null))
      ? publicIp[index].properties.ipAddress ?? ''
      : ''
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
@description('The resource ID of the deployed resource.')
type networkInterfaceIPConfigurationType = {
  @description('Optional. The name of the IP configuration.')
  name: string?

  @description('Optional. The private IP address allocation method.')
  privateIPAllocationMethod: ('Dynamic' | 'Static')?

  @description('Optional. The private IP address.')
  privateIPAddress: string?

  @description('Optional. The resource ID of the public IP address.')
  publicIPAddressResourceId: string?

  @description('Required. The resource ID of the subnet.')
  subnetResourceId: string

  @description('Optional. Array of load balancer backend address pools.')
  loadBalancerBackendAddressPools: backendAddressPoolType[]?

  @description('Optional. A list of references of LoadBalancerInboundNatRules.')
  loadBalancerInboundNatRules: inboundNatRuleType[]?

  @description('Optional. Application security groups in which the IP configuration is included.')
  applicationSecurityGroups: applicationSecurityGroupType[]?

  @description('Optional. The reference to Application Gateway Backend Address Pools.')
  applicationGatewayBackendAddressPools: applicationGatewayBackendAddressPoolsType[]?

  @description('Optional. The reference to gateway load balancer frontend IP.')
  gatewayLoadBalancer: subResourceType?

  @description('Optional. Whether the specific IP configuration is IPv4 or IPv6.')
  privateIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The reference to Virtual Network Taps.')
  virtualNetworkTaps: virtualNetworkTapType[]?
}

@export()
@description('The type for a backend address pool.')
type backendAddressPoolType = {
  @description('Optional. The resource ID of the backend address pool.')
  id: string?

  @description('Optional. The name of the backend address pool.')
  name: string?

  @description('Optional. The properties of the backend address pool.')
  properties: object?
}

@export()
@description('The type for the application security group.')
type applicationSecurityGroupType = {
  @description('Optional. Resource ID of the application security group.')
  id: string?

  @description('Optional. Location of the application security group.')
  location: string?

  @description('Optional. Properties of the application security group.')
  properties: object?

  @description('Optional. Tags of the application security group.')
  tags: object?
}

@export()
@description('The type for the application gateway backend address pool.')
type applicationGatewayBackendAddressPoolsType = {
  @description('Optional. Resource ID of the backend address pool.')
  id: string?

  @description('Optional. Name of the backend address pool that is unique within an Application Gateway.')
  name: string?

  @description('Optional. Properties of the application gateway backend address pool.')
  properties: {
    @description('Optional. Backend addresses.')
    backendAddresses: {
      @description('Optional. IP address of the backend address.')
      ipAddress: string?

      @description('Optional. FQDN of the backend address.')
      fqdn: string?
    }[]?
  }?
}

@export()
@description('The type for the sub resource.')
type subResourceType = {
  @description('Optional. Resource ID of the sub resource.')
  id: string?
}

@export()
@description('The type for the inbound NAT rule.')
type inboundNatRuleType = {
  @description('Optional. Resource ID of the inbound NAT rule.')
  id: string?

  @description('Optional. Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource.')
  name: string?

  @description('Optional. Properties of the inbound NAT rule.')
  properties: {
    @description('Optional. A reference to backendAddressPool resource.')
    backendAddressPool: subResourceType?

    @description('Optional. The port used for the internal endpoint. Acceptable values range from 1 to 65535.')
    backendPort: int?

    @description('Optional. Configures a virtual machine\'s endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can\'t be changed after you create the endpoint.')
    enableFloatingIP: bool?

    @description('Optional. Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.')
    enableTcpReset: bool?

    @description('Optional. A reference to frontend IP addresses.')
    frontendIPConfiguration: subResourceType?

    @description('Optional. The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534.')
    frontendPort: int?

    @description('Optional. The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.')
    frontendPortRangeStart: int?

    @description('Optional. The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.')
    frontendPortRangeEnd: int?

    @description('Optional. The reference to the transport protocol used by the load balancing rule.')
    protocol: ('All' | 'Tcp' | 'Udp')?
  }?
}

@export()
@description('The type for the virtual network tap.')
type virtualNetworkTapType = {
  @description('Optional. Resource ID of the virtual network tap.')
  id: string?

  @description('Optional. Location of the virtual network tap.')
  location: string?

  @description('Optional. Properties of the virtual network tap.')
  properties: object?

  @description('Optional. Tags of the virtual network tap.')
  tags: object?
}

@export()
@description('The type for the network interface IP configuration output.')
type networkInterfaceIPConfigurationOutputType = {
  @description('The name of the IP configuration.')
  name: string

  @description('The private IP address.')
  privateIP: string?

  @description('The public IP address.')
  publicIP: string?
}
