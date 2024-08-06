metadata name = 'Eventgrid Namespace Topic Spaces'
metadata description = 'This module deploys an Eventgrid Namespace Topic Space.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@sys.description('Required. Name of the Topic Space.')
param name string

@sys.description('Optional. Description of the Topic Space.')
param description string?

@minLength(1)
@sys.description('Required. The topic filters in the Topic Space.')
param topicTemplates array

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  'Azure Resource Notifications System Topics Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0b962ed2-6d56-471c-bd5f-3477d83a7ba4'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1e241071-0855-49ea-94dc-649edcd759de'
  )
  'EventGrid Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1d8c3fe3-8864-474b-8749-01e3783e8157'
  )
  'EventGrid Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '78cbd9e7-9798-4e2e-9b5a-547d9ebb31fb'
  )
  'EventGrid Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd5a91429-5739-47e2-a06b-3470a27159e7'
  )
  'EventGrid EventSubscription Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '428e0ff0-5e57-4d9c-a221-2c70d0e0a443'
  )
  'EventGrid EventSubscription Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2414bbcf-6497-4faf-8c65-045460748405'
  )
  'EventGrid TopicSpaces Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a12b0b94-b317-4dcd-84a8-502ce99884c6'
  )
  'EventGrid TopicSpaces Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b0f2fd7-60b4-4eca-896f-4435034f8bf5'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource topicSpace 'Microsoft.EventGrid/namespaces/topicSpaces@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    description: description
    topicTemplates: topicTemplates
  }
}

resource topicSpace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(topicSpace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: topicSpace
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the Topic Space.')
output resourceId string = topicSpace.id

@sys.description('The name of the Topic Space.')
output name string = topicSpace.name

@sys.description('The name of the resource group the Topic Space was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

type roleAssignmentType = {
  @sys.description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
