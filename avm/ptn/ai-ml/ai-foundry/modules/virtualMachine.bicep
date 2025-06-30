// Parameters
@description('Specifies the name of the virtual machine.')
param vmName string = 'TestVm'

@description('Specifies the size of the virtual machine.')
param vmSize string = 'Standard_DS4_v2'

@description('Specifies the resource id of the subnet hosting the virtual machine.')
param vmSubnetResourceId string

@description('Specifies the name of the storage account where the bootstrap diagnostic logs of the virtual machine are stored.')
param storageAccountName string

@description('Specifies the resource group of the storage account where the bootstrap diagnostic logs of the virtual machine are stored.')
param storageAccountResourceGroup string

@description('Specifies the image publisher of the disk image used to create the virtual machine.')
param imagePublisher string = 'MicrosoftWindowsServer'

@description('Specifies the offer of the platform image or marketplace image used to create the virtual machine.')
param imageOffer string = 'WindowsServer'

@description('Specifies the image version for the virtual machine.')
param imageSku string = '2022-datacenter-azure-edition'

@description('Specifies the type of authentication when accessing the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

@description('Specifies the name of the administrator account of the virtual machine.')
param vmAdminUsername string

@description('Specifies the SSH Key or password for the virtual machine. SSH key is recommended.')
@secure()
param vmAdminPasswordOrKey string

@description('Specifies the storage account type for OS and data disk.')
@allowed([
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
  'UltraSSD_LRS'
])
param diskStorageAccountType string = 'Premium_LRS'

@description('Specifies the number of data disks of the virtual machine.')
@minValue(0)
@maxValue(64)
param numDataDisks int = 1

@description('Specifies the size in GB of the OS disk of the VM.')
param osDiskSize int = 128

@description('Specifies the size in GB of the OS disk of the virtual machine.')
param dataDiskSize int = 50

@description('Specifies the caching requirements for the data disks.')
param dataDiskCaching string = 'ReadWrite'

@description('Specifies whether enabling Microsoft Entra ID authentication on the virtual machine.')
param enableMicrosoftEntraIdAuth bool = true

@description('Specifies whether enabling accelerated networking on the virtual machine.')
param enableAcceleratedNetworking bool = true

@description('Specifies the name of the network interface of the virtual machine.')
param vmNicName string

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

@description('Optional. Resource ID of a Log Analytics workspace for monitoring. If provided, data collection rules will be created.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. Enable data collection and monitoring. Requires logAnalyticsWorkspaceResourceId to be provided.')
param enableMonitoring bool = false

// Monitoring should only be enabled if we have a valid Log Analytics workspace ID
var shouldEnableMonitoring = enableMonitoring && !empty(logAnalyticsWorkspaceResourceId)

var randomString = uniqueString(resourceGroup().id, vmName, vmAdminPasswordOrKey)

var adminPassword = (length(vmAdminPasswordOrKey) < 8)
  ? '${vmAdminPasswordOrKey}${take(randomString, 12)}'
  : vmAdminPasswordOrKey

// Variables
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${vmAdminUsername}/.ssh/authorized_keys'
        keyData: adminPassword
      }
    ]
  }
  provisionVMAgent: true
}

// Resources

// Maintenance Configuration for VM patching compliance (only for StandardPrivate)
resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: '${vmName}-maintenance-config'
  location: location
  tags: tags
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2024-06-16 00:00'
      duration: '03:55'
      timeZone: 'UTC'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

resource virtualMachineNic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: vmNicName
  location: location
  tags: tags
  properties: {
    enableAcceleratedNetworking: enableAcceleratedNetworking
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vmSubnetResourceId
          }
        }
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountResourceGroup)
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: take(vmName, 15)
      adminUsername: vmAdminUsername
      adminPassword: adminPassword
      linuxConfiguration: (authenticationType == 'password') ? null : linuxConfiguration
      windowsConfiguration: (authenticationType == 'password')
        ? {
            patchSettings: {
              patchMode: 'AutomaticByPlatform'
              automaticByPlatformSettings: {
                rebootSetting: 'IfRequired'
                bypassPlatformSafetyChecksOnUserSchedule: true
              }
            }
            enableAutomaticUpdates: true
          }
        : null
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: osDiskSize
        managedDisk: {
          storageAccountType: diskStorageAccountType
        }
      }
      dataDisks: [
        for j in range(0, numDataDisks): {
          caching: dataDiskCaching
          diskSizeGB: dataDiskSize
          lun: j
          name: '${vmName}-DataDisk${j}'
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskStorageAccountType
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: virtualMachineNic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageAccount.properties.primaryEndpoints.blob
      }
    }
  }
}

