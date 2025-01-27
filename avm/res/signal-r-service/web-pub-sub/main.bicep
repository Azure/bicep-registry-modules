metadata name = 'SignalR Web PubSub Services'
metadata description = 'This module deploys a SignalR Web PubSub Service.'

@description('Optional. The location for the resource.')
param location string = resourceGroup().location

@description('Required. The name of the Web PubSub Service resource.')
param name string

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The unit count of the resource. 1 by default.')
param capacity int = 1

@allowed([
  'Free_F1'
  'Standard_S1'
])
@description('Optional. Pricing tier of the resource.')
param sku string = 'Standard_S1'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentityAllType?

@description('Optional. When set as true, connection with AuthType=aad won\'t work.')
param disableAadAuth bool = false

@description('Optional. Disables all authentication methods other than AAD authentication. For security reasons, this value should be set to `true`.')
param disableLocalAuth bool = true

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@allowed([
  'ConnectivityLogs'
  'MessagingLogs'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param resourceLogConfigurationsToEnable array = [
  'ConnectivityLogs'
  'MessagingLogs'
]

@description('Optional. Request client certificate during TLS handshake if enabled.')
param clientCertEnabled bool = false

@description('Optional. Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the \'SKU\' is not \'Free_F1\'. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var resourceLogConfiguration = [
  for configuration in resourceLogConfigurationsToEnable: {
    name: configuration
    enabled: 'true'
  }
]

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'SignalR AccessKey Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '04165923-9d83-45d5-8227-78b77b0a687e'
  )
  'SignalR App Server': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '420fcaa2-552c-430f-98ca-3264be4806c7'
  )
  'SignalR REST API Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fd53cd77-2268-407a-8f46-7e7863d0f521'
  )
  'SignalR REST API Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ddde6b66-c0df-4114-a159-3618637b3035'
  )
  'SignalR Service Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7e4f1700-ea5a-4f59-8f37-079cfe29dce3'
  )
  'SignalR/Web PubSub Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '8cf5e20a-e4b2-4e9d-b3a1-5ceb692c2761'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Web PubSub Service Owner (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '12cf5a90-567b-43ae-8102-96cf46c7d9b4'
  )
  'Web PubSub Service Reader (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bfb1c7d2-fb1a-466b-b2ba-aee63b92deaf'
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
  name: '46d3xbcp.res.signalrservice-webpubsub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource webPubSub 'Microsoft.SignalRService/webPubSub@2021-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: capacity
    name: sku
    tier: sku == 'Standard_S1' ? 'Standard' : 'Free'
  }
  identity: identity
  properties: {
    disableAadAuth: disableAadAuth
    disableLocalAuth: disableLocalAuth
    networkACLs: networkAcls
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
    resourceLogConfiguration: {
      categories: resourceLogConfiguration
    }
    tls: {
      clientCertEnabled: clientCertEnabled
    }
  }
}

module webPubSub_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-webPubSub-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(webPubSub.id, '/'))}-${privateEndpoint.?service ?? 'webpubsub'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(webPubSub.id, '/'))}-${privateEndpoint.?service ?? 'webpubsub'}-${index}'
              properties: {
                privateLinkServiceId: webPubSub.id
                groupIds: [
                  privateEndpoint.?service ?? 'webpubsub'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(webPubSub.id, '/'))}-${privateEndpoint.?service ?? 'webpubsub'}-${index}'
              properties: {
                privateLinkServiceId: webPubSub.id
                groupIds: [
                  privateEndpoint.?service ?? 'webpubsub'
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

resource webPubSub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: webPubSub
}

resource webPubSub_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(webPubSub.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: webPubSub
  }
]

@description('The Web PubSub name.')
output name string = webPubSub.name

@description('The Web PubSub resource group.')
output resourceGroupName string = resourceGroup().name

@description('The Web PubSub resource ID.')
output resourceId string = webPubSub.id

@description('The Web PubSub externalIP.')
output externalIP string = webPubSub.properties.externalIP

@description('The Web PubSub hostName.')
output hostName string = webPubSub.properties.hostName

@description('The Web PubSub publicPort.')
output publicPort int = webPubSub.properties.publicPort

@description('The Web PubSub serverPort.')
output serverPort int = webPubSub.properties.serverPort

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = webPubSub.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = webPubSub.location

@description('The private endpoints of the Web PubSub.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: webPubSub_privateEndpoints[i].outputs.name
    resourceId: webPubSub_privateEndpoints[i].outputs.resourceId
    groupId: webPubSub_privateEndpoints[i].outputs.groupId
    customDnsConfig: webPubSub_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: webPubSub_privateEndpoints[i].outputs.networkInterfaceIds
  }
]
