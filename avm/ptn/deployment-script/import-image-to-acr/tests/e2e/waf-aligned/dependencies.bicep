@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Azure Container Registry.')
param acrName string

var tags = {
  module: 'ptn/deployment-script/import-image-to-acr'
  test: 'waf-aligned'
}

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: managedIdentityName
  params: {
    name: managedIdentityName
    location: location
    tags: tags
  }
}

// the container registry to upload the image into
module acr 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: '${uniqueString(resourceGroup().name, location)}-acr'
  params: {
    name: acrName
    location: location
    tags: tags
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    roleAssignments: [
      for registryRole in ['AcrPull', 'AcrPush']: {
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
