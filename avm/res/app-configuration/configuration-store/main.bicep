metadata name = 'App Configuration Stores'
metadata description = 'This module deploys an App Configuration Store.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure App Configuration.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@allowed([
  'Free'
  'Standard'
])
@description('Optional. Pricing tier of App Configuration.')
param sku string = 'Standard'

@allowed([
  'Default'
  'Recover'
])
@description('Optional. Indicates whether the configuration store need to be recovered.')
param createMode string = 'Default'

@description('Optional. Disables all authentication methods other than AAD authentication.')
param disableLocalAuth bool = true

@description('Optional. Property specifying whether protection against purge is enabled for this configuration store. Defaults to true unless sku is set to Free, since purge protection is not available in Free tier.')
param enablePurgeProtection bool = true

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@description('Optional. The amount of time in days that the configuration store will be retained when it is soft deleted.')
@minValue(1)
@maxValue(7)
param softDeleteRetentionInDays int = 1

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. All Key / Values to create. Requires local authentication to be enabled.')
param keyValues array?

@description('Optional. All Replicas to create.')
param replicaLocations array?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Property specifying the configuration of data plane proxy for Azure Resource Manager (ARM).')
param dataPlaneProxy dataPlaneProxyType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'App Compliance Automation Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f37683f-2463-46b6-9ce7-9b788b988ba2'
  )
  'App Compliance Automation Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ffc6bbe0-e443-4c3b-bf54-26581bb2f78e'
  )
  'App Configuration Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'
  )
  'App Configuration Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '516239f1-63e1-4d78-a4de-a74fb236a071'
  )
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
  name: '46d3xbcp.res.appconfiguration-configurationstore.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  identity: identity
  properties: {
    createMode: createMode
    disableLocalAuth: disableLocalAuth
    enablePurgeProtection: sku == 'Free' ? false : enablePurgeProtection
    encryption: !empty(customerManagedKey)
      ? {
          keyVaultProperties: {
            keyIdentifier: !empty(customerManagedKey.?keyVersion)
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : (customerManagedKey.?autoRotationEnabled ?? true)
                  ? cMKKeyVault::cMKKey.properties.keyUri
                  : cMKKeyVault::cMKKey.properties.keyUriWithVersion
            identityClientId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? cMKUserAssignedIdentity.properties.clientId
              : null
          }
        }
      : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    softDeleteRetentionInDays: sku == 'Free' ? 0 : softDeleteRetentionInDays
    dataPlaneProxy: !empty(dataPlaneProxy)
      ? {
          authenticationMode: dataPlaneProxy.?authenticationMode ?? 'Pass-through'
          privateLinkDelegation: dataPlaneProxy!.privateLinkDelegation
        }
      : null
  }
}

module configurationStore_keyValues 'key-value/main.bicep' = [
  for (keyValue, index) in (keyValues ?? []): {
    name: '${uniqueString(deployment().name, location)}-AppConfig-KeyValues-${index}'
    params: {
      appConfigurationName: configurationStore.name
      name: keyValue.name
      value: keyValue.value
      contentType: keyValue.?contentType
      tags: keyValue.?tags ?? tags
    }
  }
]

module configurationStore_replicas 'replica/main.bicep' = [
  for (replicaLocation, index) in (replicaLocations ?? []): {
    name: '${uniqueString(deployment().name, location)}-AppConfig-Replicas-${index}'
    params: {
      appConfigurationName: configurationStore.name
      replicaLocation: replicaLocation
      name: '${replicaLocation}replica'
    }
  }
]
resource configurationStore_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: configurationStore
}

resource configurationStore_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: configurationStore
  }
]

resource configurationStore_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      configurationStore.id,
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
    scope: configurationStore
  }
]

@batchSize(1)
module configurationStore_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-configurationStore-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(configurationStore.id, '/'))}-${privateEndpoint.?service ?? 'configurationStores'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(configurationStore.id, '/'))}-${privateEndpoint.?service ?? 'configurationStores'}-${index}'
              properties: {
                privateLinkServiceId: configurationStore.id
                groupIds: [
                  privateEndpoint.?service ?? 'configurationStores'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(configurationStore.id, '/'))}-${privateEndpoint.?service ?? 'configurationStores'}-${index}'
              properties: {
                privateLinkServiceId: configurationStore.id
                groupIds: [
                  privateEndpoint.?service ?? 'configurationStores'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
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

@description('The name of the app configuration.')
output name string = configurationStore.name

@description('The resource ID of the app configuration.')
output resourceId string = configurationStore.id

@description('The resource group the app configuration store was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = configurationStore.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = configurationStore.location

@description('The endpoint of the app configuration.')
output endpoint string = configurationStore.properties.endpoint

@description('The private endpoints of the app configuration.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: configurationStore_privateEndpoints[i].outputs.name
    resourceId: configurationStore_privateEndpoints[i].outputs.resourceId
    groupId: configurationStore_privateEndpoints[i].outputs.groupId
    customDnsConfig: configurationStore_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: configurationStore_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the data plane proxy.')
type dataPlaneProxyType = {
  @description('Optional. The data plane proxy authentication mode. This property manages the authentication mode of request to the data plane resources. \'Pass-through\' is recommended.')
  authenticationMode: ('Local' | 'Pass-through')?

  @description('Required. The data plane proxy private link delegation. This property manages if a request from delegated Azure Resource Manager (ARM) private link is allowed when the data plane resource requires private link.')
  privateLinkDelegation: 'Disabled' | 'Enabled'
}
