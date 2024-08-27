metadata name = 'Virtual Networks'
metadata description = 'This module deploys a Virtual Network (vNet).'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Virtual Network (vNet).')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param addressPrefixes array

@description('Optional. An Array of subnets to deploy to the Virtual Network.')
param subnets array = []

@description('Optional. DNS Servers associated to the Virtual Network.')
param dnsServers array = []

@description('Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it\'s left blank, DDoS protection will not be configured. If it\'s provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.')
param ddosProtectionPlanResourceId string = ''

@description('Optional. Virtual Network Peerings configurations.')
param peerings array = []

@description('Optional. Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property.')
param vnetEncryption bool = false

@allowed([
  'AllowUnencrypted'
  'DropUnencrypted'
])
@description('Optional. If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled.')
param vnetEncryptionEnforcement string = 'AllowUnencrypted'

@maxValue(30)
@description('Optional. The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null.')
param flowTimeoutInMinutes int = 0

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
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

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-virtualnetwork.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    ddosProtectionPlan: !empty(ddosProtectionPlanResourceId)
      ? {
          id: ddosProtectionPlanResourceId
        }
      : null
    dhcpOptions: !empty(dnsServers)
      ? {
          dnsServers: array(dnsServers)
        }
      : null
    enableDdosProtection: !empty(ddosProtectionPlanResourceId)
    encryption: vnetEncryption == true
      ? {
          enabled: vnetEncryption
          enforcement: vnetEncryptionEnforcement
        }
      : null
    flowTimeoutInMinutes: flowTimeoutInMinutes != 0 ? flowTimeoutInMinutes : null
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          addressPrefixes: contains(subnet, 'addressPrefixes') ? subnet.addressPrefixes : []
          applicationGatewayIPConfigurations: contains(subnet, 'applicationGatewayIPConfigurations')
            ? subnet.applicationGatewayIPConfigurations
            : []
          delegations: contains(subnet, 'delegations') ? subnet.delegations : []
          ipAllocations: contains(subnet, 'ipAllocations') ? subnet.ipAllocations : []
          natGateway: contains(subnet, 'natGatewayResourceId') && !empty(subnet.natGatewayResourceId)
            ? {
                id: subnet.natGatewayResourceId
              }
            : null
          networkSecurityGroup: contains(subnet, 'networkSecurityGroupResourceId') && !empty(subnet.networkSecurityGroupResourceId)
            ? {
                id: subnet.networkSecurityGroupResourceId
              }
            : null
          privateEndpointNetworkPolicies: contains(subnet, 'privateEndpointNetworkPolicies')
            ? subnet.privateEndpointNetworkPolicies
            : null
          privateLinkServiceNetworkPolicies: contains(subnet, 'privateLinkServiceNetworkPolicies')
            ? subnet.privateLinkServiceNetworkPolicies
            : null
          routeTable: contains(subnet, 'routeTableResourceId') && !empty(subnet.routeTableResourceId)
            ? {
                id: subnet.routeTableResourceId
              }
            : null
          serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : []
          serviceEndpointPolicies: contains(subnet, 'serviceEndpointPolicies') ? subnet.serviceEndpointPolicies : []
        }
      }
    ]
  }
}

//NOTE Start: ------------------------------------
// The below module (virtualNetwork_subnets) is a duplicate of the child resource (subnets) defined in the parent module (virtualNetwork).
// The reason it exists so that deployment validation tests can be performed on the child module (subnets), in case that module needed to be deployed alone outside of this template.
// The reason for duplication is due to the current design for the (virtualNetworks) resource from Azure, where if the child module (subnets) does not exist within it, causes
//    an issue, where the child resource (subnets) gets all of its properties removed, hence not as 'idempotent' as it should be. See https://github.com/Azure/azure-quickstart-templates/issues/2786 for more details.
// You can safely remove the below child module (virtualNetwork_subnets) in your consumption of the module (virtualNetworks) to reduce the template size and duplication.
//NOTE End  : ------------------------------------

