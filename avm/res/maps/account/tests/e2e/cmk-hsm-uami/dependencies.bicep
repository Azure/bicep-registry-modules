@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to configure the HSM Key permissions.')
param deploymentScriptName string

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string

@description('Required. The name of the HSMKey Vault Encryption Key.')
param keyName string

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
    arguments: '"${last(split(managedHSMResourceId, '/'))}" "${keyName}" "${managedIdentity.properties.principalId}"'
    scriptContent: '''
      echo "Checking role assignment for HSM: $1, Key: $2, Principal: $3"
      # Allow key reference via identity
      result=$(az keyvault role assignment list --hsm-name "$1" --scope "/keys/$2" --query "[?principalId == \`$3\` && roleName == \`Managed HSM Crypto Service Encryption User\`]")

      if [[ -n "$result" ]]; then
        echo "Role assignment already exists."
      else
        echo "Role assignment not yet existing. Creating."
        az keyvault role assignment create --hsm-name "$1" --role "Managed HSM Crypto Service Encryption User" --scope "/keys/$2" --assignee $3
      fi
    '''
    retentionInterval: 'P1D'
    managedIdentities: {
      userAssignedResourceIds: [
        deploymentMSIResourceId
      ]
    }
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
