@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the data disk to create.')
param sharedDiskName string

@description('Required. The name of the os disk to create.')
param osDiskName string

@description('Required. The name of the VM to take the OS disk from. It\'s not possible to create an OS disk without a VM.')
param osDiskVMName string

@description('Required. The name of the Disk Encryption Set to create.')
param diskEncryptionSetName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Required. The name of the deployment script that waits for a role assignment to propagate.')
param waitDeploymentScriptName string

@description('Specifies the name of the administrator account.')
param adminUsername string = 'localAdminUser'

var addressPrefix = '10.0.0.0/16'

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
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2025-05-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2025-01-02' = {
  name: diskEncryptionSetName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVault.id
      }
      keyUrl: keyVault::key.properties.keyUriWithVersion
    }
    encryptionType: 'EncryptionAtRestWithPlatformAndCustomerKeys'
  }
  dependsOn: [
    waitForRolePropagation
  ]
}

resource msiKVReadRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-KeyVault-Key-Key-Vault-Crypto-Service-Encryption-User-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

// Waiting for the role assignment to propagate
resource waitForRolePropagation 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  dependsOn: [msiKVReadRoleAssignment]
  name: waitDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '11.0'
    cleanupPreference: 'Always'
    scriptContent: 'write-output "Sleeping for 15"; start-sleep -Seconds 15'
  }
}

resource sharedDataDisk 'Microsoft.Compute/disks@2024-03-02' = {
  location: location
  name: sharedDiskName
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    diskSizeGB: 1024
    creationData: {
      createOption: 'Empty'
    }
    maxShares: 2
    encryption: {
      type: 'EncryptionAtRestWithPlatformAndCustomerKeys'
      diskEncryptionSetId: diskEncryptionSet.id
    }
  }
  zones: ['1'] // Should be set to the same zone as the VM
}

resource tempVirtualMachine 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: osDiskVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      adminUsername: adminUsername
      adminPassword: password
      computerName: take(osDiskVMName, 15)
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        osType: 'Windows'
        deleteOption: 'Delete'
        name: osDiskVMName
        managedDisk: {
          diskEncryptionSet: {
            id: diskEncryptionSet.id
          }
        }
      }
    }
    networkProfile: {
      networkApiVersion: '2022-11-01'
      networkInterfaceConfigurations: [
        {
          name: 'primary'
          properties: {
            ipConfigurations: [
              {
                name: 'ipconfig01'
                properties: {
                  subnet: {
                    id: virtualNetwork.properties.subnets[0].id
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
}

resource snapshot 'Microsoft.Compute/snapshots@2024-03-02' = {
  name: '${osDiskName}-snapshot'
  location: location
  properties: {
    creationData: {
      sourceResourceId: tempVirtualMachine.properties.storageProfile.osDisk.managedDisk.id
      createOption: 'Copy'
    }
  }
}

resource osDisk 'Microsoft.Compute/disks@2024-03-02' = {
  location: location
  name: '${osDiskName}-copy'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    diskSizeGB: 1024
    creationData: {
      createOption: 'copy'
      sourceResourceId: snapshot.id
    }
    encryption: {
      type: 'EncryptionAtRestWithPlatformAndCustomerKeys'
      diskEncryptionSetId: diskEncryptionSet.id
    }
  }
  zones: ['1'] // Should be set to the same zone as the VM
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created data disk.')
output sharedDataDiskResourceId string = sharedDataDisk.id

@description('The resource ID of the created os disk.')
output osDiskResourceId string = osDisk.id

@description('The type of OS used for the os disk.')
output osType resourceOutput<'Microsoft.Compute/virtualMachines@2025-04-01'>.properties.storageProfile.osDisk.osType = tempVirtualMachine.properties.storageProfile.osDisk.osType

@description('The security type of the VM used for to create the os disk.')
output securityType resourceOutput<'Microsoft.Compute/virtualMachines@2025-04-01'>.properties.securityProfile.securityType? = tempVirtualMachine.properties.?securityProfile.?securityType

@description('The resource ID of the created Disk Encryption Set.')
output diskEncryptionSetResourceId string = diskEncryptionSet.id
