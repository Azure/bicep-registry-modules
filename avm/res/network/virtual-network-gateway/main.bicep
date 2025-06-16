metadata name = 'Virtual Network Gateways'
metadata description = 'This module deploys a Virtual Network Gateway.'

// ============= //
// User Types    //
// ============= //

@export()
@description('Configuration for Virtual Network Gateway autoscale bounds.')
type autoScaleBoundsType = {
  @description('Required. Maximum Scale Units for autoscale configuration.')
  max: int

  @description('Required. Minimum Scale Units for autoscale configuration.')
  min: int
}

@export()
@description('Configuration for Virtual Network Gateway autoscale.')
type autoScaleConfigurationType = {
  @description('Required. The bounds of the autoscale configuration.')
  bounds: autoScaleBoundsType
}

@export()
@description('Configuration for VPN client AAD authentication.')
type vpnClientAadConfigurationType = {
  @description('Required. The AAD tenant property for VPN client connection used for AAD authentication.')
  aadTenant: string

  @description('Required. The AAD audience property for VPN client connection used for AAD authentication.')
  aadAudience: string

  @description('Required. The AAD issuer property for VPN client connection used for AAD authentication.')
  aadIssuer: string

  @description('Required. VPN authentication types for the virtual network gateway.')
  vpnAuthenticationTypes: ('Certificate' | 'Radius' | 'AAD')[]

  @description('Required. VPN client protocols for Virtual network gateway.')
  vpnClientProtocols: ('IkeV2' | 'SSTP' | 'OpenVPN')[]
}

@export()
@description('Configuration for IPAM Pool Prefix Allocation.')
type ipamPoolPrefixAllocationType = {
  @description('Optional. Number of IP addresses to allocate.')
  numberOfIpAddresses: string?

  @description('Required. Pool configuration for IPAM.')
  pool: {
    @description('Required. Resource id of the associated Azure IpamPool resource.')
    id: string
  }
}

@export()
@description('Configuration for custom routes address space.')
type customRoutesType = {
  @description('Optional. A list of address blocks reserved for this virtual network in CIDR notation.')
  addressPrefixes: string[]?

  @description('Optional. A list of IPAM Pools allocating IP address prefixes.')
  ipamPoolPrefixAllocations: ipamPoolPrefixAllocationType[]?
}

// ============= //
// Parameters    //
// ============= //

@description('Required. Specifies the Virtual Network Gateway name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway.')
param existingPrimaryPublicIPResourceId string = ''

@description('Optional. Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway\'s name with the \'-pip1\' suffix.')
param primaryPublicIPName string = '${name}-pip1'

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixResourceId string = ''

@description('Optional. Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones.')
param publicIpZones array = [
  1
  2
  3
]

@description('Optional. DNS name(s) of the Public IP resource(s). If you enabled Active-Active mode, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.')
param domainNameLabel array = []

@description('Required. Specifies the gateway type. E.g. VPN, ExpressRoute.')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string

@description('Optional. The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN.')
@allowed([
  'Generation1'
  'Generation2'
  'None'
])
param vpnGatewayGeneration string = 'None'

@description('Optional. The SKU of the Gateway.')
@allowed([
  'Basic'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw4'
  'VpnGw5'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
  'Standard'
  'HighPerformance'
  'UltraPerformance'
  'ErGw1AZ'
  'ErGw2AZ'
  'ErGw3AZ'
  'ErGwScale'
])
param skuName string = (gatewayType == 'Vpn') ? 'VpnGw1AZ' : 'ErGw1AZ'

@description('Optional. Specifies the VPN type.')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param vpnType string = 'RouteBased'

@description('Required. Virtual Network resource ID.')
param virtualNetworkResourceId string

@description('Required. Specifies one of the following four configurations: Active-Active with (clusterMode = activeActiveBgp) or without (clusterMode = activeActiveNoBgp) BGP, Active-Passive with (clusterMode = activePassiveBgp) or without (clusterMode = activePassiveNoBgp) BGP.')
param clusterSettings clusterSettingType

@description('Optional. The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network.')
param vpnClientAddressPoolPrefix string = ''

