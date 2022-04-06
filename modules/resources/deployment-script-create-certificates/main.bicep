@description('The name of the Azure Key Vault')
param akvName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('Version of the Azure CLI to use')
param azCliVersion string = '2.30.0'

@description('Deployment Script timeout')
param timeout string = 'PT30M'

@description('The retention period for the deployment script')
param retention string = 'P1D'

@description('An array of Azure RoleId that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' //Key Vault Secrets Officer
]

@description('Name of the Managed Identity resource')
param managedIdName string = 'id-CertificateGenerator'

@description('An array of fully qualified certificate names to generate and store')
param certificateNames array = [
  'myApp'
]

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

resource akv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: akvName
}

resource depScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdName
  location: location
}

resource rbac 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for roleDefId in rbacRolesNeeded: {
  name: guid(akv.id, roleDefId, depScriptId.id)
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: depScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

@batchSize(1)
resource createAddCertificate 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for certificateName in certificateNames: {
  name: 'ACR-Create-Certificate-${replace(replace(certificateName,':',''),'/','-')}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${depScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbac
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: azCliVersion
    timeout: timeout
    retentionInterval: retention
    environmentVariables: [
      {
        name: 'akvName'
        value: akvName
      }
      {
        name: 'certName'
        value: certificateName
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Creating Key Vault Self-Signed certificate $certName";
      az keyvault certificate create --vault-name $akvName -n $certName -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${certName}/g )";
    '''
    cleanupPreference: cleanupPreference
  }
}]
