targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Well-Architected Framework for Windows.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualmachinescalesets-${serviceShort}-rg'

// Capacity constraints for VM type
#disable-next-line no-hardcoded-location
var enforcedLocation = 'italynorth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmsswinwaf'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    storageAccountName: take('dep${namePrefix}sa${serviceShort}01', 24)
    storageUploadDeploymentScriptName: 'dep-${namePrefix}-sads-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: take('dep${namePrefix}diasa${serviceShort}01', 24)
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
      location: enforcedLocation
      name: '${namePrefix}${serviceShort}001'
      adminUsername: 'localAdminUser'
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Windows'
      skuName: 'Standard_B12ms'
      adminPassword: password
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
      encryptionAtHost: false // Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets.
      extensionAntiMalwareConfig: {
        enabled: true
        settings: {
          AntimalwareEnabled: true
          Exclusions: {
            Extensions: '.log;.ldf'
            Paths: 'D:\\IISlogs;D:\\DatabaseLogs'
            Processes: 'mssence.svc'
          }
          RealtimeProtectionEnabled: true
          ScheduledScanSettings: {
            day: '7'
            isEnabled: 'true'
            scanType: 'Quick'
            time: '120'
          }
        }
      }
      extensionCustomScriptConfig: {
        settings: {
          commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "& ./${nestedDependencies.outputs.storageAccountCSEFileName}"'
          // Needs 'Storage Blob Data Reader' role on the storage account
          fileUris: [
            nestedDependencies.outputs.storageAccountCSEFileUrl
          ]
        }
        protectedSettings: {
          managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
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
      extensionDSCConfig: {
        enabled: true
      }
      extensionMonitoringAgentConfig: {
        enabled: true
        autoUpgradeMinorVersion: true
      }
      extensionNetworkWatcherAgentConfig: {
        enabled: true
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
      skuCapacity: 1
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      upgradePolicyMode: 'Manual'
      vmNamePrefix: 'vmsswinvm'
      vmPriority: 'Regular'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