@description('Optional. Configures this gateway to accept traffic from remote Virtual WAN networks.')
param allowVirtualWanTraffic bool = false

@description('Optional. Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN.')
param allowRemoteVnetTraffic bool = false

@description('Optional. disableIPSecReplayProtection flag. Used for VPN Gateways.')
param disableIPSecReplayProtection bool = false

@description('Optional. Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription.')
param enableDnsForwarding bool = false

@description('Optional. Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering.')
param enablePrivateIpAddress bool = false

@description('Optional. The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting.')
param gatewayDefaultSiteLocalNetworkGatewayResourceId string = ''

@description('Optional. NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.')
param natRules natRuleType[]?

@description('Optional. EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided.')
param clientRootCertData string = ''

@description('Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.')
param clientRevokedCertThumbprint string = ''

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the Public IP.')
param publicIpDiagnosticSettings diagnosticSettingFullType[]?

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/virtualNetworkGateways@2024-07-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.')
param vpnClientAadConfiguration vpnClientAadConfigurationType?

@description('Optional. The managed identity definition for this resource. Supports system-assigned and user-assigned identities.')
param managedIdentity managedIdentityAllType?

@description('Optional. Property to indicate if the Express Route Gateway serves traffic when there are multiple Express Route Gateways in the vnet. Only applicable for ExpressRoute gateways.')
@allowed([
  'Enabled'
  'Disabled'
])
param adminState string = 'Enabled'

@description('Optional. Property to indicate if the Express Route Gateway has resiliency model of MultiHomed or SingleHomed. Only applicable for ExpressRoute gateways.')
@allowed([
  'SingleHomed'
  'MultiHomed'
])
param resiliencyModel string = 'SingleHomed'

@description('Optional. Autoscale configuration for virtual network gateway. Only applicable for certain SKUs.')
param autoScaleConfiguration autoScaleConfigurationType?

@description('Optional. The reference to the address space resource which represents the custom routes address space specified by the customer for virtual network gateway and VpnClient. This is used to specify custom routes for Point-to-Site VPN clients.')
param customRoutes customRoutesType?

// ================//
// Variables       //
// ================//

var enableReferencedModulesTelemetry = false

// Other Variables
var isExpressRoute = gatewayType == 'ExpressRoute'

var isBgp = (clusterSettings.clusterMode == 'activeActiveBgp' || clusterSettings.clusterMode == 'activePassiveBgp') && !isExpressRoute

var isActiveActive = (clusterSettings.clusterMode == 'activeActiveNoBgp' || clusterSettings.clusterMode == 'activeActiveBgp') && !isExpressRoute

var existingSecondaryPublicIPResourceIdVar = isActiveActive
  ? clusterSettings.?existingSecondaryPublicIPResourceId
  : null

var existingTertiaryPublicIPResourceIdVar = isActiveActive
  ? clusterSettings.?existingTertiaryPublicIPResourceId
  : null

var secondaryPublicIPNameVar = isActiveActive ? (clusterSettings.?secondPipName ?? '${name}-pip2') : null

var tertiaryPublicIPNameVar = isActiveActive && !empty(vpnClientAddressPoolPrefix) ? '${name}-pip3' : null

var arrayPipNameVar = isActiveActive && !empty(vpnClientAddressPoolPrefix)
  ? concat(
      !empty(existingPrimaryPublicIPResourceId) ? [] : [primaryPublicIPName],
      !empty(existingSecondaryPublicIPResourceIdVar) ? [] : [secondaryPublicIPNameVar],
      !empty(existingTertiaryPublicIPResourceIdVar) ? [] : [tertiaryPublicIPNameVar]
    )
  : isActiveActive
  ? concat(
      !empty(existingPrimaryPublicIPResourceId) ? [] : [primaryPublicIPName],
      !empty(existingSecondaryPublicIPResourceIdVar) ? [] : [secondaryPublicIPNameVar]
    )
  : concat(!empty(existingPrimaryPublicIPResourceId) ? [] : [primaryPublicIPName])

