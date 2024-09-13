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

@description('Required. The name of the Proximity Placement Group to create.')
param proximityPlacementGroupName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The object ID of the Backup Management Service Enterprise Application. Required for Customer-Managed-Keys.')
param backupManagementServiceApplicationObjectId string

@description('Required. The name of the data collection rule.')
param dcrName string

@description('Required. Resource ID of the log analytics worspace to stream logs from Azure monitoring agent.')
param logAnalyticsWorkspaceResourceId string

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
  name: guid('${keyVault.name}-${location}-BackupManagementService-KeyVault-KeyVaultAdministrator-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: backupManagementServiceApplicationObjectId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

resource msiKVReadRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
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

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2022-03-01' = {
  name: proximityPlacementGroupName
  location: location
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: dcrName
  location: location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          streams: [
            'Microsoft-Perf'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Processes'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Handle Count'
            '\\System\\System Up Time'
            '\\System\\Context Switches/sec'
            '\\System\\Processor Queue Length'
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pages/sec'
            '\\Memory\\Page Faults/sec'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Packets/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
          ]
          name: 'perfCounterDataSource60'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspaceResourceId
          name: 'la--1264800308'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Perf'
        ]
        destinations: [
          'la--1264800308'
        ]
        transformKql: 'source'
        outputStream: 'Microsoft-Perf'
      }
    ]
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

@description('The name of the Custom Script Extension in the created Storage Account.')
output storageAccountCSEFileName string = storageAccountCSEFileName

@description('The URL of the Custom Script Extension in the created Storage Account')
output storageAccountCSEFileUrl string = '${storageAccount.properties.primaryEndpoints.blob}${storageAccount::blobService::container.name}/${storageAccountCSEFileName}'

@description('The resource ID of the created Proximity Placement Group.')
output proximityPlacementGroupResourceId string = proximityPlacementGroup.id

@description('The resource ID of the created data collection rule.')
output dataCollectionRuleResourceId string = dcr.id
