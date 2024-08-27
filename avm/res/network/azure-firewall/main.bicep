metadata name = 'Azure Firewalls'
metadata description = 'This module deploys an Azure Firewall.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Firewall.')
param name string

@description('Optional. Tier of an Azure Firewall.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param azureSkuTier string = 'Standard'

@description('Conditional. Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.')
param virtualNetworkResourceId string = ''

@description('Optional. The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet.')
param publicIPResourceID string = ''

@description('Optional. This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration.')
param additionalPublicIpConfigurations array = []

@description('Optional. Specifies the properties of the Public IP to create and be used by the Firewall, if no existing public IP was provided.')
param publicIPAddressObject object = {
  name: '${name}-pip'
}

@description('Optional. The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet.')
param managementIPResourceID string = ''

@description('Optional. Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it\'s not provided and managementIPResourceID is empty, a \'-mip\' suffix will be appended to the Firewall\'s name.')
param managementIPAddressObject object = {}

@description('Optional. Collection of application rule collections used by Azure Firewall.')
param applicationRuleCollections applicationRuleCollectionType

@description('Optional. Collection of network rule collections used by Azure Firewall.')
param networkRuleCollections networkRuleCollectionType

@description('Optional. Collection of NAT rule collections used by Azure Firewall.')
param natRuleCollections natRuleCollectionType

@description('Optional. Resource ID of the Firewall Policy that should be attached.')
param firewallPolicyId string = ''

@description('Conditional. IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied.')
param hubIPAddresses object = {}

@description('Conditional. The virtualHub resource ID to which the firewall belongs. Required if `virtualNetworkId` is empty.')
param virtualHubId string = ''

@allowed([
  'Alert'
  'Deny'
  'Off'
])
@description('Optional. The operation mode for Threat Intel.')
param threatIntelMode string = 'Deny'

@description('Optional. Zone numbers e.g. 1,2,3.')
param zones array = [
  1
  2
  3
]

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the Azure Firewall resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var azureSkuName = empty(virtualNetworkResourceId) ? 'AZFW_Hub' : 'AZFW_VNet'
var requiresManagementIp = azureSkuTier == 'Basic' ? true : false
var isCreateDefaultManagementIP = empty(managementIPResourceID) && requiresManagementIp

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureFirewallSubnet for different uses cases:
// 1. Use existing Public IP
// 2. Use new Public IP created in this module
// 3. Do not use a Public IP if publicIPAddressObject is empty

var additionalPublicIpConfigurationsVar = [
  for ipConfiguration in additionalPublicIpConfigurations: {
    name: ipConfiguration.name
    properties: {
      publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId')
        ? {
            id: ipConfiguration.publicIPAddressResourceId
          }
        : null
    }
  }
]
var ipConfigurations = concat(
  [
    {
      name: !empty(publicIPResourceID) ? last(split(publicIPResourceID, '/')) : publicIPAddress.outputs.name
      properties: union(
        {
          subnet: {
            id: '${virtualNetworkResourceId}/subnets/AzureFirewallSubnet' // The subnet name must be AzureFirewallSubnet
          }
        },
        (!empty(publicIPResourceID) || !empty(publicIPAddressObject))
          ? {
              //Use existing Public IP, new Public IP created in this module, or none if neither
              publicIPAddress: {
                id: !empty(publicIPResourceID) ? publicIPResourceID : publicIPAddress.outputs.resourceId
              }
            }
          : {}
      )
    }
  ],
  additionalPublicIpConfigurationsVar
)

// ----------------------------------------------------------------------------
// Prep managementIPConfiguration object for different uses cases:
// 1. Use existing Management Public IP
// 2. Use new Management Public IP created in this module

var managementIPConfiguration = {
  name: !empty(managementIPResourceID) ? last(split(managementIPResourceID, '/')) : managementIPAddress.outputs.name
  properties: {
    subnet: {
      id: '${virtualNetworkResourceId}/subnets/AzureFirewallManagementSubnet' // The subnet name must be AzureFirewallManagementSubnet for a 'Basic' SKU tier firewall
    }
    // Use existing Management Public IP, new Management Public IP created in this module, or none if neither
    publicIPAddress: {
      id: !empty(managementIPResourceID) ? managementIPResourceID : managementIPAddress.outputs.resourceId
    }
  }
}

// ----------------------------------------------------------------------------
var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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
  name: '46d3xbcp.res.network-azurefirewall.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module publicIPAddress 'br/public:avm/res/network/public-ip-address:0.5.1' = if (empty(publicIPResourceID) && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-PIP'
  params: {
    name: publicIPAddressObject.name
    publicIpPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId')
      ? (!(empty(publicIPAddressObject.publicIPPrefixResourceId)) ? publicIPAddressObject.publicIPPrefixResourceId : '')
      : ''
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod')
      ? (!(empty(publicIPAddressObject.publicIPAllocationMethod))
          ? publicIPAddressObject.publicIPAllocationMethod
          : 'Static')
      : 'Static'
    skuName: contains(publicIPAddressObject, 'skuName')
      ? (!(empty(publicIPAddressObject.skuName)) ? publicIPAddressObject.skuName : 'Standard')
      : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier')
      ? (!(empty(publicIPAddressObject.skuTier)) ? publicIPAddressObject.skuTier : 'Regional')
      : 'Regional'
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments')
      ? (!empty(publicIPAddressObject.roleAssignments) ? publicIPAddressObject.roleAssignments : [])
      : []
    diagnosticSettings: publicIPAddressObject.?diagnosticSettings
    location: location
    lock: lock
    tags: publicIPAddressObject.?tags ?? tags
    zones: zones
    enableTelemetry: publicIPAddressObject.?enableTelemetry ?? enableTelemetry
  }
}

