@description('The name of the Azure Key Vault')
param akvName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('Version of the Azure CLI to use')
param azCliVersion string = '2.35.0'

@description('Deployment Script timeout')
param timeout string = 'PT30M'

@description('The retention period for the deployment script')
param retention string = 'P1D'

@description('The RoleDefinitionId required for the DeploymentScript resource to interact with KeyVault')
param rbacRolesNeededOnKV string = 'a4417e6f-fecd-4de8-b567-7b0420556985' //KeyVault Certificate Officer

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-KeyVaultCertificateCreator'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('An array of Certificate names to create')
param certNames array

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '30s'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

resource akv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: akvName
}

@description('A new managed identity that will be created in this Resource Group, this is the default option')
resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

@description('An existing managed identity that could exist in another sub/rg')
resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbacKv 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(akv.id, rbacRolesNeededOnKV, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRolesNeededOnKV)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource createImportCert 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for certName in certNames: {
  name: 'AKV-Cert-${akv.name}-${replace(replace(certName,':',''),'/','-')}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbacKv
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: azCliVersion
    timeout: timeout
    retentionInterval: retention
    environmentVariables: [
      {
        name: 'RG'
        value: resourceGroup().name
      }
      {
        name: 'akvName'
        value: akvName
      }
      {
        name: 'certName'
        value: certName
      }
      {
        name: 'initialDelay'
        value: initialScriptDelay
      }
      {
        name: 'spClientId'
        value: useExistingManagedIdentity ? existingDepScriptId.properties.clientId : newDepScriptId.properties.clientId
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on Identity RBAC replication ($initialDelay)"
      sleep $initialDelay

      #echo "Querying role assignments for service principal"
      #az role assignment list --assignee $spClientId

      echo "Creating AKV Cert $certName"
      az keyvault certificate create --vault-name $akvName -n $certName -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${certName}/g )";

      echo "Getting akv secretid for $certName";
      versionedSecretId=$(az keyvault certificate show -n $certName --vault-name $akvName --query "sid" -o tsv);
      unversionedSecretId=$(echo $versionedSecretId | cut -d'/' -f-5) # remove the version from the url;

      jsonOutputString=$(jq -n --arg cn "$certName" --arg sid "$unversionedSecretId" --arg vsid "$versionedSecretId" '{certName: $cn, certSecretId: {versioned: $vsid, unversioned: $sid }}')
      echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
    '''
    cleanupPreference: cleanupPreference
  }
}]

@description('Array of info from each Certificate Deployment Script')
output createdCertificates array = [for (certName, i) in certNames: {
  certName: certName
  DeploymentScriptName: createImportCert[i].name
  DeploymentScriptOutputs: createImportCert[i].properties.outputs
}]
