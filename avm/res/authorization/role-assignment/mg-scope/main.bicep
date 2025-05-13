metadata name = 'Role Assignments (Management Group scope)'
metadata description = 'This module deploys a Role Assignment to a Management Group scope.'

targetScope = 'managementGroup'

@sys.description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
param name string?

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The description of the role assignment.')
param description string?

@sys.description('Optional. ID of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string?

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string?

@sys.description('Optional. The version of the condition.')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
])
param principalType string?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Management Group Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ac63b705-f282-497d-ac71-919bf39d939d'
  )
}

var roleDefinitionIdVar = builtInRoleNames[?roleDefinitionIdOrName] ?? (contains(
    roleDefinitionIdOrName,
    '/providers/Microsoft.Authorization/roleDefinitions/'
  )
  ? roleDefinitionIdOrName
  : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.authz-roleassignment_mgscope.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: name ?? guid(managementGroupId, roleDefinitionIdVar, principalId)
  properties: {
    roleDefinitionId: roleDefinitionIdVar
    principalId: principalId
    description: description
    principalType: principalType
    delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    condition: condition
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = roleAssignment.name

@sys.description('The resource ID of the Role Assignment.')
output resourceId string = roleAssignment.id

@sys.description('The scope this Role Assignment applies to.')
output scope string = az.resourceId('Microsoft.Management/managementGroups', managementGroupId)
