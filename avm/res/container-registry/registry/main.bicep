metadata name = 'Azure Container Registries (ACR)'
metadata description = 'This module deploys an Azure Container Registry (ACR).'

@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tier of your Azure container registry.')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param acrSku string = 'Premium'

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
@description('Optional. The value that indicates whether the policy for using ARM audience token for a container registry is enabled or not. Default is enabled.')
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

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the \'acrSku\' to be \'Premium\'.')
param privateEndpoints privateEndpointSingleServiceType[]?

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether or not zone redundancy is enabled for this container registry.')
param zoneRedundancy string = 'Enabled'

@description('Optional. All replications to create.')
param replications replicationType[]?

@description('Optional. All webhooks to create.')
param webhooks webhookType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enables registry-wide pull from unauthenticated clients. It\'s in preview and available in the Standard and Premium service tiers.')
param anonymousPullEnabled bool = false

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Array of Cache Rules.')
param cacheRules cacheRuleType[]?

@description('Optional. Array of Credential Sets.')
param credentialSets credentialSetType[]?

@description('Optional. Scope maps setting.')
param scopeMaps scopeMapsType[]?

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
            keyIdentifier: !empty(customerManagedKey.?keyVersion)
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
              : (customerManagedKey.?autoRotationEnabled ?? true)
                  ? cMKKeyVault::cMKKey.properties.keyUri
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

module registry_scopeMaps 'scope-map/main.bicep' = [
  for (scopeMap, index) in (scopeMaps ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Scope-${index}'
    params: {
      name: scopeMap.?name
      actions: scopeMap.actions
      description: scopeMap.?description
      registryName: registry.name
    }
  }
]

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

module registry_credentialSets 'credential-set/main.bicep' = [
  for (credentialSet, index) in (credentialSets ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-CredentialSet-${index}'
    params: {
      name: credentialSet.name
      registryName: registry.name
      managedIdentities: credentialSet.managedIdentities
      authCredentials: credentialSet.authCredentials
      loginServer: credentialSet.loginServer
    }
  }
]

module registry_cacheRules 'cache-rule/main.bicep' = [
  for (cacheRule, index) in (cacheRules ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Cache-${index}'
    params: {
      registryName: registry.name
      sourceRepository: cacheRule.sourceRepository
      name: cacheRule.?name
      targetRepository: cacheRule.?targetRepository ?? cacheRule.sourceRepository
      credentialSetResourceId: cacheRule.?credentialSetResourceId
    }
    dependsOn: [
      registry_credentialSets
    ]
  }
]

module registry_webhooks 'webhook/main.bicep' = [
  for (webhook, index) in (webhooks ?? []): {
    name: '${uniqueString(deployment().name, location)}-Registry-Webhook-${index}'
    params: {
      name: webhook.name
      registryName: registry.name
      location: webhook.?location ?? location
      action: webhook.?action
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
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(registry.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
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

module registry_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-registry-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? privateEndpoint.?subnetResourceId, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? privateEndpoint.?subnetResourceId, '/')[4]
    )
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
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
    dependsOn: [
      registry_replications
    ]
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
output systemAssignedMIPrincipalId string? = registry.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = registry.location

@description('The Principal IDs of the ACR Credential Sets system-assigned identities.')
output credentialSetsSystemAssignedMIPrincipalIds array = [
  for index in range(0, length(credentialSets ?? [])): registry_credentialSets[index].outputs.?systemAssignedMIPrincipalId
]

@description('The Resource IDs of the ACR Credential Sets.')
output credentialSetsResourceIds array = [
  for index in range(0, length(credentialSets ?? [])): registry_credentialSets[index].outputs.resourceId
]

@description('The private endpoints of the Azure container registry.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: registry_privateEndpoints[i].outputs.name
    resourceId: registry_privateEndpoints[i].outputs.resourceId
    groupId: registry_privateEndpoints[i].outputs.?groupId!
    customDnsConfigs: registry_privateEndpoints[i].outputs.customDnsConfigs
    networkInterfaceResourceIds: registry_privateEndpoints[i].outputs.networkInterfaceResourceIds
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

@export()
@description('The type for a scope map.')
type scopeMapsType = {
  @description('Optional. The name of the scope map.')
  name: string?

  @description('Required. The list of scoped permissions for registry artifacts.')
  actions: string[]

  @description('Optional. The user friendly description of the scope map.')
  description: string?
}

@export()
@description('The type for a cache rule.')
type cacheRuleType = {
  @description('Optional. The name of the cache rule. Will be derived from the source repository name if not defined.')
  name: string?

  @description('Required. Source repository pulled from upstream.')
  sourceRepository: string

  @description('Optional. Target repository specified in docker pull command. E.g.: docker pull myregistry.azurecr.io/{targetRepository}:{tag}.')
  targetRepository: string?

  @description('Optional. The resource ID of the credential store which is associated with the cache rule.')
  credentialSetResourceId: string?
}

import { managedIdentityOnlySysAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
import { authCredentialsType } from 'credential-set/main.bicep'
@export()
@description('The type for a credential set.')
type credentialSetType = {
  @description('Required. The name of the credential set.')
  name: string

  @description('Optional. The managed identity definition for this resource.')
  managedIdentities: managedIdentityOnlySysAssignedType?

  @description('Required. List of authentication credentials stored for an upstream. Usually consists of a primary and an optional secondary credential.')
  authCredentials: authCredentialsType[]

  @description('Required. The credentials are stored for this upstream or login server.')
  loginServer: string
}

@export()
@description('The type for a replication.')
type replicationType = {
  @description('Required. The name of the replication.')
  name: string

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications.')
  regionEndpointEnabled: bool?

  @description('Optional. Whether or not zone redundancy is enabled for this container registry.')
  zoneRedundancy: ('Disabled' | 'Enabled')?
}

@export()
@description('The type for a webhook.')
type webhookType = {
  @description('Optional. The name of the registry webhook.')
  @minLength(5)
  @maxLength(50)
  name: string?

  @description('Required. The service URI for the webhook to post notifications.')
  serviceUri: string

  @description('Optional. The status of the webhook at the time the operation was called.')
  status: ('enabled' | 'disabled')?

  @description('Optional. The list of actions that trigger the webhook to post notifications.')
  action: string[]?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. Custom headers that will be added to the webhook notifications.')
  customHeaders: object?

  @description('Optional. The scope of repositories where the event can be triggered. For example, \'foo:*\' means events for all tags under repository \'foo\'. \'foo:bar\' means events for \'foo:bar\' only. \'foo\' is equivalent to \'foo:latest\'. Empty means all events.')
  scope: string?
}
