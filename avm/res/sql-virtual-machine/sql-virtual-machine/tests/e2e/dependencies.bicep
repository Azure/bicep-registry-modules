@description('Required. The name of the SQL virtual machine to create.')
param virtualMachineName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The administrator password for the virtual machine.')
@secure()
param adminPassword string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: '${virtualNetworkName}-nsg'
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

module virtualMachine '../../../../compute/virtual-machine/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vm'
  params: {
    name: virtualMachineName
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
    osType: 'Windows'
    vmSize: 'Standard_D4s_v7'
  }
}

@description('The name of the created virtual machine.')
output virtualMachineName string = virtualMachine.outputs.name

@description('The resource ID of the created virtual machine.')
output virtualMachineResourceId string = virtualMachine.outputs.resourceId

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
