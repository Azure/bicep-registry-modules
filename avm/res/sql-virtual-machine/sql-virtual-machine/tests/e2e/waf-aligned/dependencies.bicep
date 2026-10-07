@description('Required. The name of the virtual machine to create.')
param virtualMachineName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Required. The name of the network security group to create.')
param networkSecurityGroupName string

@description('Required. The name of the maintenance configuration to create.')
param maintenanceConfigurationName string

@description('Required. The name of the Log Analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the data collection rule to create.')
param dataCollectionRuleName string

@description('Required. The administrator password for the virtual machine.')
@secure()
param adminPassword string

@description('Optional. The tags to apply to the virtual machine and its child resources.')
param tags object = {}

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: networkSecurityGroupName
  location: location
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
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
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

// Azure Update Manager schedule that replaces the retiring SQL IaaS Agent Automated Patching feature
resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  name: maintenanceConfigurationName
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2024-06-16 02:00'
      duration: '03:55'
      timeZone: 'UTC'
      recurEvery: '1Week Sunday'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRuleName
  location: location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'perfCounterDataSource60'
          streams: [
            'Microsoft-Perf'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Memory\\Available Bytes'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\SQLServer:Buffer Manager\\Page life expectancy'
            '\\SQLServer:SQL Statistics\\Batch Requests/sec'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'logAnalyticsDestination'
          workspaceResourceId: logAnalyticsWorkspace.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Perf'
        ]
        destinations: [
          'logAnalyticsDestination'
        ]
        transformKql: 'source'
        outputStream: 'Microsoft-Perf'
      }
    ]
  }
}

module virtualMachine '../../../../../compute/virtual-machine/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vm'
  params: {
    name: virtualMachineName
    computerName: take(virtualMachineName, 15)
    location: location
    adminUsername: 'localAdminUser'
    adminPassword: adminPassword
    availabilityZone: -1
    imageReference: {
      publisher: 'MicrosoftSQLServer'
      offer: 'SQL2022-WS2022'
      sku: 'sqldev-gen2'
      version: 'latest'
    }
    managedIdentities: {
      systemAssigned: true
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: virtualNetwork.properties.subnets[0].id
          }
        ]
        nicSuffix: '-nic-01'
        tags: tags
      }
    ]
    osDisk: {
      diskSizeGB: 128
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D4s_v7'
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.id
    extensionMonitoringAgentConfig: {
      enabled: true
      dataCollectionRuleAssociations: [
        {
          name: 'SendMetricsToLAW'
          dataCollectionRuleResourceId: dataCollectionRule.id
        }
      ]
    }
    tags: tags
  }
}

@description('The resource ID of the created virtual machine.')
output virtualMachineResourceId string = virtualMachine.outputs.resourceId
