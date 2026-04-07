metadata name = 'SQL Managed Instance Azure AD Only Authentications'
metadata description = 'This module deploys a SQL Managed Instance Azure AD Only Authentication setting.'

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Required. Whether Azure Active Directory-only authentication is enabled.')
param azureADOnlyAuthentication bool

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

resource aadOnlyAuth 'Microsoft.Sql/managedInstances/azureADOnlyAuthentications@2024-05-01-preview' = {
  name: 'Default'
  parent: managedInstance
  properties: {
    azureADOnlyAuthentication: azureADOnlyAuthentication
  }
}

@description('The name of the deployed Azure AD Only Authentication resource.')
output name string = aadOnlyAuth.name

@description('The resource ID of the deployed Azure AD Only Authentication resource.')
output resourceId string = aadOnlyAuth.id

@description('The resource group of the deployed Azure AD Only Authentication resource.')
output resourceGroupName string = resourceGroup().name
