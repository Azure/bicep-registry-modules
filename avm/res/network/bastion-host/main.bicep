metadata name = 'Bastion Hosts'
metadata description = 'This module deploys a Bastion Host.'

@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Shared services Virtual Network resource Id.')
param virtualNetworkResourceId string

@description('Optional. The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet. This parameter is ignored when enablePrivateOnlyBastion is true.')
param bastionSubnetPublicIpResourceId string = ''

@description('Optional. Specifies the properties of the Public IP to create and be used by Azure Bastion, if no existing public IP was provided. This parameter is ignored when enablePrivateOnlyBastion is true.')
param publicIPAddressObject object = {
  name: '${name}-pip'
}

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@allowed([
  'Basic'
  'Developer'
  'Premium'
  'Standard'
])
@description('Optional. The SKU of this Bastion Host.')
param skuName string = 'Basic'

@description('Optional. Choose to disable or enable Copy Paste. For Basic and Developer SKU Copy/Paste is always enabled.')
param disableCopyPaste bool = false

@description('Optional. Choose to disable or enable File Copy. Not supported for Basic and Developer SKU.')
param enableFileCopy bool = true

@description('Optional. Choose to disable or enable IP Connect. Not supported for Basic and Developer SKU.')
param enableIpConnect bool = false

@description('Optional. Choose to disable or enable Kerberos authentication. Not supported for Developer SKU.')
param enableKerberos bool = false

@description('Optional. Choose to disable or enable Shareable Link. Not supported for Basic and Developer SKU.')
param enableShareableLink bool = false

@description('Optional. Choose to disable or enable Session Recording feature. The Premium SKU is required for this feature. If Session Recording is enabled, the Native client support will be disabled.')
param enableSessionRecording bool = false

@description('Optional. Choose to disable or enable Private-only Bastion deployment. The Premium SKU is required for this feature.')
param enablePrivateOnlyBastion bool = false

@description('Optional. The scale units for the Bastion Host resource. The Basic and Developer SKU only support 2 scale units.')
param scaleUnits int = 2

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A list of availability zones denoting where the Bastion Host resource needs to come from. This is not supported for the Developer SKU.')
@allowed([
  1
  2
  3
])
param zones int[] = [] // Availability Zones are currently in preview and only available in certain regions, therefore the default is an empty array.

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureBastionSubnet for different uses cases:
// 1. Use existing Public IP
// 2. Use new Public IP created in this module
// (skuName == 'Developer' is a special case where ipConfigurations is empty)
var ipConfigurations = skuName == 'Developer'
  ? []
  : [
      {
        name: 'IpConfAzureBastionSubnet'
        properties: union(
          {
            subnet: {
              id: '${virtualNetworkResourceId}/subnets/AzureBastionSubnet' // The subnet name must be AzureBastionSubnet
            }
          },
          (!enablePrivateOnlyBastion
            ? {
                //Use existing Public IP, new Public IP created in this module
                publicIPAddress: {
                  id: !empty(bastionSubnetPublicIpResourceId)
                    ? bastionSubnetPublicIpResourceId
                    : publicIPAddress.outputs.resourceId
                }
              }
            : {})
        )
      }
    ]

// ----------------------------------------------------------------------------

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-bastionhost.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module publicIPAddress 'br/public:avm/res/network/public-ip-address:0.8.0' = if (empty(bastionSubnetPublicIpResourceId) && (skuName != 'Developer') && (!enablePrivateOnlyBastion)) {
  name: '${uniqueString(deployment().name, location)}-Bastion-PIP'
  params: {
    name: publicIPAddressObject.name
    enableTelemetry: enableTelemetry
    location: location
    lock: lock
    diagnosticSettings: publicIPAddressObject.?diagnosticSettings
    publicIPAddressVersion: publicIPAddressObject.?publicIPAddressVersion
    publicIPAllocationMethod: publicIPAddressObject.?publicIPAllocationMethod
    publicIpPrefixResourceId: publicIPAddressObject.?publicIPPrefixResourceId
    roleAssignments: publicIPAddressObject.?roleAssignments
    skuName: publicIPAddressObject.?skuName
    skuTier: publicIPAddressObject.?skuTier
    tags: publicIPAddressObject.?tags ?? tags
    zones: publicIPAddressObject.?zones ?? (length(zones) > 0 ? zones : null) // if zones of the Public IP is empty, use the zones from the bastion host only if not empty (if empty, the default of the public IP will be used)
  }
}

var bastionpropertiesVar = union(
  {
    scaleUnits: (skuName == 'Basic' || skuName == 'Developer') ? 2 : scaleUnits
    ipConfigurations: ipConfigurations
  },
  (skuName == 'Developer'
    ? {
        virtualNetwork: {
          id: virtualNetworkResourceId
        }
      }
    : {}),
  ((skuName == 'Basic' || skuName == 'Standard' || skuName == 'Premium')
    ? {
        enableKerberos: enableKerberos
      }
    : {}),
  ((skuName == 'Standard' || skuName == 'Premium')
    ? {
        enableTunneling: skuName == 'Standard' ? true : (enableSessionRecording ? false : true) // Tunneling is enabled by default for Standard SKU. For Premium SKU it is disabled by default if Session Recording is enabled.
        disableCopyPaste: disableCopyPaste
        enableFileCopy: enableFileCopy
        enableIpConnect: enableIpConnect
        enableShareableLink: enableShareableLink
      }
    : {}),
  (skuName == 'Premium'
    ? {
        enableSessionRecording: enableSessionRecording
        enablePrivateOnlyBastion: enablePrivateOnlyBastion
      }
    : {})
)

resource azureBastion 'Microsoft.Network/bastionHosts@2024-05-01' = {
  name: name
  location: location
  tags: tags ?? {} // The empty object is a workaround for error when deploying with the Developer SKU. The error seems unrelated to the tags, but it is resolved by adding the empty object.
  sku: {
    name: skuName
  }
  zones: skuName == 'Developer' ? [] : map(zones, zone => string(zone))
  properties: bastionpropertiesVar
}

resource azureBastion_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: azureBastion
}

resource azureBastion_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
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
    scope: azureBastion
  }
]

resource azureBastion_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(azureBastion.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: azureBastion
  }
]

@description('The resource group the Azure Bastion was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name the Azure Bastion.')
output name string = azureBastion.name

@description('The resource ID the Azure Bastion.')
output resourceId string = azureBastion.id

@description('The location the resource was deployed into.')
output location string = azureBastion.location

@description('The Public IPconfiguration object for the AzureBastionSubnet.')
output ipConfAzureBastionSubnet object = skuName == 'Developer' ? {} : azureBastion.properties.ipConfigurations[0]
