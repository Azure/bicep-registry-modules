metadata name = 'ResourceRole Assignments (All scopes)'
metadata description = 'This module deploys a Role Assignment for a specific resource.'
metadata owner = 'Azure/module-maintainers'

// targetScope = 'subscription'

@sys.description('Required. The scope for the role assignment, fully qualified resourceId.')
param resourceId string

@sys.description('Required. The unique guid name for the role assignment.')
param name string

@sys.description('Required. The role definition ID for the role assignment.')
param roleDefinitionId string

@sys.description('Optional. The name for the role, used for logging.')
param roleName string = ''

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

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

@sys.description('Optional. The Description of role assignment.')
param description string = ''

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =============== //
//   Definitions   //
// =============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.authorization-resourceroleassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '#_moduleVersion_#.0'
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

resource resourceRoleAssignment 'Microsoft.Resources/deployments@2023-07-01' = {
  name: '${guid(resourceId, roleDefinitionId)}-ResourceRoleAssignment'
  properties: {
    mode: 'Incremental'
    expressionEvaluationOptions: {
      scope: 'Outer'
    }
    template: loadJsonContent('modules/generic-role-assignment.json')
    parameters: {
      scope: {
        value: resourceId
      }
      name: {
        value: name
      }
      roleDefinitionId: {
        value: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
      }
      principalId: {
        value: principalId
      }
      principalType: {
        value: principalType
      }
      description: {
        value: description
      }
    }
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = name

@sys.description('The name for the role, used for logging.')
output roleName string = roleName

@sys.description('The resource ID of the Role Assignment.')
output resourceId string = resourceRoleAssignment.properties.outputs.roleAssignmentId.value

@sys.description('The name of the resource group the role assignment was applied at.')
output resourceGroupName string = resourceGroup().name
