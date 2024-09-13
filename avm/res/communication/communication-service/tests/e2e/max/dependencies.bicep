@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Email Service to create.')
param emailServiceName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource emailService 'Microsoft.Communication/emailServices@2023-04-01' = {
  name: emailServiceName
  location: 'global'
  properties: {
    dataLocation: 'Germany'
  }

  resource domain 'domains@2023-04-01' = {
    name: 'AzureManagedDomain'
    location: 'global'
    properties: {
      domainManagement: 'AzureManaged'
    }
  }
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Email Service Domain.')
output emailDomainResourceId string = emailService::domain.id
