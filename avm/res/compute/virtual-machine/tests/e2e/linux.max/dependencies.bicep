@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Load Balancer to create.')
param loadBalancerName string

@description('Required. The name of the Recovery Services Vault to create.')
param recoveryServicesVaultName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Deployment Script used to upload data to the Storage Account.')
param storageUploadDeploymentScriptName string

@description('Required. The name of the Deployment Script to create for the SSH Key generation.')
param sshDeploymentScriptName string

@description('Required. The name of the SSH Key to create.')
param sshKeyName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var storageAccountCSEFileName = 'scriptExtensionMasterInstaller.ps1'
var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2023-04-01' = {
  name: applicationSecurityGroupName
  location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource msiRGContrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'Contributor', managedIdentity.id)
  scope: resourceGroup()
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: loadBalancerName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'servers'
      }
    ]
  }
}

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2022-04-01' = {
  name: recoveryServicesVaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}

  resource backupPolicy 'backupPolicies@2022-03-01' = {
    name: 'backupPolicy'
    properties: {
      backupManagementType: 'AzureIaasVM'
      instantRPDetails: {}
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Daily'
        scheduleRunTimes: [
          '2019-11-07T07:00:00Z'
        ]
        scheduleWeeklyFrequency: 0
      }
      retentionPolicy: {
        retentionPolicyType: 'LongTermRetentionPolicy'
        dailySchedule: {
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 180
            durationType: 'Days'
          }
        }
        weeklySchedule: {
          daysOfTheWeek: [
            'Sunday'
          ]
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 12
            durationType: 'Weeks'
          }
        }
        monthlySchedule: {
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 60
            durationType: 'Months'
          }
        }
        yearlySchedule: {
          retentionScheduleFormatType: 'Weekly'
          monthsOfYear: [
            'January'
          ]
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 10
            durationType: 'Years'
          }
        }
      }
      instantRpRetentionRangeInDays: 2
      timeZone: 'UTC'
      protectedItemsCount: 0
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2022-07-01' = {
    name: 'encryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource backupServiceKeyVaultPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${keyVault.name}-${location}-268f6a53-9f68-4a38-ae47-166f730d86af-KeyVault-KeyVaultAdministrator-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: '268f6a53-9f68-4a38-ae47-166f730d86af' // Backup Management Service Enterprise Application Object Id (Note: this is tenant specific)
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

resource msiKVCryptoUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-KeyVault-Key-Read-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices@2021-09-01' = {
    name: 'default'

    resource container 'containers@2021-09-01' = {
      name: 'scripts'
    }
  }
}

resource storageUpload 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: storageUploadDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-StorageAccountName "${storageAccount.name}" -ResourceGroupName "${resourceGroup().name}" -ContainerName "${storageAccount::blobService::container.name}" -FileName "${storageAccountCSEFileName}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Set-BlobContent.ps1')
  }
  dependsOn: [
    msiRGContrRoleAssignment
  ]
}

resource sshDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: sshDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
  }
  dependsOn: [
    msiRGContrRoleAssignment
  ]
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: sshKeyName
  location: location
  properties: {
    publicKey: sshDeploymentScript.properties.outputs.publicKey
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Load Balancer Backend Pool.')
output loadBalancerBackendPoolResourceId string = loadBalancer.properties.backendAddressPools[0].id

@description('The name of the created Recovery Services Vault.')
output recoveryServicesVaultName string = recoveryServicesVault.name

@description('The name of the Resource Group, the Recovery Services Vault was created in.')
output recoveryServicesVaultResourceGroupName string = resourceGroup().name

@description('The name of the Backup Policy created in the Backup Recovery Vault.')
output recoveryServicesVaultBackupPolicyName string = recoveryServicesVault::backupPolicy.name

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The URL of the created Key Vault.')
output keyVaultUrl string = keyVault.properties.vaultUri

@description('The URL of the created Key Vault Encryption Key.')
output keyVaultEncryptionKeyUrl string = keyVault::key.properties.keyUriWithVersion

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The URL of the Custom Script Extension in the created Storage Account.')
output storageAccountCSEFileUrl string = '${storageAccount.properties.primaryEndpoints.blob}${storageAccount::blobService::container.name}/${storageAccountCSEFileName}'

@description('The name of the Custom Script Extension in the created Storage Account.')
output storageAccountCSEFileName string = storageAccountCSEFileName

@description('The Public Key of the created SSH Key.')
output SSHKeyPublicKey string = sshKey.properties.publicKey
