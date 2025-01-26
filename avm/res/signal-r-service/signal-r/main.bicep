metadata name = 'SignalR Service SignalR'
metadata description = 'This module deploys a SignalR Service SignalR.'

// ============== //
//   Parameters   //
// ============== //

@description('Optional. The location for the resource.')
param location string = resourceGroup().location

@description('Required. The name of the SignalR Service resource.')
param name string

@description('Optional. The kind of the service.')
@allowed([
  'SignalR'
  'RawWebSockets'
])
param kind string = 'SignalR'

@description('Optional. The SKU of the service.')
@allowed([
  'Free_F1'
  'Standard_S1'
  'Standard_S2'
  'Standard_S3'
  'Premium_P1'
  'Premium_P2'
  'Premium_P3'
])
param sku string = 'Standard_S1'

@allowed([
  'Free'
  'Premium'
  'Standard'
])
@description('Optional. The tier of the service.')
param tier string = sku == 'Free_F1'
  ? 'Free'
  : sku == 'Standard_S1' || sku == 'Standard_S2' || sku == 'Standard_S3' ? 'Standard' : 'Premium'

@description('Optional. The unit count of the resource.')
param capacity int = 1

@description('Optional. The tags of the resource.')
param tags object?

@description('Optional. The allowed origin settings of the resource.')
param allowedOrigins array = [
  '*'
]

@description('Optional. The disable Azure AD auth settings of the resource.')
param disableAadAuth bool = false

@description('Optional. The disable local auth settings of the resource.')
param disableLocalAuth bool = true

@description('Optional. The features settings of the resource, `ServiceMode` is the only required feature. See https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/signalr?pivots=deployment-language-bicep#signalrfeature for more information.')
param features array = [
  {
    flag: 'ServiceMode'
    value: 'Serverless'
  }
]

@description('Optional. Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the \'SKU\' is not \'Free_F1\'. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {}

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
param liveTraceCatagoriesToEnable array = [
  'ConnectivityLogs'
  'MessagingLogs'
]

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

@description('Optional. Upstream templates to enable. For more information, see https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/2022-02-01/signalr?pivots=deployment-language-bicep#upstreamtemplate.')
param upstreamTemplatesToEnable array?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

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
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var liveTraceCatagories = [
  for configuration in liveTraceCatagoriesToEnable: {
    name: configuration
    enabled: 'true'
  }
]

var resourceLogConfiguration = [
  for configuration in resourceLogConfigurationsToEnable: {
    name: configuration
    enabled: 'true'
  }
]

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
  name: '46d3xbcp.res.signalrservice-signalr.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource signalR 'Microsoft.SignalRService/signalR@2022-02-01' = {
  name: name
  location: location
  kind: kind
  sku: {
    name: sku
    capacity: capacity
    tier: tier
  }
  tags: tags
  identity: identity
  properties: {
    cors: {
      allowedOrigins: allowedOrigins
    }
    disableAadAuth: disableAadAuth
    disableLocalAuth: disableLocalAuth
    features: features
    liveTraceConfiguration: !empty(liveTraceCatagoriesToEnable)
      ? {
          categories: liveTraceCatagories
        }
      : {}
    networkACLs: !empty(networkAcls) ? any(networkAcls) : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
    resourceLogConfiguration: {
      categories: resourceLogConfiguration
    }
    tls: {
      clientCertEnabled: clientCertEnabled
    }
    upstream: !empty(upstreamTemplatesToEnable)
      ? {
          templates: upstreamTemplatesToEnable
        }
      : {}
  }
}

module signalR_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.8.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-signalR-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(signalR.id, '/'))}-${privateEndpoint.?service ?? 'signalr'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(signalR.id, '/'))}-${privateEndpoint.?service ?? 'signalr'}-${index}'
              properties: {
                privateLinkServiceId: signalR.id
                groupIds: [
                  privateEndpoint.?service ?? 'signalr'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(signalR.id, '/'))}-${privateEndpoint.?service ?? 'signalr'}-${index}'
              properties: {
                privateLinkServiceId: signalR.id
                groupIds: [
                  privateEndpoint.?service ?? 'signalr'
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

resource signalR_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: signalR
}

resource signalR_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(signalR.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: signalR
  }
]

@description('The SignalR name.')
output name string = signalR.name

@description('The SignalR resource group.')
output resourceGroupName string = resourceGroup().name

@description('The SignalR resource ID.')
output resourceId string = signalR.id

@description('The location the resource was deployed into.')
output location string = signalR.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = signalR.?identity.?principalId ?? ''

@description('The private endpoints of the SignalR.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: signalR_privateEndpoints[i].outputs.name
    resourceId: signalR_privateEndpoints[i].outputs.resourceId
    groupId: signalR_privateEndpoints[i].outputs.groupId
    customDnsConfig: signalR_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: signalR_privateEndpoints[i].outputs.networkInterfaceIds
  }
]
