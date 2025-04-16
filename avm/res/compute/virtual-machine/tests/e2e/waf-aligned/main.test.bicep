targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Well-Architected Framework for Windows.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualMachines-${serviceShort}-rg'

// Capacity constraints for VM type
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmwinwaf'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object id of the Backup Management Service Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-BackupManagementServiceEnterpriseApplicationObjectId\'.')
@secure()
param backupManagementServiceEnterpriseApplicationObjectId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    recoveryServicesVaultName: 'dep-${namePrefix}-rsv-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    storageUploadDeploymentScriptName: 'dep-${namePrefix}-sads-${serviceShort}'
    proximityPlacementGroupName: 'dep-${namePrefix}-ppg-${serviceShort}'
    backupManagementServiceApplicationObjectId: backupManagementServiceEnterpriseApplicationObjectId
    dcrName: 'dep-${namePrefix}-dcr-${serviceShort}'
    logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
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
      name: '${namePrefix}${serviceShort}'
      computerName: '${namePrefix}winvm1'
      adminUsername: 'VMAdmin'
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter'
        version: 'latest'
      }
      nicConfigurations: [
        {
          deleteOption: 'Delete'
          ipConfigurations: [
            {
              applicationSecurityGroups: [
                {
                  id: nestedDependencies.outputs.applicationSecurityGroupResourceId
                }
              ]
              loadBalancerBackendAddressPools: [
                {
                  id: nestedDependencies.outputs.loadBalancerBackendPoolResourceId
                }
              ]
              name: 'ipconfig01'
              pipConfiguration: {
                publicIpNameSuffix: '-pip-01'
                zones: [
                  1
                  2
                  3
                ]
                roleAssignments: [
                  {
                    roleDefinitionIdOrName: 'Reader'
                    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                    principalType: 'ServicePrincipal'
                  }
                ]
              }
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
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
            }
          ]
          nicSuffix: '-nic-01'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
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
        }
      ]
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Windows'
      vmSize: 'Standard_D2s_v3'
      adminPassword: password
      zone: 2
      backupPolicyName: nestedDependencies.outputs.recoveryServicesVaultBackupPolicyName
      backupVaultName: nestedDependencies.outputs.recoveryServicesVaultName
      backupVaultResourceGroup: nestedDependencies.outputs.recoveryServicesVaultResourceGroupName
      dataDisks: [
        {
          caching: 'ReadOnly'
          createOption: 'Empty'
          deleteOption: 'Delete'
          diskSizeGB: 128
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
        {
          caching: 'ReadOnly'
          createOption: 'Empty'
          deleteOption: 'Delete'
          diskSizeGB: 128
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
      enableAutomaticUpdates: true
      patchMode: 'AutomaticByPlatform'
      bypassPlatformSafetyChecksOnUserSchedule: true
      maintenanceConfigurationResourceId: nestedDependencies.outputs.maintenanceConfigurationResourceId
      encryptionAtHost: false
      extensionAntiMalwareConfig: {
        enabled: true
        settings: {
          AntimalwareEnabled: 'true'
          Exclusions: {
            Extensions: '.ext1;.ext2'
            Paths: 'c:\\excluded-path-1;c:\\excluded-path-2'
            Processes: 'excludedproc1.exe;excludedproc2.exe'
          }
          RealtimeProtectionEnabled: 'true'
          ScheduledScanSettings: {
            day: '7'
            isEnabled: 'true'
            scanType: 'Quick'
            time: '120'
          }
        }
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
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
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      extensionCustomScriptProtectedSetting: {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "& ./${nestedDependencies.outputs.storageAccountCSEFileName}"'
      }
      extensionDependencyAgentConfig: {
        enabled: true
        enableAMA: true
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
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
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
      }
      extensionAadJoinConfig: {
        enabled: true
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      extensionDSCConfig: {
        enabled: true
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      extensionMonitoringAgentConfig: {
        enabled: true
        dataCollectionRuleAssociations: [
          {
            name: 'SendMetricsToLAW'
            dataCollectionRuleResourceId: nestedDependencies.outputs.dataCollectionRuleResourceId
          }
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      extensionNetworkWatcherAgentConfig: {
        enabled: true
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      proximityPlacementGroupResourceId: nestedDependencies.outputs.proximityPlacementGroupResourceId
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
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
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
