@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment to create.')
param managedEnvironmentName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault referenced by the Container Apps.')
param keyVaultName string

@description('Required. The secret name of the Key Vault referenced by the Container Apps.')
param keyVaultSecretName string

@description('Optional. Key vault stored secret to pass into environment variables. The value is a GUID.')
@secure()
param myCustomKeyVaultSecret string = newGuid()

@description('Required. The name of the Container App.')
param containerAppName string

@description('Required. The name of the Container Registry.')
param containerRegistryName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: managedEnvironmentName
  location: location
  properties: {}
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: keyVaultSecretName
  properties: {
    value: myCustomKeyVaultSecret
  }
}

@description('The the built-in Key Vault Secret User role definition.')
resource roleDefinitionKeyVault 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}

resource roleAssignmentKeyVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id)
  scope: keyVault
  properties: {
    roleDefinitionId: roleDefinitionKeyVault.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

module containerApp 'br/public:avm/res/app/container-app:0.9.0' = {
  name: containerAppName
  params: {
    name: containerAppName
    containers: [
      {
        name: 'simple-hello-world-container'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          // workaround as 'float' values are not supported in Bicep, yet the resource providers expects them. Related issue: https://github.com/Azure/bicep/issues/1386
          cpu: json('0.25')
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: managedEnvironment.id
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.5.1' = {
  name: containerRegistryName
  params: {
    name: containerRegistryName
  }
}

@description('The name of the Container Apps environment.')
output containerAppsEnvironmentName string = managedEnvironment.name

@description('The resource id of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The name of the created managed identity.')
output managedIdentityName string = managedIdentity.name

@description('The principalId of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The key vault secret URI.')
output keyVaultSecretURI string = keyVaultSecret.properties.secretUri

@description('The name of the Container Apps environment.')
output existingcontainerAppName string = containerApp.outputs.name

@description('The Name of the Azure container registry.')
output containerRegistryName string = containerRegistry.outputs.name
