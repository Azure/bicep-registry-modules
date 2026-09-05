@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The location to deploy resources to.')
param lawReplicationRegion string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the managed identity to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Application insights instance to create.')
param applicationInsightsName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

var addressPrefix = '10.0.0.0/16'

#disable-next-line use-recent-api-versions
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

#disable-next-line use-recent-api-versions
resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azure-api.net'
  location: 'global'

  #disable-next-line use-recent-api-versions
  resource virtualNetworkLinks 'virtualNetworkLinks@2024-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

#disable-next-line use-recent-api-versions
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

// Key Vault Secrets User role for the managed identity to access named value secrets
resource keyVaultSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, managedIdentity.id, '4633458b-17de-408a-b874-0445c86b69e6')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    )
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

#disable-next-line use-recent-api-versions
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    replication: {
      enabled: true
      location: lawReplicationRegion
    }
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
}

#disable-next-line use-recent-api-versions
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
  }
}

#disable-next-line use-recent-api-versions
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'apimNamedValueSecret'
  properties: {
    value: 'dummySecretValue'
  }
}

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The client ID of the created Managed Identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId

@description('The Application Insights Instrumentation Key')
output appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('The Application Insights ResourceId')
output appInsightsResourceId string = applicationInsights.id

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The URI of the created Key Vault secret.')
output keyVaultSecretUri string = keyVaultSecret.properties.secretUri
