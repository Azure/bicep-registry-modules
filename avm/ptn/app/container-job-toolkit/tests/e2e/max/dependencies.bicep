@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param lawName string

@description('Required. The name of the Application Insights service.')
param appInsightsName string

@description('Required. The name of the User Assigned Identity.')
param userIdentityName string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: lawName
  location: location
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: law.id
    RetentionInDays: 30
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userIdentityName
  location: location
}

resource dnsZoneKeyVault 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
}

resource dnsZoneContainerRegistry_existing 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
  location: 'global'
}

@description('The ResourceId of the created Log Analytics Workspace.')
output logAnalyticsResourceId string = law.id

@description('The Connection String of the created Application Insights.')
output appInsightsConnectionString string = appInsights.properties.ConnectionString

@description('The name of the created User Assigned Identity.')
output userIdentityName string = userAssignedIdentity.name

@description('The ResourceId of the created User Assigned Identity.')
output userIdentityResourceId string = userAssignedIdentity.id

@description('The PrincipalId of the created User Assigned Identity.')
output userIdentityPrincipalId string = userAssignedIdentity.properties.principalId

@description('The Id of the created DNS Zone for Key Vault.')
output dnsZoneKeyVaultId string = dnsZoneKeyVault.id

@description('The name of the created DNS Zone for Container Registry.')
output dnsZoneContainerRegistryId string = dnsZoneContainerRegistry_existing.id
