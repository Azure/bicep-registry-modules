metadata name = 'Service Bus Namespaces'
metadata description = 'This module deploys a Service Bus Namespace.'

@description('Required. Name of the Service Bus Namespace.')
@maxLength(260)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The SKU of the Service Bus Namespace. Defaulted to Premium for ZoneRedundant configurations by default.')
param skuObject skuType = {
  name: 'Premium'
  capacity: 2
}

@description('Optional. Enabled by default in order to align with resiliency best practices, thus requires Premium SKU.')
param zoneRedundant bool = true

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. The minimum TLS version for the cluster to support.')
param minimumTlsVersion string = '1.2'

@description('Optional. Alternate name for namespace.')
param alternateName string?

@description('Optional. The number of partitions of a Service Bus namespace. This property is only applicable to Premium SKU namespaces. The default value is 1 and possible values are 1, 2 and 4.')
param premiumMessagingPartitions int = 1

@description('Optional. Authorization Rules for the Service Bus namespace.')
param authorizationRules authorizationRuleType[] = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

@description('Optional. The migration configuration.')
param migrationConfiguration migrationConfigurationType?

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfig disasterRecoveryConfigType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets networkRuleSetType?

@description('Optional. This property disables SAS authentication for the Service Bus namespace.')
param disableLocalAuth bool = true

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The queues to create in the service bus namespace.')
param queues queueType[]?

@description('Optional. The topics to create in the service bus namespace.')
param topics topicType[]?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = true

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
  'Azure Service Bus Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '090c5cfd-751d-490a-894a-3ce6f1109419'
  )
  'Azure Service Bus Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  )
  'Azure Service Bus Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
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
  name: '46d3xbcp.res.servicebus-namespace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuObject.name
    capacity: skuObject.?capacity
  }
  identity: identity
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    minimumTlsVersion: minimumTlsVersion
    alternateName: alternateName
    zoneRedundant: zoneRedundant
    disableLocalAuth: disableLocalAuth
    premiumMessagingPartitions: skuObject.name == 'Premium' ? premiumMessagingPartitions : 0
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
              keyVaultUri: cMKKeyVault.properties.vaultUri
              keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
                ? customerManagedKey!.keyVersion
                : (customerManagedKey.?autoRotationEnabled ?? true)
                    ? null
                    : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
            }
          ]
          requireInfrastructureEncryption: requireInfrastructureEncryption
        }
      : null
  }
}

module serviceBusNamespace_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
    params: {
      namespaceName: serviceBusNamespace.name
      name: authorizationRule.name
      rights: authorizationRule.?rights
    }
  }
]

module serviceBusNamespace_disasterRecoveryConfig 'disaster-recovery-config/main.bicep' = if (!empty(disasterRecoveryConfig)) {
  name: '${uniqueString(deployment().name, location)}-DisasterRecoveryConfig'
  params: {
    namespaceName: serviceBusNamespace.name
    name: disasterRecoveryConfig.?name ?? 'default'
    alternateName: disasterRecoveryConfig.?alternateName
    partnerNamespaceResourceID: disasterRecoveryConfig.?partnerNamespace
  }
}

module serviceBusNamespace_migrationConfiguration 'migration-configuration/main.bicep' = if (!empty(migrationConfiguration ?? {})) {
  name: '${uniqueString(deployment().name, location)}-MigrationConfigurations'
  params: {
    namespaceName: serviceBusNamespace.name
    postMigrationName: migrationConfiguration!.postMigrationName
    targetNamespaceResourceId: migrationConfiguration!.targetNamespace
  }
}

module serviceBusNamespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-NetworkRuleSet'
  params: {
    namespaceName: serviceBusNamespace.name
    publicNetworkAccess: networkRuleSets.?publicNetworkAccess ?? (!empty(privateEndpoints) && empty(networkRuleSets)
      ? 'Disabled'
      : 'Enabled')
    defaultAction: networkRuleSets.?defaultAction ?? 'Allow'
    trustedServiceAccessEnabled: networkRuleSets.?trustedServiceAccessEnabled ?? true
    ipRules: networkRuleSets.?ipRules ?? []
    virtualNetworkRules: networkRuleSets.?virtualNetworkRules ?? []
  }
}

