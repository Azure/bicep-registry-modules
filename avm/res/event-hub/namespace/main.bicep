metadata name = 'Event Hub Namespaces'
metadata description = 'This module deploys an Event Hub Namespace.'

@description('Required. The name of the event hub namespace.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. event hub plan SKU name.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Optional. The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.')
@minValue(1)
@maxValue(20)
param skuCapacity int = 1

@description('Optional. Switch to make the Event Hub Namespace zone redundant.')
param zoneRedundant bool = true

@description('Optional. Switch to enable the Auto Inflate feature of Event Hub. Auto Inflate is not supported in Premium SKU EventHub.')
param isAutoInflateEnabled bool = false

@description('Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units.')
@minValue(0)
@maxValue(20)
param maximumThroughputUnits int = 1

@description('Optional. Authorization Rules for the Event Hub namespace.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

@description('Optional. This property disables SAS authentication for the Event Hubs namespace.')
param disableLocalAuth bool = true

@description('Optional. Value that indicates whether Kafka is enabled for Event Hubs Namespace.')
param kafkaEnabled bool = false

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. The minimum TLS version for the cluster to support.')
param minimumTlsVersion string = '1.2'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configure networking options. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.EventHub/namespaces@2024-01-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The event hubs to deploy into this namespace.')
param eventhubs array = []

@description('Optional. The disaster recovery config for this namespace.')
param disasterRecoveryConfig disasterRecoveryConfigType?

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

var enableReferencedModulesTelemetry = false

var maximumThroughputUnitsVar = !isAutoInflateEnabled ? 0 : maximumThroughputUnits

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Azure Event Hubs Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f526a384-b230-433a-b45c-95f59c4a2dec'
  )
  'Azure Event Hubs Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a638d3c7-ab3a-418d-83e6-5f17a39d4fde'
  )
  'Azure Event Hubs Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2b629674-e913-4c01-ae53-ef4638d8f975'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventhub-namespace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuName
    capacity: skuCapacity
  }
  properties: {
    disableLocalAuth: disableLocalAuth
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: [
            {
              identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
                ? {
                    userAssignedIdentity: cMKUserAssignedIdentity.id
                  }
                : null
              keyName: customerManagedKey!.keyName
              keyVaultUri: cMKKeyVault!.properties.vaultUri
              keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
                ? customerManagedKey!.?keyVersion
                : (customerManagedKey.?autoRotationEnabled ?? true)
                    ? null
                    : last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
            }
          ]
          requireInfrastructureEncryption: requireInfrastructureEncryption
        }
      : null
    isAutoInflateEnabled: isAutoInflateEnabled
    kafkaEnabled: kafkaEnabled
    maximumThroughputUnits: maximumThroughputUnitsVar
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: networkRuleSets.?publicNetworkAccess ?? (!empty(privateEndpoints) && empty(networkRuleSets)
      ? 'Disabled'
      : publicNetworkAccess)
    zoneRedundant: zoneRedundant
  }
}

module eventHubNamespace_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${uniqueString(deployment().name, location)}-EvhbNamespace-AuthRule-${index}'
    params: {
      namespaceName: eventHubNamespace.name
      name: authorizationRule.name
      rights: authorizationRule.?rights ?? []
    }
  }
]

module eventHubNamespace_disasterRecoveryConfig 'disaster-recovery-config/main.bicep' = if (!empty(disasterRecoveryConfig)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-DisRecConfig'
  params: {
    namespaceName: eventHubNamespace.name
    name: disasterRecoveryConfig!.name
    partnerNamespaceResourceId: disasterRecoveryConfig.?partnerNamespaceResourceId
  }
}

module eventHubNamespace_eventhubs 'eventhub/main.bicep' = [
  for (eventHub, index) in eventhubs: {
    name: '${uniqueString(deployment().name, location)}-EvhbNamespace-EventHub-${index}'
    params: {
      namespaceName: eventHubNamespace.name
      name: eventHub.name
      enableTelemetry: enableReferencedModulesTelemetry
      authorizationRules: eventHub.?authorizationRules
      captureDescriptionDestinationArchiveNameFormat: eventHub.?captureDescriptionDestinationArchiveNameFormat
      captureDescriptionDestinationBlobContainer: eventHub.?captureDescriptionDestinationBlobContainer
      captureDescriptionDestinationName: eventHub.?captureDescriptionDestinationName
      captureDescriptionDestinationStorageAccountResourceId: eventHub.?captureDescriptionDestinationStorageAccountResourceId
      captureDescriptionEnabled: eventHub.?captureDescriptionEnabled
      captureDescriptionEncoding: eventHub.?captureDescriptionEncoding
      captureDescriptionIntervalInSeconds: eventHub.?captureDescriptionIntervalInSeconds
      captureDescriptionSizeLimitInBytes: eventHub.?captureDescriptionSizeLimitInBytes
      captureDescriptionSkipEmptyArchives: eventHub.?captureDescriptionSkipEmptyArchives
      consumergroups: eventHub.?consumergroups ?? []
      lock: eventHub.?lock ?? lock
      messageRetentionInDays: eventHub.?messageRetentionInDays
      partitionCount: eventHub.?partitionCount
      roleAssignments: eventHub.?roleAssignments
      status: eventHub.?status
      retentionDescriptionEnabled: eventHub.?retentionDescriptionEnabled
      retentionDescriptionCleanupPolicy: eventHub.?retentionDescriptionCleanupPolicy
      retentionDescriptionRetentionTimeInHours: eventHub.?retentionDescriptionRetentionTimeInHours
      retentionDescriptionTombstoneRetentionTimeInHours: eventHub.?retentionDescriptionTombstoneRetentionTimeInHours
    }
  }
]

module eventHubNamespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-NetworkRuleSet'
  params: {
    namespaceName: eventHubNamespace.name
    publicNetworkAccess: networkRuleSets.?publicNetworkAccess ?? (!empty(privateEndpoints) && empty(networkRuleSets)
      ? 'Disabled'
      : 'Enabled')
    defaultAction: networkRuleSets.?defaultAction
    trustedServiceAccessEnabled: networkRuleSets.?trustedServiceAccessEnabled
    ipRules: networkRuleSets.?ipRules
    virtualNetworkRules: networkRuleSets.?virtualNetworkRules
  }
}

module eventHubNamespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(eventHubNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(eventHubNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: eventHubNamespace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(eventHubNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: eventHubNamespace.id
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

resource eventHubNamespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      eventHubNamespace.id,
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
    scope: eventHubNamespace
  }
]

resource eventHubNamespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: eventHubNamespace
}

resource eventHubNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: eventHubNamespace
  }
]

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[2],
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId!, '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'rootPrimaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?rootPrimaryConnectionStringName
              value: listkeys('${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', '2024-01-01').primaryConnectionString
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'rootSecondaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?rootSecondaryConnectionStringName
              value: listkeys('${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', '2024-01-01').secondaryConnectionString
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'rootPrimaryKeyName')
        ? [
            {
              name: secretsExportConfiguration!.?rootPrimaryKeyName
              value: listkeys('${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', '2024-01-01').primaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'rootSecondaryKeyName')
        ? [
            {
              name: secretsExportConfiguration!.?rootSecondaryKeyName
              value: listkeys('${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', '2024-01-01').secondaryKey
            }
          ]
        : []
    )
  }
}

@description('The name of the eventspace.')
output name string = eventHubNamespace.name

@description('The resource ID of the eventspace.')
output resourceId string = eventHubNamespace.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = eventHubNamespace.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = eventHubNamespace.location

@description('The Resources IDs of the EventHubs within this eventspace.')
output eventHubResourceIds string[] = [
  for index in range(0, length(eventhubs ?? [])): eventHubNamespace_eventhubs[index].outputs.resourceId
]

@description('The private endpoints of the eventspace.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: eventHubNamespace_privateEndpoints[index].outputs.name
    resourceId: eventHubNamespace_privateEndpoints[index].outputs.resourceId
    groupId: eventHubNamespace_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: eventHubNamespace_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: eventHubNamespace_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport!.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

@secure()
@description('The namespace\'s primary connection string.')
output primaryConnectionString string = listkeys(
  '${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey',
  '2024-01-01'
).primaryConnectionString

@secure()
@description('The namespace\'s secondary connection string.')
output secondaryConnectionString string = listkeys(
  '${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey',
  '2024-01-01'
).secondaryConnectionString

@secure()
@description('The namespace\'s primary key.')
output primaryKey string = listkeys(
  '${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey',
  '2024-01-01'
).primaryKey

@secure()
@description('The namespace\'s secondary key.')
output secondaryKey string = listkeys(
  '${eventHubNamespace.id}/AuthorizationRules/RootManageSharedAccessKey',
  '2024-01-01'
).secondaryKey

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

@export()
type disasterRecoveryConfigType = {
  @description('Required. The name of the disaster recovery config.')
  name: string

  @description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.')
  partnerNamespaceResourceId: string?
}

@export()
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The rootPrimaryConnectionStringName secret name to create.')
  rootPrimaryConnectionStringName: string?

  @description('Optional. The rootSecondaryConnectionStringName secret name to create.')
  rootSecondaryConnectionStringName: string?

  @description('Optional. The rootPrimaryKeyName secret name to create.')
  rootPrimaryKeyName: string?

  @description('Optional. The rootSecondaryKeyName secret name to create.')
  rootSecondaryKeyName: string?
}
