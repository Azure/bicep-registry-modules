param acrName string
param location string
param loginServer string
param tasks array = []

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: acrName
}

resource task 'Microsoft.ContainerRegistry/registries/tasks@2019-06-01-preview' = [for task in tasks: {
  name: task.taskName
  location: location
  parent: containerRegistry
  identity: task.identity
  properties: {
    status: task.status
    platform: task.platform
    agentConfiguration: task.agentConfiguration
    trigger: task.trigger
    step: task.step
    credentials: {
      customRegistries: {
        '${loginServer}': task.identity.type == 'SystemAssigned' ? {
          identity: '[system]'
        } : {}
      }
    }
  }
}]

module containerRegistry_rbac '../.bicep/nested_rbac.bicep' = [for (t, index) in tasks: {
  name: '${uniqueString(deployment().name, location)}-acr-task-rbac-${index}'
  params: {
    description: 'role assignment for task ${t.taskName}'
    roleDefinitionIdOrName: 'Contributor'
    principalIds: [
      task[index].identity.principalId
    ]
    principalType: 'ServicePrincipal'
    resourceId: containerRegistry.id
  }
}]

output tasksRoleAssignments array = [for (t, index) in tasks: {
  description: 'role assignment for task ${t.taskName}'
  roleDefinitionIdOrName: 'Contributor'
  principalType: 'ServicePrincipal'
  principalIds: task[index].identity.principalId
}]
