targetScope = 'subscription'

extension microsoftGraphV1

metadata name = 'Using large parameter set for Linux'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualMachines-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'vmlimax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. An existing built-in service principal object ID for offline validation. When omitted, resolve it through Microsoft Graph.')
param builtInServicePrincipalObjectId string?

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource backupManagementService 'Microsoft.Graph/servicePrincipals@v1.0' existing = if (builtInServicePrincipalObjectId == null) {
  appId: '262044b1-e2ce-469f-a196-69ab7ada62d3'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    recoveryServicesVaultName: 'dep-${namePrefix}-rsv-${serviceShort}'
    storageAccountName: '${take('dep${namePrefix}sa${serviceShort}01', 11)}${uniqueString(resourceGroup.id, namePrefix, serviceShort)}'
    storageUploadDeploymentScriptName: '${take('dep-${namePrefix}-sads-${serviceShort}', 76)}-${uniqueString(deployment().name, resourceLocation, namePrefix, serviceShort, 'sads')}'
    sshDeploymentScriptName: '${take('dep-${namePrefix}-ds-${serviceShort}', 76)}-${uniqueString(deployment().name, resourceLocation, namePrefix, serviceShort, 'ds')}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
    dcrName: 'dep-${namePrefix}-dcr-${serviceShort}'
    backupManagementServiceApplicationObjectId: builtInServicePrincipalObjectId != null
      ? builtInServicePrincipalObjectId!
      : backupManagementService!.id
    waitDeploymentScriptName: '${take('dep-${namePrefix}-ds-${serviceShort}-waitForBackupRolePropagation', 76)}-${uniqueString(deployment().name, resourceLocation, namePrefix, serviceShort, 'waitForBackupRolePropagation')}'
    logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}'
    computerName: '${namePrefix}linvm1'
    location: resourceLocation
    adminUsername: 'localAdministrator'
    diskControllerType: 'SCSI'
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-focal'
      sku: '20_04-lts-gen2' // Note: 22.04 does not support DependencyAgent
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
              availabilityZones: [
                1
                2
                3
              ]
              diagnosticSettings: [
                {
                  workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
                }
              ]
              roleAssignments: [
                {
                  name: '696e6067-3ddc-4b71-bf97-9caebeba441a'
                  roleDefinitionIdOrName: 'Reader'
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
                    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
                  )
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
        name: 'nic-test-01'
        roleAssignments: [
          {
            name: 'ff72f58d-a3cf-42fd-9c27-c61906bdddfe'
            roleDefinitionIdOrName: 'Reader'
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
              '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
            )
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
      name: 'osdisk01'
      caching: 'ReadOnly'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_D4ads_v5'
    availabilityZone: 1
    backupPolicyName: nestedDependencies.outputs.recoveryServicesVaultBackupPolicyName
    backupVaultName: nestedDependencies.outputs.recoveryServicesVaultName
    backupVaultResourceGroup: nestedDependencies.outputs.recoveryServicesVaultResourceGroupName
    dataDisks: [
      {
        name: 'datadisk01'
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        name: 'datadisk02'
        caching: 'ReadWrite'
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
    rebootSetting: 'IfRequired'
    disablePasswordAuthentication: true
    encryptionAtHost: false
    extensionCustomScriptConfig: {
      name: 'myCustomScript'
      settings: {
        commandToExecute: 'bash ${nestedDependencies.outputs.storageAccountCSEFileName}'
      }
      protectedSettings: {
        // Needs 'Storage Blob Data Reader' role on the storage account
        managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
        fileUris: [
          nestedDependencies.outputs.storageAccountCSEFileUrl
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
      name: 'myDependencyAgent'
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
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionAadJoinConfig: {
      enabled: true
      name: 'myAADLogin'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: false
      name: 'myDesiredStateConfiguration'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      name: 'myMonitoringAgent'
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
      name: 'myNetworkWatcherAgent'
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
    publicKeys: [
      {
        keyData: nestedDependencies.outputs.SSHKeyPublicKey
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        name: 'eb01de52-d2be-4272-a7b9-13de6c399e27'
        roleDefinitionIdOrName: 'Reader'
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
          '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
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