// Potential BGP configurations (Active-Active vs Active-Passive)
var bgpSettingsVar = isActiveActive
  ? {
      asn: clusterSettings.?asn ?? 65515
      bgpPeeringAddresses: [
        {
          customBgpIpAddresses: clusterSettings.?customBgpIpAddresses
          ipconfigurationId: '${az.resourceId('Microsoft.Network/virtualNetworkGateways', name)}/ipConfigurations/vNetGatewayConfig1'
        }
        {
          customBgpIpAddresses: clusterSettings.?secondCustomBgpIpAddresses
          ipconfigurationId: '${az.resourceId('Microsoft.Network/virtualNetworkGateways', name)}/ipConfigurations/vNetGatewayConfig2'
        }
      ]
    }
  : {
      asn: clusterSettings.?asn ?? 65515
      bgpPeeringAddresses: [
        {
          customBgpIpAddresses: clusterSettings.?customBgpIpAddresses
          ipconfigurationId: '${az.resourceId('Microsoft.Network/virtualNetworkGateways', name)}/ipConfigurations/vNetGatewayConfig1'
        }
      ]
    }

// Potential IP configurations (Active-Active vs Active-Passive)
var ipConfiguration = isActiveActive && !empty(vpnClientAddressPoolPrefix)
  ? [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
          }
          // Use existing Public IP, new Public IP created in this module
          publicIPAddress: {
            id: !empty(existingPrimaryPublicIPResourceId)
              ? existingPrimaryPublicIPResourceId
              : az.resourceId('Microsoft.Network/publicIPAddresses', primaryPublicIPName)
          }
        }
        name: 'vNetGatewayConfig1'
      }
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: isActiveActive
              ? !empty(existingSecondaryPublicIPResourceIdVar)
                  ? existingSecondaryPublicIPResourceIdVar
                  : az.resourceId('Microsoft.Network/publicIPAddresses', secondaryPublicIPNameVar)
              : !empty(existingPrimaryPublicIPResourceId)
                  ? existingPrimaryPublicIPResourceId
                  : az.resourceId('Microsoft.Network/publicIPAddresses', primaryPublicIPName)
          }
        }
        name: 'vNetGatewayConfig2'
      }
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: !empty(existingTertiaryPublicIPResourceIdVar)
                  ? existingTertiaryPublicIPResourceIdVar
                  : az.resourceId('Microsoft.Network/publicIPAddresses', tertiaryPublicIPNameVar!)
          }
        }
        name: 'vNetGatewayConfig3'
      }
    ]
  : isActiveActive
    ? [
        {
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
            }
            publicIPAddress: {
              id: !empty(existingPrimaryPublicIPResourceId)
                ? existingPrimaryPublicIPResourceId
                : az.resourceId('Microsoft.Network/publicIPAddresses', primaryPublicIPName)
            }
          }
          name: 'vNetGatewayConfig1'
        }
        {
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
            }
            publicIPAddress: {
              id: isActiveActive
                ? !empty(existingSecondaryPublicIPResourceIdVar)
                    ? existingSecondaryPublicIPResourceIdVar
                    : az.resourceId('Microsoft.Network/publicIPAddresses', secondaryPublicIPNameVar)
                : !empty(existingPrimaryPublicIPResourceId)
                    ? existingPrimaryPublicIPResourceId
                    : az.resourceId('Microsoft.Network/publicIPAddresses', primaryPublicIPName)
            }
          }
          name: 'vNetGatewayConfig2'
        }      
    ]
  : [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworkResourceId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: !empty(existingPrimaryPublicIPResourceId)
              ? existingPrimaryPublicIPResourceId
              : az.resourceId('Microsoft.Network/publicIPAddresses', primaryPublicIPName)
          }
        }
        name: 'vNetGatewayConfig1'
      }
    ]

