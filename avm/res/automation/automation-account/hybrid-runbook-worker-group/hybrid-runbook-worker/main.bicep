metadata name = 'Automation Account Hybrid Runbook Worker Group Workers'
metadata description = 'This module deploys an Azure Automation Account Hybrid Runbook Worker Group Worker.'

@description('Required. Name of the Hybrid Runbook Worker Group Worker.')
param name string

@description('Conditional. The name of the parent Hybrid Runbook Worker Group. Required if the template is used in a standalone deployment.')
param hybridRunbookWorkerGroupName string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. Azure Resource Manager Id for a virtual machine.')
param vmResourceId string

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName

  resource hybridRunbookWorkerGroup 'hybridRunbookWorkerGroups@2024-10-23' existing = {
    name: hybridRunbookWorkerGroupName
  }
}

resource hybridRunbookWorker 'Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers@2024-10-23' = {
  parent: automationAccount::hybridRunbookWorkerGroup
  name: name
  properties: {
    vmResourceId: vmResourceId
  }
}

@description('The name of the deployed hybrid runbook worker.')
output name string = hybridRunbookWorker.name

@description('The resource ID of the deployed hybrid runbook worker.')
output resourceId string = hybridRunbookWorker.id

@description('The resource group of the deployed hybrid runbook worker.')
output resourceGroupName string = resourceGroup().name
