metadata name = 'API Connections'
metadata description = 'This module deploys an Azure API Connection.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Connection name for connection. It can change depending on the resource.')
param name string

@description('Optional. Location of the deployment.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============ //
// Parameters   //
// ============ //

@description('Optional. Specific values for some API connections.')
@metadata({
  example: '''
  // for a Service Bus connection
  {
    type: 'Microsoft.Web/locations/managedApis'
    id: subscriptionResourceId('Microsoft.Web/locations/managedApis', '${resourceLocation}', 'servicebus')
  }
'''
})
param api object?

@description('Optional. Dictionary of custom parameter values for specific connections.')
param customParameterValues object?

@description('Required. Display name connection. Example: `blobconnection` when using blobs. It can change depending on the resource.')
param displayName string

@description('Optional. Dictionary of nonsecret parameter values.')
#disable-next-line secure-secrets-in-params // Not a secret
param nonSecretParameterValues object?

@description('Optional. Connection strings or access keys for connection. Example: `accountName` and `accessKey` when using blobs. It can change depending on the resource.')
@secure()
@metadata({
  example: '''
    {
      connectionString: 'listKeys('/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/Microsoft.ServiceBus/namespaces/AuthorizationRules/<serviceBusName>/RootManagedSharedAccessKey', '2023-01-01').primaryConnectionString'
    }
    {
      rootfolder: fileshareConnection.rootfolder
      authType: fileshareConnection.authType
      // to add an object, use the any() function
      gateway: any({
        name: fileshareConnection.odgw.name
        id: resourceId(fileshareConnection.odgw.resourceGroup, 'Microsoft.Web/connectionGateways', fileshareConnection.odgw.name)
        type: 'Microsoft.Web/connectionGateways'
      })
      username: username
      password: password
    }
  '''
})
param parameterValues object?

@description('Optional. Additional parameter value set used for authentication settings.')
@metadata({
  example: '''
  // for a Service Bus connection
  {
    name: 'managedIdentityAuth'
    values: {
      namespaceEndpoint: {
        value: 'sb://${dependency.outputs.serviceBusEndpoint}'
      }
    }
  }
'''
})
param parameterValueSet object?

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The status of the connection.')
param statuses object[]?

@description('Optional. The lock settings of the service.')
param lock lockType

@metadata({
  example: '''
  {
      key1: 'value1'
      key2: 'value2'
  }
  '''
})
@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Links to test the API connection.')
param testLinks object[]?

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

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-connection.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource connection 'Microsoft.Web/connections@2016-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    displayName: displayName
    customParameterValues: customParameterValues
    api: api
    parameterValues: parameterValues
    nonSecretParameterValues: nonSecretParameterValues
    testLinks: testLinks
    statuses: statuses
    #disable-next-line BCP037 // the parameterValueSet is not yet made available in the resource provider, which generates warnings. Disable the warning for now.
    parameterValueSet: parameterValueSet
  }
}

resource connection_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: connection
}

resource connection_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(connection.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: connection
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the connection.')
output resourceId string = connection.id

@description('The resource group the connection was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the connection.')
output name string = connection.name

@description('The location the resource was deployed into.')
output location string = connection.location

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
