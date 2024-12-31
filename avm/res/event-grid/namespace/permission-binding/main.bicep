metadata name = 'Eventgrid Namespace Permissions Bindings'
metadata description = 'This module deploys an Eventgrid Namespace Permission Binding.'

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@sys.description('Required. Name of the Permission Binding.')
param name string

@sys.description('Optional. Description of the Permission Binding.')
param description string?

@sys.description('Required. The name of the client group resource that the permission is bound to. The client group needs to be a resource under the same namespace the permission binding is a part of.')
param clientGroupName string

@sys.description('Required. The name of the Topic Space resource that the permission is bound to. The Topic space needs to be a resource under the same namespace the permission binding is a part of.')
param topicSpaceName string

@allowed([
  'Publisher'
  'Subscriber'
])
@sys.description('Required. The allowed permission.')
param permission string

// ============== //
// Resources      //
// ============== //

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource permissionBinding 'Microsoft.EventGrid/namespaces/permissionBindings@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    clientGroupName: clientGroupName
    description: description
    permission: permission
    topicSpaceName: topicSpaceName
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the Permission Binding.')
output resourceId string = permissionBinding.id

@sys.description('The name of the Permission Binding.')
output name string = permissionBinding.name

@sys.description('The name of the resource group the Permission Binding was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
