metadata name = 'Synapse Workspaces Firewall Rules'
metadata description = 'This module deploys Synapse Workspaces Firewall Rules.'

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The name of the firewall rule.')
param name string

@description('Required. The start IP address of the firewall rule. Must be IPv4 format.')
param startIpAddress string

@description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress.')
param endIpAddress string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.synapse-workspace-firewallrule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource firewallRule 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  name: name
  parent: workspace
  properties: {
    startIpAddress: startIpAddress
    endIpAddress: endIpAddress
  }
}

@description('The name of the deployed firewall rule.')
output name string = firewallRule.name

@description('The resource ID of the deployed firewall rule.')
output resourceId string = firewallRule.id

@description('The resource group of the deployed firewall rule.')
output resourceGroupName string = resourceGroup().name