var vpnClientConfiguration = !empty(clientRootCertData)
  ? {
      vpnClientAddressPool: {
        addressPrefixes: [
          vpnClientAddressPoolPrefix
        ]
      }
      vpnClientRootCertificates: [
        {
          name: 'RootCert1'
          properties: {
            publicCertData: clientRootCertData
          }
        }
      ]
      vpnClientRevokedCertificates: !empty(clientRevokedCertThumbprint)
        ? [
            {
              name: 'RevokedCert1'
              properties: {
                thumbprint: clientRevokedCertThumbprint
              }
            }
          ]
        : null
    }
  : !empty(vpnClientAadConfiguration)
      ? {
          vpnClientAddressPool: {
            addressPrefixes: [
              vpnClientAddressPoolPrefix
            ]
          }
          aadTenant: vpnClientAadConfiguration!.aadTenant
          aadAudience: vpnClientAadConfiguration!.aadAudience
          aadIssuer: vpnClientAadConfiguration!.aadIssuer
          vpnAuthenticationTypes: vpnClientAadConfiguration!.vpnAuthenticationTypes
          vpnClientProtocols: vpnClientAadConfiguration!.vpnClientProtocols
        }
      : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
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

resource primaryPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' existing = if (!empty(existingPrimaryPublicIPResourceId)) {
  name: last(split(existingPrimaryPublicIPResourceId, '/'))
  scope: resourceGroup(
    split(existingPrimaryPublicIPResourceId, '/')[2],
    split(existingPrimaryPublicIPResourceId, '/')[4]
  )
}

resource secondaryPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' existing = if (!empty(clusterSettings.?existingSecondaryPublicIPResourceId)) {
  name: last(split(clusterSettings.?existingSecondaryPublicIPResourceId, '/'))
  scope: resourceGroup(
    split(clusterSettings.?existingSecondaryPublicIPResourceId, '/')[2],
    split(clusterSettings.?existingSecondaryPublicIPResourceId, '/')[4]
  )
}

resource tertiaryPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' existing = if (!empty(clusterSettings.?existingTertiaryPublicIPResourceId)) {
  name: last(split(clusterSettings.?existingTertiaryPublicIPResourceId, '/'))
  scope: resourceGroup(
    split(clusterSettings.?existingTertiaryPublicIPResourceId, '/')[2],
    split(clusterSettings.?existingTertiaryPublicIPResourceId, '/')[4]
  )
}

// ================//
// Deployments     //
// ================//

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-virtualnetworkgateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

// Public IPs
var isAzSku = contains(skuName, 'AZ')
var publicIpZonesToApply = isAzSku ? publicIpZones : []

@batchSize(1)
module publicIPAddress 'br/public:avm/res/network/public-ip-address:0.8.0' = [
  for (virtualGatewayPublicIpName, index) in arrayPipNameVar: {
    name: virtualGatewayPublicIpName
    params: {
      name: virtualGatewayPublicIpName
      diagnosticSettings: publicIpDiagnosticSettings
      location: location
      lock: lock
      publicIPAllocationMethod: skuName == 'Basic' ? 'Dynamic' : 'Static'
      publicIpPrefixResourceId: !empty(publicIPPrefixResourceId) ? publicIPPrefixResourceId : ''
      tags: tags
      skuName: skuName == 'Basic' ? 'Basic' : 'Standard'
      zones: publicIpZonesToApply
      dnsSettings: {
        domainNameLabel: length(arrayPipNameVar) == length(domainNameLabel)
          ? domainNameLabel[index]
          : virtualGatewayPublicIpName
        domainNameLabelScope: 'TenantReuse'
      }
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

// VNET Gateway
// ============
resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2024-05-01' = {
  name: name
  location: location
  tags: tags
  identity: managedIdentity != null
    ? {
        type: (managedIdentity.?systemAssigned ?? false) && (managedIdentity.?userAssignedResourceIds ?? []) != []
          ? 'SystemAssigned, UserAssigned'
          : (managedIdentity.?systemAssigned ?? false)
            ? 'SystemAssigned'
            : (managedIdentity.?userAssignedResourceIds ?? []) != []
              ? 'UserAssigned'
              : 'None'
        userAssignedIdentities: (managedIdentity.?userAssignedResourceIds ?? []) != []
          ? reduce(
              map((managedIdentity.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
              {},
              (cur, next) => union(cur, next)
            )
          : null
      }
    : null
  properties: {
    ipConfigurations: ipConfiguration
    activeActive: isActiveActive
    allowRemoteVnetTraffic: allowRemoteVnetTraffic
    allowVirtualWanTraffic: allowVirtualWanTraffic
    enableBgp: isBgp
    bgpSettings: isBgp ? bgpSettingsVar : null
    disableIPSecReplayProtection: disableIPSecReplayProtection
    enableDnsForwarding: !isExpressRoute ? enableDnsForwarding : null
    enablePrivateIpAddress: enablePrivateIpAddress
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    gatewayType: gatewayType
    gatewayDefaultSite: !empty(gatewayDefaultSiteLocalNetworkGatewayResourceId)
      ? {
          id: gatewayDefaultSiteLocalNetworkGatewayResourceId
        }
      : null
    sku: {
      name: skuName
      tier: skuName
    }
    vpnType: !isExpressRoute ? vpnType : 'PolicyBased'
    vpnClientConfiguration: !empty(vpnClientAddressPoolPrefix) ? vpnClientConfiguration : null
    vpnGatewayGeneration: gatewayType == 'Vpn' ? vpnGatewayGeneration : 'None'
    customRoutes: customRoutes
    adminState: isExpressRoute ? adminState : null
    resiliencyModel: isExpressRoute ? resiliencyModel : null
    autoScaleConfiguration: autoScaleConfiguration
  }
  dependsOn: [
    publicIPAddress
  ]
}

module virtualNetworkGateway_natRules 'nat-rule/main.bicep' = [
  for (natRule, index) in (natRules ?? []): {
    name: '${deployment().name}-NATRule-${index}'
    params: {
      name: natRule.name
      virtualNetworkGatewayName: virtualNetworkGateway.name
      externalMappings: natRule.?externalMappings
      internalMappings: natRule.?internalMappings
      ipConfigurationResourceId: natRule.?ipConfigurationResourceId
      mode: natRule.?mode
      type: natRule.?type
    }
  }
]

resource virtualNetworkGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: virtualNetworkGateway
}

resource virtualNetworkGateway_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: virtualNetworkGateway
  }
]

resource virtualNetworkGateway_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      virtualNetworkGateway.id,
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
    scope: virtualNetworkGateway
  }
]

