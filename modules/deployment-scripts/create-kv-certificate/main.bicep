@description('The name of the Azure Key Vault')
param akvName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

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

@description('The name of the certificate to create')
param certificateName string

@description('The common name of the certificate to create')
param certificateCommonName string = certificateName

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '0'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

var neededRBACRoles = !empty(rbacRolesNeededOnKV) ? rbacRolesNeededOnKV : 'a4417e6f-fecd-4de8-b567-7b0420556985'

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
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', neededRBACRoles)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource createImportCert 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'AKV-Cert-${akv.name}-${replace(replace(certificateName,':',''),'/','-')}'
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
    azCliVersion: '2.35.0'
    timeout: 'PT10M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'akvName'
        value: akvName
      }
      {
        name: 'certName'
        value: certificateName
      }
      {
        name: 'certCommonName'
        value: certificateCommonName
      }
      {
        name: 'initialDelay'
        value: initialScriptDelay
      }
      {
        name: 'retryMax'
        value: '10'
      }
      {
        name: 'retrySleep'
        value: '5s'
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on Identity RBAC replication ($initialDelay)"
      sleep $initialDelay

      #Retry loop to catch errors (usually RBAC delays)
      retryLoopCount=0
      until [ $retryLoopCount -ge $retryMax ]
      do
        echo "Creating AKV Cert $certName with CN $certCommonName (attempt $retryLoopCount)..."
        az keyvault certificate create --vault-name $akvName -n $certName -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${certCommonName}/g )" \
          && break

        sleep $retrySleep
        retryLoopCount=$((retryLoopCount+1))
      done

      echo "Getting Certificate $certName";
      retryLoopCount=0
      createdCert=$(az keyvault certificate show -n $certName --vault-name $akvName -o json)
      while [ -z "$(echo $createdCert | jq -r '.x509ThumbprintHex')" ] && [ $retryLoopCount -lt $retryMax ]
      do
        echo "Waiting for cert creation (attempt $retryLoopCount)..."
        sleep $retrySleep
        createdCert=$(az keyvault certificate show -n $certName --vault-name $akvName -o json)
        retryLoopCount=$((retryLoopCount+1))
      done

      unversionedSecretId=$(echo $createdCert | jq -r ".sid" | cut -d'/' -f-5) # remove the version from the url;
      jsonOutputString=$(echo $createdCert | jq --arg usid $unversionedSecretId '{name: .name ,certSecretId: {versioned: .sid, unversioned: $usid }, thumbprint: .x509Thumbprint, thumbprintHex: .x509ThumbprintHex}')
      echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
    '''
    cleanupPreference: cleanupPreference
  }
}

@description('Certificate name')
output certificateName string = createImportCert.properties.outputs.name

@description('KeyVault secret id to the created version')
output certificateSecretId string = createImportCert.properties.outputs.certSecretId.versioned

@description('KeyVault secret id which uses the unversioned uri')
output certificateSecretIdUnversioned string = createImportCert.properties.outputs.certSecretId.unversioned

@description('Certificate Thumbprint')
output certificateThumbprint string = createImportCert.properties.outputs.thumbprint

@description('Certificate Thumbprint (in hex)')
output certificateThumbprintHex string = createImportCert.properties.outputs.thumbprintHex
