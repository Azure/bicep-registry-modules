metadata name = 'Azure Monitor Private Link Scopes'
metadata description = 'This module deploys an Azure Monitor Private Link Scope.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private link scope.')
@minLength(1)
param name string

@description('''Optional. Specifies the access mode of ingestion or queries through associated private endpoints in scope. For security reasons, it is recommended to use PrivateOnly whenever possible to avoid data exfiltration.

  * Private Only - This mode allows the connected virtual network to reach only Private Link resources. It is the most secure mode and is set as the default when the `privateEndpoints` parameter is configured.
  * Open - Allows the connected virtual network to reach both Private Link resources and the resources not in the AMPLS resource. Data exfiltration cannot be prevented in this mode.''')
param accessModeSettings accessModeType

@description('Optional. The location of the private link scope. Should be global.')
param location string = 'global'

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for Azure Monitor Resources.')
param scopedResources scopedResourceType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

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
    accessModeSettings: !empty(privateEndpoints)
      ? {
          ingestionAccessMode: accessModeSettings.?ingestionAccessMode ?? 'PrivateOnly'
          queryAccessMode: accessModeSettings.?queryAccessMode ?? 'PrivateOnly'
          exclusions: accessModeSettings.?exclusions ?? []
        }
      : accessModeSettings ?? {
          ingestionAccessMode: accessModeSettings.?ingestionAccessMode ?? 'Open'
          queryAccessMode: accessModeSettings.?queryAccessMode ?? 'Open'
          exclusions: accessModeSettings.?exclusions ?? []
        }
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

module privateLinkScope_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-privateLinkScope-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: privateLinkScope_privateEndpoints[i].outputs.name
    resourceId: privateLinkScope_privateEndpoints[i].outputs.resourceId
    groupId: privateLinkScope_privateEndpoints[i].outputs.groupId
    customDnsConfig: privateLinkScope_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: privateLinkScope_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

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

  @description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @description('Optional. The name of the private DNS zone group config.')
      name: string?

      @description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

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

type scopedResourceType = {
  @description('Required. Name of the private link scoped resource.')
  name: string

  @description('Required. The resource ID of the scoped Azure monitor resource.')
  linkedResourceId: string
}[]?

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
}?
