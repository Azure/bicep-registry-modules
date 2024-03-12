@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Automation Account to create.')
param automationAccountName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Automation Account.')
output automationAccountResourceId string = automationAccount.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
