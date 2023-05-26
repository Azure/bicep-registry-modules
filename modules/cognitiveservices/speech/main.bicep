@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('Prefix of Resource Name. Not used if name is provided')
param prefix string = 'cog'

@minLength(3)
@maxLength(63)
// Must contain only lowercase letters, hyphens and numbers
// Must contain at least 3 through 63 characters
// Can't start or end with hyphen
@description('The name of the Speech service.')
param name string = take('${prefix}-${uniqueString(resourceGroup().id, location)}', 63)

@description('The tags to apply to each resource.')
param tags object = {}

@description('A custom subdomain to reach the Speech Service.')
param customSubDomainName string = ''

@description('The Public Network Access setting of the Speech Service. When Disabled, only requests from Private Endpoints can access the Speech Service.')
@allowed([ 'Enabled', 'Disabled' ])
param publicNetworkAccess string = 'Enabled'

@description('A list of private endpoints to connect to the Speech Service.')
param privateEndpoints array = []

@allowed([
  'F0'
  'S0'
])
@description('The name of the SKU')
param skuName string = 'S0'

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${speechService.name}-${endpoint.name}'
  privateLinkServiceId: speechService.id
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

resource speechService 'Microsoft.CognitiveServices/accounts@2021-10-01' = {
  name: toLower(name)
  location: location
  tags: tags
  kind: 'SpeechServices'
  sku: {
    name: skuName
  }

  properties: {
    publicNetworkAccess: publicNetworkAccess
    customSubDomainName: customSubDomainName
  }

}

@batchSize(1)
module speechServiceRbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'speech-service-rbac-${uniqueString(deployment().name, location)}-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    speechServiceName: name
  }
}]

module speechServicePrivateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${name}-${uniqueString(deployment().name, location)}-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

@description('Resource Name')
output name string = name

@description('Resource Id')
output id string = speechService.id

@description('Endpoint')
output endpoint string = speechService.properties.endpoint




