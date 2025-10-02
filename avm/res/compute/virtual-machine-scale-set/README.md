# Virtual Machine Scale Sets `[Microsoft.Compute/virtualMachineScaleSets]`

This module deploys a Virtual Machine Scale Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Compute/virtualMachineScaleSets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachinescalesets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachineScaleSets)</li></ul> |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachinescalesets_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachineScaleSets/extensions)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/virtual-machine-scale-set:<version>`.

- [Using only defaults for Linux](#example-1-using-only-defaults-for-linux)
- [Deploys VMSS with health extension](#example-2-deploys-vmss-with-health-extension)
- [Using large parameter set for Linux](#example-3-using-large-parameter-set-for-linux)
- [Using disk encryption set for the VM.](#example-4-using-disk-encryption-set-for-the-vm)
- [Using only defaults for Windows](#example-5-using-only-defaults-for-windows)
- [Using large parameter set for Windows](#example-6-using-large-parameter-set-for-windows)
- [Deploying VMSS in uniform orchestration mode with Windows image.](#example-7-deploying-vmss-in-uniform-orchestration-mode-with-windows-image)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Using only defaults for Linux_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmsslinmin001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsslinmin'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    disablePasswordAuthentication: true
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsslinmin001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsslinmin"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "disablePasswordAuthentication": {
      "value": true
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'scaleSetAdmin'
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmsslinmin001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsslinmin'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param skuName = 'Standard_B12ms'
// Non-required parameters
param disablePasswordAuthentication = true
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/scaleSetAdmin/.ssh/authorized_keys'
  }
]
```

</details>
<p>

### Example 2: _Deploys VMSS with health extension_

This instance deploys the module with as Linux VMSS with health extension.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmsslinhealth001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsslinhealth'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    disablePasswordAuthentication: true
    extensionHealthConfig: {
      enabled: true
      port: 22
      protocol: 'tcp'
    }
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsslinhealth001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsslinhealth"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "disablePasswordAuthentication": {
      "value": true
    },
    "extensionHealthConfig": {
      "value": {
        "enabled": true,
        "port": 22,
        "protocol": "tcp"
      }
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'scaleSetAdmin'
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmsslinhealth001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsslinhealth'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param skuName = 'Standard_B12ms'
// Non-required parameters
param disablePasswordAuthentication = true
param extensionHealthConfig = {
  enabled: true
  port: 22
  protocol: 'tcp'
}
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/scaleSetAdmin/.ssh/authorized_keys'
  }
]
```

</details>
<p>

### Example 3: _Using large parameter set for Linux_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmsslinmax001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsslinmax'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    availabilityZones: [
      2
    ]
    bootDiagnosticEnabled: true
    bootDiagnosticStorageAccountName: '<bootDiagnosticStorageAccountName>'
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: 256
        lun: 1
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: 128
        lun: 2
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disablePasswordAuthentication: true
    encryptionAtHost: false
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: '<KekVaultResourceId>'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
        KeyVaultResourceId: '<KeyVaultResourceId>'
        KeyVaultURL: '<KeyVaultURL>'
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      protectedSettings: {
        managedIdentityResourceId: '<managedIdentityResourceId>'
      }
      settings: {
        commandToExecute: '<commandToExecute>'
        fileUris: [
          '<storageAccountCSEFileUrl>'
        ]
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionMonitoringAgentConfig: {
      autoUpgradeMinorVersion: true
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        name: '8abf72f9-e918-4adc-b20b-c783b8799065'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    scaleSetFaultDomain: 1
    skuCapacity: 1
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradePolicyMode: 'Manual'
    vmNamePrefix: 'vmsslinvm'
    vmPriority: 'Regular'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsslinmax001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsslinmax"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "availabilityZones": {
      "value": [
        2
      ]
    },
    "bootDiagnosticEnabled": {
      "value": true
    },
    "bootDiagnosticStorageAccountName": {
      "value": "<bootDiagnosticStorageAccountName>"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "diskSizeGB": 256,
          "lun": 1,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "diskSizeGB": 128,
          "lun": 2,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAzureDiskEncryptionConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "EncryptionOperation": "EnableEncryption",
          "KekVaultResourceId": "<KekVaultResourceId>",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyEncryptionKeyURL": "<KeyEncryptionKeyURL>",
          "KeyVaultResourceId": "<KeyVaultResourceId>",
          "KeyVaultURL": "<KeyVaultURL>",
          "ResizeOSDisk": "false",
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "protectedSettings": {
          "managedIdentityResourceId": "<managedIdentityResourceId>"
        },
        "settings": {
          "commandToExecute": "<commandToExecute>",
          "fileUris": [
            "<storageAccountCSEFileUrl>"
          ]
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "autoUpgradeMinorVersion": true,
        "enabled": true
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "8abf72f9-e918-4adc-b20b-c783b8799065",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "scaleSetFaultDomain": {
      "value": 1
    },
    "skuCapacity": {
      "value": 1
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "upgradePolicyMode": {
      "value": "Manual"
    },
    "vmNamePrefix": {
      "value": "vmsslinvm"
    },
    "vmPriority": {
      "value": "Regular"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'scaleSetAdmin'
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmsslinmax001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsslinmax'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param skuName = 'Standard_B12ms'
// Non-required parameters
param availabilityZones = [
  2
]
param bootDiagnosticEnabled = true
param bootDiagnosticStorageAccountName = '<bootDiagnosticStorageAccountName>'
param dataDisks = [
  {
    caching: 'ReadOnly'
    createOption: 'Empty'
    diskSizeGB: 256
    lun: 1
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
  }
  {
    caching: 'ReadOnly'
    createOption: 'Empty'
    diskSizeGB: 128
    lun: 2
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disablePasswordAuthentication = true
param encryptionAtHost = false
param extensionAzureDiskEncryptionConfig = {
  enabled: true
  settings: {
    EncryptionOperation: 'EnableEncryption'
    KekVaultResourceId: '<KekVaultResourceId>'
    KeyEncryptionAlgorithm: 'RSA-OAEP'
    KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
    KeyVaultResourceId: '<KeyVaultResourceId>'
    KeyVaultURL: '<KeyVaultURL>'
    ResizeOSDisk: 'false'
    VolumeType: 'All'
  }
}
param extensionCustomScriptConfig = {
  protectedSettings: {
    managedIdentityResourceId: '<managedIdentityResourceId>'
  }
  settings: {
    commandToExecute: '<commandToExecute>'
    fileUris: [
      '<storageAccountCSEFileUrl>'
    ]
  }
}
param extensionDependencyAgentConfig = {
  enabled: true
}
param extensionMonitoringAgentConfig = {
  autoUpgradeMinorVersion: true
  enabled: true
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/scaleSetAdmin/.ssh/authorized_keys'
  }
]
param roleAssignments = [
  {
    name: '8abf72f9-e918-4adc-b20b-c783b8799065'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param scaleSetFaultDomain = 1
param skuCapacity = 1
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradePolicyMode = 'Manual'
param vmNamePrefix = 'vmsslinvm'
param vmPriority = 'Regular'
```

