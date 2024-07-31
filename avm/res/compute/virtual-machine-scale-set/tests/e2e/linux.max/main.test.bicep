targetScope = 'subscription'

metadata name = 'Using large parameter set for Linux'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualmachinescalesets-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmsslinmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    storageAccountName: take('dep${namePrefix}sa${serviceShort}01', 24)
    storageUploadDeploymentScriptName: 'dep-${namePrefix}-sads-${serviceShort}'
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: take('dep${namePrefix}diasa${serviceShort}01', 24)
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      adminUsername: 'scaleSetAdmin'
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Linux'
      skuName: 'Standard_B12ms'
      availabilityZones: [
        '2'
      ]
      bootDiagnosticStorageAccountName: nestedDependencies.outputs.storageAccountName
      dataDisks: [
        {
          caching: 'ReadOnly'
          createOption: 'Empty'
          diskSizeGB: '256'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
        {
          caching: 'ReadOnly'
          createOption: 'Empty'
          diskSizeGB: '128'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      disablePasswordAuthentication: true
      encryptionAtHost: false
      extensionCustomScriptConfig: {
        enabled: true
        fileData: [
          {
            storageAccountId: nestedDependencies.outputs.storageAccountResourceId
            uri: nestedDependencies.outputs.storageAccountCSEFileUrl
          }
        ]
        protectedSettings: {
          commandToExecute: 'sudo apt-get update'
        }
      }
      extensionDependencyAgentConfig: {
        enabled: true
      }
      extensionAzureDiskEncryptionConfig: {
        enabled: true
        settings: {
          EncryptionOperation: 'EnableEncryption'
          KekVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
          KeyEncryptionAlgorithm: 'RSA-OAEP'
          KeyEncryptionKeyURL: nestedDependencies.outputs.keyVaultEncryptionKeyUrl
          KeyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
          KeyVaultURL: nestedDependencies.outputs.keyVaultUrl
          ResizeOSDisk: 'false'
          VolumeType: 'All'
        }
      }
      extensionMonitoringAgentConfig: {
        enabled: true
      }
      extensionNetworkWatcherAgentConfig: {
        enabled: true
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig1'
              properties: {
                subnet: {
                  id: nestedDependencies.outputs.subnetResourceId
                }
                publicIPAddressConfiguration: {
                  name: '${namePrefix}-pip-${serviceShort}'
                }
              }
            }
          ]
          nicSuffix: '-nic01'
        }
      ]
      publicKeys: [
        {
          keyData: nestedDependencies.outputs.SSHKeyPublicKey
          path: '/home/scaleSetAdmin/.ssh/authorized_keys'
        }
      ]
      roleAssignments: [
        {
          name: '8abf72f9-e918-4adc-b20b-c783b8799065'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      scaleSetFaultDomain: 1
      skuCapacity: 1
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      upgradePolicyMode: 'Manual'
      vmNamePrefix: 'vmsslinvm'
      vmPriority: 'Regular'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
