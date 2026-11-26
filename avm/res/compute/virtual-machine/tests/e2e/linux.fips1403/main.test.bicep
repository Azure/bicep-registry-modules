module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-fips1403'
  params: {
    name: '${namePrefix}${serviceShort}'
    computerName: '${namePrefix}fipsvm'
    location: enforcedLocation

    adminUsername: 'localAdministrator'

    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-jammy'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }

    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]

    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }

    osType: 'Linux'
    vmSize: 'Standard_D2s_v6'
    availabilityZone: -1

    disablePasswordAuthentication: true

    enableFips1403Encryption: true

    publicKeys: [
      {
        keyData: nestedDependencies.outputs.SSHKeyPublicKey
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
  }
}
