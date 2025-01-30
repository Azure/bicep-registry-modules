metadata name = 'SQL Managed Instances Administrator'
metadata description = 'This module deploys a SQL Managed Instance Administrator.'

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Required. Login name of the managed instance administrator.')
param login string

@description('Required. SID (object ID) of the managed instance administrator.')
param sid string

@description('Optional. Tenant ID of the managed instance administrator.')
param tenantId string = ''

resource managedInstance 'Microsoft.Sql/managedInstances@2023-08-01-preview' existing = {
  name: managedInstanceName
}

resource administrator 'Microsoft.Sql/managedInstances/administrators@2023-08-01-preview' = {
  name: 'ActiveDirectory'
  parent: managedInstance
  properties: {
    administratorType: 'ActiveDirectory'
    login: login
    sid: sid
    tenantId: tenantId
  }
}

@description('The name of the deployed managed instance administrator.')
output name string = administrator.name

@description('The resource ID of the deployed managed instance administrator.')
output resourceId string = administrator.id

@description('The resource group of the deployed managed instance administrator.')
output resourceGroupName string = resourceGroup().name
