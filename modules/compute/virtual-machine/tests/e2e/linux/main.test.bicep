targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualMachines-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmlincom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: location
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    recoveryServicesVaultName: 'dep-${namePrefix}-rsv-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    storageUploadDeploymentScriptName: 'dep-${namePrefix}-sads-${serviceShort}'
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}'
    computerName: '${namePrefix}linvm1'
    location: location
    adminUsername: 'localAdministrator'
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-focal'
      sku: '20_04-lts-gen2' // Note: 22.04 does not support OMS extension
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
              roleAssignments: [
                {
                  roleDefinitionIdOrName: 'Reader'
                  principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                  principalType: 'ServicePrincipal'
                }
              ]
            }
            zones: [
              '1'
              '2'
              '3'
            ]
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
      caching: 'ReadOnly'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    availabilityZone: 1
    backupPolicyName: nestedDependencies.outputs.recoveryServicesVaultBackupPolicyName
    backupVaultName: nestedDependencies.outputs.recoveryServicesVaultName
    backupVaultResourceGroup: nestedDependencies.outputs.recoveryServicesVaultResourceGroupName
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
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
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: 'value=$(./${nestedDependencies.outputs.storageAccountCSEFileName}); echo "$value"'
    }
    extensionDependencyAgentConfig: {
      enabled: true
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
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: false
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
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
    monitoringWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    publicKeys: [
      {
        keyData: nestedDependencies.outputs.SSHKeyPublicKey
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
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
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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
  dependsOn: [
    nestedDependencies // Required to leverage `existing` SSH key reference
  ]
}
