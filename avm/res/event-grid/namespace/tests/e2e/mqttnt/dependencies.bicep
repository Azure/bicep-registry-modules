@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the EventGrid Namespace to create.')
param eventGridNamespaceName string

@description('Required. The name of the EventGrid Namespace Topic to create.')
param eventGridNamespaceTopicName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource eventGridNamespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' = {
  name: eventGridNamespaceName
  location: location

  resource topic 'topics@2023-12-15-preview' = {
    name: eventGridNamespaceTopicName
    properties: {
      inputSchema: 'CloudEventSchemaV1_0'
    }
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource Id of the created EventGrid Namespace Topic.')
output eventGridNameSpaceTopicResourceId string = eventGridNamespace::topic.id
