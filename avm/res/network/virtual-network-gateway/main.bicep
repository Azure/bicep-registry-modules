metadata name = 'Virtual Network Gateways'
metadata description = 'This module deploys a Virtual Network Gateway.'

@description('Required. Specifies the Virtual Network Gateway name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway.')
param existingFirstPipResourceId string = ''

@description('Optional. Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway\'s name with the \'-pip1\' suffix.')
param firstPipName string = '${name}-pip1'

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

@description('Required. The SKU of the Gateway.')
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
])
param skuName string = (gatewayType == 'VPN') ? 'VpnGw1AZ' : 'ErGw1AZ'

@description('Optional. Specifies the VPN type.')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param vpnType string = 'RouteBased'

@description('Required. Virtual Network resource ID.')
param vNetResourceId string

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
param gatewayDefaultSiteLocalNetworkGatewayId string = ''

@description('Optional. NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.')
param natRules array = []

@description('Optional. EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided.')
param clientRootCertData string = ''

@description('Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.')
param clientRevokedCertThumbprint string = ''

@description('Optional. The diagnostic settings of the Public IP.')
param publicIpDiagnosticSettings diagnosticSettingType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.')
param vpnClientAadConfiguration object = {}

// ================//
// Variables       //
// ================//

// Other Variables
var gatewayPipAllocationMethod = skuName == 'Basic' ? 'Dynamic' : 'Static'

var isExpressRoute = gatewayType == 'ExpressRoute'

var vpnTypeVar = !isExpressRoute ? vpnType : 'PolicyBased'

var isBgp = (clusterSettings.clusterMode == 'activeActiveBgp' || clusterSettings.clusterMode == 'activePassiveBgp') && !isExpressRoute

var isActiveActive = (clusterSettings.clusterMode == 'activeActiveNoBgp' || clusterSettings.clusterMode == 'activeActiveBgp') && !isExpressRoute

var existingSecondPipResourceIdVar = isActiveActive ? clusterSettings.?existingSecondPipResourceId : null

var secondPipNameVar = isActiveActive ? (clusterSettings.?secondPipName ?? '${name}-pip2') : null

var arrayPipNameVar = isActiveActive
  ? concat(
      !empty(existingFirstPipResourceId) ? [] : [firstPipName],
      !empty(existingSecondPipResourceIdVar) ? [] : [secondPipNameVar]
    )
  : concat(!empty(existingFirstPipResourceId) ? [] : [firstPipName])

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
var ipConfiguration = isActiveActive
  ? [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vNetResourceId}/subnets/GatewaySubnet'
          }
          // Use existing Public IP, new Public IP created in this module
          publicIPAddress: {
            id: !empty(existingFirstPipResourceId)
              ? existingFirstPipResourceId
              : az.resourceId('Microsoft.Network/publicIPAddresses', firstPipName)
          }
        }
        name: 'vNetGatewayConfig1'
      }
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vNetResourceId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: isActiveActive
              ? !empty(existingSecondPipResourceIdVar)
                  ? existingSecondPipResourceIdVar
                  : az.resourceId('Microsoft.Network/publicIPAddresses', secondPipNameVar)
              : !empty(existingFirstPipResourceId)
                  ? existingFirstPipResourceId
                  : az.resourceId('Microsoft.Network/publicIPAddresses', firstPipName)
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
            id: '${vNetResourceId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: !empty(existingFirstPipResourceId)
              ? existingFirstPipResourceId
              : az.resourceId('Microsoft.Network/publicIPAddresses', firstPipName)
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
          aadTenant: vpnClientAadConfiguration.aadTenant
          aadAudience: vpnClientAadConfiguration.aadAudience
          aadIssuer: vpnClientAadConfiguration.aadIssuer
          vpnAuthenticationTypes: vpnClientAadConfiguration.vpnAuthenticationTypes
          vpnClientProtocols: vpnClientAadConfiguration.vpnClientProtocols
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
@batchSize(1)
module publicIPAddress 'br/public:avm/res/network/public-ip-address:0.5.1' = [
  for (virtualGatewayPublicIpName, index) in arrayPipNameVar: {
    name: virtualGatewayPublicIpName
    params: {
      name: virtualGatewayPublicIpName
      diagnosticSettings: publicIpDiagnosticSettings
      location: location
      lock: lock
      publicIPAllocationMethod: gatewayPipAllocationMethod
      publicIpPrefixResourceId: !empty(publicIPPrefixResourceId) ? publicIPPrefixResourceId : ''
      tags: tags
      skuName: skuName == 'Basic' ? 'Basic' : 'Standard'
      zones: skuName != 'Basic' ? publicIpZones : []
      dnsSettings: {
        domainNameLabel: length(arrayPipNameVar) == length(domainNameLabel)
          ? domainNameLabel[index]
          : virtualGatewayPublicIpName
        domainNameLabelScope: ''
      }
    }
  }
]

// VNET Gateway
// ============
resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
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
    gatewayDefaultSite: !empty(gatewayDefaultSiteLocalNetworkGatewayId)
      ? {
          id: gatewayDefaultSiteLocalNetworkGatewayId
        }
      : null
    sku: {
      name: skuName
      tier: skuName
    }
    vpnType: vpnTypeVar
    vpnClientConfiguration: !empty(vpnClientAddressPoolPrefix) ? vpnClientConfiguration : null
    vpnGatewayGeneration: gatewayType == 'Vpn' ? vpnGatewayGeneration : 'None'
  }
  dependsOn: [
    publicIPAddress
  ]
}

module virtualNetworkGateway_natRules 'nat-rule/main.bicep' = [
  for (natRule, index) in natRules: {
    name: '${deployment().name}-NATRule-${index}'
    params: {
      name: natRule.name
      virtualNetworkGatewayName: virtualNetworkGateway.name
      externalMappings: natRule.?externalMappings ?? []
      internalMappings: natRule.?internalMappings ?? []
      ipConfigurationId: natRule.?ipConfigurationId ?? ''
      mode: natRule.?mode ?? ''
      type: natRule.?type ?? ''
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

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type activePassiveNoBgpType = {
  clusterMode: 'activePassiveNoBgp'
}

type activeActiveNoBgpType = {
  clusterMode: 'activeActiveNoBgp'

  @description('Optional. The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingSecondPipResourceId: string?

  @description('Optional. Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway\'s name with the \'-pip2\' suffix.')
  secondPipName: string?
}

type activePassiveBgpType = {
  clusterMode: 'activePassiveBgp'

  @description('Optional. The Autonomous System Number value. If it\'s not provided, a default \'65515\' value will be assigned to the ASN.')
  @minValue(0)
  @maxValue(4294967295)
  asn: int?

  @description('Optional. The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  customBgpIpAddresses: string[]?
}

type activeActiveBgpType = {
  clusterMode: 'activeActiveBgp'

  @description('Optional. The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.')
  existingSecondPipResourceId: string?

  @description('Optional. Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway\'s name with the \'-pip2\' suffix.')
  secondPipName: string?

  @description('Optional. The Autonomous System Number value. If it\'s not provided, a default \'65515\' value will be assigned to the ASN.')
  @minValue(0)
  @maxValue(4294967295)
  asn: int?

  @description('Optional. The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  customBgpIpAddresses: string[]?
  @description('Optional. The list of the second custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.')
  secondCustomBgpIpAddresses: string[]?
}

@discriminator('clusterMode')
type clusterSettingType = activeActiveNoBgpType | activeActiveBgpType | activePassiveBgpType | activePassiveNoBgpType
