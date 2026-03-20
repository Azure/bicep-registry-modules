metadata name = 'Automation Account Hybrid Runbook Worker Groups'
metadata description = 'This module deploys an Azure Automation Account Hybrid Runbook Worker Group.'

@description('Required. Name of the Hybrid Runbook Worker Group.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Optional. Gets or sets the name of the credential.')
param credentialName string?

@description('Optional. An array of Hybrid Runbook Worker Group Workers to deploy with the Hybrid Runbook Worker Group.')
param hybridRunbookWorkerGroupWorkers hybridRunbookWorkerGroupWorkerType[]?

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource hybridRunbookWorkerGroup 'Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups@2024-10-23' = {
  parent: automationAccount
  name: name
  properties: {
    credential: !empty(credentialName)
      ? {
          name: credentialName
        }
      : null
  }
}

module hybridRunbookWorkerGroup_workers 'hybrid-runbook-worker/main.bicep' = [
  for (worker, index) in (hybridRunbookWorkerGroupWorkers ?? []): {
    name: '${uniqueString(subscription().id, resourceGroup().id)}-AutoAccount-HybridWorkerGroup-Worker-${index}'
    params: {
      name: worker.name
      hybridRunbookWorkerGroupName: hybridRunbookWorkerGroup.name
      automationAccountName: automationAccount.name
      vmResourceId: worker.vmResourceId
    }
  }
]

@description('The name of the deployed hybrid runbook worker group.')
output name string = hybridRunbookWorkerGroup.name

@description('The resource ID of the deployed hybrid runbook worker group.')
output resourceId string = hybridRunbookWorkerGroup.id

@description('The resource group of the deployed hybrid runbook worker group.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //
@export()
type hybridRunbookWorkerGroupWorkerType = {
  @description('Required. Azure Resource Manager Id for a virtual machine.')
  vmResourceId: string
}
