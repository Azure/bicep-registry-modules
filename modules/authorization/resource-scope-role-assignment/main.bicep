@sys.description('The scope for the role assignment, fully qualified resourceId')
param resourceId string

@sys.description('The unique guid name for the role assignment')
param name string

@sys.description('The role definitionId from your tenant/subscription')
param roleDefinitionId string

@sys.description('The principal ID')
param principalId string

@sys.description('The principal type of the assigned principal ID')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
  ''
])
param principalType string = ''

@sys.description('The name for the role, used for logging')
param roleName string = ''

@sys.description('The Description of role assignment')
param description string = ''

resource resourceRoleAssignment 'Microsoft.Resources/deployments@2022-09-01' = {
  name: take('RA-${name}-${last(split(resourceId,'/'))}', 64)
  properties: {
    mode: 'Incremental'
    expressionEvaluationOptions: {
      scope: 'Outer'
    }
    template: loadJsonContent('modules/authorization/genericRoleAssignment.json')
    parameters: {
      scope: {
        value: resourceId
      }
      name: {
        value: name
      }
      roleDefinitionId: {
        value: roleDefinitionId
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

@sys.description('The unique name guid used for the roleAssignment')
output name string = name

@sys.description('The name for the role, used for logging')
output roleName string = roleName

@sys.description('The roleAssignmentId created on the scope of the resourceId')
output id string = resourceRoleAssignment.properties.outputs.roleAssignmentId.value
