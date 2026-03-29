targetScope = 'subscription'

metadata name = 'Windows Managed Instance App Service Plan'
metadata description = 'This instance deploys a Windows Managed Instance App Service Plan with install scripts, registry adapters, storage mounts, and RDP enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.serverfarms-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsfmi'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location // Just a value to avoid ongoing capacity challenges
var enforcedLocation = 'australiaeast'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    bastionName: 'dep-${namePrefix}-bas-${serviceShort}'
    bastionPublicIpName: 'dep-${namePrefix}-pip-${serviceShort}'
    deploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      kind: 'app'
      skuName: 'P1v4'
      skuCapacity: 1
      zoneRedundant: false
      isCustomMode: true
      rdpEnabled: true
      virtualNetworkSubnetId: nestedDependencies.outputs.subnetResourceId
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      planDefaultIdentity: {
        identityType: 'UserAssigned'
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
      installScripts: [
        {
          name: 'CustomInstaller'
          source: {
            type: 'RemoteAzureBlob'
            sourceUri: 'https://${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}/scripts/scripts.zip'
          }
        }
      ]
      registryAdapters: [
        {
          registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterString'
          type: 'String'
          keyVaultSecretReference: {
            secretUri: '${nestedDependencies.outputs.keyVaultUri}secrets/registry-string-value'
          }
        }
        {
          registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterDWORD'
          type: 'DWORD'
          keyVaultSecretReference: {
            secretUri: '${nestedDependencies.outputs.keyVaultUri}secrets/registry-dword-value'
          }
        }
      ]
      storageMounts: [
        {
          name: 'g-drive'
          type: 'LocalStorage'
          destinationPath: 'G:\\'
        }
        {
          name: 'h-drive'
          type: 'AzureFiles'
          source: '\\\\${nestedDependencies.outputs.storageAccountName}.file.${environment().suffixes.storage}\\${nestedDependencies.outputs.fileShareName}'
          destinationPath: 'H:\\'
          credentialsKeyVaultReference: {
            // NOTE: the extra slash before /secrets/ is intentional — vaultUri ends with '/'
            // so this produces a double slash (e.g. https://kv.vault.azure.net//secrets/...).
            // The API requires this format for storage mount credential references.
            secretUri: '${nestedDependencies.outputs.keyVaultUri}/secrets/storage-account-key'
          }
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]

// Web App running .NET 10 on Windows, hosted on the Managed Instance plan
// NOTE: If the web app is not deployed and running, you will not be able to RDP onto the instances
module webApp 'br/public:avm/res/web/site:0.22.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-webapp-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}app001'
    location: enforcedLocation
    kind: 'app'
    serverFarmResourceId: testDeployment[1].outputs.resourceId
    siteConfig: {
      alwaysOn: true
      netFrameworkVersion: 'v10.0'
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
