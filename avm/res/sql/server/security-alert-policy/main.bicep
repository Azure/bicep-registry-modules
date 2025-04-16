metadata name = 'Azure SQL Server Security Alert Policies'
metadata description = 'This module deploys an Azure SQL Server Security Alert Policy.'

@description('Required. The name of the Security Alert Policy.')
param name string

@description('Optional. Alerts to disable.')
@allowed([
  'Sql_Injection'
  'Sql_Injection_Vulnerability'
  'Access_Anomaly'
  'Data_Exfiltration'
  'Unsafe_Action'
  'Brute_Force'
])
param disabledAlerts string[] = []

@description('Optional. Specifies that the alert is sent to the account administrators.')
param emailAccountAdmins bool = false

@description('Optional. Specifies an array of email addresses to which the alert is sent.')
param emailAddresses string[] = []

@description('Optional. Specifies the number of days to keep in the Threat Detection audit logs.')
param retentionDays int = 0

@description('Optional. Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database.')
@allowed([
  'Disabled'
  'Enabled'
])
param state string = 'Disabled'

@description('Optional. Specifies the identifier key of the Threat Detection audit storage account.')
@secure()
param storageAccountAccessKey string?

@description('Optional. Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs.')
param storageEndpoint string?

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource securityAlertPolicy 'Microsoft.Sql/servers/securityAlertPolicies@2023-08-01-preview' = {
  name: name
  parent: server
  properties: {
    disabledAlerts: disabledAlerts
    emailAccountAdmins: emailAccountAdmins
    emailAddresses: emailAddresses
    retentionDays: retentionDays
    state: state
    storageAccountAccessKey: storageAccountAccessKey
    storageEndpoint: storageEndpoint
  }
}

@description('The name of the deployed security alert policy.')
output name string = securityAlertPolicy.name

@description('The resource ID of the deployed security alert policy.')
output resourceId string = securityAlertPolicy.id

@description('The resource group of the deployed security alert policy.')
output resourceGroupName string = resourceGroup().name
