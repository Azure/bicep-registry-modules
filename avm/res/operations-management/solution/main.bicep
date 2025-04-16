metadata name = 'Operations Management Solutions'
metadata description = 'This module deploys an Operations Management Solution.'

@description('''Required. Name of the solution.
For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.
For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.
The solution type is case-sensitive.''')
param name string

@description('Required. Plan for solution object supported by the OperationsManagement resource provider.')
param plan solutionPlanType

@description('Required. Name of the Log Analytics workspace where the solution will be deployed/enabled.')
param logAnalyticsWorkspaceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.operationsmanagement-solution.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: plan.?name ?? name
    promotionCode: ''
    product: plan.product
    publisher: plan.?publisher ?? 'Microsoft'
  }
}

@description('The name of the deployed solution.')
output name string = solution.name

@description('The resource ID of the deployed solution.')
output resourceId string = solution.id

@description('The resource group where the solution is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = solution.location

// =============== //
//   Definitions   //
// =============== //

@export()
type solutionPlanType = {
  @description('''Optional. Name of the solution to be created.
  For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.
  For solutions authored by third parties, it can be anything.
  The solution type is case-sensitive.
  If not provided, the value of the `name` parameter will be used.''')
  name: string?

  @description('''Required. The product name of the deployed solution.
  For Microsoft published gallery solution it should be `OMSGallery/{solutionType}`, for example `OMSGallery/AntiMalware`.
  For a third party solution, it can be anything.
  This is case sensitive.''')
  product: string

  @description('Optional. The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`, which is the default value.')
  publisher: string?
}
