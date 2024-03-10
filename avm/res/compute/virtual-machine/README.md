# Virtual Machines `[Microsoft.Compute/virtualMachines]`

This module deploys a Virtual Machine with one or multiple NICs and optionally one or multiple public IPs.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2021-04-30-preview](https://learn.microsoft.com/en-us/azure/templates) |
| `Microsoft.Compute/virtualMachines` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkInterfaces` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkInterfaces) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/virtual-machine:<version>`.

- [Using automanage for the VM.](#example-1-using-automanage-for-the-vm)
- [Using only defaults for Linux](#example-2-using-only-defaults-for-linux)
- [Using large parameter set for Linux](#example-3-using-large-parameter-set-for-linux)
- [WAF-aligned](#example-4-waf-aligned)
- [Using only defaults for Windows](#example-5-using-only-defaults-for-windows)
- [Using large parameter set for Windows](#example-6-using-large-parameter-set-for-windows)
- [Using disk encryption set for the VM.](#example-7-using-disk-encryption-set-for-the-vm)

### Example 1: _Using automanage for the VM._

This instance deploys the module with registering to an automation account.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmlinatmg'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmlinatmg'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
            subnetResourceId: '<subnetResourceId>'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
    disablePasswordAuthentication: true
    location: '<location>'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdminUser/.ssh/authorized_keys'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
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
      "value": "cvmlinatmg"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01"
              },
              "subnetResourceId": "<subnetResourceId>",
              "zones": [
                "1",
                "2",
                "3"
              ]
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "configurationProfile": {
      "value": "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction"
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdminUser/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults for Linux_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmlinmin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'cvmlinmin'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    disablePasswordAuthentication: true
    location: '<location>'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdminUser/.ssh/authorized_keys'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
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
      "value": "cvmlinmin"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01"
              },
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadWrite",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "disablePasswordAuthentication": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdminUser/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set for Linux_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmlinmax'
  params: {
    // Required parameters
    adminUsername: 'localAdministrator'
    imageReference: {
      offer: '0001-com-ubuntu-server-focal'
      publisher: 'Canonical'
      sku: '<sku>'
      version: 'latest'
    }
    name: 'cvmlinmax'
    nicConfigurations: [
      {
        deleteOption: 'Delete'
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
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: '<id>'
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
            loadBalancerBackendAddressPools: [
              {
                id: '<id>'
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalId: '<principalId>'
                  principalType: 'ServicePrincipal'
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadOnly'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    availabilityZone: 1
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: 'linvm1'
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    disablePasswordAuthentication: true
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
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
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: '<storageAccountId>'
          uri: '<uri>'
        }
      ]
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: '<commandToExecute>'
    }
    extensionDependencyAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: false
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    patchMode: 'AutomaticByPlatform'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdministrator"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-focal",
        "publisher": "Canonical",
        "sku": "<sku>",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmlinmax"
    },
    "nicConfigurations": {
      "value": [
        {
          "deleteOption": "Delete",
          "diagnosticSettings": [
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
          ],
          "ipConfigurations": [
            {
              "applicationSecurityGroups": [
                {
                  "id": "<id>"
                }
              ],
              "diagnosticSettings": [
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
              ],
              "loadBalancerBackendAddressPools": [
                {
                  "id": "<id>"
                }
              ],
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalId": "<principalId>",
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>",
              "zones": [
                "1",
                "2",
                "3"
              ]
            }
          ],
          "nicSuffix": "-nic-01",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadOnly",
        "createOption": "fromImage",
        "deleteOption": "Delete",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": 1
    },
    "backupPolicyName": {
      "value": "<backupPolicyName>"
    },
    "backupVaultName": {
      "value": "<backupVaultName>"
    },
    "backupVaultResourceGroup": {
      "value": "<backupVaultResourceGroup>"
    },
    "computerName": {
      "value": "linvm1"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "ReadWrite",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "ReadWrite",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "enableAutomaticUpdates": {
      "value": true
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
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
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "enabled": true,
        "fileData": [
          {
            "storageAccountId": "<storageAccountId>",
            "uri": "<uri>"
          }
        ],
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptProtectedSetting": {
      "value": {
        "commandToExecute": "<commandToExecute>"
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": false,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true,
        "monitoringWorkspaceResourceId": "<monitoringWorkspaceResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdministrator/.ssh/authorized_keys"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework for Windows.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmwinwaf'
  params: {
    // Required parameters
    adminUsername: 'VMAdmin'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    name: 'cvmwinwaf'
    nicConfigurations: [
      {
        deleteOption: 'Delete'
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
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: '<id>'
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
            loadBalancerBackendAddressPools: [
              {
                id: '<id>'
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalId: '<principalId>'
                  principalType: 'ServicePrincipal'
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    availabilityZone: 2
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: 'winvm1'
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: 'true'
        Exclusions: {
          Extensions: '.ext1;.ext2'
          Paths: 'c:\\excluded-path-1;c:\\excluded-path-2'
          Processes: 'excludedproc1.exe;excludedproc2.exe'
        }
        RealtimeProtectionEnabled: 'true'
        ScheduledScanSettings: {
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
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
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: '<storageAccountId>'
          uri: '<uri>'
        }
      ]
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: '<commandToExecute>'
    }
    extensionDependencyAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    patchMode: 'AutomaticByPlatform'
    proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2019-datacenter",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmwinwaf"
    },
    "nicConfigurations": {
      "value": [
        {
          "deleteOption": "Delete",
          "diagnosticSettings": [
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
          ],
          "ipConfigurations": [
            {
              "applicationSecurityGroups": [
                {
                  "id": "<id>"
                }
              ],
              "diagnosticSettings": [
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
              ],
              "loadBalancerBackendAddressPools": [
                {
                  "id": "<id>"
                }
              ],
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalId": "<principalId>",
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>",
              "zones": [
                "1",
                "2",
                "3"
              ]
            }
          ],
          "nicSuffix": "-nic-01",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadWrite",
        "createOption": "fromImage",
        "deleteOption": "Delete",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "availabilityZone": {
      "value": 2
    },
    "backupPolicyName": {
      "value": "<backupPolicyName>"
    },
    "backupVaultName": {
      "value": "<backupVaultName>"
    },
    "backupVaultResourceGroup": {
      "value": "<backupVaultResourceGroup>"
    },
    "computerName": {
      "value": "winvm1"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "enableAutomaticUpdates": {
      "value": true
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionAntiMalwareConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "AntimalwareEnabled": "true",
          "Exclusions": {
            "Extensions": ".ext1;.ext2",
            "Paths": "c:\\excluded-path-1;c:\\excluded-path-2",
            "Processes": "excludedproc1.exe;excludedproc2.exe"
          },
          "RealtimeProtectionEnabled": "true",
          "ScheduledScanSettings": {
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
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
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          },
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "enabled": true,
        "fileData": [
          {
            "storageAccountId": "<storageAccountId>",
            "uri": "<uri>"
          }
        ],
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptProtectedSetting": {
      "value": {
        "commandToExecute": "<commandToExecute>"
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
    },
    "proximityPlacementGroupResourceId": {
      "value": "<proximityPlacementGroupResourceId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 5: _Using only defaults for Windows_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmwinmin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwinmin'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
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
      "value": "cvmwinmin"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadWrite",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 6: _Using large parameter set for Windows_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmwinmax'
  params: {
    // Required parameters
    adminUsername: 'VMAdmin'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    name: 'cvmwinmax'
    nicConfigurations: [
      {
        deleteOption: 'Delete'
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
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: '<id>'
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
            loadBalancerBackendAddressPools: [
              {
                id: '<id>'
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalId: '<principalId>'
                  principalType: 'ServicePrincipal'
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    availabilityZone: 2
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: 'winvm1'
    dataDisks: [
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: 'true'
        Exclusions: {
          Extensions: '.ext1;.ext2'
          Paths: 'c:\\excluded-path-1;c:\\excluded-path-2'
          Processes: 'excludedproc1.exe;excludedproc2.exe'
        }
        RealtimeProtectionEnabled: 'true'
        ScheduledScanSettings: {
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
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
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: '<storageAccountId>'
          uri: '<uri>'
        }
      ]
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: '<commandToExecute>'
    }
    extensionDependencyAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    patchMode: 'AutomaticByPlatform'
    proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2019-datacenter",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmwinmax"
    },
    "nicConfigurations": {
      "value": [
        {
          "deleteOption": "Delete",
          "diagnosticSettings": [
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
          ],
          "ipConfigurations": [
            {
              "applicationSecurityGroups": [
                {
                  "id": "<id>"
                }
              ],
              "diagnosticSettings": [
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
              ],
              "loadBalancerBackendAddressPools": [
                {
                  "id": "<id>"
                }
              ],
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalId": "<principalId>",
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>",
              "zones": [
                "1",
                "2",
                "3"
              ]
            }
          ],
          "nicSuffix": "-nic-01",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadWrite",
        "createOption": "fromImage",
        "deleteOption": "Delete",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "availabilityZone": {
      "value": 2
    },
    "backupPolicyName": {
      "value": "<backupPolicyName>"
    },
    "backupVaultName": {
      "value": "<backupVaultName>"
    },
    "backupVaultResourceGroup": {
      "value": "<backupVaultResourceGroup>"
    },
    "computerName": {
      "value": "winvm1"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "enableAutomaticUpdates": {
      "value": true
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionAntiMalwareConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "AntimalwareEnabled": "true",
          "Exclusions": {
            "Extensions": ".ext1;.ext2",
            "Paths": "c:\\excluded-path-1;c:\\excluded-path-2",
            "Processes": "excludedproc1.exe;excludedproc2.exe"
          },
          "RealtimeProtectionEnabled": "true",
          "ScheduledScanSettings": {
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
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
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          },
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "enabled": true,
        "fileData": [
          {
            "storageAccountId": "<storageAccountId>",
            "uri": "<uri>"
          }
        ],
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptProtectedSetting": {
      "value": {
        "commandToExecute": "<commandToExecute>"
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true,
        "monitoringWorkspaceResourceId": "<monitoringWorkspaceResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
    },
    "proximityPlacementGroupResourceId": {
      "value": "<proximityPlacementGroupResourceId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 7: _Using disk encryption set for the VM._

This instance deploys the module with disk enryption set.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-cvmwincmk'
  params: {
    // Required parameters
    adminUsername: 'VMAdministrator'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    name: 'cvmwincmk'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        diskEncryptionSet: {
          id: '<id>'
        }
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    dataDisks: [
      {
        diskSizeGB: '128'
        managedDisk: {
          diskEncryptionSet: {
            id: '<id>'
          }
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdministrator"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2019-datacenter",
        "version": "latest"
      }
    },
    "name": {
      "value": "cvmwincmk"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "diskEncryptionSet": {
            "id": "<id>"
          },
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "dataDisks": {
      "value": [
        {
          "diskSizeGB": "128",
          "managedDisk": {
            "diskEncryptionSet": {
              "id": "<id>"
            },
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminUsername`](#parameter-adminusername) | securestring | Administrator username. |
| [`configurationProfile`](#parameter-configurationprofile) | string | The configuration profile of automanage. |
| [`imageReference`](#parameter-imagereference) | object | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| [`name`](#parameter-name) | string | The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. |
| [`nicConfigurations`](#parameter-nicconfigurations) | array | Configures NICs and PIPs. |
| [`osDisk`](#parameter-osdisk) | object | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`osType`](#parameter-ostype) | string | The chosen OS type. |
| [`vmSize`](#parameter-vmsize) | string | Specifies the size for the VMs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalUnattendContent`](#parameter-additionalunattendcontent) | array | Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied. |
| [`adminPassword`](#parameter-adminpassword) | securestring | When specifying a Windows Virtual Machine, this value should be passed. |
| [`allowExtensionOperations`](#parameter-allowextensionoperations) | bool | Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| [`availabilitySetResourceId`](#parameter-availabilitysetresourceid) | string | Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set. |
| [`availabilityZone`](#parameter-availabilityzone) | int | If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set. |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault. |
| [`backupVaultName`](#parameter-backupvaultname) | string | Recovery service vault name to add VMs to backup. |
| [`backupVaultResourceGroup`](#parameter-backupvaultresourcegroup) | string | Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| [`bootDiagnostics`](#parameter-bootdiagnostics) | bool | Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled. |
| [`bootDiagnosticStorageAccountName`](#parameter-bootdiagnosticstorageaccountname) | string | Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided. |
| [`bootDiagnosticStorageAccountUri`](#parameter-bootdiagnosticstorageaccounturi) | string | Storage account boot diagnostic base URI. |
| [`certificatesToBeInstalled`](#parameter-certificatestobeinstalled) | array | Specifies set of certificates that should be installed onto the virtual machine. |
| [`computerName`](#parameter-computername) | string | Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name. |
| [`customData`](#parameter-customdata) | string | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| [`dataDisks`](#parameter-datadisks) | array | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`dedicatedHostId`](#parameter-dedicatedhostid) | string | Specifies resource ID about the dedicated host that the virtual machine resides in. |
| [`disablePasswordAuthentication`](#parameter-disablepasswordauthentication) | bool | Specifies whether password authentication should be disabled. |
| [`enableAutomaticUpdates`](#parameter-enableautomaticupdates) | bool | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| [`enableEvictionPolicy`](#parameter-enableevictionpolicy) | bool | Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionAtHost`](#parameter-encryptionathost) | bool | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`extensionAadJoinConfig`](#parameter-extensionaadjoinconfig) | object | The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionAntiMalwareConfig`](#parameter-extensionantimalwareconfig) | object | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionAzureDiskEncryptionConfig`](#parameter-extensionazurediskencryptionconfig) | object | The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys. |
| [`extensionCustomScriptConfig`](#parameter-extensioncustomscriptconfig) | object | The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionCustomScriptProtectedSetting`](#parameter-extensioncustomscriptprotectedsetting) | secureObject | Any object that contains the extension specific protected settings. |
| [`extensionDependencyAgentConfig`](#parameter-extensiondependencyagentconfig) | object | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinConfig`](#parameter-extensiondomainjoinconfig) | object | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinPassword`](#parameter-extensiondomainjoinpassword) | securestring | Required if name is specified. Password of the user specified in user parameter. |
| [`extensionDSCConfig`](#parameter-extensiondscconfig) | object | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionMonitoringAgentConfig`](#parameter-extensionmonitoringagentconfig) | object | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionNetworkWatcherAgentConfig`](#parameter-extensionnetworkwatcheragentconfig) | object | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`licenseType`](#parameter-licensetype) | string | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True". |
| [`maxPriceForLowPriorityVm`](#parameter-maxpriceforlowpriorityvm) | string | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| [`patchAssessmentMode`](#parameter-patchassessmentmode) | string | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| [`patchMode`](#parameter-patchmode) | string | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'. |
| [`plan`](#parameter-plan) | object | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| [`priority`](#parameter-priority) | string | Specifies the priority for the virtual machine. |
| [`provisionVMAgent`](#parameter-provisionvmagent) | bool | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | Resource ID of a proximity placement group. |
| [`publicKeys`](#parameter-publickeys) | array | The list of SSH public keys used to authenticate with linux based VMs. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sasTokenValidityLength`](#parameter-sastokenvaliditylength) | string | SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| [`secureBootEnabled`](#parameter-securebootenabled) | bool | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`securityType`](#parameter-securitytype) | string | Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeZone`](#parameter-timezone) | string | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| [`ultraSSDEnabled`](#parameter-ultrassdenabled) | bool | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| [`vTpmEnabled`](#parameter-vtpmenabled) | bool | Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`winRM`](#parameter-winrm) | array | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a registration token. |

### Parameter: `adminUsername`

Administrator username.

- Required: Yes
- Type: securestring

### Parameter: `configurationProfile`

The configuration profile of automanage.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  ]
  ```

### Parameter: `imageReference`

OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations`

Configures NICs and PIPs.

- Required: Yes
- Type: array

### Parameter: `osDisk`

Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

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

### Parameter: `vmSize`

Specifies the size for the VMs.

- Required: Yes
- Type: string

### Parameter: `additionalUnattendContent`

Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `adminPassword`

When specifying a Windows Virtual Machine, this value should be passed.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `allowExtensionOperations`

Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `availabilitySetResourceId`

Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set.

- Required: No
- Type: string
- Default: `''`

### Parameter: `availabilityZone`

If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set.

- Required: No
- Type: int
- Default: `0`
- Allowed:
  ```Bicep
  [
    0
    1
    2
    3
  ]
  ```

### Parameter: `backupPolicyName`

Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault.

- Required: No
- Type: string
- Default: `'DefaultPolicy'`

### Parameter: `backupVaultName`

Recovery service vault name to add VMs to backup.

- Required: No
- Type: string
- Default: `''`

### Parameter: `backupVaultResourceGroup`

Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default.

- Required: No
- Type: string
- Default: `[resourceGroup().name]`

### Parameter: `bootDiagnostics`

Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `bootDiagnosticStorageAccountName`

Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided.

- Required: No
- Type: string
- Default: `''`

### Parameter: `bootDiagnosticStorageAccountUri`

Storage account boot diagnostic base URI.

- Required: No
- Type: string
- Default: `[format('.blob.{0}/', environment().suffixes.storage)]`

### Parameter: `certificatesToBeInstalled`

Specifies set of certificates that should be installed onto the virtual machine.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `computerName`

Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `customData`

Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataDisks`

Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `dedicatedHostId`

Specifies resource ID about the dedicated host that the virtual machine resides in.

- Required: No
- Type: string
- Default: `''`

### Parameter: `disablePasswordAuthentication`

Specifies whether password authentication should be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAutomaticUpdates`

Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.

- Required: No
- Type: bool
- Default: `True`

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

This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extensionAadJoinConfig`

The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

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

The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
      fileData: []
  }
  ```

### Parameter: `extensionCustomScriptProtectedSetting`

Any object that contains the extension specific protected settings.

- Required: No
- Type: secureObject
- Default: `{}`

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
- Type: object
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

### Parameter: `extensionMonitoringAgentConfig`

The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
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

### Parameter: `licenseType`

Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
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

### Parameter: `managedIdentities`

The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True".

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `maxPriceForLowPriorityVm`

Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.

- Required: No
- Type: string
- Default: `''`

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
- Default: `''`
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

### Parameter: `plan`

Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `priority`

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

### Parameter: `provisionVMAgent`

Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `proximityPlacementGroupResourceId`

Resource ID of a proximity placement group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `publicKeys`

The list of SSH public keys used to authenticate with linux based VMs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

### Parameter: `sasTokenValidityLength`

SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.

- Required: No
- Type: string
- Default: `'PT8H'`

### Parameter: `secureBootEnabled`

Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `securityType`

Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `timeZone`

Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ultraSSDEnabled`

The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vTpmEnabled`

Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `winRM`

Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `baseTime`

Do not provide a value! This date value is used to generate a registration token.

- Required: No
- Type: string
- Default: `[utcNow('u')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VM. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the VM. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/network-interface:0.2.2` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.2.1` | Remote reference |

## Notes

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

### Parameter Usage: `nicConfigurations`

Comments:
- The field `nicSuffix` and `subnetResourceId` are mandatory.
- If `enablePublicIP` is set to true, then `publicIpNameSuffix` is also mandatory.
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
      "nsgId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>",
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
      nsgId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>'
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
    ],
    "settings": {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File testscript.ps1"
    }
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
    settings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File testscript.ps1'
    }
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
      "commandToExecute": "mycommandToRun -someParam MYSECRET"
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
        commandToExecute: 'mycommandToRun -someParam MYSECRET'
    }
]
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
