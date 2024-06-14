metadata name = 'VPN Sites'
metadata description = 'This module deploys a VPN Site.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the VPN Site.')
param name string

@description('Required. Resource ID of the virtual WAN to link to.')
param virtualWanId string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Conditional. An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured.')
param addressPrefixes array = []

@description('Conditional. BGP settings details. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. Required if no addressPrefixes or VPNSiteLinks are configured.')
param bgpProperties object = {}

@description('Optional. List of properties of the device.')
param deviceProperties object = {}

@description('Optional. The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead.')
param ipAddress string = ''

@description('Optional. IsSecuritySite flag.')
param isSecuritySite bool = false

@description('Optional. The Office365 breakout policy.')
param o365Policy object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. List of all VPN site links.')
param vpnSiteLinks array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
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

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' =
  if (enableTelemetry) {
    name: take(
      '46d3xbcp.res.network-vpnsite.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
      64
    )
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

resource vpnSite 'Microsoft.Network/vpnSites@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: !empty(addressPrefixes)
      ? {
          addressPrefixes: addressPrefixes
        }
      : null
    bgpProperties: !empty(bgpProperties) ? bgpProperties : null
    deviceProperties: !empty(deviceProperties) ? deviceProperties : null
    ipAddress: !empty(ipAddress) ? ipAddress : null
    isSecuritySite: isSecuritySite
    o365Policy: !empty(o365Policy) ? o365Policy : null
    virtualWan: {
      id: virtualWanId
    }
    vpnSiteLinks: !empty(vpnSiteLinks) ? vpnSiteLinks : null
  }
}

resource vpnSite_lock 'Microsoft.Authorization/locks@2020-05-01' =
  if (!empty(lock ?? {}) && lock.?kind != 'None') {
    name: lock.?name ?? 'lock-${name}'
    properties: {
      level: lock.?kind ?? ''
      notes: lock.?kind == 'CanNotDelete'
        ? 'Cannot delete resource or child resources.'
        : 'Cannot delete or modify the resource or child resources.'
    }
    scope: vpnSite
  }

resource vpnSite_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(vpnSite.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: vpnSite
  }
]

@description('The name of the VPN site.')
output name string = vpnSite.name

@description('The resource ID of the VPN site.')
output resourceId string = vpnSite.id

@description('The resource group the VPN site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnSite.location

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