// ================//
// Outputs         //
// ================//
@description('The resource group the virtual network gateway was deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network gateway.')
output name string = virtualNetworkGateway.name

@description('The resource ID of the virtual network gateway.')
output resourceId string = virtualNetworkGateway.id

@description('Shows if the virtual network gateway is configured in Active-Active mode.')
output activeActive bool = virtualNetworkGateway.properties.activeActive

@description('The location the resource was deployed into.')
output location string = virtualNetworkGateway.location

@description('The ASN (Autonomous System Number) of the virtual network gateway.')
output asn int? = virtualNetworkGateway.properties.?bgpSettings.?asn

@description('The IPconfigurations object of the Virtual Network Gateway.')
output ipConfigurations object[]? = virtualNetworkGateway.properties.?ipConfigurations

@description('The primary public IP address of the virtual network gateway.')
output primaryPublicIpAddress string = !empty(existingPrimaryPublicIPResourceId)
  ? primaryPublicIP.properties.ipAddress
  : publicIPAddress[0].outputs.ipAddress

@description('The primary default Azure BGP peer IP address.')
output defaultBgpIpAddresses string? = join(
  virtualNetworkGateway.properties.?bgpSettings.?bgpPeeringAddresses[?0].?defaultBgpIpAddresses ?? [],
  ','
) //'Not applicable (No Bgp)'

@description('The primary custom Azure APIPA BGP IP address.')
output customBgpIpAddresses string? = join(
  virtualNetworkGateway.properties.?bgpSettings.?bgpPeeringAddresses[?0].?customBgpIpAddresses ?? [],
  ','
) //'Not applicable (No Bgp)'

@description('The secondary public IP address of the virtual network gateway (Active-Active mode).')
output secondaryPublicIpAddress string? = isActiveActive
  ? (!empty(existingSecondaryPublicIPResourceIdVar)
      ? secondaryPublicIP.properties.ipAddress
      : publicIPAddress[1].outputs.ipAddress)
  : null // 'Not applicable (Active-Passive mode)'

  // Add for tertiary public IP address (Active-Active with P2S mode)
