metadata name = 'Purview Accounts'
metadata description = 'This module deploys a Purview Account.'

@description('Required. Name of the Purview Account.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlyUserAssignedType?

@description('Optional. The state of the managed Event Hub.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param managedEventHubState string = 'Disabled'

@description('Optional. The Managed Resource Group Name. A managed Storage Account, and an Event Hubs will be created in the selected subscription for catalog ingestion scenarios. Default is \'managed-rg-<purview-account-name>\'.')
param managedResourceGroupName string = 'managed-rg-${name}'

@description('Optional. Whether or not public network access is allowed for managed resources.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param managedResourcesPublicNetworkAccess string = 'NotSpecified'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param publicNetworkAccess string = 'NotSpecified'

@description('Optional. The state of tenant endpoint.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param tenantEndpointState string = 'NotSpecified'

@description('Optional. The SKU of the Purview Account.')
@allowed([
  'Standard'
  'Free'
])
param accountSku string = 'Standard'

@description('Optional. The capacity of the Purview Account SKU. The default value is 1.')
param accountSkuCapacity int = 1

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for Purview Account private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'account\'.')
param accountPrivateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configuration details for Purview Portal private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'portal\'.')
param portalPrivateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configuration details for Purview Managed Storage Account blob private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'blob\'.')
param storageBlobPrivateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configuration details for Purview Managed Storage Account queue private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'queue\'.')
param storageQueuePrivateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configuration details for Purview Managed Event Hub namespace private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'namespace\'.')
param eventHubPrivateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

// =========== //
// Variables   //
// =========== //

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = {
  type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
}

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
  name: '46d3xbcp.res.purview-account.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource account 'Microsoft.Purview/accounts@2024-04-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    cloudConnectors: {}
    ingestionStorage: {
      publicNetworkAccess: publicNetworkAccess
    }
    managedEventHubState: managedEventHubState
    managedResourceGroupName: managedResourceGroupName
    managedResourcesPublicNetworkAccess: managedResourcesPublicNetworkAccess
    publicNetworkAccess: publicNetworkAccess
    tenantEndpointState: tenantEndpointState
  }
  sku: {
    capacity: accountSkuCapacity
    name: accountSku
  }
}

resource account_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: account
}

resource account_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: account
  }
]

module account_accountPrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (accountPrivateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-account-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
              properties: {
                privateLinkServiceId: account.id
                groupIds: [
                  privateEndpoint.?service ?? 'account'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
              properties: {
                privateLinkServiceId: account.id
                groupIds: [
                  privateEndpoint.?service ?? 'account'
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

module account_portalPrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (portalPrivateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-portal-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'portal'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'portal'}-${index}'
              properties: {
                privateLinkServiceId: account.id
                groupIds: [
                  privateEndpoint.?service ?? 'portal'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'portal'}-${index}'
              properties: {
                privateLinkServiceId: account.id
                groupIds: [
                  privateEndpoint.?service ?? 'portal'
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

module account_storageBlobPrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (storageBlobPrivateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-blob-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'blob'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'blob'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.storageAccount
                groupIds: [
                  privateEndpoint.?service ?? 'blob'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'blob'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.storageAccount
                groupIds: [
                  privateEndpoint.?service ?? 'blob'
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

module account_storageQueuePrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (storageQueuePrivateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-queue-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'queue'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'queue'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.storageAccount
                groupIds: [
                  privateEndpoint.?service ?? 'queue'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'queue'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.storageAccount
                groupIds: [
                  privateEndpoint.?service ?? 'queue'
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

module account_eventHubPrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (eventHubPrivateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-eventHub-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.eventHubNamespace
                groupIds: [
                  privateEndpoint.?service ?? 'namespace'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(account.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: account.properties.managedResources.eventHubNamespace
                groupIds: [
                  privateEndpoint.?service ?? 'namespace'
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

resource account_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(account.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: account
  }
]

@description('The name of the Purview Account.')
output name string = account.name

@description('The resource group the Purview Account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Purview Account.')
output resourceId string = account.id

@description('The location the resource was deployed into.')
output location string = account.location

@description('The name of the managed resource group.')
output managedResourceGroupName string? = account.properties.?managedResourceGroupName

@description('The resource ID of the managed resource group.')
output managedResourceGroupId string? = account.properties.?managedResources.?resourceGroup

@description('The resource ID of the managed storage account.')
output managedStorageAccountId string? = account.properties.?managedResources.?storageAccount

@description('The resource ID of the managed Event Hub Namespace.')
output managedEventHubId string? = account.properties.?managedResources.?eventHubNamespace

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = account.?identity.?principalId

@description('The private endpoints of the Purview Account.')
output accountPrivateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (accountPrivateEndpoints ?? []): {
    name: account_accountPrivateEndpoints[index].outputs.name
    resourceId: account_accountPrivateEndpoints[index].outputs.resourceId
    groupId: account_accountPrivateEndpoints[index].outputs.?groupId!
    customDnsConfigs: account_accountPrivateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: account_accountPrivateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

@description('The private endpoints of the Purview Account Portal.')
output portalPrivateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (portalPrivateEndpoints ?? []): {
    name: account_portalPrivateEndpoints[index].outputs.name
    resourceId: account_portalPrivateEndpoints[index].outputs.resourceId
    groupId: account_portalPrivateEndpoints[index].outputs.?groupId!
    customDnsConfigs: account_portalPrivateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: account_portalPrivateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

@description('The private endpoints of the managed storage account blob service.')
output storageBlobPrivateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (storageBlobPrivateEndpoints ?? []): {
    name: account_storageBlobPrivateEndpoints[index].outputs.name
    resourceId: account_storageBlobPrivateEndpoints[index].outputs.resourceId
    groupId: account_storageBlobPrivateEndpoints[index].outputs.?groupId!
    customDnsConfigs: account_storageBlobPrivateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: account_storageBlobPrivateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

@description('The private endpoints of the managed storage account queue service.')
output storageQueuePrivateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (storageQueuePrivateEndpoints ?? []): {
    name: account_storageQueuePrivateEndpoints[index].outputs.name
    resourceId: account_storageQueuePrivateEndpoints[index].outputs.resourceId
    groupId: account_storageQueuePrivateEndpoints[index].outputs.?groupId!
    customDnsConfigs: account_storageQueuePrivateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: account_storageQueuePrivateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

@description('The private endpoints of the managed Event Hub Namespace.')
output eventHubPrivateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (eventHubPrivateEndpoints ?? []): {
    name: account_eventHubPrivateEndpoints[index].outputs.name
    resourceId: account_eventHubPrivateEndpoints[index].outputs.resourceId
    groupId: account_eventHubPrivateEndpoints[index].outputs.?groupId!
    customDnsConfigs: account_eventHubPrivateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: account_eventHubPrivateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

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
