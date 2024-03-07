targetScope = 'resourceGroup'

@sys.description('Required. You can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param resourceGroupName string = resourceGroup().name

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param subscriptionId string = subscription().subscriptionId

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

//@sys.description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
//param enableDefaultTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Security Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
}

/*resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}*/

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(subscriptionId, resourceGroupName, principalId, roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : contains(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName)
    principalId: principalId
    description: !empty(description) ? description : null
    principalType: !empty(principalType) ? any(principalType) : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId) ? delegatedManagedIdentityResourceId : null
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    condition: !empty(condition) ? condition : null
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = roleAssignment.name

@sys.description('The resource ID of the Role Assignment.')
output scope string = resourceGroup().id

@sys.description('The scope this Role Assignment applies to.')
output resourceId string = az.resourceId(resourceGroupName, 'Microsoft.Authorization/roleAssignments', roleAssignment.name)

@sys.description('The name of the resource group the role assignment was applied at.')
output resourceGroupName string = resourceGroup().name
