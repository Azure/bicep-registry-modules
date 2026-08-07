@description('Optional. The location for the dependency resources.')
param location string = resourceGroup().location

@description('Required. The name prefix for dependency resources.')
param namePrefix string

@description('Required. The service short name.')
param serviceShort string

// ============== //
//   Resources    //
// ============== //

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'dep-${namePrefix}-msi-${serviceShort}'
  location: location
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'dep-${namePrefix}-law-${serviceShort}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'dep-${namePrefix}-appi-${serviceShort}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// ============== //
//    Outputs     //
// ============== //

@description('The resource ID of the User-Assigned Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the User-Assigned Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The App ID of the Application Insights instance.')
output applicationInsightsAppId string = applicationInsights.properties.AppId

@description('The connection string of the Application Insights instance.')
output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