// Maintenance Configuration Assignment (assigns the maintenance config to the VM)
resource vmMaintenanceAssignment 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = {
  name: '${virtualMachine.name}-maintenance-assignment'
  location: location
  scope: virtualMachine
  properties: {
    maintenanceConfigurationId: maintenanceConfiguration.id
  }
}

resource dependencyExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (shouldEnableMonitoring) {
  name: 'DependencyAgentWindows'
  parent: virtualMachine
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.4'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
}

resource amaExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (shouldEnableMonitoring) {
  name: 'AzureMonitorWindowsAgent'
  parent: virtualMachine
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    dependencyExtension
  ]
}

resource entraExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (enableMicrosoftEntraIdAuth) {
  name: 'AADLoginForWindows'
  parent: virtualMachine
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
  }
  dependsOn: shouldEnableMonitoring
    ? [
        amaExtension
      ]
    : []
}

resource dcrEventLogs 'Microsoft.Insights/dataCollectionRules@2023-03-11' = if (shouldEnableMonitoring) {
  name: 'DCR-Win-Event-Logs-to-LAW'
  location: location
  kind: 'Windows'
  properties: {
    dataFlows: [
      {
        destinations: [
          'logAnalyticsWorkspace'
        ]
        streams: [
          'Microsoft-Event'
        ]
      }
    ]
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2 or Level=3 or or Level=0) ]]'
            'Security!*[System[(band(Keywords,13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or or Level=0)]]'
          ]
          name: 'eventLogsDataSource'
        }
      ]
    }
    description: 'Collect Windows Event Logs and send to Azure Monitor Logs'
    destinations: {
      logAnalytics: [
        {
          name: 'logAnalyticsWorkspace'
          workspaceResourceId: logAnalyticsWorkspaceResourceId
        }
      ]
    }
  }
  dependsOn: enableMicrosoftEntraIdAuth
    ? [
        entraExtension
      ]
    : []
}

resource dcrPerfLaw 'Microsoft.Insights/dataCollectionRules@2023-03-11' = if (shouldEnableMonitoring) {
  name: 'DCR-Win-Perf-to-LAW'
  location: location
  kind: 'Windows'
  properties: {
    dataFlows: [
      {
        destinations: [
          'logAnalyticsWorkspace'
        ]
        streams: [
          'Microsoft-Perf'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
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
          samplingFrequencyInSeconds: 60
          streams: [
            'Microsoft-Perf'
          ]
        }
      ]
    }
    description: 'Collect Performance Counters and send to Azure Monitor Logs.'
    destinations: {
      logAnalytics: [
        {
          name: 'logAnalyticsWorkspace'
          workspaceResourceId: logAnalyticsWorkspaceResourceId
        }
      ]
    }
  }
  dependsOn: enableMicrosoftEntraIdAuth
    ? [
        entraExtension
      ]
    : []
}

resource dcrEventLogsAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2023-03-11' = if (shouldEnableMonitoring) {
  name: 'DCRA-VMSS-WEL-LAW'
  scope: virtualMachine
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine.'
    dataCollectionRuleId: dcrEventLogs.id
  }
}

resource dcrPerfLawAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2023-03-11' = if (shouldEnableMonitoring) {
  name: 'DCRA-VM-PC-LAW'
  scope: virtualMachine
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine.'
    dataCollectionRuleId: dcrPerfLaw.id
  }
}

resource virtualMachineAdministratorLoginRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '1c0163c0-47e6-4577-8991-ea5c82e286e4'
  scope: subscription()
}

// This role assignment grants the Virtual Machine Administrator Login role to the current user.
resource virtualMachineAdministratorLoginUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableMicrosoftEntraIdAuth && !empty(userObjectId)) {
  name: guid(virtualMachine.id, virtualMachineAdministratorLoginRoleDefinition.id, userObjectId)
  scope: virtualMachine
  properties: {
    roleDefinitionId: virtualMachineAdministratorLoginRoleDefinition.id
    principalType: 'ServicePrincipal'
    principalId: userObjectId
  }
}

// Maintenance configuration removed to avoid API version and naming conflicts in testing

output name string = virtualMachine.name
output id string = virtualMachine.id