module serviceBusNamespace_queues 'queue/main.bicep' = [
  for (queue, index) in (queues ?? []): {
    name: '${uniqueString(deployment().name, location)}-Queue-${index}'
    params: {
      namespaceName: serviceBusNamespace.name
      name: queue.name
      autoDeleteOnIdle: queue.?autoDeleteOnIdle
      forwardDeadLetteredMessagesTo: queue.?forwardDeadLetteredMessagesTo
      forwardTo: queue.?forwardTo
      maxMessageSizeInKilobytes: queue.?maxMessageSizeInKilobytes
      authorizationRules: queue.?authorizationRules
      deadLetteringOnMessageExpiration: queue.?deadLetteringOnMessageExpiration
      defaultMessageTimeToLive: queue.?defaultMessageTimeToLive
      duplicateDetectionHistoryTimeWindow: queue.?duplicateDetectionHistoryTimeWindow
      enableBatchedOperations: queue.?enableBatchedOperations
      enableExpress: queue.?enableExpress
      enablePartitioning: queue.?enablePartitioning
      lock: queue.?lock ?? lock
      lockDuration: queue.?lockDuration
      maxDeliveryCount: queue.?maxDeliveryCount
      maxSizeInMegabytes: queue.?maxSizeInMegabytes
      requiresDuplicateDetection: queue.?requiresDuplicateDetection
      requiresSession: queue.?requiresSession
      roleAssignments: queue.?roleAssignments
      status: queue.?status
    }
  }
]

module serviceBusNamespace_topics 'topic/main.bicep' = [
  for (topic, index) in (topics ?? []): {
    name: '${uniqueString(deployment().name, location)}-Topic-${index}'
    params: {
      namespaceName: serviceBusNamespace.name
      name: topic.name
      authorizationRules: topic.?authorizationRules
      autoDeleteOnIdle: topic.?autoDeleteOnIdle
      defaultMessageTimeToLive: topic.?defaultMessageTimeToLive
      duplicateDetectionHistoryTimeWindow: topic.?duplicateDetectionHistoryTimeWindow
      enableBatchedOperations: topic.?enableBatchedOperations
      enableExpress: topic.?enableExpress
      enablePartitioning: topic.?enablePartitioning
      lock: topic.?lock ?? lock
      maxMessageSizeInKilobytes: topic.?maxMessageSizeInKilobytes
      requiresDuplicateDetection: topic.?requiresDuplicateDetection
      roleAssignments: topic.?roleAssignments
      status: topic.?status
      supportOrdering: topic.?supportOrdering
      subscriptions: topic.?subscriptions
      maxSizeInMegabytes: topic.?maxSizeInMegabytes
    }
  }
]

resource serviceBusNamespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: serviceBusNamespace
}

resource serviceBusNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: serviceBusNamespace
  }
]

module serviceBusNamespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-serviceBusNamespace-PrivateEndpoint-${index}'
    scope: !empty(privateEndpoint.?resourceGroupResourceId)
      ? resourceGroup(
          split((privateEndpoint.?resourceGroupResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?resourceGroupResourceId ?? '////'), '/')[4]
        )
      : resourceGroup(
          split((privateEndpoint.?subnetResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?subnetResourceId ?? '////'), '/')[4]
        )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(serviceBusNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(serviceBusNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: serviceBusNamespace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(serviceBusNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: serviceBusNamespace.id
                groupIds: [
                  privateEndpoint.?service ?? 'namespace'
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

resource serviceBusNamespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      serviceBusNamespace.id,
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
    scope: serviceBusNamespace
  }
]

@description('The resource ID of the deployed service bus namespace.')
output resourceId string = serviceBusNamespace.id

@description('The resource group of the deployed service bus namespace.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed service bus namespace.')
output name string = serviceBusNamespace.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = serviceBusNamespace.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = serviceBusNamespace.location

@description('The private endpoints of the service bus namespace.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: serviceBusNamespace_privateEndpoints[i].outputs.name
    resourceId: serviceBusNamespace_privateEndpoints[i].outputs.resourceId
    groupId: serviceBusNamespace_privateEndpoints[i].outputs.groupId
    customDnsConfig: serviceBusNamespace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: serviceBusNamespace_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

@description('The endpoint of the deployed service bus namespace.')
output serviceBusEndpoint string = serviceBusNamespace.properties.serviceBusEndpoint

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a SKU.')
type skuType = {
  @description('Required. Name of this SKU. - Basic, Standard, Premium.')
  name: ('Basic' | 'Standard' | 'Premium')

  @description('Optional. The specified messaging units for the tier. Only used for Premium Sku tier.')
  capacity: int?
}

@export()
@description('The type for an authorization rule.')
type authorizationRuleType = {
  @description('Required. The name of the authorization rule.')
  name: string

  @description('Optional. The rights associated with the rule.')
  rights: ('Listen' | 'Manage' | 'Send')[]?
}

@export()
@description('The type for a disaster recovery configuration.')
type disasterRecoveryConfigType = {
  @description('Optional. The name of the disaster recovery config.')
  name: string?

  @description('Optional. Primary/Secondary eventhub namespace name, which is part of GEO DR pairing.')
  alternateName: string?

  @description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.')
  partnerNamespace: string?
}

@export()
@description('The type for a migration configuration')
type migrationConfigurationType = {
  @description('Required. Name to access Standard Namespace after migration.')
  postMigrationName: string

  @description('Required. Existing premium Namespace resource ID which has no entities, will be used for migration.')
  targetNamespace: string
}

@export()
@description('The type for a network rule set.')
type networkRuleSetType = {
  @description('Optional. This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied.')
  publicNetworkAccess: ('Disabled' | 'Enabled')?

  @description('Optional. Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used.')
  defaultAction: ('Allow' | 'Deny')?

  @description('Optional. Value that indicates whether Trusted Service Access is enabled or not. Default is "true". It will not be set if publicNetworkAccess is "Disabled".')
  trustedServiceAccessEnabled: bool?

  @description('Optional. List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
  ipRules: {
    @description('Required. The IP filter action.')
    action: ('Allow' | 'Deny')

    @description('Required. The IP mask.')
    ipMask: string
  }[]?

  @description('Optional. List virtual network rules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
  virtualNetworkRules: {
    @description('Required. The virtual network rule name.')
    ignoreMissingVnetServiceEndpoint: bool

    @description('Required. The ID of the subnet.')
    subnetResourceId: string
  }[]?
}

@export()
@description('The type for a queue.')
type queueType = {
  @description('Required. The name of the queue.')
  name: string

  @description('Optional. ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M).')
  autoDeleteOnIdle: string?

  @description('Optional. Queue/Topic name to forward the Dead Letter message.')
  forwardDeadLetteredMessagesTo: string?

  @description('Optional. Queue/Topic name to forward the messages.')
  forwardTo: string?

  @description('Optional. Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024.')
  maxMessageSizeInKilobytes: int?

  @description('Optional. Authorization Rules for the Service Bus Queue.')
  authorizationRules: authorizationRuleType[]?

  @description('Optional. A value that indicates whether this queue has dead letter support when a message expires.')
  deadLetteringOnMessageExpiration: bool?

  @description('Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
  defaultMessageTimeToLive: string?

  @description('Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.')
  duplicateDetectionHistoryTimeWindow: string?

  @description('Optional. Value that indicates whether server-side batched operations are enabled.')
  enableBatchedOperations: bool?

  @description('Optional. A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.')
  enableExpress: bool?

  @description('Optional. A value that indicates whether the queue is to be partitioned across multiple message brokers.')
  enablePartitioning: bool?

  @description('Optional. The lock settings of the service.')
  lock: lockType?

  @description('Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.')
  lockDuration: string?

  @description('Optional. The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.')
  maxDeliveryCount: int?

  @description('Optional. The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024.')
  maxSizeInMegabytes: int?

  @description('Optional. A value indicating if this queue requires duplicate detection.')
  requiresDuplicateDetection: bool?

  @description('Optional. A value that indicates whether the queue supports the concept of sessions.')
  requiresSession: bool?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.')
  status: (
    | 'Active'
    | 'Disabled'
    | 'Restoring'
    | 'SendDisabled'
    | 'ReceiveDisabled'
    | 'Creating'
    | 'Deleting'
    | 'Renaming'
    | 'Unknown')?
}

import { subscriptionType } from 'topic/main.bicep'
@export()
@description('The type for a topic.')
type topicType = {
  @description('Required. The name of the topic.')
  name: string

  @description('Optional. Authorization Rules for the Service Bus Topic.')
  authorizationRules: authorizationRuleType[]?

  @description('Optional. ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes.')
  autoDeleteOnIdle: string?

  @description('Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
  defaultMessageTimeToLive: string?

  @description('Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.')
  duplicateDetectionHistoryTimeWindow: string?

  @description('Optional. Value that indicates whether server-side batched operations are enabled.')
  enableBatchedOperations: bool?

  @description('Optional. A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.')
  enableExpress: bool?

  @description('Optional. A value that indicates whether the topic is to be partitioned across multiple message brokers.')
  enablePartitioning: bool?

  @description('Optional. The lock settings of the service.')
  lock: lockType?

  @description('Optional. Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024.')
  maxMessageSizeInKilobytes: int?

  @description('Optional. The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024.')
  maxSizeInMegabytes: int?

  @description('Optional. A value indicating if this topic requires duplicate detection.')
  requiresDuplicateDetection: bool?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.')
  status: (
    | 'Active'
    | 'Disabled'
    | 'Restoring'
    | 'SendDisabled'
    | 'ReceiveDisabled'
    | 'Creating'
    | 'Deleting'
    | 'Renaming'
    | 'Unknown')?

  @description('Optional. Value that indicates whether the topic supports ordering.')
  supportOrdering: bool?

  @description('Optional. The subscriptions of the topic.')
  subscriptions: subscriptionType[]?
}
