@description('Optional. The location to deploy to.')
param location string

@description('Required. The name of the Recovery Services Vault to create.')
param recoveryServicesVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
}

resource rsv 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: recoveryServicesVaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

@description('The resource ID of the recovery services vault.')
output recoveryServicesVaultResourceId string = rsv.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
