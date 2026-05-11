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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.aut-autacct-hybrunbkwrkrgrphybrubo.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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
