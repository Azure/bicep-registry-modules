@description('The kind of Cognitive Service to create. See: https://learn.microsoft.com/en-us/azure/cognitive-services/create-account-bicep for available kinds.')
@allowed([ 'CognitiveServices', 'ComputerVision', 'CustomVision.Prediction', 'CustomVision.Training', 'Face', 'FormRecognizer', 'SpeechServices', 'LUIS', 'QnAMaker', 'TextAnalytics', 'TextTranslation', 'AnomalyDetector', 'ContentModerator', 'Personalizer', 'OpenAI' ])
param kind string = 'CognitiveServices'

@description('Prefix of Resource Name. Not used if name is provided')
param prefix string = 'cog'

@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@minLength(2)
@maxLength(64)
// Must contain only lowercase letters, hyphens and numbers
// Must contain at least 2 through 64 characters
// Can't start or end with hyphen
@description('The name of the Cognitive Service.')
param name string = take('${prefix}-${kind}-${uniqueString(resourceGroup().id, location)}', 64)

@description('The tags to apply to each resource.')
param tags object = {}

@description('A custom subdomain to reach the Cognitive Service.')
param customSubDomainName string = ''

@description('The Public Network Access setting of the Cognitive Service. When false, only requests from Private Endpoints can access it.')
param publicNetworkAccess bool = true

@description('A list of private endpoints to connect to the Cognitive Service.')
param privateEndpoints array = []

@description('The name of the SKU. Be aware that not all SKUs may be available for your Subscription. See: https://learn.microsoft.com/en-us/rest/api/cognitiveservices/accountmanagement/resource-skus')
@allowed([ 'F0', 'S0', 'S1', 'S2', 'S3', 'S4' ])
param skuName string = 'F0'

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

@description('The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned, UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock on Cosmos DB account resource.')
param lock string = 'NotSpecified'

@description('The api properties for special APIs. More info: https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts?pivots=deployment-language-bicep#apiproperties')
param apiProperties object = {}

@description('Indicates whether requests using non-AAD authentication are blocked')
param disableLocalAuth bool = false

@description('Enables rate limiting autoscale feature. Requires paid subscription. https://learn.microsoft.com/en-us/azure/cognitive-services/autoscale')
param dynamicThrottlingEnabled bool = false

@description('The encryption settings of the Cognitive Service.')
param encryption object = {}

@description('The multiregion settings of Cognitive Services account.')
param locations object = {}

@description('A collection of rules governing the accessibility from specific network locations.')
param networkAcls object = {}

@description('The migration token for the Cognitive Service.')
param migrationToken string = ''

@description('Specifies whether to a soft-deleted Cognitive Service should be restored. If false, the Cognitive Service needs to be purged before another with the same name can be created.')
param restore bool = false

@description('Set this to true for data loss prevention. Will block all outbound traffic except to allowedFqdnList. https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-data-loss-prevention')
param restrictOutboundNetworkAccess bool = false

@description('List of allowed FQDNs(Fully Qualified Domain Name) for egress from the Cognitive Service.')
param allowedFqdnList array = []

@description('The user owned storage accounts for the Cognitive Service.')
param userOwnedStorage array = []

@description('The deployments for Cognitive Services that support them. See: https://docs.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts/deployments for available properties.')
param deployments array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${name}-${endpoint.name}'
  privateLinkServiceId: cognitiveService.id
  groupIds: [
    endpoint.groupId
  ]
  subnetId: endpoint.subnetId
  privateDnsZones: contains(endpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: endpoint.privateDnsZoneId
    }
  ] : []
  manualApprovalEnabled: contains(endpoint, 'manualApprovalEnabled') ? endpoint.manualApprovalEnabled : false
}]

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: toLower(name)
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  identity: {
    type: identityType
    userAssignedIdentities: userAssignedIdentities
  }
  properties: {
    allowedFqdnList: allowedFqdnList
    apiProperties: apiProperties
    customSubDomainName: customSubDomainName
    disableLocalAuth: disableLocalAuth
    dynamicThrottlingEnabled: dynamicThrottlingEnabled
    encryption: encryption == {} ? null : encryption
    locations: locations == {} ? null : locations
    migrationToken: migrationToken
    networkAcls: networkAcls
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    restore: restore
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    userOwnedStorage: userOwnedStorage == [] ? null : userOwnedStorage
  }
}

resource cognitiveServiceDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for (deployment, index) in deployments: {
  name: '${name}-deploy-${index}'
  parent: cognitiveService
  sku: deployment.sku
  properties: deployment.properties
}]

@batchSize(1)
module cognitiveServiceRbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${name}-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    cognitiveServiceName: name
  }
}]

module cognitiveServicePrivateEndpoint 'modules/privateEndpoint.bicep' = if (privateEndpoints != []) {
  name: '${name}-peps'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

resource cognitiveServiceLock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: '${name}-lock'
  scope: cognitiveService
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

@description('Resource Name')
output name string = name

@description('Resource Id')
output id string = cognitiveService.id

@description('Endpoint')
output endpoint string = cognitiveService.properties.endpoint
