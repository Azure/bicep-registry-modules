metadata name = 'AI Gateway test dependencies'
metadata description = 'Creates a user-assigned identity, workspace-based Application Insights and an optional gateway subnet.'

@description('Required. Short lowercase resource-name prefix.')
param namePrefix string
@description('Optional. Dependency region.')
param location string = resourceGroup().location
@description('Optional. Create a virtual network for the maximum configuration scenario.')
param enableVirtualNetwork bool = false

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: '${namePrefix}-aigw-id'
  location: location
}
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-07-01' = if (enableVirtualNetwork) {
  name: '${namePrefix}-aigw-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.42.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'aigateway'
        properties: {
          addressPrefix: '10.42.0.0/24'
        }
      }
    ]
  }
}
resource logs 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: '${namePrefix}-aigw-logs'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}
resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${namePrefix}-aigw-insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logs.id
  }
}

@description('The user-assigned identity resource ID.')
output identityResourceId string = identity.id
@description('The user-assigned identity principal ID.')
output identityPrincipalId string = identity.properties.principalId
@description('The user-assigned identity client ID.')
output identityClientId string = identity.properties.clientId
@description('The Application Insights component resource ID.')
output appInsightsResourceId string = insights.id
@secure()
@description('The Application Insights connection string.')
output appInsightsConnectionString string = insights.properties.ConnectionString
@description('The gateway subnet resource ID, or null when network configuration is not requested.')
output subnetResourceId string? = enableVirtualNetwork ? '${virtualNetwork!.id}/subnets/aigateway' : null
