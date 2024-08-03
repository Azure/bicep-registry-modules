metadata name = 'Service Bus Namespaces'
metadata description = 'This module deploys a Service Bus Namespace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Service Bus Namespace.')
@maxLength(260)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The SKU of the Service Bus Namespace.')
param skuObject skuType

@description('Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones.')
param zoneRedundant bool = false

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
param authorizationRules authorizationRuleType = [
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
param migrationConfiguration migrationConfigurationsType

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfig disasterRecoveryConfigType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets networkRuleSetType?

@description('Optional. This property disables SAS authentication for the Service Bus namespace.')
param disableLocalAuth bool = true

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The queues to create in the service bus namespace.')
param queues queueType?

@description('Optional. The topics to create in the service bus namespace.')
param topics topicType?

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourcesIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'UserAssigned' : null)
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

module serviceBusNamespace_migrationConfigurations 'migration-configuration/main.bicep' = if (!empty(migrationConfiguration ?? {})) {
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

module serviceBusNamespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.6.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-serviceBusNamespace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
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
output systemAssignedMIPrincipalId string = serviceBusNamespace.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = serviceBusNamespace.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourcesIds: string[]?
}?

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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
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

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}?

type skuType = {
  @description('Required. Name of this SKU. - Basic, Standard, Premium.')
  name: ('Basic' | 'Standard' | 'Premium')

  @description('Optional. The specified messaging units for the tier. Only used for Premium Sku tier.')
  capacity: int?
}

type authorizationRuleType = {
  @description('Required. The name of the authorization rule.')
  name: string

  @description('Optional. The rights associated with the rule.')
  rights: ('Listen' | 'Manage' | 'Send')[]?
}[]

type disasterRecoveryConfigType = {
  @description('Optional. The name of the disaster recovery config.')
  name: string?

  @description('Optional. Primary/Secondary eventhub namespace name, which is part of GEO DR pairing.')
  alternateName: string?

  @description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.')
  partnerNamespace: string?
}?

type migrationConfigurationsType = {
  @description('Required. Name to access Standard Namespace after migration.')
  postMigrationName: string

  @description('Required. Existing premium Namespace resource ID which has no entities, will be used for migration.')
  targetNamespace: string
}?

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
}?

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
  authorizationRules: authorizationRuleType?

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
  roleAssignments: roleAssignmentType?

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
}[]?

type topicType = {
  @description('Required. The name of the topic.')
  name: string

  @description('Optional. Authorization Rules for the Service Bus Topic.')
  authorizationRules: authorizationRuleType?

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
  roleAssignments: roleAssignmentType?

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
  subscriptions: {
    @description('Required. The name of the service bus namespace topic subscription.')
    name: string

    @description('Optional. ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes.')
    autoDeleteOnIdle: string?

    @description('Optional. The properties that are associated with a subscription that is client-affine.')
    clientAffineProperties: {
      @description('Required. Indicates the Client ID of the application that created the client-affine subscription.')
      clientId: string

      @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is durable or not.')
      isDurable: bool?

      @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is shared or not.')
      isShared: bool?
    }?

    @description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
    deadLetteringOnMessageExpiration: bool?

    @description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
    deadLetteringOnFilterEvaluationExceptions: bool?

    @description('Optional. ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.')
    defaultMessageTimeToLive: string?

    @description('Optional. ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.')
    duplicateDetectionHistoryTimeWindow: string?

    @description('Optional. A value that indicates whether server-side batched operations are enabled.')
    enableBatchedOperations: bool?

    @description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
    forwardDeadLetteredMessagesTo: string?

    @description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
    forwardTo: string?

    @description('Optional. A value that indicates whether the subscription supports the concept of session.')
    isClientAffine: bool?

    @description('Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.')
    lockDuration: string?

    @description('Optional. Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.')
    maxDeliveryCount: int?

    @description('Optional. A value that indicates whether the subscription supports the concept of session.')
    requiresSession: bool?

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
  }[]?
}[]?
