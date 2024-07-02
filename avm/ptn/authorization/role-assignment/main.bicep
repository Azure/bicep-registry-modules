metadata name = 'Role Assignments (All scopes)'
metadata description = 'This module deploys a Role Assignment at a Management Group, Subscription or Resource Group scope.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'managementGroup'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group.')
param resourceGroupName string = ''

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = ''

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. The description of the role assignment.')
param description string = ''

@sys.description('Optional. ID of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
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
  ''
])
param principalType string = ''

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.authorization-roleassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module roleAssignment_mg 'modules/management-group.bicep' = if (empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleAssignment-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    managementGroupId: managementGroupId
    description: !empty(description) ? description : ''
    principalType: !empty(principalType) ? principalType : ''
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId)
      ? delegatedManagedIdentityResourceId
      : ''
    conditionVersion: conditionVersion
    condition: !empty(condition) ? condition : ''
  }
}

module roleAssignment_sub 'modules/subscription.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleAssignment-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    description: !empty(description) ? description : ''
    principalType: !empty(principalType) ? principalType : ''
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId)
      ? delegatedManagedIdentityResourceId
      : ''
    conditionVersion: conditionVersion
    condition: !empty(condition) ? condition : ''
  }
}

module roleAssignment_rg 'modules/resource-group.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-RoleAssignment-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    description: !empty(description) ? description : ''
    principalType: !empty(principalType) ? principalType : ''
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId)
      ? delegatedManagedIdentityResourceId
      : ''
    conditionVersion: conditionVersion
    condition: !empty(condition) ? condition : ''
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.name
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.name
      : roleAssignment_rg.outputs.name)

@sys.description('The resource ID of the Role Assignment.')
output resourceId string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.resourceId
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.resourceId
      : roleAssignment_rg.outputs.resourceId)

@sys.description('The scope this Role Assignment applies to.')
output scope string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.scope
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.scope
      : roleAssignment_rg.outputs.scope)
