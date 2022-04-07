@description('The name of the Azure Key Vault')
param akvName string

@description('The name of the Azure Application Gateway')
param agwName string = ''

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

@description('An array of Azure RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor is needed to import ACR
]

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-ContainerRegistryImport'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('An array of Certificate names to create')
param certNames array

@allowed([
  'none'
  'root-cert'
  'ssl-cert'
])
@description('Configured certificate in Application Gateway as Frontend (ssl-cert) or Backend (root-cert)')
param agwCertType string = 'none'

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

resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for roleDefId in rbacRolesNeeded: {
  name: guid(akv.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

resource createImportImage 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for certName in certNames: {
  name: 'ACR-Import-${akv.name}-${replace(replace(certName,':',''),'/','-')}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
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
        name: 'RG'
        value: resourceGroup().name
      }
      {
        name: 'akvName'
        value: akvName
      }
      {
        name: 'agwName'
        value: agwName
      }
      {
        name: 'agwCertType'
        value: agwCertType
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
        name: 'certificateWait'
        value: initialScriptDelay
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on RBAC replication ($initialDelay)"
      sleep $initialDelay

      echo "Creating AKV Cert $certName";
      az keyvault certificate create --vault-name $akvName -n $certName -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${certName}/g )";

      if [ "$agwCertType" != "none" ];
      then
        sleep $certificateWait

        echo "getting akv secretid for $certName to add to $agwName";
        versionedSecretId=$(az keyvault certificate show -n $certName --vault-name $akvName --query "sid" -o tsv);
        unversionedSecretId=$(echo $versionedSecretId | cut -d'/' -f-5) # remove the version from the url;

        echo $agwCertType
        echo "creating root certificate reference in application gateway";
        rootcertcmd="az network application-gateway root-cert create --gateway-name $agwName  -g $RG -n $certName --keyvault-secret $unversionedSecretId";
        $rootcertcmd
      fi
    '''
    cleanupPreference: cleanupPreference
  }
}]
