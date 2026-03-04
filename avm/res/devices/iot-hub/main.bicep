metadata name = 'Azure Iot hubs'
metadata description = 'This module deploys a Iot Hub.'

@description('Required. The name of the IoT Hub.')
param name string

@description('Optional. Defaults to the current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the IoT Hub SKU.')
param skuName resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.sku.name

@description('Optional. The number of provisioned IoT Hub units. Restricted to 1 unit for the F1 SKU. Can be set up to 200 units for S1, S2, S3, B1, B2, B3 SKUs.')
@minValue(1)
@maxValue(200)
param skuCapacity resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.sku.capacity = 1

@description('Optional. List of allowed FQDNs(Fully Qualified Domain Name) for egress from Iot Hub.')
param allowedFqdnList resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.allowedFqdnList?

@description('Optional. The shared access policies you can use to secure a connection to the IoT hub.')
param authorizationPolicies resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.authorizationPolicies?

@description('Optional. The IoT hub cloud-to-device messaging properties.')
param cloudToDevice resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.cloudToDevice?

@description('Optional. IoT hub comments.')
param comments resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.comments?

@description('Optional. If true, all device(including Edge devices but excluding modules) scoped SAS keys cannot be used for authentication.')
param disableDeviceSAS resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.disableDeviceSAS = true

@description('Optional. If true, SAS tokens with Iot hub scoped SAS keys cannot be used for authentication.')
param disableLocalAuth resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.disableLocalAuth = true

@description('Optional. If true, all module scoped SAS keys cannot be used for authentication.')
param disableModuleSAS resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.disableModuleSAS = true

@description('Optional. This property when set to true, will enable data residency, thus, disabling disaster recovery.')
param enableDataResidency resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.enableDataResidency = false

@description('Optional. If True, file upload notifications are enabled.')
param enableFileUploadNotifications resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.enableFileUploadNotifications = false

@description('Optional. The Event Hub-compatible endpoint properties. The only possible keys to this dictionary is events. This key has to be present in the dictionary while making create or update calls for the IoT hub.')
param eventHubEndpoints resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.eventHubEndpoints?

@description('Optional. The capabilities and features enabled for the IoT hub.')
param features resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.features = 'None'

@description('Optional. The IP filter rules.')
param ipFilterRules resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.ipFilterRules?

@description('Optional. The messaging endpoint properties for the file upload notification queue.')
param messagingEndpoints resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.messagingEndpoints?

@description('Optional. Specifies the minimum TLS version to support for this hub. Can be set to "1.2" to have clients that use a TLS version below 1.2 to be rejected.')
param minTlsVersion resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.minTlsVersion = '1.2'

@description('Optional. Network Rule Set Properties of IotHub.')
param networkRuleSets resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.networkRuleSets?

@description('Optional. Whether requests from Public Network are allowed.')
param publicNetworkAccess resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.publicNetworkAccess = 'Disabled'

@description('Optional. Private endpoint connections created on this IotHub.')
param privateEndpointConnections resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.privateEndpointConnections?

@description('Optional. If true, egress from IotHub will be restricted to only the allowed FQDNs that are configured via allowedFqdnList.')
param restrictOutboundNetworkAccess resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.restrictOutboundNetworkAccess = true

@description('Optional. The routing related properties of the IoT hub. See: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-messaging.')
param routing resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.routing?

@description('Optional. The list of Azure Storage endpoints where you can upload files. Currently you can configure only one Azure Storage account and that MUST have its key as $default. Specifying more than one storage account causes an error to be thrown. Not specifying a value for this property when the enableFileUploadNotifications property is set to True, causes an error to be thrown.')
param storageEndpoints resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.properties.storageEndpoints?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Devices/IotHubs@2023-06-30'>.tags?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =========== //
// Variables   //
// =========== //

var enableReferencedModulesTelemetry bool = false

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

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devices-iothub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource iotHub 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    allowedFqdnList: allowedFqdnList
    authorizationPolicies: authorizationPolicies
    cloudToDevice: cloudToDevice
    comments: comments
    disableDeviceSAS: disableDeviceSAS
    disableLocalAuth: disableLocalAuth
    disableModuleSAS: disableModuleSAS
    enableDataResidency: enableDataResidency
    enableFileUploadNotifications: enableFileUploadNotifications
    eventHubEndpoints: eventHubEndpoints
    features: features
    ipFilterRules: ipFilterRules
    messagingEndpoints: messagingEndpoints
    minTlsVersion: minTlsVersion
    networkRuleSets: networkRuleSets
    publicNetworkAccess: publicNetworkAccess
    privateEndpointConnections: privateEndpointConnections
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    routing: routing
    storageEndpoints: storageEndpoints
  }
}

resource iothub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: iotHub
}

resource iothub_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: iotHub
  }
]

module iothub_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-iothub-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(iotHub.id, '/'))}-${privateEndpoint.?service ?? 'iotHub'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(iotHub.id, '/'))}-${privateEndpoint.?service ?? 'iotHub'}-${index}'
              properties: {
                privateLinkServiceId: iotHub.id
                groupIds: [
                  privateEndpoint.?service ?? 'iotHub'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(iotHub.id, '/'))}-${privateEndpoint.?service ?? 'iotHub'}-${index}'
              properties: {
                privateLinkServiceId: iotHub.id
                groupIds: [
                  privateEndpoint.?service ?? 'iotHub'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource iothub_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(iotHub.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: iotHub
  }
]

// =========== //
// Outputs     //
// =========== //
@description('The resource ID of the iotHub.')
output resourceId string = iotHub.id

@description('The name of the resource group the iotHub was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the iotHub.')
output name string = iotHub.name

@description('The location the resource was deployed into.')
output location string = iotHub.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = iotHub.?identity.?principalId

@description('The private endpoints of the iotHub.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: iothub_privateEndpoints[index].outputs.name
    resourceId: iothub_privateEndpoints[index].outputs.resourceId
    groupId: iothub_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: iothub_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: iothub_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}