// create a Management Public IP address if one is not provided and the flag is true
module managementIPAddress 'br/public:avm/res/network/public-ip-address:0.5.1' = if (isCreateDefaultManagementIP && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-MIP'
  params: {
    name: contains(managementIPAddressObject, 'name')
      ? (!(empty(managementIPAddressObject.name)) ? managementIPAddressObject.name : '${name}-mip')
      : '${name}-mip'
    publicIpPrefixResourceId: contains(managementIPAddressObject, 'managementIPPrefixResourceId')
      ? (!(empty(managementIPAddressObject.managementIPPrefixResourceId))
          ? managementIPAddressObject.managementIPPrefixResourceId
          : '')
      : ''
    publicIPAllocationMethod: contains(managementIPAddressObject, 'managementIPAllocationMethod')
      ? (!(empty(managementIPAddressObject.managementIPAllocationMethod))
          ? managementIPAddressObject.managementIPAllocationMethod
          : 'Static')
      : 'Static'
    skuName: contains(managementIPAddressObject, 'skuName')
      ? (!(empty(managementIPAddressObject.skuName)) ? managementIPAddressObject.skuName : 'Standard')
      : 'Standard'
    skuTier: contains(managementIPAddressObject, 'skuTier')
      ? (!(empty(managementIPAddressObject.skuTier)) ? managementIPAddressObject.skuTier : 'Regional')
      : 'Regional'
    roleAssignments: contains(managementIPAddressObject, 'roleAssignments')
      ? (!empty(managementIPAddressObject.roleAssignments) ? managementIPAddressObject.roleAssignments : [])
      : []
    diagnosticSettings: managementIPAddressObject.?diagnosticSettings
    location: location
    tags: managementIPAddressObject.?tags ?? tags
    zones: zones
    enableTelemetry: managementIPAddressObject.?enableTelemetry ?? enableTelemetry
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-04-01' = {
  name: name
  location: location
  zones: length(zones) == 0 ? null : zones
  tags: tags
  properties: azureSkuName == 'AZFW_VNet'
    ? {
        threatIntelMode: threatIntelMode
        firewallPolicy: !empty(firewallPolicyId)
          ? {
              id: firewallPolicyId
            }
          : null
        ipConfigurations: ipConfigurations
        managementIpConfiguration: requiresManagementIp ? managementIPConfiguration : null
        sku: {
          name: azureSkuName
          tier: azureSkuTier
        }
        applicationRuleCollections: applicationRuleCollections ?? []
        natRuleCollections: natRuleCollections ?? []
        networkRuleCollections: networkRuleCollections ?? []
      }
    : {
        firewallPolicy: !empty(firewallPolicyId)
          ? {
              id: firewallPolicyId
            }
          : null
        sku: {
          name: azureSkuName
          tier: azureSkuTier
        }
        hubIPAddresses: !empty(hubIPAddresses) ? hubIPAddresses : null
        virtualHub: !empty(virtualHubId)
          ? {
              id: virtualHubId
            }
          : null
      }
}

resource azureFirewall_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: azureFirewall
}

resource azureFirewall_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: azureFirewall
  }
]

resource azureFirewall_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(azureFirewall.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: azureFirewall
  }
]

@description('The resource ID of the Azure Firewall.')
output resourceId string = azureFirewall.id

@description('The name of the Azure Firewall.')
output name string = azureFirewall.name

@description('The resource group the Azure firewall was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The private IP of the Azure firewall.')
output privateIp string = contains(azureFirewall.properties, 'ipConfigurations')
  ? azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
  : ''

@description('The Public IP configuration object for the Azure Firewall Subnet.')
output ipConfAzureFirewallSubnet object = contains(azureFirewall.properties, 'ipConfigurations')
  ? azureFirewall.properties.ipConfigurations[0]
  : {}

