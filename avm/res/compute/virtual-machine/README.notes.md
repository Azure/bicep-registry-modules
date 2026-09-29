
Inside the `nicConfigurations` section and there inside the `ipConfigurations`, a `pipConfiguration` can be defined. For a new puplic IP address, the naming can either be set with the `name` or the `publicIpNameSuffix`. Per default a newly created PIP will have its `zones` parameter set to `[1,2,3]`. You can override it, for example with `[]`. If an existing PIP should be used, only set the `publicIPAddressResourceId`.

### Automanage considerations

Enabling automanage triggers the creation of additional resources outside of the specific virtual machine deployment, such as:
- an `Automanage-Automate-<timestamp>` in the same Virtual Machine Resource Group and linking to the log analytics workspace leveraged by Azure Security Center.
- a `DefaultResourceGroup-<locationId>` resource group hosting a recovery services vault `DefaultBackupVault-<location>` where virtual machine backups are stored
For further details on automanage please refer to [Automanage virtual machines](https://learn.microsoft.com/en-us/azure/automanage/automanage-virtual-machines).

### Parameter Usage: `imageReference`

#### Marketplace images

<details>

<summary>Parameter JSON format</summary>

```json
"imageReference": {
    "value": {
        "publisher": "MicrosoftWindowsServer",
        "offer": "WindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
    }
}
```

</details>
<details>

<summary>Bicep format</summary>

```bicep
imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
}
```

</details>
<p>

#### Custom images

<details>

<summary>Parameter JSON format</summary>

```json
"imageReference": {
    "value": {
        "id": "/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
imageReference: {
    id: '/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename'
}
```

</details>
<p>

### Parameter Usage: `plan`

<details>

<summary>Parameter JSON format</summary>

```json
"plan": {
    "value": {
        "name": "qvsa-25",
        "product": "qualys-virtual-scanner",
        "publisher": "qualysguard"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
plan: {
    name: 'qvsa-25'
    product: 'qualys-virtual-scanner'
    publisher: 'qualysguard'
}
```

</details>
<p>

### Parameter Usage: `osDisk`

<details>

<summary>Parameter JSON format</summary>

```json
"osDisk": {
    "value": {
        "createOption": "fromImage",
        "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS",
             "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                        "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
              }
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
osDisk: {
    createOption: 'fromImage'
    deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
    diskSizeGB: '128'
    managedDisk: {
        storageAccountType: 'Premium_LRS'
        diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
            id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
        }
    }
}
```

</details>
<p>

### Parameter Usage: `dataDisks`

#### Creation during deployment

<details>

<summary>Parameter JSON format</summary>

```json
"dataDisks": {
    "value": [
        {
            "caching": "ReadOnly",
            "createOption": "Empty",
            "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
            "diskSizeGB": "256",
            "managedDisk": {
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                    "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
                }
            }
        },
        {
            "caching": "ReadOnly",
            "createOption": "Empty",
            "diskSizeGB": "128",
            "managedDisk": {
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                    "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
                }
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
dataDisks: [
    {
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
        diskSizeGB: '256'
        managedDisk: {
            storageAccountType: 'Premium_LRS'
            diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
            }
        }
    }
    {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        managedDisk: {
            storageAccountType: 'Premium_LRS'
            diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
            }
        }
    }
]
```

</details>
<p>

#### Pre-existing disks

<details>

<summary>Parameter JSON format</summary>

```json
"dataDisks": {
    "value": [
        {
          "managedDisk": {
            "id": "<resourceId>"
          }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
dataDisks: [
    {
        managedDisk: {
            id: '<resourceId>'
        }
    }
]
```

</details>
<p>

### Parameter Usage: `nicConfigurations`

Comments:
- The field `nicSuffix` and `subnetResourceId` are mandatory.
- Skipping the `pipConfiguration` or setting it to `null` or `{}` will prevent the creation of a public IP address.
- If `pipConfiguration` is provided and is not null or empty object, then `publicIpNameSuffix` is also mandatory.
- Each IP config needs to have the mandatory field `name`.
- If not disabled, `enableAcceleratedNetworking` is considered `true` by default and requires the VM to be deployed with a supported OS and VM size.

<details>

<summary>Parameter JSON format</summary>

```json
"nicConfigurations": {
  "value": [
    {
      "nicSuffix": "-nic-01",
      "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
      "ipConfigurations": [
        {
          "name": "ipconfig1",
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "pipConfiguration": {
            "publicIpNameSuffix": "-pip-01",
            "roleAssignments": [
              {
                "roleDefinitionIdOrName": "Reader",
                "principalIds": [
                  "<principalId>"
                ]
              }
            ]
          }
        },
        {
          "name": "ipconfig2",
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
        }
      ],
      "networkSecurityGroupResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>",
      "roleAssignments": [
        {
          "roleDefinitionIdOrName": "Reader",
          "principalIds": [
            "<principalId>"
          ]
        }
      ]
    },
    {
      "nicSuffix": "-nic-02",
      "ipConfigurations": [
        {
          "name": "ipconfig1",
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "pipConfiguration": {
            "publicIpNameSuffix": "-pip-02"
          }
        },
        {
          "name": "ipconfig2",
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "privateIPAllocationMethod": "Static",
          "privateIPAddress": "10.0.0.9"
        }
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
nicConfigurations: {
  value: [
    {
      nicSuffix: '-nic-01'
      deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
      ipConfigurations: [
        {
          name: 'ipconfig1'
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          pipConfiguration: {
            publicIpNameSuffix: '-pip-01'
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalIds: [
                  '<principalId>'
                ]
              }
            ]
          }
        }
        {
          name: 'ipconfig2'
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
        }
      ]
      networkSecurityGroupResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>'
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Reader'
          principalIds: [
            '<principalId>'
          ]
        }
      ]
    }
    {
      nicSuffix: '-nic-02'
      ipConfigurations: [
        {
          name: 'ipconfig1'
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          pipConfiguration: {
            publicIpNameSuffix: '-pip-02'
          }
        }
        {
          name: 'ipconfig2'
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.0.9'
        }
      ]
    }
  ]
}
```

</details>
<p>

### Parameter Usage: `configurationProfileAssignments`

<details>

<summary>Parameter JSON format</summary>

```json
"configurationProfileAssignments": {
    "value": [
        "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction",
        "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest"
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
configurationProfileAssignments: [
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
]
```

</details>
<p>

### Parameter Usage: `extensionDomainJoinConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionDomainJoinConfig": {
  "value": {
    "enabled": true,
    "settings": {
      "name": "contoso.com",
      "user": "test.user@testcompany.com",
      "ouPath": "OU=testOU; DC=contoso; DC=com",
      "restart": true,
      "options": 3
    }
  }
},
"extensionDomainJoinPassword": {
  "reference": {
    "keyVault": {
      "id": "/subscriptions/<<subscriptionId>/resourceGroups/myRG/providers/Microsoft.KeyVault/vaults/myKvlt"
    },
    "secretName": "domainJoinUser02-Password"
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDomainJoinConfig: {
    enabled: true
    settings: {
      name: 'contoso.com'
      user: 'test.user@testcompany.com'
      ouPath: 'OU=testOU; DC=contoso; DC=com'
      restart: true
      options: 3
    }
}
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-#_namePrefix_#-az-kv-x-001'
  scope: resourceGroup('[[subscriptionId]]','validation-rg')
}
extensionDomainJoinPassword: kv1.getSecret('domainJoinUser02-Password')
```

</details>
<p>

### Parameter Usage: `extensionAntiMalwareConfig`

Only for OSType Windows

<details>

<summary>Parameter JSON format</summary>

```json
"extensionAntiMalwareConfig": {
  "value": {
    "enabled": true,
    "settings": {
      "AntimalwareEnabled": true,
      "Exclusions": {
        "Extensions": ".log;.ldf",
        "Paths": "D:\\IISlogs;D:\\DatabaseLogs",
        "Processes": "mssence.svc"
      },
      "RealtimeProtectionEnabled": true,
      "ScheduledScanSettings": {
        "isEnabled": "true",
        "scanType": "Quick",
        "day": "7",
        "time": "120"
      }
    }
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionAntiMalwareConfig: {
    enabled: true
    settings: {
        AntimalwareEnabled: true
        Exclusions: {
            Extensions: '.log;.ldf'
            Paths: 'D:\\IISlogs;D:\\DatabaseLogs'
            Processes: 'mssence.svc'
        }
        RealtimeProtectionEnabled: true
        ScheduledScanSettings: {
            isEnabled: 'true'
            scanType: 'Quick'
            day: '7'
            time: '120'
        }
    }
}
```

</details>
<p>

### Parameter Usage: `extensionAzureDiskEncryptionConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionAzureDiskEncryptionConfig": {
  // Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.
  "value": {
    "enabled": true,
    "settings": {
      "EncryptionOperation": "EnableEncryption",
      "KeyVaultURL": "https://mykeyvault.vault.azure.net/",
      "KeyVaultResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
      "KeyEncryptionKeyURL": "https://mykeyvault.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5", // ID must be updated for new keys
      "KekVaultResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
      "KeyEncryptionAlgorithm": "RSA-OAEP", //'RSA-OAEP'/'RSA-OAEP-256'/'RSA1_5'
      "VolumeType": "All", //'OS'/'Data'/'All'
      "ResizeOSDisk": "false"
    }
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionAzureDiskEncryptionConfig: {
    // Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.
    enabled: true
    settings: {
        EncryptionOperation: 'EnableEncryption'
        KeyVaultURL: 'https://mykeyvault.vault.azure.net/'
        KeyVaultResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001'
        KeyEncryptionKeyURL: 'https://mykeyvault.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5' // ID must be updated for new keys
        KekVaultResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001'
        KeyEncryptionAlgorithm: 'RSA-OAEP' //'RSA-OAEP'/'RSA-OAEP-256'/'RSA1_5'
        VolumeType: 'All' //'OS'/'Data'/'All'
        ResizeOSDisk: 'false'
    }
}
```

</details>
<p>

### Parameter Usage: `extensionDSCConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionDSCConfig": {
  "value": {
    {
      "enabled": true,
      "settings": {
        "wmfVersion": "latest",
        "configuration": {
          "url": "http://validURLToConfigLocation",
          "script": "ConfigurationScript.ps1",
          "function": "ConfigurationFunction"
        },
        "configurationArguments": {
          "argument1": "Value1",
          "argument2": "Value2"
        },
        "configurationData": {
          "url": "https://foo.psd1"
        },
        "privacy": {
          "dataCollection": "enable"
        },
        "advancedOptions": {
          "forcePullAndApply": false,
          "downloadMappings": {
            "specificDependencyKey": "https://myCustomDependencyLocation"
          }
        }
      },
      "protectedSettings": {
        "configurationArguments": {
          "mySecret": "MyPlaceholder"
        },
        "configurationUrlSasToken": "MyPlaceholder",
        "configurationDataUrlSasToken": "MyPlaceholder"
      }
    }
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDSCConfig: {
    {
      enabled: true
      settings: {
          wmfVersion: 'latest'
          configuration: {
            url: 'http://validURLToConfigLocation'
            script: 'ConfigurationScript.ps1'
            function: 'ConfigurationFunction'
          }
          configurationArguments: {
            argument1: 'Value1'
            argument2: 'Value2'
          }
          configurationData: {
            url: 'https://foo.psd1'
          }
          privacy: {
            dataCollection: 'enable'
          }
          advancedOptions: {
            forcePullAndApply: false
            downloadMappings: {
              specificDependencyKey: 'https://myCustomDependencyLocation'
            }
          }
        }
        protectedSettings: {
          configurationArguments: {
            mySecret: 'MyPlaceholder'
          }
          configurationUrlSasToken: 'MyPlaceholder'
          configurationDataUrlSasToken: 'MyPlaceholder'
        }
    }
}
```

</details>
<p>

### Parameter Usage: `extensionCustomScriptConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionCustomScriptConfig": {
  "value": {
    "enabled": true,
    "fileData": [
      //storage accounts with SAS token requirement
      {
        "uri": "https://mystorageaccount.blob.core.windows.net/avdscripts/File1.ps1",
        "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
      },
      {
        "uri": "https://mystorageaccount.blob.core.windows.net/avdscripts/File2.ps1",
        "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
      },
      //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
      {
        "uri": "https://github.com/myProject/File3.ps1",
        "storageAccountId": ""
      }
    ]
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionCustomScriptConfig: {
    enabled: true
    fileData: [
      //storage accounts with SAS token requirement
      {
        uri: 'https://mystorageaccount.blob.core.windows.net/avdscripts/File1.ps1'
        storageAccountId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName'
      }
      {
        uri: 'https://mystorageaccount.blob.core.windows.net/avdscripts/File2.ps1'
        storageAccountId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName'
      }
      //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
      {
        uri: 'https://github.com/myProject/File3.ps1'
        storageAccountId: ''
      }
    ]
}
```

</details>
<p>

### Parameter Usage: `extensionCustomScriptProtectedSetting`

This is used if you are going to use secrets or other sensitive information that you don't want to be visible in the deployment and logs.

<details>

<summary>Parameter JSON format</summary>

```json
"extensionCustomScriptProtectedSetting": {
  "value": [
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File testscript.ps1"
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionCustomScriptProtectedSetting: [
    {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File testscript.ps1'
    }
]
```

</details>
<p>

