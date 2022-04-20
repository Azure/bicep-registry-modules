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

@description('An array of Azure Key Vault RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeededOnKV array = [
  'a4417e6f-fecd-4de8-b567-7b0420556985' //KeyVault Certificate Officer
]

@description('An array of Azure Application Gateway RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeededOnAppGw array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor
]

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

@allowed([
  'none'
  'root-cert'
  'ssl-cert'
])
@description('Configured certificate in Application Gateway as Frontend (ssl-cert) or Backend (root-cert)')
param agwCertType string = 'none'

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '30s'

@description('A delay before the Application Gateway imports the Certificate from KeyVault. Primarily to allow the certificate creation operation to complete')
param agwCertImportDelay string = '120s'

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

resource agw 'Microsoft.Network/applicationGateways@2021-05-01' existing = if (!empty(agwName) && agwCertType != 'none') {
  name: agwName
}

@description('The User Assigned Identity of the Azure Application Gateway')
param agwIdName string = ''
resource agwId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (!empty(agwName) && !empty(agwIdName) && agwCertType != 'none') {
  name: agwIdName
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

resource rbacKv 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for roleDefId in rbacRolesNeededOnKV: {
  name: guid(akv.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

resource rbacAppGw 'Microsoft.Authorization/roleAssignments@2020-08-01-preview'  =  [for roleDefId in rbacRolesNeededOnAppGw: if (!empty(agwName) && agwCertType != 'none') {
  name: guid(agw.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: agw
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

var managedIdentityOperator = resourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
@description('Managed identity requires "Managed Identity Operator" permission over the user assigned identity of the Application Gateway.')
resource agwIdRbac 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' =  if (!empty(agwName) && agwCertType != 'none') {
  scope: agwId
  name: guid(agwId.id, managedIdentityOperator, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  properties: {
    roleDefinitionId: managedIdentityOperator
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@batchSize(1)
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
    rbacAppGw
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
        value: agwCertImportDelay
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      echo "Waiting on Identity RBAC replication ($initialDelay)"
      sleep $initialDelay

      echo "Creating AKV Cert $certName"
      az keyvault certificate create --vault-name $akvName -n $certName -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${certName}/g )";

      echo "Waiting for AKV Cert Generation ($certificateWait)"
      sleep $certificateWait

      echo "getting akv secretid for $certName to add to $agwName";
      versionedSecretId=$(az keyvault certificate show -n $certName --vault-name $akvName --query "sid" -o tsv);
      unversionedSecretId=$(echo $versionedSecretId | cut -d'/' -f-5) # remove the version from the url;

      case $agwCertType in
        none)
          echo "AppGw Certificate Creation not configured"
          ;;

        root-cert)
          echo "Creating root certificate in application gateway";
          rootcertcmd="az network application-gateway root-cert create --gateway-name $agwName -g $RG -n $certName --key-vault-secret-id $unversionedSecretId";
          echo $rootcertcmd #Inspecting az command is a great DEBUG for the script output
          $rootcertcmd
          ;;

        ssl-cert)
          echo "Creating ssl certificate in application gateway";
          fecertcmd="az network application-gateway ssl-cert create --gateway-name $agwName -g $RG -n $certName --key-vault-secret-id $unversionedSecretId";
          echo $fecertcmd #Inspecting az command is a great DEBUG for the script output
          $fecertcmd
          ;;

      esac

      jsonOutputString=$(jq -n --arg cn "$certName" --arg sid "$unversionedSecretId" --arg vsid "$versionedSecretId" --arg ct "$agwCertType" '{certName: $cn, certSecretId: {versioned: $vsid, unversioned: $sid }, agwCertType: $ct}')
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
  DeploymentScriptStartTime: createImportCert[i].properties.status.startTime
  DeploymentScriptEndTime: createImportCert[i].properties.status.endTime
}]