</details>
<p>

### Example 4: _Using disk encryption set for the VM._

This instance deploys the module with disk enryption set.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmsslcmk001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsslcmk'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        diskEncryptionSet: {
          id: '<id>'
        }
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: 128
        lun: 1
        managedDisk: {
          diskEncryptionSet: {
            id: '<id>'
          }
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    disablePasswordAuthentication: true
    extensionMonitoringAgentConfig: {
      autoUpgradeMinorVersion: true
      enabled: true
    }
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsslcmk001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsslcmk"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "diskEncryptionSet": {
            "id": "<id>"
          },
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "dataDisks": {
      "value": [
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "diskSizeGB": 128,
          "lun": 1,
          "managedDisk": {
            "diskEncryptionSet": {
              "id": "<id>"
            },
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "autoUpgradeMinorVersion": true,
        "enabled": true
      }
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'scaleSetAdmin'
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmsslcmk001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsslcmk'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    diskEncryptionSet: {
      id: '<id>'
    }
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param skuName = 'Standard_B12ms'
// Non-required parameters
param dataDisks = [
  {
    caching: 'ReadOnly'
    createOption: 'Empty'
    diskSizeGB: 128
    lun: 1
    managedDisk: {
      diskEncryptionSet: {
        id: '<id>'
      }
      storageAccountType: 'Premium_LRS'
    }
  }
]
param disablePasswordAuthentication = true
param extensionMonitoringAgentConfig = {
  autoUpgradeMinorVersion: true
  enabled: true
}
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/scaleSetAdmin/.ssh/authorized_keys'
  }
]
```

</details>
<p>

### Example 5: _Using only defaults for Windows_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmsswinmin001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsswinmin'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsswinmin001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsswinmin"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'localAdminUser'
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmsswinmin001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsswinmin'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param skuName = 'Standard_B12ms'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 6: _Using large parameter set for Windows_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmsswinmax001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsswinmax'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    encryptionAtHost: false
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
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
    }
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: '<KekVaultResourceId>'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
        KeyVaultResourceId: '<KeyVaultResourceId>'
        KeyVaultURL: '<KeyVaultURL>'
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      protectedSettings: {
        managedIdentityResourceId: '<managedIdentityResourceId>'
      }
      settings: {
        commandToExecute: '<commandToExecute>'
        fileUris: [
          '<storageAccountCSEFileUrl>'
        ]
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionDSCConfig: {
      enabled: true
    }
    extensionHealthConfig: {
      enabled: true
      port: 80
      protocol: 'http'
      requestPath: '/'
    }
    extensionMonitoringAgentConfig: {
      autoUpgradeMinorVersion: true
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: '1910de8c-4dab-4189-96bb-2feb68350fb8'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    skuCapacity: 1
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradePolicyMode: 'Manual'
    vmNamePrefix: 'vmsswinvm'
    vmPriority: 'Regular'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsswinmax001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsswinmax"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "encryptionAtHost": {
      "value": false
    },
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
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        }
      }
    },
    "extensionAzureDiskEncryptionConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "EncryptionOperation": "EnableEncryption",
          "KekVaultResourceId": "<KekVaultResourceId>",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyEncryptionKeyURL": "<KeyEncryptionKeyURL>",
          "KeyVaultResourceId": "<KeyVaultResourceId>",
          "KeyVaultURL": "<KeyVaultURL>",
          "ResizeOSDisk": "false",
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "protectedSettings": {
          "managedIdentityResourceId": "<managedIdentityResourceId>"
        },
        "settings": {
          "commandToExecute": "<commandToExecute>",
          "fileUris": [
            "<storageAccountCSEFileUrl>"
          ]
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionHealthConfig": {
      "value": {
        "enabled": true,
        "port": 80,
        "protocol": "http",
        "requestPath": "/"
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "autoUpgradeMinorVersion": true,
        "enabled": true
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "1910de8c-4dab-4189-96bb-2feb68350fb8",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "skuCapacity": {
      "value": 1
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "upgradePolicyMode": {
      "value": "Manual"
    },
    "vmNamePrefix": {
      "value": "vmsswinvm"
    },
    "vmPriority": {
      "value": "Regular"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'localAdminUser'
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmsswinmax001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsswinmax'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param skuName = 'Standard_B12ms'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param encryptionAtHost = false
param extensionAntiMalwareConfig = {
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
      day: '7'
      isEnabled: 'true'
      scanType: 'Quick'
      time: '120'
    }
  }
}
param extensionAzureDiskEncryptionConfig = {
  enabled: true
  settings: {
    EncryptionOperation: 'EnableEncryption'
    KekVaultResourceId: '<KekVaultResourceId>'
    KeyEncryptionAlgorithm: 'RSA-OAEP'
    KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
    KeyVaultResourceId: '<KeyVaultResourceId>'
    KeyVaultURL: '<KeyVaultURL>'
    ResizeOSDisk: 'false'
    VolumeType: 'All'
  }
}
param extensionCustomScriptConfig = {
  protectedSettings: {
    managedIdentityResourceId: '<managedIdentityResourceId>'
  }
  settings: {
    commandToExecute: '<commandToExecute>'
    fileUris: [
      '<storageAccountCSEFileUrl>'
    ]
  }
}
param extensionDependencyAgentConfig = {
  enabled: true
}
param extensionDSCConfig = {
  enabled: true
}
param extensionHealthConfig = {
  enabled: true
  port: 80
  protocol: 'http'
  requestPath: '/'
}
param extensionMonitoringAgentConfig = {
  autoUpgradeMinorVersion: true
  enabled: true
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    name: '1910de8c-4dab-4189-96bb-2feb68350fb8'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param skuCapacity = 1
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradePolicyMode = 'Manual'
param vmNamePrefix = 'vmsswinvm'
param vmPriority = 'Regular'
```

