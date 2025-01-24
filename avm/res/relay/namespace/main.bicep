metadata name = 'Relay Namespaces'
metadata description = 'This module deploys a Relay Namespace'

@description('Required. Name of the Relay Namespace.')
@minLength(6)
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of this SKU.')
@allowed([
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Authorization Rules for the Relay Namespace.')
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

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Configure networking options for Relay. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The hybrid connections to create in the relay namespace.')
param hybridConnections array = []

@description('Optional. The wcf relays to create in the relay namespace.')
param wcfRelays array = []

var builtInRoleNames = {
  'Azure Relay Listener': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '26e0b698-aa6d-4085-9386-aadae190014d'
  )
  'Azure Relay Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2787bf04-f1f5-4bfe-8383-c8a24483ee38'
  )
  'Azure Relay Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '26baccc8-eea7-41f1-98f4-1762cc7f685d'
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
  name: '46d3xbcp.res.relay-namespace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' = {
  name: name
  location: location
  tags: empty(tags) ? null : tags
  sku: {
    name: skuName
  }
  properties: {}
}

module namespace_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
    params: {
      namespaceName: namespace.name
      name: authorizationRule.name
      rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    }
  }
]

module namespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-NetworkRuleSet'
  params: {
    namespaceName: namespace.name
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess')
      ? networkRuleSets.publicNetworkAccess
      : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    defaultAction: contains(networkRuleSets, 'defaultAction') ? networkRuleSets.defaultAction : 'Allow'
    ipRules: contains(networkRuleSets, 'ipRules') ? networkRuleSets.ipRules : []
  }
}

module namespace_hybridConnections 'hybrid-connection/main.bicep' = [
  for (hybridConnection, index) in hybridConnections: {
    name: '${uniqueString(deployment().name, location)}-HybridConnection-${index}'
    params: {
      namespaceName: namespace.name
      name: hybridConnection.name
      authorizationRules: contains(hybridConnection, 'authorizationRules')
        ? hybridConnection.authorizationRules
        : [
            {
              name: 'RootManageSharedAccessKey'
              rights: [
                'Listen'
                'Manage'
                'Send'
              ]
            }
            {
              name: 'defaultListener'
              rights: [
                'Listen'
              ]
            }
            {
              name: 'defaultSender'
              rights: [
                'Send'
              ]
            }
          ]
      requiresClientAuthorization: contains(hybridConnection, 'requiresClientAuthorization')
        ? hybridConnection.requiresClientAuthorization
        : true
      userMetadata: hybridConnection.userMetadata
    }
  }
]

module namespace_wcfRelays 'wcf-relay/main.bicep' = [
  for (wcfRelay, index) in wcfRelays: {
    name: '${uniqueString(deployment().name, location)}-WcfRelay-${index}'
    params: {
      namespaceName: namespace.name
      name: wcfRelay.name
      authorizationRules: contains(wcfRelay, 'authorizationRules')
        ? wcfRelay.authorizationRules
        : [
            {
              name: 'RootManageSharedAccessKey'
              rights: [
                'Listen'
                'Manage'
                'Send'
              ]
            }
            {
              name: 'defaultListener'
              rights: [
                'Listen'
              ]
            }
            {
              name: 'defaultSender'
              rights: [
                'Send'
              ]
            }
          ]
      relayType: wcfRelay.relayType
      requiresClientAuthorization: contains(wcfRelay, 'requiresClientAuthorization')
        ? wcfRelay.requiresClientAuthorization
        : true
      requiresTransportSecurity: contains(wcfRelay, 'requiresTransportSecurity')
        ? wcfRelay.requiresTransportSecurity
        : true
      userMetadata: contains(wcfRelay, 'userMetadata') ? wcfRelay.userMetadata : null
    }
  }
]

resource namespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: namespace
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: namespace
  }
]

module namespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: namespace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
              properties: {
                privateLinkServiceId: namespace.id
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

resource namespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(namespace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: namespace
  }
]

@description('The resource ID of the deployed relay namespace.')
output resourceId string = namespace.id

@description('The resource group of the deployed relay namespace.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed relay namespace.')
output name string = namespace.name

@description('The location the resource was deployed into.')
output location string = namespace.location

@description('The private endpoints of the relay namespace.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: namespace_privateEndpoints[i].outputs.name
    resourceId: namespace_privateEndpoints[i].outputs.resourceId
    groupId: namespace_privateEndpoints[i].outputs.groupId
    customDnsConfig: namespace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: namespace_privateEndpoints[i].outputs.networkInterfaceIds
  }
]
