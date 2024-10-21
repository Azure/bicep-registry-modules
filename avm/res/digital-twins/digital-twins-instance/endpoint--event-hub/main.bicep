metadata name = 'Digital Twins Instance EventHub Endpoint'
metadata description = 'This module deploys a Digital Twins Instance EventHub Endpoint.'

@description('Optional. The name of the Digital Twin Endpoint.')
param name string = 'EventHubEndpoint'

@description('Conditional. The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.')
param digitalTwinInstanceName string

@allowed([
  'IdentityBased'
  'KeyBased'
])
@description('Optional. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is selected, the endpointUri and entityPath properties must be specified.')
param authenticationType string = 'IdentityBased'

@description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
@secure()
param deadLetterSecret string = ''

@description('Optional. Dead letter storage URL for identity-based authentication.')
param deadLetterUri string = ''

@description('Conditional. PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased".')
@secure()
param connectionStringPrimaryKey string = ''

@description('Optional. SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Only used if the `authenticationType` is "KeyBased".')
@secure()
param connectionStringSecondaryKey string = ''

@description('Optional. The EventHub name in the EventHub namespace for identity-based authentication.')
param entityPath string = ''

@description('Optional. The URL of the EventHub namespace for identity-based authentication. It must include the protocol \'sb://\' (i.e. sb://xyz.servicebus.windows.net).')
param endpointUri string = ''

@description('Optional. The managed identity definition for this resource.  Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentitiesType

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceId ?? '') ? 'UserAssigned' : null)
      userAssignedIdentity: managedIdentities.?userAssignedResourceId
    }
  : null

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' existing = {
  name: digitalTwinInstanceName
}

resource endpoint 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2023-01-31' = {
  name: name
  parent: digitalTwinsInstance
  properties: {
    endpointType: 'EventHub'
    authenticationType: authenticationType
    connectionStringPrimaryKey: connectionStringPrimaryKey
    connectionStringSecondaryKey: connectionStringSecondaryKey
    deadLetterSecret: deadLetterSecret
    deadLetterUri: deadLetterUri
    endpointUri: endpointUri
    entityPath: entityPath
    identity: identity
  }
}

@description('The resource ID of the Endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Endpoint.')
output name string = endpoint.name

@description('The principal ID of the system assigned identity. Note: As of 2024-03 is not exported by API.')
#disable-next-line BCP187
output systemAssignedMIPrincipalId string = endpoint.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceId: string?
}?
