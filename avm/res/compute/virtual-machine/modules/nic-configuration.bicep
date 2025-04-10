param networkInterfaceName string
param virtualMachineName string
param ipConfigurations array

@description('Optional. Location for all resources.')
param location string

@description('Optional. Tags of the resource.')
param tags object?

param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []

@description('Required. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableTelemetry bool

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

module networkInterface_publicIPAddresses 'br/public:avm/res/network/public-ip-address:0.6.0' = [
  for (ipConfiguration, index) in ipConfigurations: !empty(ipConfiguration.?pipConfiguration) && empty(ipConfiguration.?pipConfiguration.?publicIPAddressResourceId) {
    name: '${deployment().name}-publicIP-${index}'
    params: {
      name: ipConfiguration.pipConfiguration.?name ?? '${virtualMachineName}${ipConfiguration.pipConfiguration.?publicIpNameSuffix}'
      diagnosticSettings: ipConfiguration.?diagnosticSettings
      location: location
      lock: lock
      idleTimeoutInMinutes: ipConfiguration.pipConfiguration.?idleTimeoutInMinutes
      ddosSettings: ipConfiguration.pipConfiguration.?ddosSettings
      dnsSettings: ipConfiguration.pipConfiguration.?dnsSettings
      publicIPAddressVersion: ipConfiguration.pipConfiguration.?publicIPAddressVersion ?? 'IPv4'
      publicIPAllocationMethod: ipConfiguration.pipConfiguration.?publicIPAllocationMethod ?? 'Static'
      publicIpPrefixResourceId: ipConfiguration.pipConfiguration.?publicIPPrefixResourceId ?? ''
      roleAssignments: ipConfiguration.pipConfiguration.?roleAssignments ?? []
      skuName: ipConfiguration.pipConfiguration.?skuName ?? 'Standard'
      skuTier: ipConfiguration.pipConfiguration.?skuTier ?? 'Regional'
      tags: ipConfiguration.?tags ?? tags
      zones: ipConfiguration.pipConfiguration.?zones ?? [
        1
        2
        3
      ]
      enableTelemetry: ipConfiguration.?enableTelemetry ?? enableTelemetry
    }
  }
]

module networkInterface 'br/public:avm/res/network/network-interface:0.4.0' = {
  name: '${deployment().name}-NetworkInterface'
  params: {
    name: networkInterfaceName
    ipConfigurations: [
      for (ipConfiguration, index) in ipConfigurations: {
        name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
        primary: index == 0
        privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod')
          ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null)
          : null
        privateIPAddress: contains(ipConfiguration, 'privateIPAddress')
          ? (!empty(ipConfiguration.privateIPAddress) ? ipConfiguration.privateIPAddress : null)
          : null
        publicIPAddressResourceId: contains(ipConfiguration, 'pipConfiguration') && !empty(ipConfiguration.pipConfiguration)
          ? !contains(ipConfiguration.pipConfiguration, 'publicIPAddressResourceId')
              ? resourceId(
                  'Microsoft.Network/publicIPAddresses',
                  ipConfiguration.pipConfiguration.?name ?? '${virtualMachineName}${ipConfiguration.pipConfiguration.?publicIpNameSuffix}'
                )
              : ipConfiguration.pipConfiguration.publicIPAddressResourceId
          : null
        subnetResourceId: ipConfiguration.subnetResourceId
        loadBalancerBackendAddressPools: ipConfiguration.?loadBalancerBackendAddressPools ?? null
        applicationSecurityGroups: ipConfiguration.?applicationSecurityGroups ?? null
        applicationGatewayBackendAddressPools: ipConfiguration.?applicationGatewayBackendAddressPools ?? null
        gatewayLoadBalancer: ipConfiguration.?gatewayLoadBalancer ?? null
        loadBalancerInboundNatRules: ipConfiguration.?loadBalancerInboundNatRules ?? null
        privateIPAddressVersion: ipConfiguration.?privateIPAddressVersion ?? null
        virtualNetworkTaps: ipConfiguration.?virtualNetworkTaps ?? null
      }
    ]
    location: location
    tags: tags
    diagnosticSettings: diagnosticSettings
    dnsServers: !empty(dnsServers) ? dnsServers : []
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableTelemetry: enableTelemetry
    enableIPForwarding: enableIPForwarding
    lock: lock
    networkSecurityGroupResourceId: !empty(networkSecurityGroupResourceId) ? networkSecurityGroupResourceId : ''
    roleAssignments: !empty(roleAssignments) ? roleAssignments : []
  }
  dependsOn: [
    networkInterface_publicIPAddresses
  ]
}
