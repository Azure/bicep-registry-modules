metadata name = 'Azure SQL Server Audit Settings'
metadata description = 'This module deploys an Azure SQL Server Audit Settings.'

@description('Required. The name of the audit settings.')
param name string

@description('Conditional. The Name of SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required.')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Enabled'

@description('Optional. Specifies the Actions-Groups and Actions to audit.')
param auditActionsAndGroups string[] = [
  'BATCH_COMPLETED_GROUP'
  'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
  'FAILED_DATABASE_AUTHENTICATION_GROUP'
]

@description('Optional. Specifies whether audit events are sent to Azure Monitor.')
param isAzureMonitorTargetEnabled bool = true

@description('Optional. Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.')
param isDevopsAuditEnabled bool = false

@description('Optional. Specifies whether Managed Identity is used to access blob storage.')
param isManagedIdentityInUse bool = false

@description('Optional. Specifies whether storageAccountAccessKey value is the storage\'s secondary key.')
param isStorageSecondaryKeyInUse bool = false

@description('Optional. Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.')
param queueDelayMs int = 1000

@description('Optional. Specifies the number of days to keep in the audit logs in the storage account.')
param retentionDays int = 90

@description('Optional. A blob storage to hold the auditing storage account.')
param storageAccountResourceId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource server 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: serverName
}

// Assign SQL Server MSI access to storage account
var primaryUserAssignedIdentityPrincipalId = filter(
  items(server.identity.userAssignedIdentities),
  identity => identity.key == server.properties.primaryUserAssignedIdentityId
)[0].value.principalId

module storageAccount_sbdc_rbac 'modules/nested_storageRoleAssignment.bicep' = if (isManagedIdentityInUse && !empty(storageAccountResourceId)) {
  scope: resourceGroup(
    split(storageAccountResourceId ?? resourceGroup().id, '/')[2],
    split(storageAccountResourceId ?? resourceGroup().id, '/')[4]
  )
  params: {
    storageAccountName: last(split(storageAccountResourceId!, '/'))
    managedIdentityPrincipalId: server.identity.type == 'UserAssigned'
      ? primaryUserAssignedIdentityPrincipalId
      : server.identity.principalId
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-auditingsetting.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource auditSettings 'Microsoft.Sql/servers/auditingSettings@2025-01-01' = {
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
      : null
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
