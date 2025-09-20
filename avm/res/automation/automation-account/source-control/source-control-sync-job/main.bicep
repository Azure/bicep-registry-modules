metadata name = 'Automation Account Source Controls Sync Job'
metadata description = 'This module deploys an Azure Automation Account Source Control Sync Jobs.'

@description('Optional. The source control sync job id. Must match the pattern `^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$`.')
@maxLength(36)
@minLength(36)
param name string = guid(commitId)

@description('Conditional. The name of the parent Source Control. Required if the template is used in a standalone deployment.')
param sourceControlName string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. The commit id of the source control sync job. If not syncing to a commitId, enter an empty string.')
param commitId string

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName

  resource sourceControl 'sourceControls@2024-10-23' existing = {
    name: sourceControlName
  }
}

resource sourceControlSyncJob 'Microsoft.Automation/automationAccounts/sourceControls/sourceControlSyncJobs@2024-10-23' = {
  name: name
  parent: automationAccount::sourceControl
  properties: {
    commitId: commitId
  }
}

@description('The name of the deployed sync job.')
output name string = sourceControlSyncJob.name

@description('The resource ID of the deployed sync job.')
output resourceId string = sourceControlSyncJob.id

@description('The resource group of the deployed sync job.')
output resourceGroupName string = resourceGroup().name
