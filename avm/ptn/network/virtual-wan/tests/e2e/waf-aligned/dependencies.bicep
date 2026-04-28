@description('Required. The name of the Azure Firewall Policy.')
param azureFirewallPolicyName string

@description('Required. The name of the virtual network.')
param virtualNetworkName string

@description('Required. The name of the Storage Account for diagnostics.')
param storageAccountName string

@description('Required. The name of the Log Analytics Workspace for diagnostics.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Event Hub Namespace for diagnostics.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub within the Event Hub Namespace for diagnostics.')
param eventHubNamespaceEventHubName string

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2024-10-01' = {
  name: azureFirewallPolicyName
  location: resourceGroup().location
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Deny'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: virtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
  }
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  name: '${uniqueString(deployment().name)}-diagnosticDependencies'
  params: {
    storageAccountName: storageAccountName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    eventHubNamespaceName: eventHubNamespaceName
    eventHubNamespaceEventHubName: eventHubNamespaceEventHubName
    location: resourceGroup().location
  }
}

@description('The ID of the Azure Firewall Policy.')
output azureFirewallPolicyId string = azureFirewallPolicy.id

@description('The resource ID of the virtual network.')
output virtualNetworkId string = vnet.id

@description('The resource ID of the Log Analytics Workspace.')
output logAnalyticsWorkspaceId string = diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId

@description('The resource ID of the Storage Account used for diagnostics.')
output storageAccountId string = diagnosticDependencies.outputs.storageAccountResourceId
