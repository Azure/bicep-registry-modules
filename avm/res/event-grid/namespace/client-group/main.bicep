metadata name = 'Eventgrid Namespace Client Groups'
metadata description = 'This module deploys an Eventgrid Namespace Client Group.'

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@sys.description('Required. Name of the Client Group.')
param name string

@sys.description('Required. The grouping query for the clients.')
param query string

@sys.description('Optional. Description of the Client Group.')
param description string?

// ============== //
// Resources      //
// ============== //

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource clientGroup 'Microsoft.EventGrid/namespaces/clientGroups@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    description: description
    query: query
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the Client Group.')
output resourceId string = clientGroup.id

@sys.description('The name of the Client Group.')
output name string = clientGroup.name

@sys.description('The name of the resource group the Client Group was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
