metadata name = 'Azure Monitor Private Link Scopes'
metadata description = 'This module deploys an Azure Monitor Private Link Scope.'

@description('Required. Name of the private link scope.')
@minLength(1)
param name string

@description('''Optional. Specifies the access mode of ingestion or queries through associated private endpoints in scope. For security reasons, it is recommended to use PrivateOnly whenever possible to avoid data exfiltration.

  * Private Only - This mode allows the connected virtual network to reach only Private Link resources. It is the most secure mode and is set as the default when the `privateEndpoints` parameter is configured.
  * Open - Allows the connected virtual network to reach both Private Link resources and the resources not in the AMPLS resource. Data exfiltration cannot be prevented in this mode.''')
param accessModeSettings accessModeType?

@description('Optional. The location of the private link scope. Should be global.')
param location string = 'global'

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Configuration details for Azure Monitor Resources.')
param scopedResources scopedResourceType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Resource tags.')
param tags object?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
  )
  'Logic App Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '87a39d53-fc1b-424a-814c-f7e04687dc9e'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  )
  'Monitoring Metrics Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3913510d-42f4-4e42-8a64-420c390055eb'
  )
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  )
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Tag Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
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
  name: '46d3xbcp.res.insights-privatelinkscope.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource privateLinkScope 'microsoft.insights/privateLinkScopes@2021-07-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    accessModeSettings: accessModeSettings ?? (!empty(privateEndpoints)
      ? {
          ingestionAccessMode: 'PrivateOnly'
          queryAccessMode: 'PrivateOnly'
        }
      : {
          ingestionAccessMode: 'Open'
          queryAccessMode: 'Open'
        })
  }
}

module privateLinkScope_scopedResource 'scoped-resource/main.bicep' = [
  for (scopedResource, index) in (scopedResources ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateLinkScope-ScopedResource-${index}'
    params: {
      name: scopedResource.name
      privateLinkScopeName: privateLinkScope.name
      linkedResourceId: scopedResource.linkedResourceId
    }
  }
]

resource privateLinkScope_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: privateLinkScope
}

module privateLinkScope_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-privateLinkScope-PrivateEndpoint-${index}'
    // use the subnet resource group if the resource group is not explicitly provided
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(privateLinkScope.id, '/'))}-${privateEndpoint.?service ?? 'azuremonitor'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(privateLinkScope.id, '/'))}-${privateEndpoint.?service ?? 'azuremonitor'}-${index}'
              properties: {
                privateLinkServiceId: privateLinkScope.id
                groupIds: [
                  privateEndpoint.?service ?? 'azuremonitor'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(privateLinkScope.id, '/'))}-${privateEndpoint.?service ?? 'azuremonitor'}-${index}'
              properties: {
                privateLinkServiceId: privateLinkScope.id
                groupIds: [
                  privateEndpoint.?service ?? 'azuremonitor'
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
      privateLinkScope_scopedResource
    ]
  }
]

resource privateLinkScope_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(privateLinkScope.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: privateLinkScope
  }
]

@description('The name of the private link scope.')
output name string = privateLinkScope.name

@description('The resource ID of the private link scope.')
output resourceId string = privateLinkScope.id

@description('The resource group the private link scope was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = privateLinkScope.location

@description('The private endpoints of the private link scope.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: privateLinkScope_privateEndpoints[index].outputs.name
    resourceId: privateLinkScope_privateEndpoints[index].outputs.resourceId
    groupId: privateLinkScope_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: privateLinkScope_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: privateLinkScope_privateEndpoints[index].outputs.networkInterfaceResourceIds
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
@description('The scoped resource type.')
type scopedResourceType = {
  @description('Required. Name of the private link scoped resource.')
  name: string

  @description('Required. The resource ID of the scoped Azure monitor resource.')
  linkedResourceId: string
}

@export()
@description('The access mode type.')
type accessModeType = {
  @description('Optional. List of exclusions that override the default access mode settings for specific private endpoint connections. Exclusions for the current created Private endpoints can only be applied post initial provisioning.')
  exclusions: {
    @description('Required. The private endpoint connection name associated to the private endpoint on which we want to apply the specific access mode settings.')
    privateEndpointConnectionName: string

    @description('Required. Specifies the access mode of ingestion through the specified private endpoint connection in the exclusion.')
    ingestionAccessMode: 'Open' | 'PrivateOnly'

    @description('Required. Specifies the access mode of queries through the specified private endpoint connection in the exclusion.')
    queryAccessMode: 'Open' | 'PrivateOnly'
  }[]?

  @description('Optional. Specifies the default access mode of ingestion through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value.')
  ingestionAccessMode: 'Open' | 'PrivateOnly'?

  @description('Optional. Specifies the default access mode of queries through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value.')
  queryAccessMode: 'Open' | 'PrivateOnly'?
}
