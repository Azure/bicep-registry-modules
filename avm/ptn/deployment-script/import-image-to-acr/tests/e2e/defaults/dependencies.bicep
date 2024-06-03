@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

param acrName string

module acr 'br/public:avm/res/container-registry/registry:0.2.0' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: 'Standard'
    acrAdminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSetDefaultAction: 'Deny'
  }
}

output acrName string = acr.outputs.name
