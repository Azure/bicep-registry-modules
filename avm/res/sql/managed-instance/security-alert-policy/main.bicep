metadata name = 'SQL Managed Instance Security Alert Policies'
metadata description = 'This module deploys a SQL Managed Instance Security Alert Policy.'

@description('Required. The name of the security alert policy.')
param name string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Disabled'

@description('Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators.')
param emailAccountAdmins bool = false

resource managedInstance 'Microsoft.Sql/managedInstances@2023-08-01-preview' existing = {
  name: managedInstanceName
}

resource securityAlertPolicy 'Microsoft.Sql/managedInstances/securityAlertPolicies@2023-08-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    state: state
    emailAccountAdmins: emailAccountAdmins
  }
}

@description('The name of the deployed security alert policy.')
output name string = securityAlertPolicy.name

@description('The resource ID of the deployed security alert policy.')
output resourceId string = securityAlertPolicy.id

@description('The resource group of the deployed security alert policy.')
output resourceGroupName string = resourceGroup().name
