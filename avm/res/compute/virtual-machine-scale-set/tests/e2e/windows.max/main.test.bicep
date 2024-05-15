targetScope = 'subscription'

metadata name = 'Using large parameter set for Windows'
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
param serviceShort string = 'cvmsswinmax'

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
      adminUsername: 'localAdminUser'
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        diskSizeGB: '128'
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
      encryptionAtHost: false
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
        enabled: true
        fileData: [
          {
            storageAccountId: nestedDependencies.outputs.storageAccountResourceId
            uri: nestedDependencies.outputs.storageAccountCSEFileUrl
          }
        ]
        protectedSettings: {
          commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "& ./${nestedDependencies.outputs.storageAccountCSEFileName}"'
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
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          roleDefinitionIdOrName: 'Reader'
          principalType: 'ServicePrincipal'
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
