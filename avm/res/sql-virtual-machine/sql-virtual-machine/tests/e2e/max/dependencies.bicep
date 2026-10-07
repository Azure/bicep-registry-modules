@description('Required. The name of the virtual machine to create.')
param virtualMachineName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Required. The name of the network security group to create.')
param networkSecurityGroupName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the storage account to create for automated backups.')
param storageAccountName string

@description('Required. The administrator password for the virtual machine.')
@secure()
param adminPassword string

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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    // SQL Server Automated Backup only supports storage account access key authentication
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.22.3' = {
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
      }
    ]
    osDisk: {
      diskSizeGB: 128
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    // Data (LUN 0), log (LUN 1) and tempdb (LUN 2) disks consumed by the SQL storage configuration
    dataDisks: [
      {
        lun: 0
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        lun: 1
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        lun: 2
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    osType: 'Windows'
    vmSize: 'Standard_D4s_v7'
  }
}

@description('The resource ID of the created virtual machine.')
output virtualMachineResourceId string = virtualMachine.outputs.resourceId

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The blob endpoint of the created storage account.')
output storageAccountBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