@description('The tertiary public IP address of the virtual network gateway (Active-Active with P2S mode).')
output tertiaryPublicIpAddress string? = isActiveActive && !empty(vpnClientAddressPoolPrefix)
  ? (!empty(existingTertiaryPublicIPResourceIdVar)
      ? tertiaryPublicIP.properties.ipAddress
      : publicIPAddress[2].outputs.ipAddress)
  : null // 'Not applicable (Active-Passive mode) or no P2S'

@description('The secondary default Azure BGP peer IP address (Active-Active mode).')
output secondaryDefaultBgpIpAddress string? = join(
  virtualNetworkGateway.properties.?bgpSettings.?bgpPeeringAddresses[?1].?defaultBgpIpAddresses ?? [],
  ','
) //'Not applicable (Active-Passive mode)'

@description('The secondary custom Azure APIPA BGP IP address (Active-Active mode).')
output secondaryCustomBgpIpAddress string? = join(
  virtualNetworkGateway.properties.?bgpSettings.?bgpPeeringAddresses[?1].?customBgpIpAddresses ?? [],
  ','
) //'Not applicable (Active-Passive mode)'

// =============== //
//   Definitions   //
// =============== //

import { mappingType } from 'nat-rule/main.bicep'

@export()
@description('The type for a cluster configuration.')
@discriminator('clusterMode')
type clusterSettingType = activeActiveNoBgpType | activeActiveBgpType | activePassiveBgpType | activePassiveNoBgpType

@export()
@description('The type for a NAT rule.')
type natRuleType = {
  @description('Required. The name of the NAT rule.')
  name: string

  @description('Optional. An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range.')
  externalMappings: mappingType[]?

  @description('Optional. An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.')
  internalMappings: mappingType[]?

  @description('Optional. A NAT rule must be configured to a specific Virtual Network Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both Virtual Network Gateway instances.')
  ipConfigurationResourceId: string?

  @description('Optional. The type of NAT rule for Virtual Network NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub\'s site-to-site Virtual Network gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub\'s Site-to-site Virtual Network gateway.')
  mode: ('EgressSnat' | 'IngressSnat')?

  @description('Optional. The type of NAT rule for Virtual Network NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability.')
  type: ('Dynamic' | 'Static')?
}

@description('The type for an active-passive no BGP cluster configuration.')
type activePassiveNoBgpType = {
  @description('Required. The cluster mode deciding the configuration.')
  clusterMode: 'activePassiveNoBgp'
}

@description('The type for an active-active no BGP cluster configuration.')
type activeActiveNoBgpType = {
  @description('Required. The cluster mode deciding the configuration.')
  clusterMode: 'activeActiveNoBgp'

  @description('Optional. The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingSecondaryPublicIPResourceId: string?
  
  @description('Optional. The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingTertiaryPublicIPResourceId: string?

  @description('Optional. Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway\'s name with the \'-pip2\' suffix.')
  secondPipName: string?
}

@description('The type for an active-passive BGP cluster configuration.')
type activePassiveBgpType = {
  @description('Required. The cluster mode deciding the configuration.')
  clusterMode: 'activePassiveBgp'

  @description('Optional. The Autonomous System Number value. If it\'s not provided, a default \'65515\' value will be assigned to the ASN.')
  @minValue(0)
  @maxValue(4294967295)
  asn: int?

  @description('Optional. The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  customBgpIpAddresses: string[]?
}

@description('The type for an active-active BGP cluster configuration.')
type activeActiveBgpType = {
  @description('Required. The cluster mode deciding the configuration.')
  clusterMode: 'activeActiveBgp'

  @description('Optional. The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingSecondaryPublicIPResourceId: string?

  @description('Optional. Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway\'s name with the \'-pip2\' suffix.')
  secondPipName: string?

  @description('Optional. The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingTertiaryPublicIPResourceId: string?

  @description('Optional. The Autonomous System Number value. If it\'s not provided, a default \'65515\' value will be assigned to the ASN.')
  @minValue(0)
  @maxValue(4294967295)
  asn: int?

  @description('Optional. The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  customBgpIpAddresses: string[]?

  @description('Optional. The list of the second custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  secondCustomBgpIpAddresses: string[]?
}
