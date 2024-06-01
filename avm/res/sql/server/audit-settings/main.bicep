metadata name = 'Azure SQL Server Audit Settings'
metadata description = 'This module deploys an Azure SQL Server Audit Settings.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the audit settings.')
param name string

@description('Conditional. The Name of SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Required. The resource group of the SQL Server. Required if the template is used in a standalone deployment.')
@allowed([
  'Enabled'
  'Disabled'
])
param state string

@description('Optional. Specifies the Actions-Groups and Actions to audit.')
param auditActionsAndGroups array?

@description('Optional. Specifies whether audit events are sent to Azure Monitor.')
param isAzureMonitorTargetEnabled bool = false

@description('Optional. Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.')
param isDevopsAuditEnabled bool?

@description('Optional. Specifies whether Managed Identity is used to access blob storage.')
param isManagedIdentityInUse bool = false

@description('Optional. Specifies whether storageAccountAccessKey value is the storage\'s secondary key.')
param isStorageSecondaryKeyInUse bool?

@description('Optional. Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.')
param queueDelayMs int?

@description('Optional. Specifies the number of days to keep in the audit logs in the storage account.')
param retentionDays int?

@description('Optional. A blob storage to hold the auditing storage account.')
param storageAccountResourceId string = ''

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

// Assign SQL Server MSI access to storage account
module storageAccount_sbdc_rbac 'modules/nested_storageRoleAssignment.bicep' = if (isManagedIdentityInUse && !empty(storageAccountResourceId)) {
  name: '${server.name}-stau-rbac'
  scope: (isManagedIdentityInUse && !empty(storageAccountResourceId))
    ? resourceGroup(split(storageAccountResourceId!, '/')[2], split(storageAccountResourceId!, '/')[4])
    : resourceGroup()
  params: {
    storageAccountName: last(split(storageAccountResourceId!, '/'))
    managedInstanceIdentityPrincipalId: server.identity.principalId
  }
}

resource auditSettings 'Microsoft.Sql/servers/auditingSettings@2023-08-01-preview' = {
  name: name
  parent: server
  properties: {
    state: state
    auditActionsAndGroups: auditActionsAndGroups
    isAzureMonitorTargetEnabled: isAzureMonitorTargetEnabled
    isDevopsAuditEnabled: isDevopsAuditEnabled
    isManagedIdentityInUse: isManagedIdentityInUse
    isStorageSecondaryKeyInUse: isStorageSecondaryKeyInUse
    queueDelayMs: queueDelayMs
    retentionDays: retentionDays
    storageAccountAccessKey: !empty(storageAccountResourceId) && !isManagedIdentityInUse
      ? listKeys(storageAccountResourceId, '2019-06-01').keys[0].value
      : any(null)
    storageAccountSubscriptionId: !empty(storageAccountResourceId) ? split(storageAccountResourceId, '/')[2] : any(null)
    storageEndpoint: !empty(storageAccountResourceId)
      ? 'https://${last(split(storageAccountResourceId, '/'))}.blob.${environment().suffixes.storage}'
      : any(null)
  }
}

@description('The name of the deployed audit settings.')
output name string = auditSettings.name

@description('The resource ID of the deployed audit settings.')
output resourceId string = auditSettings.id

@description('The resource group of the deployed audit settings.')
output resourceGroupName string = resourceGroup().name
