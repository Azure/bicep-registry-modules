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

@description('Optional. Create the Storage Blob Data Contributor role assignment on the storage account. Note, the role assignment must not already exist on the storage account.')
param createStorageRoleAssignment bool = true

@description('Optional. Specifies an array of alerts that are disabled.')
param disabledAlerts (
  | 'Sql_Injection'
  | 'Sql_Injection_Vulnerability'
  | 'Access_Anomaly'
  | 'Data_Exfiltration'
  | 'Unsafe_Action'
  | 'Brute_Force')[]?

@description('Optional. Use Access Key to access the storage account. The storage account cannot be behind a firewall or virtual network. If an access key is not used, the SQL MI system assigned managed identity must be assigned the Storage Blob Data Contributor role on the storage account.')
param useStorageAccountAccessKey bool = false

@description('Conditional. A blob storage to  hold all Threat Detection audit logs. Required if state is \'Enabled\'.')
param storageAccountResourceId string?

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = if (!empty(storageAccountResourceId)) {
  name: last(split(storageAccountResourceId!, '/'))
  scope: resourceGroup(split(storageAccountResourceId!, '/')[2], split(storageAccountResourceId!, '/')[4])
}

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

// Assign SQL MI MSI access to storage account
module storageAccount_sbdc_rbac 'modules/nested_storageRoleAssignment.bicep' = if (!useStorageAccountAccessKey && createStorageRoleAssignment && !empty(storageAccountResourceId)) {
  name: '${managedInstance.name}-sbdc-rbac'
  scope: resourceGroup(split(storageAccountResourceId!, '/')[2], split(storageAccountResourceId!, '/')[4])
  params: {
    storageAccountName: last(split(storageAccountResourceId!, '/'))
    managedInstanceIdentityPrincipalId: managedInstance.identity.principalId
  }
}

resource securityAlertPolicy 'Microsoft.Sql/managedInstances/securityAlertPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    state: state
    emailAccountAdmins: emailAccountAdmins
    emailAddresses: emailAddresses
    disabledAlerts: disabledAlerts
    ...(!empty(storageAccountResourceId) && state == 'Enabled'
      ? {
          retentionDays: retentionDays
          storageEndpoint: storageAccount!.properties.primaryEndpoints.blob
          storageAccountAccessKey: useStorageAccountAccessKey ? storageAccount!.listKeys().keys[0].value : null
        }
      : {})
  }
}

@description('The name of the deployed security alert policy.')
output name string = securityAlertPolicy.name

@description('The resource ID of the deployed security alert policy.')
output resourceId string = securityAlertPolicy.id

@description('The resource group of the deployed security alert policy.')
output resourceGroupName string = resourceGroup().name
