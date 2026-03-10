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

@description('Optional. Specifies an array of e-mail addresses to which the alert is sent.')
param emailAddresses string[]?

@description('Optional. Specifies the number of days to keep in the Threat Detection audit logs.')
param retentionDays int?

@description('Optional. Specifies an array of alerts that are disabled.')
param disabledAlerts (
  | 'Sql_Injection'
  | 'Sql_Injection_Vulnerability'
  | 'Access_Anomaly'
  | 'Data_Exfiltration'
  | 'Unsafe_Action'
  | 'Brute_Force')[]?

@description('Conditional. A blob storage to hold all Threat Detection audit logs. Required if state is \'Enabled\'.')
param storageAccountResourceId string?

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = if (!empty(storageAccountResourceId)) {
  name: last(split(storageAccountResourceId!, '/'))
  scope: resourceGroup(split(storageAccountResourceId!, '/')[2], split(storageAccountResourceId!, '/')[4])
}

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

resource securityAlertPolicy 'Microsoft.Sql/managedInstances/securityAlertPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    disabledAlerts: disabledAlerts
    emailAccountAdmins: emailAccountAdmins
    emailAddresses: emailAddresses
    retentionDays: retentionDays
    state: state
    storageAccountAccessKey: !empty(storageAccountResourceId) ? storageAccount!.listKeys().keys[0].value : null
    storageEndpoint: !empty(storageAccountResourceId) ? storageAccount!.properties.primaryEndpoints.blob : null
  }
}

@description('The name of the deployed security alert policy.')
output name string = securityAlertPolicy.name

@description('The resource ID of the deployed security alert policy.')
output resourceId string = securityAlertPolicy.id

@description('The resource group of the deployed security alert policy.')
output resourceGroupName string = resourceGroup().name
