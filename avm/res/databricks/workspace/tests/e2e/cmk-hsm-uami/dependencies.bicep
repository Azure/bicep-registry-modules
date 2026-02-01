@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The object ID of the Databricks Enterprise Application. Required for Customer-Managed-Keys.')
param databricksApplicationObjectId string

@description('Required. The prefix name of the Deployment Script to configure the HSM Key permissions. The complete name will include instance counter depending on if the secondaryHSMKeyName is also passed.')
param deploymentScriptNamePrefix string

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string

@description('Required. The name of the primary HSMKey Vault Encryption Key.')
param primaryHSMKeyName string

@description('Optional. The name of the secondary HSMKey Vault Encryption Key.')
param secondaryHSMKeyName string?

module allowHsmAccess 'br/public:avm/res/resources/deployment-script:0.5.2' = [
  for (key, index) in [primaryHSMKeyName, secondaryHSMKeyName]: {
    name: '${uniqueString(deployment().name, location)}-HSMKeyPermissions-${index}'
    params: {
      name: '${deploymentScriptNamePrefix}${index}'
      kind: 'AzureCLI'
      azCliVersion: '2.67.0'
      arguments: '"${last(split(managedHSMResourceId, '/'))}" "${key}" "${databricksApplicationObjectId}"'
      scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Set-mHSMKeyConfig.sh')
      retentionInterval: 'P1D'
      managedIdentities: {
        userAssignedResourceIds: [
          deploymentMSIResourceId
        ]
      }
    }
  }
]
