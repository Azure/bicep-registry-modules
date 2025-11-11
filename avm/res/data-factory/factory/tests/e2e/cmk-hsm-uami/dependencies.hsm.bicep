@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityResourceId string

@description('Required. The name of the Deployment script used to configure the HSM.')
param hsmDeploymentScriptName string

@description('Required. The name of the key to create in the HSM.')
param hsmKeyName string

@description('Required. The resource ID of the Managed Identity used by the deployment script. Must be an identity with permissions to assign roles on the HSM.')
@secure()
param deploymentMSIResourceId string

@description('Required. The name of the managed HSM used for encryption.')
@secure()
param managedHSMName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: last(split(managedIdentityResourceId, '/'))
  scope: resourceGroup(split(managedIdentityResourceId, '/')[2], split(managedIdentityResourceId, '/')[4])
}

resource deploymentMSI 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: last(split(deploymentMSIResourceId, '/'))!
  scope: resourceGroup(split(deploymentMSIResourceId, '/')[2], split(deploymentMSIResourceId, '/')[4])
}

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHSMName

  resource key 'keys@2025-05-01' existing = {
    name: hsmKeyName
  }
  // resource key 'keys@2025-05-01' = {
  //   name: hsmKeyName
  //   properties: {
  //     keySize: 4096
  //     kty: 'RSA-HSM'
  //   }
  // }
}

// Configure HSM
resource configureHSM 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: hsmDeploymentScriptName
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentMSI.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.67.0'
    retentionInterval: 'P1D'
    arguments: '"${managedHsm.name}" "${managedHsm::key.name}" "${managedIdentity.properties.principalId}"'
    scriptContent: '''
      # Allow key reference via managedIdentity
      az keyvault role assignment create --hsm-name $1 --role "Managed HSM Crypto Service Encryption User" --scope /keys/$2 --assignee $3

      # Allow usage via ARM
      az keyvault setting update --hsm-name $1 --name 'AllowKeyManagementOperationsThroughARM' --value 'true'
    '''
  }
}

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The name of the HSMKey Vault Encryption Key.')
output keyName string = managedHsm::key.name

@description('The version of the HSMKey Vault Encryption Key.')
output keyVersion string = last(split(managedHsm::key.properties.keyUriWithVersion, '/'))

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