@batchSize(1)
module virtualNetwork_subnets 'subnet/main.bicep' = [
  for (subnet, index) in subnets: {
    name: '${uniqueString(deployment().name, location)}-subnet-${index}'
    params: {
      virtualNetworkName: virtualNetwork.name
      name: subnet.name
      addressPrefix: subnet.addressPrefix
      addressPrefixes: contains(subnet, 'addressPrefixes') ? subnet.addressPrefixes : []
      applicationGatewayIPConfigurations: contains(subnet, 'applicationGatewayIPConfigurations')
        ? subnet.applicationGatewayIPConfigurations
        : []
      delegations: contains(subnet, 'delegations') ? subnet.delegations : []
      ipAllocations: contains(subnet, 'ipAllocations') ? subnet.ipAllocations : []
      natGatewayResourceId: contains(subnet, 'natGatewayResourceId') ? subnet.natGatewayResourceId : ''
      networkSecurityGroupResourceId: contains(subnet, 'networkSecurityGroupResourceId')
        ? subnet.networkSecurityGroupResourceId
        : ''
      privateEndpointNetworkPolicies: contains(subnet, 'privateEndpointNetworkPolicies')
        ? subnet.privateEndpointNetworkPolicies
        : ''
      privateLinkServiceNetworkPolicies: contains(subnet, 'privateLinkServiceNetworkPolicies')
        ? subnet.privateLinkServiceNetworkPolicies
        : ''
      roleAssignments: contains(subnet, 'roleAssignments') ? subnet.roleAssignments : []
      routeTableResourceId: contains(subnet, 'routeTableResourceId') ? subnet.routeTableResourceId : ''
      serviceEndpointPolicies: contains(subnet, 'serviceEndpointPolicies') ? subnet.serviceEndpointPolicies : []
      serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : []
    }
  }
]

// Local to Remote peering
module virtualNetwork_peering_local 'virtual-network-peering/main.bicep' = [
  for (peering, index) in peerings: {
    name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-local-${index}'
    params: {
      localVnetName: virtualNetwork.name
      remoteVirtualNetworkId: peering.remoteVirtualNetworkId
      name: contains(peering, 'name') ? peering.name : '${name}-${last(split(peering.remoteVirtualNetworkId, '/'))}'
      allowForwardedTraffic: contains(peering, 'allowForwardedTraffic') ? peering.allowForwardedTraffic : true
      allowGatewayTransit: contains(peering, 'allowGatewayTransit') ? peering.allowGatewayTransit : false
      allowVirtualNetworkAccess: contains(peering, 'allowVirtualNetworkAccess')
        ? peering.allowVirtualNetworkAccess
        : true
      doNotVerifyRemoteGateways: contains(peering, 'doNotVerifyRemoteGateways')
        ? peering.doNotVerifyRemoteGateways
        : true
      useRemoteGateways: contains(peering, 'useRemoteGateways') ? peering.useRemoteGateways : false
    }
  }
]

// Remote to local peering (reverse)
module virtualNetwork_peering_remote 'virtual-network-peering/main.bicep' = [
  for (peering, index) in peerings: if (contains(peering, 'remotePeeringEnabled')
    ? peering.remotePeeringEnabled == true
    : false) {
    name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-remote-${index}'
    scope: resourceGroup(split(peering.remoteVirtualNetworkId, '/')[2], split(peering.remoteVirtualNetworkId, '/')[4])
    params: {
      localVnetName: last(split(peering.remoteVirtualNetworkId, '/'))!
      remoteVirtualNetworkId: virtualNetwork.id
      name: contains(peering, 'remotePeeringName')
        ? peering.remotePeeringName
        : '${last(split(peering.remoteVirtualNetworkId, '/'))}-${name}'
      allowForwardedTraffic: contains(peering, 'remotePeeringAllowForwardedTraffic')
        ? peering.remotePeeringAllowForwardedTraffic
        : true
      allowGatewayTransit: contains(peering, 'remotePeeringAllowGatewayTransit')
        ? peering.remotePeeringAllowGatewayTransit
        : false
      allowVirtualNetworkAccess: contains(peering, 'remotePeeringAllowVirtualNetworkAccess')
        ? peering.remotePeeringAllowVirtualNetworkAccess
        : true
      doNotVerifyRemoteGateways: contains(peering, 'remotePeeringDoNotVerifyRemoteGateways')
        ? peering.remotePeeringDoNotVerifyRemoteGateways
        : true
      useRemoteGateways: contains(peering, 'remotePeeringUseRemoteGateways')
        ? peering.remotePeeringUseRemoteGateways
        : false
    }
  }
]

resource virtualNetwork_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: virtualNetwork
}

resource virtualNetwork_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: virtualNetwork
  }
]

resource virtualNetwork_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(virtualNetwork.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: virtualNetwork
  }
]

@description('The resource group the virtual network was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual network.')
output resourceId string = virtualNetwork.id

@description('The name of the virtual network.')
output name string = virtualNetwork.name

@description('The names of the deployed subnets.')
output subnetNames array = [for subnet in subnets: subnet.name]

@description('The resource IDs of the deployed subnets.')
output subnetResourceIds array = [
  for subnet in subnets: az.resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnet.name)
]

@description('The location the resource was deployed into.')
output location string = virtualNetwork.location

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