</details>
<p>

### Example 7: _Deploying VMSS in uniform orchestration mode with Windows image._

This instance deploys the module with the minimum set of required parameters in uniform orchestration mode.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmsswinuni001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsswinuni'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    orchestrationMode: 'Uniform'
    patchMode: 'AutomaticByOS'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsswinuni001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsswinuni"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "orchestrationMode": {
      "value": "Uniform"
    },
    "patchMode": {
      "value": "AutomaticByOS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'localAdminUser'
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmsswinuni001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsswinuni'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param skuName = 'Standard_B12ms'
// Non-required parameters
param orchestrationMode = 'Uniform'
param patchMode = 'AutomaticByOS'
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework for Windows.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:<version>' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmsswinwaf001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsswinwaf'
              }
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    encryptionAtHost: false
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
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
    }
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: '<KekVaultResourceId>'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
        KeyVaultResourceId: '<KeyVaultResourceId>'
        KeyVaultURL: '<KeyVaultURL>'
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      protectedSettings: {
        managedIdentityResourceId: '<managedIdentityResourceId>'
      }
      settings: {
        commandToExecute: '<commandToExecute>'
        fileUris: [
          '<storageAccountCSEFileUrl>'
        ]
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionDSCConfig: {
      enabled: true
    }
    extensionMonitoringAgentConfig: {
      autoUpgradeMinorVersion: true
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    skuCapacity: 1
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradePolicyMode: 'Manual'
    vmNamePrefix: 'vmsswinvm'
    vmPriority: 'Regular'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmsswinwaf001"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "publicIPAddressConfiguration": {
                  "name": "pip-cvmsswinwaf"
                },
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "encryptionAtHost": {
      "value": false
    },
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
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        }
      }
    },
    "extensionAzureDiskEncryptionConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "EncryptionOperation": "EnableEncryption",
          "KekVaultResourceId": "<KekVaultResourceId>",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyEncryptionKeyURL": "<KeyEncryptionKeyURL>",
          "KeyVaultResourceId": "<KeyVaultResourceId>",
          "KeyVaultURL": "<KeyVaultURL>",
          "ResizeOSDisk": "false",
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "protectedSettings": {
          "managedIdentityResourceId": "<managedIdentityResourceId>"
        },
        "settings": {
          "commandToExecute": "<commandToExecute>",
          "fileUris": [
            "<storageAccountCSEFileUrl>"
          ]
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "autoUpgradeMinorVersion": true,
        "enabled": true
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "skuCapacity": {
      "value": 1
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "upgradePolicyMode": {
      "value": "Manual"
    },
    "vmNamePrefix": {
      "value": "vmsswinvm"
    },
    "vmPriority": {
      "value": "Regular"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine-scale-set:<version>'

// Required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'localAdminUser'
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmsswinwaf001'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddressConfiguration: {
            name: 'pip-cvmsswinwaf'
          }
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    nicSuffix: '-nic01'
  }
]
param osDisk = {
  createOption: 'fromImage'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param skuName = 'Standard_B12ms'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param encryptionAtHost = false
param extensionAntiMalwareConfig = {
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
      day: '7'
      isEnabled: 'true'
      scanType: 'Quick'
      time: '120'
    }
  }
}
param extensionAzureDiskEncryptionConfig = {
  enabled: true
  settings: {
    EncryptionOperation: 'EnableEncryption'
    KekVaultResourceId: '<KekVaultResourceId>'
    KeyEncryptionAlgorithm: 'RSA-OAEP'
    KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
    KeyVaultResourceId: '<KeyVaultResourceId>'
    KeyVaultURL: '<KeyVaultURL>'
    ResizeOSDisk: 'false'
    VolumeType: 'All'
  }
}
param extensionCustomScriptConfig = {
  protectedSettings: {
    managedIdentityResourceId: '<managedIdentityResourceId>'
  }
  settings: {
    commandToExecute: '<commandToExecute>'
    fileUris: [
      '<storageAccountCSEFileUrl>'
    ]
  }
}
param extensionDependencyAgentConfig = {
  enabled: true
}
param extensionDSCConfig = {
  enabled: true
}
param extensionMonitoringAgentConfig = {
  autoUpgradeMinorVersion: true
  enabled: true
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param skuCapacity = 1
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradePolicyMode = 'Manual'
param vmNamePrefix = 'vmsswinvm'
param vmPriority = 'Regular'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminPassword`](#parameter-adminpassword) | securestring | When specifying a Windows Virtual Machine, this value should be passed. |
| [`adminUsername`](#parameter-adminusername) | securestring | Administrator username. |
| [`imageReference`](#parameter-imagereference) | object | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| [`name`](#parameter-name) | string | Name of the VMSS. |
| [`nicConfigurations`](#parameter-nicconfigurations) | array | Configures NICs and PIPs. The first item in the list is considered the `primary` configuration. |
| [`osDisk`](#parameter-osdisk) | object | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| [`osType`](#parameter-ostype) | string | The chosen OS type. |
| [`skuName`](#parameter-skuname) | string | The SKU size of the VMs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalUnattendContent`](#parameter-additionalunattendcontent) | array | Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object. |
| [`automaticRepairsPolicyEnabled`](#parameter-automaticrepairspolicyenabled) | bool | Specifies whether automatic repairs should be enabled on the virtual machine scale set. |
| [`availabilityZones`](#parameter-availabilityzones) | array | The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set. |
| [`bootDiagnosticEnabled`](#parameter-bootdiagnosticenabled) | bool | Enable boot diagnostics to use default managed or secure storage. Defaults set to false. |
| [`bootDiagnosticStorageAccountName`](#parameter-bootdiagnosticstorageaccountname) | string | The name of the boot diagnostic storage account. Provide this if you want to use your own storage account for security reasons instead of the recommended Microsoft Managed Storage Account. |
| [`bootDiagnosticStorageAccountUri`](#parameter-bootdiagnosticstorageaccounturi) | string | Storage account boot diagnostic base URI. |
| [`bypassPlatformSafetyChecksOnUserSchedule`](#parameter-bypassplatformsafetychecksonuserschedule) | bool | Enables customer to schedule patching without accidental upgrades. |
| [`customData`](#parameter-customdata) | string | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| [`dataDisks`](#parameter-datadisks) | array | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableAutomaticRollback`](#parameter-disableautomaticrollback) | bool | Whether OS image rollback feature should be disabled. |
| [`disablePasswordAuthentication`](#parameter-disablepasswordauthentication) | bool | Specifies whether password authentication should be disabled. |
| [`doNotRunExtensionsOnOverprovisionedVMs`](#parameter-donotrunextensionsonoverprovisionedvms) | bool | When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs. |
| [`enableAutomaticOSUpgrade`](#parameter-enableautomaticosupgrade) | bool | Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true. |
| [`enableAutomaticUpdates`](#parameter-enableautomaticupdates) | bool | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| [`enableCrossZoneUpgrade`](#parameter-enablecrosszoneupgrade) | bool | Allow VMSS to ignore AZ boundaries when constructing upgrade batches. Take into consideration the Update Domain and maxBatchInstancePercent to determine the batch size. |
| [`enableEvictionPolicy`](#parameter-enableevictionpolicy) | bool | Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionAtHost`](#parameter-encryptionathost) | bool | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets. |
| [`extensionAntiMalwareConfig`](#parameter-extensionantimalwareconfig) | object | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionAzureDiskEncryptionConfig`](#parameter-extensionazurediskencryptionconfig) | object | The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys. |
| [`extensionCustomScriptConfig`](#parameter-extensioncustomscriptconfig) | object | The configuration for the [Custom Script] extension. |
| [`extensionDependencyAgentConfig`](#parameter-extensiondependencyagentconfig) | object | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinConfig`](#parameter-extensiondomainjoinconfig) | secureObject | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinPassword`](#parameter-extensiondomainjoinpassword) | securestring | Required if name is specified. Password of the user specified in user parameter. |
| [`extensionDSCConfig`](#parameter-extensiondscconfig) | object | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionHealthConfig`](#parameter-extensionhealthconfig) | object | Turned on by default. The configuration for the [Application Health Monitoring] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionMonitoringAgentConfig`](#parameter-extensionmonitoringagentconfig) | object | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionNetworkWatcherAgentConfig`](#parameter-extensionnetworkwatcheragentconfig) | object | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`gracePeriod`](#parameter-graceperiod) | string | The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M). |
| [`licenseType`](#parameter-licensetype) | string | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`maxBatchInstancePercent`](#parameter-maxbatchinstancepercent) | int | The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability. |
| [`maxPriceForLowPriorityVm`](#parameter-maxpriceforlowpriorityvm) | int | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| [`maxSurge`](#parameter-maxsurge) | bool | Create new virtual machines to upgrade the scale set, rather than updating the existing virtual machines. Existing virtual machines will be deleted once the new virtual machines are created for each batch. |
| [`maxUnhealthyInstancePercent`](#parameter-maxunhealthyinstancepercent) | int | The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |
| [`maxUnhealthyUpgradedInstancePercent`](#parameter-maxunhealthyupgradedinstancepercent) | int | The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |
| [`monitoringWorkspaceResourceId`](#parameter-monitoringworkspaceresourceid) | string | Resource ID of the monitoring log analytics workspace. |
| [`orchestrationMode`](#parameter-orchestrationmode) | string | Specifies the orchestration mode for the virtual machine scale set. |
| [`overprovision`](#parameter-overprovision) | bool | Specifies whether the Virtual Machine Scale Set should be overprovisioned. |
| [`patchAssessmentMode`](#parameter-patchassessmentmode) | string | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| [`patchMode`](#parameter-patchmode) | string | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'. |
| [`pauseTimeBetweenBatches`](#parameter-pausetimebetweenbatches) | string | The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format. |
| [`plan`](#parameter-plan) | object | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| [`prioritizeUnhealthyInstances`](#parameter-prioritizeunhealthyinstances) | bool | Upgrade all unhealthy instances in a scale set before any healthy instances. |
| [`provisionVMAgent`](#parameter-provisionvmagent) | bool | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | Resource ID of a proximity placement group. |
| [`publicKeys`](#parameter-publickeys) | array | The list of SSH public keys used to authenticate with linux based VMs. |
| [`rebootSetting`](#parameter-rebootsetting) | string | Specifies the reboot setting for all AutomaticByPlatform patch installation operations. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`rollbackFailedInstancesOnPolicyBreach`](#parameter-rollbackfailedinstancesonpolicybreach) | bool | Rollback failed instances to previous model if the Rolling Upgrade policy is violated. |
| [`scaleInPolicy`](#parameter-scaleinpolicy) | object | Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in. |
| [`scaleSetFaultDomain`](#parameter-scalesetfaultdomain) | int | Fault Domain count for each placement group. |
| [`scheduledEventsProfile`](#parameter-scheduledeventsprofile) | object | Specifies Scheduled Event related configurations. |
| [`secrets`](#parameter-secrets) | array | Specifies set of certificates that should be installed onto the virtual machines in the scale set. |
| [`secureBootEnabled`](#parameter-securebootenabled) | bool | Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`securityType`](#parameter-securitytype) | string | Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings. |
| [`singlePlacementGroup`](#parameter-singleplacementgroup) | bool | When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true. |
| [`skuCapacity`](#parameter-skucapacity) | int | The initial instance count of scale set VMs. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeZone`](#parameter-timezone) | string | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| [`ultraSSDEnabled`](#parameter-ultrassdenabled) | bool | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| [`upgradePolicyMode`](#parameter-upgradepolicymode) | string | Specifies the mode of an upgrade to virtual machines in the scale set.' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling. |
| [`vmNamePrefix`](#parameter-vmnameprefix) | string | Specifies the computer name prefix for all of the virtual machines in the scale set. |
| [`vmPriority`](#parameter-vmpriority) | string | Specifies the priority for the virtual machine. |
| [`vTpmEnabled`](#parameter-vtpmenabled) | bool | Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`winRM`](#parameter-winrm) | object | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |
| [`zoneBalance`](#parameter-zonebalance) | bool | Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage. |

### Parameter: `adminPassword`

When specifying a Windows Virtual Machine, this value should be passed.

- Required: Yes
- Type: securestring

### Parameter: `adminUsername`

Administrator username.

- Required: Yes
- Type: securestring

### Parameter: `imageReference`

OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image.

- Required: Yes
- Type: object

### Parameter: `name`

Name of the VMSS.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations`

Configures NICs and PIPs. The first item in the list is considered the `primary` configuration.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-nicconfigurationsipconfigurations) | array | Specifies the IP configurations of the network interface. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableAcceleratedNetworking`](#parameter-nicconfigurationsenableacceleratednetworking) | bool | Specifies whether the network interface is accelerated networking-enabled. Defaults to `true`. |
| [`name`](#parameter-nicconfigurationsname) | string | The name of the NIC configuration. If not provided, a name is generated using the `nicSuffic` and an incremental counter. |
| [`networkSecurityGroupResourceId`](#parameter-nicconfigurationsnetworksecuritygroupresourceid) | string | The resource ID of a network security group to associate with the NIC. |
| [`nicSuffix`](#parameter-nicconfigurationsnicsuffix) | string | The suffix to add to each NIC configuration name if no `name` was provided. |

### Parameter: `nicConfigurations.ipConfigurations`

Specifies the IP configurations of the network interface.

- Required: Yes
- Type: array

### Parameter: `nicConfigurations.enableAcceleratedNetworking`

Specifies whether the network interface is accelerated networking-enabled. Defaults to `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.name`

The name of the NIC configuration. If not provided, a name is generated using the `nicSuffic` and an incremental counter.

- Required: No
- Type: string

### Parameter: `nicConfigurations.networkSecurityGroupResourceId`

The resource ID of a network security group to associate with the NIC.

- Required: No
- Type: string

### Parameter: `nicConfigurations.nicSuffix`

The suffix to add to each NIC configuration name if no `name` was provided.

- Required: No
- Type: string

### Parameter: `osDisk`

Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.

- Required: Yes
- Type: object

### Parameter: `osType`

The chosen OS type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `skuName`

The SKU size of the VMs.

- Required: Yes
- Type: string

### Parameter: `additionalUnattendContent`

Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object.

- Required: No
- Type: array

### Parameter: `automaticRepairsPolicyEnabled`

Specifies whether automatic repairs should be enabled on the virtual machine scale set.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `availabilityZones`

The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `bootDiagnosticEnabled`

Enable boot diagnostics to use default managed or secure storage. Defaults set to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `bootDiagnosticStorageAccountName`

The name of the boot diagnostic storage account. Provide this if you want to use your own storage account for security reasons instead of the recommended Microsoft Managed Storage Account.

- Required: No
- Type: string

### Parameter: `bootDiagnosticStorageAccountUri`

Storage account boot diagnostic base URI.

- Required: No
- Type: string
- Default: `[format('.blob.{0}/', environment().suffixes.storage)]`

### Parameter: `bypassPlatformSafetyChecksOnUserSchedule`

Enables customer to schedule patching without accidental upgrades.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `customData`

Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataDisks`

Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableAutomaticRollback`

Whether OS image rollback feature should be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `disablePasswordAuthentication`

Specifies whether password authentication should be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `doNotRunExtensionsOnOverprovisionedVMs`

When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAutomaticOSUpgrade`

Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAutomaticUpdates`

Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableCrossZoneUpgrade`

Allow VMSS to ignore AZ boundaries when constructing upgrade batches. Take into consideration the Update Domain and maxBatchInstancePercent to determine the batch size.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableEvictionPolicy`

Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionAtHost`

This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extensionAntiMalwareConfig`

The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionAzureDiskEncryptionConfig`

The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionCustomScriptConfig`

The configuration for the [Custom Script] extension.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoUpgradeMinorVersion`](#parameter-extensioncustomscriptconfigautoupgrademinorversion) | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `true`. |
| [`enableAutomaticUpgrade`](#parameter-extensioncustomscriptconfigenableautomaticupgrade) | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `false`. |
| [`forceUpdateTag`](#parameter-extensioncustomscriptconfigforceupdatetag) | string | How the extension handler should be forced to update even if the extension configuration has not changed. |
| [`name`](#parameter-extensioncustomscriptconfigname) | string | The name of the virtual machine extension. Defaults to `CustomScriptExtension`. |
| [`protectedSettings`](#parameter-extensioncustomscriptconfigprotectedsettings) | secureObject | The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`. |
| [`protectedSettingsFromKeyVault`](#parameter-extensioncustomscriptconfigprotectedsettingsfromkeyvault) | object | The extensions protected settings that are passed by reference, and consumed from key vault. |
| [`provisionAfterExtensions`](#parameter-extensioncustomscriptconfigprovisionafterextensions) | array | Collection of extension names after which this extension needs to be provisioned. |
| [`settings`](#parameter-extensioncustomscriptconfigsettings) | object | The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`. |
| [`supressFailures`](#parameter-extensioncustomscriptconfigsupressfailures) | bool | Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). Defaults to `false`. |
| [`tags`](#parameter-extensioncustomscriptconfigtags) | object | Tags of the resource. |
| [`typeHandlerVersion`](#parameter-extensioncustomscriptconfigtypehandlerversion) | string | Specifies the version of the script handler. Defaults to `1.10` for Windows and `2.1` for Linux. |

### Parameter: `extensionCustomScriptConfig.autoUpgradeMinorVersion`

Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `true`.

- Required: No
- Type: bool

### Parameter: `extensionCustomScriptConfig.enableAutomaticUpgrade`

Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `false`.

- Required: No
- Type: bool

### Parameter: `extensionCustomScriptConfig.forceUpdateTag`

How the extension handler should be forced to update even if the extension configuration has not changed.

- Required: No
- Type: string

### Parameter: `extensionCustomScriptConfig.name`

The name of the virtual machine extension. Defaults to `CustomScriptExtension`.

- Required: No
- Type: string

### Parameter: `extensionCustomScriptConfig.protectedSettings`

The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`.

- Required: No
- Type: secureObject

### Parameter: `extensionCustomScriptConfig.protectedSettingsFromKeyVault`

The extensions protected settings that are passed by reference, and consumed from key vault.

- Required: No
- Type: object

### Parameter: `extensionCustomScriptConfig.provisionAfterExtensions`

Collection of extension names after which this extension needs to be provisioned.

- Required: No
- Type: array

### Parameter: `extensionCustomScriptConfig.settings`

The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`.

- Required: No
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`commandToExecute`](#parameter-extensioncustomscriptconfigsettingscommandtoexecute) | string | The entry point script to run. If the command contains any credentials, use the same property of the `protectedSettings` instead. Required if `protectedSettings.commandToExecute` is not provided. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fileUris`](#parameter-extensioncustomscriptconfigsettingsfileuris) | array | URLs for files to be downloaded. If URLs are sensitive, for example, if they contain keys, this field should be specified in `protectedSettings`. |

### Parameter: `extensionCustomScriptConfig.settings.commandToExecute`

The entry point script to run. If the command contains any credentials, use the same property of the `protectedSettings` instead. Required if `protectedSettings.commandToExecute` is not provided.

- Required: No
- Type: string

### Parameter: `extensionCustomScriptConfig.settings.fileUris`

URLs for files to be downloaded. If URLs are sensitive, for example, if they contain keys, this field should be specified in `protectedSettings`.

- Required: No
- Type: array

### Parameter: `extensionCustomScriptConfig.supressFailures`

Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). Defaults to `false`.

- Required: No
- Type: bool

### Parameter: `extensionCustomScriptConfig.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `extensionCustomScriptConfig.typeHandlerVersion`

Specifies the version of the script handler. Defaults to `1.10` for Windows and `2.1` for Linux.

- Required: No
- Type: string

### Parameter: `extensionDependencyAgentConfig`

The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionDomainJoinConfig`

The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: secureObject
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionDomainJoinPassword`

Required if name is specified. Password of the user specified in user parameter.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `extensionDSCConfig`

The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionHealthConfig`

Turned on by default. The configuration for the [Application Health Monitoring] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      port: 80
      protocol: 'http'
      requestPath: '/'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-extensionhealthconfigenabled) | bool | Enable or disable the Health Config extension. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-extensionhealthconfigport) | int | The port to connect to. Defaults to `80`. Required if `protocol` is `tcp`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoUpgradeMinorVersion`](#parameter-extensionhealthconfigautoupgrademinorversion) | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `false`. |
| [`enableAutomaticUpgrade`](#parameter-extensionhealthconfigenableautomaticupgrade) | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `true`. |
| [`gracePeriod`](#parameter-extensionhealthconfiggraceperiod) | int | The grace period for newly created instances. Defaults to `intervalInSeconds` x `numberOfProbes`. |
| [`intervalInSeconds`](#parameter-extensionhealthconfigintervalinseconds) | int | This is the interval between each health probe. For example, if intervalInSeconds == 5, a probe will be sent to the local application endpoint once every 5 seconds. Defaults to `5`. |
| [`numberOfProbes`](#parameter-extensionhealthconfignumberofprobes) | int | This is the number of consecutive probes required for the health status to change. For example, if numberOfProbles == 3, you will need 3 consecutive "Healthy" signals to change the health status from "Unhealthy" into "Healthy" state. The same requirement applies to change health status into "Unhealthy" state. Defaults to `1`. |
| [`protocol`](#parameter-extensionhealthconfigprotocol) | string | The protocol to connect with. Defaults to `http`. |
| [`provisionAfterExtensions`](#parameter-extensionhealthconfigprovisionafterextensions) | array | Collection of extension names after which this extension needs to be provisioned. |
| [`requestPath`](#parameter-extensionhealthconfigrequestpath) | string | The path of the request. Not allowed if `protocol` is `tcp`. |
| [`typeHandlerVersion`](#parameter-extensionhealthconfigtypehandlerversion) | string | Specifies the version of the script handler. Defaults to `2.0`. |

### Parameter: `extensionHealthConfig.enabled`

Enable or disable the Health Config extension.

- Required: Yes
- Type: bool

### Parameter: `extensionHealthConfig.port`

The port to connect to. Defaults to `80`. Required if `protocol` is `tcp`.

- Required: No
- Type: int

### Parameter: `extensionHealthConfig.autoUpgradeMinorVersion`

Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `false`.

- Required: No
- Type: bool

### Parameter: `extensionHealthConfig.enableAutomaticUpgrade`

Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `true`.

- Required: No
- Type: bool

### Parameter: `extensionHealthConfig.gracePeriod`

The grace period for newly created instances. Defaults to `intervalInSeconds` x `numberOfProbes`.

- Required: No
- Type: int
- MaxValue: 14400

### Parameter: `extensionHealthConfig.intervalInSeconds`

This is the interval between each health probe. For example, if intervalInSeconds == 5, a probe will be sent to the local application endpoint once every 5 seconds. Defaults to `5`.

- Required: No
- Type: int
- MinValue: 5
- MaxValue: 60

### Parameter: `extensionHealthConfig.numberOfProbes`

This is the number of consecutive probes required for the health status to change. For example, if numberOfProbles == 3, you will need 3 consecutive "Healthy" signals to change the health status from "Unhealthy" into "Healthy" state. The same requirement applies to change health status into "Unhealthy" state. Defaults to `1`.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 24

### Parameter: `extensionHealthConfig.protocol`

The protocol to connect with. Defaults to `http`.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'http'
    'https'
    'tcp'
  ]
  ```

### Parameter: `extensionHealthConfig.provisionAfterExtensions`

Collection of extension names after which this extension needs to be provisioned.

- Required: No
- Type: array

### Parameter: `extensionHealthConfig.requestPath`

The path of the request. Not allowed if `protocol` is `tcp`.

- Required: No
- Type: string

### Parameter: `extensionHealthConfig.typeHandlerVersion`

Specifies the version of the script handler. Defaults to `2.0`.

- Required: No
- Type: string

### Parameter: `extensionMonitoringAgentConfig`

The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      autoUpgradeMinorVersion: true
      enabled: false
  }
  ```

### Parameter: `extensionNetworkWatcherAgentConfig`

The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `gracePeriod`

The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M).

- Required: No
- Type: string
- Default: `'PT30M'`

### Parameter: `licenseType`

Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Windows_Client'
    'Windows_Server'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `maxBatchInstancePercent`

The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability.

- Required: No
- Type: int
- Default: `20`

### Parameter: `maxPriceForLowPriorityVm`

Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.

- Required: No
- Type: int

### Parameter: `maxSurge`

Create new virtual machines to upgrade the scale set, rather than updating the existing virtual machines. Existing virtual machines will be deleted once the new virtual machines are created for each batch.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `maxUnhealthyInstancePercent`

The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.

- Required: No
- Type: int
- Default: `20`

### Parameter: `maxUnhealthyUpgradedInstancePercent`

The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.

- Required: No
- Type: int
- Default: `20`

### Parameter: `monitoringWorkspaceResourceId`

Resource ID of the monitoring log analytics workspace.

- Required: No
- Type: string
- Default: `''`

### Parameter: `orchestrationMode`

Specifies the orchestration mode for the virtual machine scale set.

- Required: No
- Type: string
- Default: `'Flexible'`
- Allowed:
  ```Bicep
  [
    'Flexible'
    'Uniform'
  ]
  ```

### Parameter: `overprovision`

Specifies whether the Virtual Machine Scale Set should be overprovisioned.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `patchAssessmentMode`

VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours.

- Required: No
- Type: string
- Default: `'ImageDefault'`
- Allowed:
  ```Bicep
  [
    'AutomaticByPlatform'
    'ImageDefault'
  ]
  ```

### Parameter: `patchMode`

VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'.

- Required: No
- Type: string
- Default: `'AutomaticByPlatform'`
- Allowed:
  ```Bicep
  [
    ''
    'AutomaticByOS'
    'AutomaticByPlatform'
    'ImageDefault'
    'Manual'
  ]
  ```

### Parameter: `pauseTimeBetweenBatches`

The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format.

- Required: No
- Type: string
- Default: `'PT0S'`

### Parameter: `plan`

Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.

- Required: No
- Type: object

### Parameter: `prioritizeUnhealthyInstances`

Upgrade all unhealthy instances in a scale set before any healthy instances.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `provisionVMAgent`

Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `proximityPlacementGroupResourceId`

Resource ID of a proximity placement group.

- Required: No
- Type: string

### Parameter: `publicKeys`

The list of SSH public keys used to authenticate with linux based VMs.

- Required: No
- Type: array

### Parameter: `rebootSetting`

Specifies the reboot setting for all AutomaticByPlatform patch installation operations.

- Required: No
- Type: string
- Default: `'IfRequired'`
- Allowed:
  ```Bicep
  [
    'Always'
    'IfRequired'
    'Never'
    'Unknown'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Data Operator for Managed Disks'`
  - `'Desktop Virtualization Power On Contributor'`
  - `'Desktop Virtualization Power On Off Contributor'`
  - `'Desktop Virtualization Virtual Machine Contributor'`
  - `'DevTest Labs User'`
  - `'Disk Backup Reader'`
  - `'Disk Pool Operator'`
  - `'Disk Restore Operator'`
  - `'Disk Snapshot Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Virtual Machine Administrator Login'`
  - `'Virtual Machine Contributor'`
  - `'Virtual Machine User Login'`
  - `'VM Scanner Operator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `rollbackFailedInstancesOnPolicyBreach`

Rollback failed instances to previous model if the Rolling Upgrade policy is violated.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `scaleInPolicy`

Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      rules: [
        'Default'
      ]
  }
  ```

### Parameter: `scaleSetFaultDomain`

Fault Domain count for each placement group.

- Required: No
- Type: int
- Default: `1`

### Parameter: `scheduledEventsProfile`

Specifies Scheduled Event related configurations.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `secrets`

Specifies set of certificates that should be installed onto the virtual machines in the scale set.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `secureBootEnabled`

Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `securityType`

Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings.

- Required: No
- Type: string
- Default: `''`

### Parameter: `singlePlacementGroup`

When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `skuCapacity`

The initial instance count of scale set VMs.

- Required: No
- Type: int
- Default: `1`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `timeZone`

Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.

- Required: No
- Type: string

### Parameter: `ultraSSDEnabled`

The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `upgradePolicyMode`

Specifies the mode of an upgrade to virtual machines in the scale set.' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling.

- Required: No
- Type: string
- Default: `'Manual'`
- Allowed:
  ```Bicep
  [
    'Automatic'
    'Manual'
    'Rolling'
  ]
  ```

### Parameter: `vmNamePrefix`

Specifies the computer name prefix for all of the virtual machines in the scale set.

- Required: No
- Type: string
- Default: `'vmssvm'`

### Parameter: `vmPriority`

Specifies the priority for the virtual machine.

- Required: No
- Type: string
- Default: `'Regular'`
- Allowed:
  ```Bicep
  [
    'Low'
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `vTpmEnabled`

Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `winRM`

Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.

- Required: No
- Type: object

### Parameter: `zoneBalance`

Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual machine scale set. |
| `resourceGroupName` | string | The resource group of the virtual machine scale set. |
| `resourceId` | string | The resource ID of the virtual machine scale set. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
