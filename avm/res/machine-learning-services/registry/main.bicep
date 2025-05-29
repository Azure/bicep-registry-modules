metadata name = 'Azure ML Registry'
metadata description = 'This module deploys an Azure Machine Learning Registry.'

@description('Required. Name of the Azure ML Registry.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Location for the Azure ML Registry.')
param location string = resourceGroup().location

@description('Optional. Additional locations for the Azure ML Registry.')
param locations array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true


var builtInRoleNames = {
  'AzureML Compute Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815'
  )
  'AzureML Data Scientist': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f6c7c914-8db3-469d-8ca1-694a8f32e121'
  )
  'AzureML Metrics Writer (preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '635dd51f-9968-44d3-b7fb-6d9a6bd613ae'
  )
  'AzureML Registry User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1823dd4f-9b8c-4ab6-ab4e-7397a3684615'
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


var enableReferencedModulesTelemetry = false


#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.machinelearningservices-registry.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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


var allLocations = union([location], locations)

var resolvedPublicNetworkAccess = !empty(publicNetworkAccess)
  ? any(publicNetworkAccess)
  : (!empty(privateEndpoints) ? 'Disabled' : null)

resource registry 'Microsoft.MachineLearningServices/registries@2024-10-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'registry'
  properties: {
    publicNetworkAccess: resolvedPublicNetworkAccess
    regionDetails: [
      for loc in allLocations: {
        location: loc
        storageAccountDetails: [
          {
            systemCreatedStorageAccount: {}
          }
        ]
        acrDetails: [
          {
            systemCreatedAcrAccount: {
              acrAccountSku: 'Premium'
            }
          }
        ]
      }
    ]
  }
}

module registry_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-registry-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'amlregistry'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'amlregistry'}-${index}'
              properties: {
                privateLinkServiceId: registry.id
                groupIds: [
                  privateEndpoint.?service ?? 'amlregistry'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(registry.id, '/'))}-${privateEndpoint.?service ?? 'amlregistry'}-${index}'
              properties: {
                privateLinkServiceId: registry.id
                groupIds: [
                  privateEndpoint.?service ?? 'amlregistry'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
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
    // dependsOn: [
    //   registry
    // ]
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
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: registry
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

@description('The Name of the Azure ML registry.')
output name string = registry.name

@description('The resource ID of the Azure ML registry.')
output resourceId string = registry.id

@description('The name of the Azure ML registry.')
output resourceGroupName string = resourceGroup().name

@description('The private endpoints of the Azure container registry.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: registry_privateEndpoints[index].outputs.name
    resourceId: registry_privateEndpoints[index].outputs.resourceId
    groupId: registry_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: registry_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: registry_privateEndpoints[index].outputs.networkInterfaceResourceIds
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
