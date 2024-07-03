@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Azure Container Registry.')
param acrName string

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: managedIdentityName
  params: {
    name: managedIdentityName
    location: location
  }
}

// the container registry to upload the image into
module acr 'br/public:avm/res/container-registry/registry:0.2.0' = {
  name: '${uniqueString(resourceGroup().name, location)}-acr'
  params: {
    name: acrName
    location: location
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    roleAssignments: [
      // assign ArcPull and AcrPush
      for registryRole in ['7f951dda-4ed3-4680-a7ca-43fe172d538d', '8311e382-0749-4cb8-b61a-304f252e45ec']: {
        principalId: identity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: registryRole
      }
    ]
    networkRuleBypassOptions: 'AzureServices'
    publicNetworkAccess: 'Disabled'
    networkRuleSetDefaultAction: 'Deny'
  }
}

@description('The resource id of the created managed identity.')
output managedIdentityResourceId string = identity.outputs.resourceId

@description('The name of the created Azure Container Registry.')
output acrName string = acr.outputs.name
