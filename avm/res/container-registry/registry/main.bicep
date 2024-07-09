metadata name = 'Azure Container Registries (ACR)'
metadata description = 'This module deploys an Azure Container Registry (ACR).'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tier of your Azure container registry.')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param acrSku string = 'Basic'

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The value that indicates whether the export policy is enabled or not.')
param exportPolicyStatus string = 'disabled'

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The value that indicates whether the quarantine policy is enabled or not. Note, requires the \'acrSku\' to be \'Premium\'.')
param quarantinePolicyStatus string = 'disabled'

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The value that indicates whether the trust policy is enabled or not. Note, requires the \'acrSku\' to be \'Premium\'.')
param trustPolicyStatus string = 'disabled'

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The value that indicates whether the retention policy is enabled or not.')
param retentionPolicyStatus string = 'enabled'

@description('Optional. The number of days to retain an untagged manifest after which it gets purged.')
param retentionPolicyDays int = 15

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled.')
param azureADAuthenticationAsArmPolicyStatus string = 'enabled'

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. Soft Delete policy status. Default is disabled.')
param softDeletePolicyStatus string = 'disabled'

@description('Optional. The number of days after which a soft-deleted item is permanently deleted.')
param softDeletePolicyDays int = 7

@description('Optional. Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the \'acrSku\' to be \'Premium\'.')
param dataEndpointEnabled bool = false

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the \'acrSku\' to be \'Premium\'.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@allowed([
  'AzureServices'
  'None'
])
@description('Optional. Whether to allow trusted Azure services to access a network restricted registry.')
param networkRuleBypassOptions string = 'AzureServices'

@allowed([
  'Allow'
  'Deny'
])
@description('Optional. The default action of allow or deny when no other rules match.')
param networkRuleSetDefaultAction string = 'Deny'

@description('Optional. The IP ACL rules. Note, requires the \'acrSku\' to be \'Premium\'.')
param networkRuleSetIpRules array?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the \'acrSku\' to be \'Premium\'.')
param privateEndpoints privateEndpointType

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether or not zone redundancy is enabled for this container registry.')
param zoneRedundancy string = 'Disabled'

@description('Optional. All replications to create.')
param replications array?

@description('Optional. All webhooks to create.')
param webhooks array?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Enables registry-wide pull from unauthenticated clients. It\'s in preview and available in the Standard and Premium service tiers.')
param anonymousPullEnabled bool = false

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@description('Optional. Array of Cache Rules. Note: This is a preview feature ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)).')
param cacheRules array?

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
  AcrDelete: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c2f4ef07-c644-48eb-af81-4b1b4947fb11')
  AcrImageSigner: subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6cef56e8-d556-48e5-a04f-b8e64114680f'
  )
  AcrPull: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  AcrPush: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8311e382-0749-4cb8-b61a-304f252e45ec')
  AcrQuarantineReader: subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'cdda3590-29a3-44f6-95f2-9f980659eb04'
  )
  AcrQuarantineWriter: subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c8d4ff99-41c3-41a8-9f60-21dfdad59608'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-registry.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' = {
  name: name
  location: location
  identity: identity
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    anonymousPullEnabled: anonymousPullEnabled
    adminUserEnabled: acrAdminUserEnabled
    encryption: !empty(customerManagedKey)
      ? {
          status: 'enabled'
          keyVaultProperties: {
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? cMKUserAssignedIdentity.properties.clientId
              : null
            keyIdentifier: !empty(customerManagedKey.?keyVersion ?? '')
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          }
        }
      : null
    policies: {
      azureADAuthenticationAsArmPolicy: {
        status: azureADAuthenticationAsArmPolicyStatus
      }
      exportPolicy: acrSku == 'Premium'
        ? {
            status: exportPolicyStatus
          }
        : null
      quarantinePolicy: acrSku == 'Premium'
        ? {
            status: quarantinePolicyStatus
          }
        : null
      trustPolicy: acrSku == 'Premium'
        ? {
            type: 'Notary'
            status: trustPolicyStatus
          }
        : null
      retentionPolicy: acrSku == 'Premium'
        ? {
            days: retentionPolicyDays
            status: retentionPolicyStatus
          }
        : null
      softDeletePolicy: {
        retentionDays: softDeletePolicyDays
        status: softDeletePolicyStatus
      }
    }
    dataEndpointEnabled: dataEndpointEnabled
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) && empty(networkRuleSetIpRules) ? 'Disabled' : null)
    networkRuleBypassOptions: networkRuleBypassOptions
    networkRuleSet: !empty(networkRuleSetIpRules)
      ? {
          defaultAction: networkRuleSetDefaultAction
          ipRules: networkRuleSetIpRules
        }
      : null
    zoneRedundancy: acrSku == 'Premium' ? zoneRedundancy : null
  }
}

module registry_replications 'replication/main.bicep' = [
  for (replication, index) in (replications ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Replication-${index}'
    params: {
      name: replication.name
      registryName: registry.name
      location: replication.location
      regionEndpointEnabled: replication.?regionEndpointEnabled
      zoneRedundancy: replication.?zoneRedundancy
      tags: replication.?tags ?? tags
    }
  }
]

module registry_cacheRules 'cache-rules/main.bicep' = [
  for (cacheRule, index) in (cacheRules ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Cache-${index}'
    params: {
      registryName: registry.name
      sourceRepository: cacheRule.sourceRepository
      name: cacheRule.?name ?? replace(replace(cacheRule.sourceRepository, '/', '-'), '.', '-')
      targetRepository: cacheRule.?targetRepository ?? cacheRule.sourceRepository
      credentialSetResourceId: cacheRule.?credentialSetResourceId
    }
  }
]

module registry_webhooks 'webhook/main.bicep' = [
  for (webhook, index) in (webhooks ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Webhook-${index}'
    params: {
      name: webhook.name
      registryName: registry.name
      location: webhook.?location ?? location
      action: webhook.?action ?? [
        'chart_delete'
        'chart_push'
        'delete'
        'push'
        'quarantine'
      ]
      customHeaders: webhook.?customHeaders
      scope: webhook.?scope
      status: webhook.?status
      serviceUri: webhook.serviceUri
      tags: webhook.?tags ?? tags
    }
  }
]

resource registry_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: registry
}

resource registry_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: registry
  }
]

resource registry_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(registry.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: registry
  }
]

module registry_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-registry-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'registry'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'registry'}-${index}'
              properties: {
                privateLinkServiceId: registry.id
                groupIds: [
                  privateEndpoint.?service ?? 'registry'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'registry'}-${index}'
              properties: {
                privateLinkServiceId: registry.id
                groupIds: [
                  privateEndpoint.?service ?? 'registry'
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

@description('The Name of the Azure container registry.')
output name string = registry.name

@description('The reference to the Azure container registry.')
output loginServer string = reference(registry.id, '2019-05-01').loginServer

@description('The name of the Azure container registry.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Azure container registry.')
output resourceId string = registry.id

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = registry.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = registry.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
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