@description('List of Application Rule Collections used by Azure Firewall.')
output applicationRuleCollections array = applicationRuleCollections ?? []

@description('List of Network Rule Collections used by Azure Firewall.')
output networkRuleCollections array = networkRuleCollections ?? []

@description('List of NAT rule collections used by Azure Firewall.')
output natRuleCollections array = natRuleCollections ?? []

@description('The location the resource was deployed into.')
output location string = azureFirewall.location

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

type natRuleCollectionType = {
  @description('Required. Name of the NAT rule collection.')
  name: string

  @description('Required. Properties of the azure firewall NAT rule collection.')
  properties: {
    @description('Required. The action type of a NAT rule collection.')
    action: {
      @description('Required. The type of action.')
      type: 'Dnat' | 'Snat'
    }

    @description('Required. Priority of the NAT rule collection.')
    @minValue(100)
    @maxValue(65000)
    priority: int

    @description('Required. Collection of rules used by a NAT rule collection.')
    rules: {
      @description('Required. Name of the NAT rule.')
      name: string

      @description('Optional. Description of the rule.')
      description: string?

      @description('Required. Array of AzureFirewallNetworkRuleProtocols applicable to this NAT rule.')
      protocols: ('TCP' | 'UDP' | 'Any' | 'ICMP')[]

      @description('Optional. List of destination IP addresses for this rule. Supports IP ranges, prefixes, and service tags.')
      destinationAddresses: string[]?

      @description('Optional. List of destination ports.')
      destinationPorts: string[]?

      @description('Optional. List of source IP addresses for this rule.')
      sourceAddresses: string[]?

      @description('Optional. List of source IpGroups for this rule.')
      sourceIpGroups: string[]?

      @description('Optional. The translated address for this NAT rule.')
      translatedAddress: string?

      @description('Optional. The translated FQDN for this NAT rule.')
      translatedFqdn: string?

      @description('Optional. The translated port for this NAT rule.')
      translatedPort: string?
    }[]
  }
}[]?

type applicationRuleCollectionType = {
  @description('Required. Name of the application rule collection.')
  name: string

  @description('Required. Properties of the azure firewall application rule collection.')
  properties: {
    @description('Required. The action type of a rule collection.')
    action: {
      @description('Required. The type of action.')
      type: 'Allow' | 'Deny'
    }

    @description('Required. Priority of the application rule collection.')
    @minValue(100)
    @maxValue(65000)
    priority: int

    @description('Required. Collection of rules used by a application rule collection.')
    rules: {
      @description('Required. Name of the application rule.')
      name: string

      @description('Optional. Description of the rule.')
      description: string?

      @description('Required. Array of ApplicationRuleProtocols.')
      protocols: {
        @description('Optional. Port number for the protocol.')
        @maxValue(64000)
        port: int?

        @description('Required. Protocol type.')
        protocolType: 'Http' | 'Https' | 'Mssql'
      }[]

      @description('Optional. List of FQDN Tags for this rule.')
      fqdnTags: string[]?

      @description('Optional. List of FQDNs for this rule.')
      targetFqdns: string[]?

      @description('Optional. List of source IP addresses for this rule.')
      sourceAddresses: string[]?

      @description('Optional. List of source IpGroups for this rule.')
      sourceIpGroups: string[]?
    }[]
  }
}[]?

type networkRuleCollectionType = {
  @description('Required. Name of the network rule collection.')
  name: string

  @description('Required. Properties of the azure firewall network rule collection.')
  properties: {
    @description('Required. The action type of a rule collection.')
    action: {
      @description('Required. The type of action.')
      type: 'Allow' | 'Deny'
    }

    @description('Required. Priority of the network rule collection.')
    @minValue(100)
    @maxValue(65000)
    priority: int

    @description('Required. Collection of rules used by a network rule collection.')
    rules: {
      @description('Required. Name of the network rule.')
      name: string

      @description('Optional. Description of the rule.')
      description: string?

      @description('Required. Array of AzureFirewallNetworkRuleProtocols.')
      protocols: ('TCP' | 'UDP' | 'Any' | 'ICMP')[]

      @description('Optional. List of destination IP addresses.')
      destinationAddresses: string[]?

      @description('Optional. List of destination FQDNs.')
      destinationFqdns: string[]?

      @description('Optional. List of destination IP groups for this rule.')
      destinationIpGroups: string[]?

      @description('Optional. List of destination ports.')
      destinationPorts: string[]?

      @description('Optional. List of source IP addresses for this rule.')
      sourceAddresses: string[]?

      @description('Optional. List of source IpGroups for this rule.')
      sourceIpGroups: string[]?
    }[]
  }
}[]?
