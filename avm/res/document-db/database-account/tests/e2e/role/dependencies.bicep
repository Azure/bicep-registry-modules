@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param keyVaultName string

@description('Required. The name of the App Service to create.')
param appName string

@description('Optional. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app,linux' // linux web app
  'app' // normal web app
])
param appKind string = 'app,linux'

@description('Required. The name of the App Service Plan to create.')
param appServicePlanName string

@description('Optional. The kind of the App Service Plan.')
param appServicePlanKind string = ''

@description('Optional. If Linux app service plan , otherwise.')
param appServicePlanReserved bool = true

@description('Optional. Managed service identity.')
param managedIdentity bool = !empty(keyVaultName)

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B3'
  }
  kind: appServicePlanKind
  properties: {
    reserved: appServicePlanReserved
  }
}

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  kind: appKind
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'dotnetcore|8.0'
      alwaysOn: true
    }
  }

  identity: { type: managedIdentity ? 'SystemAssigned' : 'None' }
}

@description('The name of the Key Vault created.')
output keyVaultName string = keyVaultName

@description('The app identity Principal Id.')
output identityPrincipalId string = managedIdentity ? app.identity.principalId : ''
