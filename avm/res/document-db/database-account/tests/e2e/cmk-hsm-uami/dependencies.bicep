@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Deployment Script to configure the HSM Key permissions.')
param deploymentScriptName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string

@description('Required. The name of the HSMKey Vault Encryption Key.')
param hSMKeyName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

module allowHsmAccess 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-hmsKeyPermissions'
  params: {
    name: deploymentScriptName
    kind: 'AzureCLI'
    azCliVersion: '2.67.0'
    arguments: '"${last(split(managedHSMResourceId, '/'))}" "${hSMKeyName}" "${managedIdentity.properties.principalId}"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Set-mHSMKeyConfig.sh')
    retentionInterval: 'P1D'
    managedIdentities: {
      userAssignedResourceIds: [
        deploymentMSIResourceId
      ]
    }
  }
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
