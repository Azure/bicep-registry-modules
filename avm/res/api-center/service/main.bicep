metadata name = 'API Center Services'
metadata description = 'This module deploys an API Center Service.'

@description('Required. The name of the API Center service.')
@minLength(3)
@maxLength(90)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ApiCenter/services@2024-03-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings for the service resource.')
param lock lockType?

@description('Optional. The SKU to deploy, Use Free for evaluation purposes and Standard for long-lived and production deployments. Defaults to Standard.')
param sku ('Free' | 'Standard') = 'Standard'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create scoped to the service.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { metadataSchemaType } from 'metadata-schema/main.bicep'
@description('Optional. The metadata schemas to create within the API Center service.')
param metadataSchemas metadataSchemaType[]?

import { environmentType } from 'workspace/main.bicep'
@description('Optional. The environments to create within the default workspace of the API Center service.')
param environments environmentType[]?

import { apiType } from 'workspace/main.bicep'
@description('Optional. The APIs to create within the default workspace of the API Center service.')
param apis apiType[]?

import { apiSourceType } from 'workspace/main.bicep'
@description('Optional. The API sources to create within the default workspace for importing APIs from external sources.')
param apiSources apiSourceType[]?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)
var identity = {
  type: (managedIdentities.?systemAssigned ?? false)
    ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
    : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
}

var builtInRoleNames = {
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
  'Azure API Center Compliance Manager': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ede9aaa3-4627-494e-be13-4aa7c256148d'
  )
  'Azure API Center Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c7244dfb-f447-457d-b2ba-3999044d1706'
  )
  'Azure API Center Service Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'dd24193f-ef65-44e5-8a7e-6fa6e03f7713'
  )
  'Azure API Center Service Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6cba8790-29c5-48e5-bab1-c7541b01cb04'
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

resource service 'Microsoft.ApiCenter/services@2024-03-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  #disable-next-line BCP187 // SKU Not published in type schema but required by the RP
  sku: {
    name: sku
  }
}

module service_metadataSchemas 'metadata-schema/main.bicep' = [
  for (metadataSchema, index) in (metadataSchemas ?? []): {
    name: '${uniqueString(service.id, location)}-ApiCenter-MetadataSchema-${index}'
    params: {
      serviceName: service.name
      name: metadataSchema.name
      schema: metadataSchema.schema
      assignedTo: metadataSchema.?assignedTo
    }
  }
]

module service_defaultWorkspace 'workspace/main.bicep' = {
  name: '${uniqueString(service.id, location)}-ApiCenter-Workspace-Default'
  params: {
    serviceName: service.name
    name: 'default'
    title: 'Default workspace'
    environments: environments
    apis: apis
    apiSources: apiSources
  }
  dependsOn: [
    service_metadataSchemas
  ]
}

resource service_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(service.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: service
  }
]

resource service_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: service
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apicenter-service.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

@description('The name of the API Center service.')
output name string = service.name

@description('The resource ID of the API Center service.')
output resourceId string = service.id

@description('The name of the resource group the API Center service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = service.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = service.location
