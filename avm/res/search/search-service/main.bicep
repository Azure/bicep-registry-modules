metadata name = 'Search Services'
metadata description = 'This module deploys a Search Service.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the Azure Cognitive Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.')
param name string

@description('Optional. Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if \'disableLocalAuth\' is set to true.')
param authOptions authOptionsType?

@description('Optional. When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if \'authOptions\' are defined.')
param disableLocalAuth bool = true

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys.')
@allowed([
  'Disabled'
  'Enabled'
  'Unspecified'
])
param cmkEnforcement string = 'Unspecified'

@description('Optional. Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either \'default\' or \'highDensity\'. For all other SKUs, this value must be \'default\'.')
@allowed([
  'default'
  'highDensity'
])
param hostingMode string = 'default'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The lock settings for all Resources in the solution.')
param lock lockType?

@description('Optional. Network specific rules that determine how the Azure Cognitive Search service may be reached.')
param networkRuleSet networkRuleSetType?

@description('Optional. The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For \'standard3\' services with hostingMode set to \'highDensity\', the allowed values are between 1 and 3.')
@minValue(1)
@maxValue(12)
param partitionCount int = 1

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. The sharedPrivateLinkResources to create as part of the search Service.')
param sharedPrivateLinkResources array = []

@description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

@description('Optional. The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU.')
@minValue(1)
@maxValue(12)
param replicaCount int = 3

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@allowed([
  'disabled'
  'free'
  'standard'
])
@description('Optional. Sets options that control the availability of semantic search. This configuration is only possible for certain search SKUs in certain locations.')
param semanticSearch string?

@description('Optional. Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits.')
@allowed([
  'basic'
  'free'
  'standard'
  'standard2'
  'standard3'
  'storage_optimized_l1'
  'storage_optimized_l2'
])
param sku string = 'standard'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Tags to help categorize the resource in the Azure portal.')
param tags object?

// ============= //
//   Variables   //
// ============= //

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : '')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// =============== //
//   Deployments   //
// =============== //

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Search Index Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  )
  'Search Index Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1407120a-92aa-4202-b7e9-c0e197c71c8f'
  )
  'Search Service Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
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
  name: '46d3xbcp.res.search-searchservice.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource searchService 'Microsoft.Search/searchServices@2024-03-01-preview' = {
  location: location
  name: name
  sku: {
    name: sku
  }
  tags: tags
  identity: identity
  properties: {
    authOptions: authOptions
    disableLocalAuth: disableLocalAuth
    encryptionWithCmk: {
      enforcement: cmkEnforcement
    }
    hostingMode: hostingMode
    networkRuleSet: networkRuleSet
    partitionCount: partitionCount
    replicaCount: replicaCount
    publicNetworkAccess: toLower(publicNetworkAccess)
    semanticSearch: semanticSearch
  }
}

resource searchService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: searchService
  }
]

resource searchService_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: searchService
}

resource searchService_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(searchService.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: searchService
  }
]

module searchService_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-searchService-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(searchService.id, '/'))}-${privateEndpoint.?service ?? 'searchService'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(searchService.id, '/'))}-${privateEndpoint.?service ?? 'searchService'}-${index}'
              properties: {
                privateLinkServiceId: searchService.id
                groupIds: [
                  privateEndpoint.?service ?? 'searchService'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(searchService.id, '/'))}-${privateEndpoint.?service ?? 'searchService'}-${index}'
              properties: {
                privateLinkServiceId: searchService.id
                groupIds: [
                  privateEndpoint.?service ?? 'searchService'
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

// The Shared Private Link Resources must be deployed sequentially
// otherwise the deployment may fail.
// Using batchSize(1) to deploy them one by one
@batchSize(1)
module searchService_sharedPrivateLinkResources 'shared-private-link-resource/main.bicep' = [
  for (sharedPrivateLinkResource, index) in sharedPrivateLinkResources: {
    name: '${uniqueString(deployment().name, location)}-searchService-SharedPrivateLink-${index}'
    params: {
      name: sharedPrivateLinkResource.?name ?? 'spl-${last(split(searchService.id, '/'))}-${sharedPrivateLinkResource.groupId}-${index}'
      searchServiceName: searchService.name
      privateLinkResourceId: sharedPrivateLinkResource.privateLinkResourceId
      groupId: sharedPrivateLinkResource.groupId
      requestMessage: sharedPrivateLinkResource.requestMessage
      resourceRegion: sharedPrivateLinkResource.?resourceRegion
    }
  }
]

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split((secretsExportConfiguration.?keyVaultResourceId ?? '//'), '/')[2],
    split((secretsExportConfiguration.?keyVaultResourceId ?? '////'), '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId ?? '//', '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'primaryAdminKeyName')
        ? [
            {
              name: secretsExportConfiguration!.primaryAdminKeyName
              value: searchService.listAdminKeys().primaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryAdminKeyName')
        ? [
            {
              name: secretsExportConfiguration!.secondaryAdminKeyName
              value: searchService.listAdminKeys().secondaryKey
            }
          ]
        : []
    )
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the search service.')
output name string = searchService.name

@description('The resource ID of the search service.')
output resourceId string = searchService.id

@description('The name of the resource group the search service was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = searchService.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = searchService.location

@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

type secretsExportConfigurationType = {
  @description('Required. The key vault name where to store the API Admin keys generated by the modules.')
  keyVaultResourceId: string

  @description('Optional. The primaryAdminKey secret name to create.')
  primaryAdminKeyName: string?

  @description('Optional. The secondaryAdminKey secret name to create.')
  secondaryAdminKeyName: string?
}

import { secretSetType } from 'modules/keyVaultExport.bicep'
type secretsOutputType = {
  @description('An exported secret\'s references.')
  *: secretSetType
}

@export()
type authOptionsType = {
  @description('Optional. Indicates that either the API key or an access token from a Microsoft Entra ID tenant can be used for authentication.')
  aadOrApiKey: {
    @description('Optional. Describes what response the data plane API of a search service would send for requests that failed authentication.')
    aadAuthFailureMode: ('http401WithBearerChallenge' | 'http403')?
  }?
  @description('Optional. Indicates that only the API key can be used for authentication.')
  apiKeyOnly: object?
}

@export()
type networkRuleSetType = {
  @description('Optional. Network specific rules that determine how the Azure AI Search service may be reached.')
  bypass: ('AzurePortal' | 'None')?
  @description('Optional. A list of IP restriction rules that defines the inbound network(s) with allowing access to the search service endpoint. At the meantime, all other public IP networks are blocked by the firewall. These restriction rules are applied only when the \'publicNetworkAccess\' of the search service is \'enabled\'; otherwise, traffic over public interface is not allowed even with any public IP rules, and private endpoint connections would be the exclusive access method.')
  ipRules: ipRuleType[]?
}

@export()
type ipRuleType = {
  @description('Required. Value corresponding to a single IPv4 address (eg., 123.1.2.3) or an IP range in CIDR format (eg., 123.1.2.3/24) to be allowed.')
  value: string
}
