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

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.DevTestLab/schedules` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2024-04-05 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2024-04-05/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2023-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2025-02-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/virtual-machine:<version>`.

- [Using automanage for the VM.](#example-1-using-automanage-for-the-vm)
- [Using only defaults for Linux](#example-2-using-only-defaults-for-linux)
- [Using large parameter set for Linux](#example-3-using-large-parameter-set-for-linux)
- [WAF-aligned](#example-4-waf-aligned)
- [Using only defaults for Windows](#example-5-using-only-defaults-for-windows)
- [Deploying Windows VM with premium SSDv2 data disk and shared disk](#example-6-deploying-windows-vm-with-premium-ssdv2-data-disk-and-shared-disk)
- [Using guest configuration for Windows](#example-7-using-guest-configuration-for-windows)
- [Using a host pool to register the VM](#example-8-using-a-host-pool-to-register-the-vm)
- [Using large parameter set for Windows](#example-9-using-large-parameter-set-for-windows)
- [Deploy a VM with nVidia graphic card](#example-10-deploy-a-vm-with-nvidia-graphic-card)
- [Using disk encryption set for the VM.](#example-11-using-disk-encryption-set-for-the-vm)
- [Adding the VM to a VMSS.](#example-12-adding-the-vm-to-a-vmss)
- [Deploying Windows VM in a defined zone with a premium zrs data disk](#example-13-deploying-windows-vm-in-a-defined-zone-with-a-premium-zrs-data-disk)

### Example 1: _Using automanage for the VM._

This instance deploys the module with registering to an automation account.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
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
              zones: [
                1
                2
                3
              ]
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_D2s_v3'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
                "publicIpNameSuffix": "-pip-01",
                "zones": [
                  1,
                  2,
                  3
                ]
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmlinatmg'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        pipConfiguration: {
          publicIpNameSuffix: '-pip-01'
          zones: [
            1
            2
            3
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    nicSuffix: '-nic-01'
  }
]
param osDisk = {
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param configurationProfile = '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
param disablePasswordAuthentication = true
param location = '<location>'
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/localAdminUser/.ssh/authorized_keys'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults for Linux_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
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
            subnetResourceId: '<subnetResourceId>'
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
    vmSize: 'Standard_D2s_v3'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}
param name = 'cvmlinmin'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Linux'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param disablePasswordAuthentication = true
param location = '<location>'
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/localAdminUser/.ssh/authorized_keys'
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
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdministrator'
    availabilityZone: 1
    imageReference: {
      offer: '0001-com-ubuntu-server-focal'
      publisher: 'Canonical'
      sku: '<sku>'
      version: 'latest'
    }
    name: 'cvmlimax'
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
              availabilityZones: [
                1
                2
                3
              ]
              diagnosticSettings: [
                {
                  workspaceResourceId: '<workspaceResourceId>'
                }
              ]
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  name: '696e6067-3ddc-4b71-bf97-9caebeba441a'
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
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        name: 'nic-test-01'
        roleAssignments: [
          {
            name: 'ff72f58d-a3cf-42fd-9c27-c61906bdddfe'
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
      }
    ]
    osDisk: {
      caching: 'ReadOnly'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
      name: 'osdisk01'
    }
    osType: 'Linux'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: 'linvm1'
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        name: 'datadisk01'
      }
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        name: 'datadisk02'
      }
    ]
    disablePasswordAuthentication: true
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      name: 'myAADLogin'
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
      name: 'myCustomScript'
      protectedSettings: {
        fileUris: [
          '<storageAccountCSEFileUrl>'
        ]
        managedIdentityResourceId: '<managedIdentityResourceId>'
      }
      settings: {
        commandToExecute: '<commandToExecute>'
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDependencyAgentConfig: {
      enableAMA: true
      enabled: true
      name: 'myDependencyAgent'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: false
      name: 'myDesiredStateConfiguration'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      dataCollectionRuleAssociations: [
        {
          dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
          name: 'SendMetricsToLAW'
        }
      ]
      enabled: true
      name: 'myMonitoringAgent'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      name: 'myNetworkWatcherAgent'
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
    rebootSetting: 'IfRequired'
    roleAssignments: [
      {
        name: 'eb01de52-d2be-4272-a7b9-13de6c399e27'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdministrator"
    },
    "availabilityZone": {
      "value": 1
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
      "value": "cvmlimax"
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
                "availabilityZones": [
                  1,
                  2,
                  3
                ],
                "diagnosticSettings": [
                  {
                    "workspaceResourceId": "<workspaceResourceId>"
                  }
                ],
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "name": "696e6067-3ddc-4b71-bf97-9caebeba441a",
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
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "name": "nic-test-01",
          "roleAssignments": [
            {
              "name": "ff72f58d-a3cf-42fd-9c27-c61906bdddfe",
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
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadOnly",
        "createOption": "FromImage",
        "deleteOption": "Delete",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        },
        "name": "osdisk01"
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
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
          "diskSizeGB": 128,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          },
          "name": "datadisk01"
        },
        {
          "caching": "ReadWrite",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": 128,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          },
          "name": "datadisk02"
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
        "name": "myAADLogin",
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
        "name": "myCustomScript",
        "protectedSettings": {
          "fileUris": [
            "<storageAccountCSEFileUrl>"
          ],
          "managedIdentityResourceId": "<managedIdentityResourceId>"
        },
        "settings": {
          "commandToExecute": "<commandToExecute>"
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enableAMA": true,
        "enabled": true,
        "name": "myDependencyAgent",
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
        "name": "myDesiredStateConfiguration",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "dataCollectionRuleAssociations": [
          {
            "dataCollectionRuleResourceId": "<dataCollectionRuleResourceId>",
            "name": "SendMetricsToLAW"
          }
        ],
        "enabled": true,
        "name": "myMonitoringAgent",
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
        "name": "myNetworkWatcherAgent",
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
    "rebootSetting": {
      "value": "IfRequired"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "eb01de52-d2be-4272-a7b9-13de6c399e27",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdministrator'
param availabilityZone = 1
param imageReference = {
  offer: '0001-com-ubuntu-server-focal'
  publisher: 'Canonical'
  sku: '<sku>'
  version: 'latest'
}
param name = 'cvmlimax'
param nicConfigurations = [
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
          availabilityZones: [
            1
            2
            3
          ]
          diagnosticSettings: [
            {
              workspaceResourceId: '<workspaceResourceId>'
            }
          ]
          publicIpNameSuffix: '-pip-01'
          roleAssignments: [
            {
              name: '696e6067-3ddc-4b71-bf97-9caebeba441a'
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
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nic-test-01'
    roleAssignments: [
      {
        name: 'ff72f58d-a3cf-42fd-9c27-c61906bdddfe'
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
  }
]
param osDisk = {
  caching: 'ReadOnly'
  createOption: 'FromImage'
  deleteOption: 'Delete'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
  name: 'osdisk01'
}
param osType = 'Linux'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param backupPolicyName = '<backupPolicyName>'
param backupVaultName = '<backupVaultName>'
param backupVaultResourceGroup = '<backupVaultResourceGroup>'
param computerName = 'linvm1'
param dataDisks = [
  {
    caching: 'ReadWrite'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
    name: 'datadisk01'
  }
  {
    caching: 'ReadWrite'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
    name: 'datadisk02'
  }
]
param disablePasswordAuthentication = true
param enableAutomaticUpdates = true
param encryptionAtHost = false
param extensionAadJoinConfig = {
  enabled: true
  name: 'myAADLogin'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
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
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionCustomScriptConfig = {
  name: 'myCustomScript'
  protectedSettings: {
    fileUris: [
      '<storageAccountCSEFileUrl>'
    ]
    managedIdentityResourceId: '<managedIdentityResourceId>'
  }
  settings: {
    commandToExecute: '<commandToExecute>'
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDependencyAgentConfig = {
  enableAMA: true
  enabled: true
  name: 'myDependencyAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDSCConfig = {
  enabled: false
  name: 'myDesiredStateConfiguration'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionMonitoringAgentConfig = {
  dataCollectionRuleAssociations: [
    {
      dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
      name: 'SendMetricsToLAW'
    }
  ]
  enabled: true
  name: 'myMonitoringAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
  name: 'myNetworkWatcherAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param patchMode = 'AutomaticByPlatform'
param publicKeys = [
  {
    keyData: '<keyData>'
    path: '/home/localAdministrator/.ssh/authorized_keys'
  }
]
param rebootSetting = 'IfRequired'
param roleAssignments = [
  {
    name: 'eb01de52-d2be-4272-a7b9-13de6c399e27'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
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
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'VMAdmin'
    availabilityZone: 2
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
              availabilityZones: [
                1
                2
                3
              ]
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
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    bypassPlatformSafetyChecksOnUserSchedule: true
    computerName: '<computerName>'
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      settings: {
        mdmId: ''
      }
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
      name: 'myCustomScript'
      protectedSettings: {
        fileUris: [
          '<storageAccountCSEFileUrl>'
        ]
        managedIdentityResourceId: '<managedIdentityResourceId>'
      }
      settings: {
        commandToExecute: '<commandToExecute>'
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDependencyAgentConfig: {
      enableAMA: true
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
      dataCollectionRuleAssociations: [
        {
          dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
          name: 'SendMetricsToLAW'
        }
      ]
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
    maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdmin"
    },
    "availabilityZone": {
      "value": 2
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
                "availabilityZones": [
                  1,
                  2,
                  3
                ],
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalId": "<principalId>",
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>"
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
        "createOption": "FromImage",
        "deleteOption": "Delete",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
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
    "bypassPlatformSafetyChecksOnUserSchedule": {
      "value": true
    },
    "computerName": {
      "value": "<computerName>"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": 128,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": 128,
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
        "settings": {
          "mdmId": ""
        },
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
        "name": "myCustomScript",
        "protectedSettings": {
          "fileUris": [
            "<storageAccountCSEFileUrl>"
          ],
          "managedIdentityResourceId": "<managedIdentityResourceId>"
        },
        "settings": {
          "commandToExecute": "<commandToExecute>"
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enableAMA": true,
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
        "dataCollectionRuleAssociations": [
          {
            "dataCollectionRuleResourceId": "<dataCollectionRuleResourceId>",
            "name": "SendMetricsToLAW"
          }
        ],
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
    "maintenanceConfigurationResourceId": {
      "value": "<maintenanceConfigurationResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'VMAdmin'
param availabilityZone = 2
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2019-datacenter'
  version: 'latest'
}
param name = 'cvmwinwaf'
param nicConfigurations = [
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
          availabilityZones: [
            1
            2
            3
          ]
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
param osDisk = {
  caching: 'ReadWrite'
  createOption: 'FromImage'
  deleteOption: 'Delete'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param backupPolicyName = '<backupPolicyName>'
param backupVaultName = '<backupVaultName>'
param backupVaultResourceGroup = '<backupVaultResourceGroup>'
param bypassPlatformSafetyChecksOnUserSchedule = true
param computerName = '<computerName>'
param dataDisks = [
  {
    caching: 'ReadOnly'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
  }
  {
    caching: 'ReadOnly'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
  }
]
param enableAutomaticUpdates = true
param encryptionAtHost = false
param extensionAadJoinConfig = {
  enabled: true
  settings: {
    mdmId: ''
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionAntiMalwareConfig = {
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    VolumeType: 'All'
  }
}
param extensionCustomScriptConfig = {
  name: 'myCustomScript'
  protectedSettings: {
    fileUris: [
      '<storageAccountCSEFileUrl>'
    ]
    managedIdentityResourceId: '<managedIdentityResourceId>'
  }
  settings: {
    commandToExecute: '<commandToExecute>'
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDependencyAgentConfig = {
  enableAMA: true
  enabled: true
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDSCConfig = {
  enabled: true
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionMonitoringAgentConfig = {
  dataCollectionRuleAssociations: [
    {
      dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
      name: 'SendMetricsToLAW'
    }
  ]
  enabled: true
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param location = '<location>'
param maintenanceConfigurationResourceId = '<maintenanceConfigurationResourceId>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param patchMode = 'AutomaticByPlatform'
param proximityPlacementGroupResourceId = '<proximityPlacementGroupResourceId>'
param roleAssignments = [
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
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
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwinmin'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param location = '<location>'
```

</details>
<p>

### Example 6: _Deploying Windows VM with premium SSDv2 data disk and shared disk_

This instance deploys the module with premium SSDv2 data disk and attachment of an existing shared disk.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: 1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwindisk'
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    dataDisks: [
      {
        caching: 'None'
        diskIOPSReadWrite: 3000
        diskMBpsReadWrite: 125
        diskSizeGB: 1024
        managedDisk: {
          storageAccountType: 'PremiumV2_LRS'
        }
      }
      {
        managedDisk: {
          id: '<id>'
        }
      }
    ]
    location: '<location>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": 1
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
      "value": "cvmwindisk"
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "None",
          "diskIOPSReadWrite": 3000,
          "diskMBpsReadWrite": 125,
          "diskSizeGB": 1024,
          "managedDisk": {
            "storageAccountType": "PremiumV2_LRS"
          }
        },
        {
          "managedDisk": {
            "id": "<id>"
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = 1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwindisk'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param dataDisks = [
  {
    caching: 'None'
    diskIOPSReadWrite: 3000
    diskMBpsReadWrite: 125
    diskSizeGB: 1024
    managedDisk: {
      storageAccountType: 'PremiumV2_LRS'
    }
  }
  {
    managedDisk: {
      id: '<id>'
    }
  }
]
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 7: _Using guest configuration for Windows_

This instance deploys the module with the a guest configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwingst'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              zones: []
            }
            subnetResourceId: '<subnetResourceId>'
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
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    extensionGuestConfigurationExtension: {
      enabled: true
    }
    guestConfiguration: {
      assignmentType: 'ApplyAndMonitor'
      configurationParameter: [
        {
          name: 'Minimum Password Length;ExpectedValue'
          value: '16'
        }
        {
          name: 'Minimum Password Length;RemediateValue'
          value: '16'
        }
        {
          name: 'Maximum Password Age;ExpectedValue'
          value: '75'
        }
        {
          name: 'Maximum Password Age;RemediateValue'
          value: '75'
        }
      ]
      name: 'myAzureWindowsBaseline'
      version: '1.*'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
      "value": "cvmwingst"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "zones": []
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "extensionGuestConfigurationExtension": {
      "value": {
        "enabled": true
      }
    },
    "guestConfiguration": {
      "value": {
        "assignmentType": "ApplyAndMonitor",
        "configurationParameter": [
          {
            "name": "Minimum Password Length;ExpectedValue",
            "value": "16"
          },
          {
            "name": "Minimum Password Length;RemediateValue",
            "value": "16"
          },
          {
            "name": "Maximum Password Age;ExpectedValue",
            "value": "75"
          },
          {
            "name": "Maximum Password Age;RemediateValue",
            "value": "75"
          }
        ],
        "name": "myAzureWindowsBaseline",
        "version": "1.*"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwingst'
param nicConfigurations = [
  {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        pipConfiguration: {
          publicIpNameSuffix: '-pip-01'
          zones: []
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    nicSuffix: '-nic-01'
  }
]
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param extensionGuestConfigurationExtension = {
  enabled: true
}
param guestConfiguration = {
  assignmentType: 'ApplyAndMonitor'
  configurationParameter: [
    {
      name: 'Minimum Password Length;ExpectedValue'
      value: '16'
    }
    {
      name: 'Minimum Password Length;RemediateValue'
      value: '16'
    }
    {
      name: 'Maximum Password Age;ExpectedValue'
      value: '75'
    }
    {
      name: 'Maximum Password Age;RemediateValue'
      value: '75'
    }
  ]
  name: 'myAzureWindowsBaseline'
  version: '1.*'
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 8: _Using a host pool to register the VM_

This instance deploys the module and registers it in a host pool.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: '<name>'
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    extensionAadJoinConfig: {
      enabled: true
      settings: {
        mdmId: ''
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionHostPoolRegistration: {
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      enabled: true
      hostPoolName: '<hostPoolName>'
      modulesUrl: '<modulesUrl>'
      registrationInfoToken: '<registrationInfoToken>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
      "value": "<name>"
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "mdmId": ""
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionHostPoolRegistration": {
      "value": {
        "configurationFunction": "Configuration.ps1\\AddSessionHost",
        "enabled": true,
        "hostPoolName": "<hostPoolName>",
        "modulesUrl": "<modulesUrl>",
        "registrationInfoToken": "<registrationInfoToken>",
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = '<name>'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param extensionAadJoinConfig = {
  enabled: true
  settings: {
    mdmId: ''
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionHostPoolRegistration = {
  configurationFunction: 'Configuration.ps1\\AddSessionHost'
  enabled: true
  hostPoolName: '<hostPoolName>'
  modulesUrl: '<modulesUrl>'
  registrationInfoToken: '<registrationInfoToken>'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 9: _Using large parameter set for Windows_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'VMAdmin'
    availabilityZone: 2
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
        enableIPForwarding: true
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
              diagnosticSettings: [
                {
                  workspaceResourceId: '<workspaceResourceId>'
                }
              ]
              publicIPAddressResourceId: '<publicIPAddressResourceId>'
              roleAssignments: [
                {
                  name: 'e962e7c1-261a-4afd-b5ad-17a640a0b7bc'
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
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        name: 'nic-test-01'
        roleAssignments: [
          {
            name: '95fc1cc2-05ed-4f5a-a22c-a6ca852df7e7'
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
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
      name: 'osdisk01'
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    additionalUnattendContent: [
      {
        content: '<FirstLogonCommands><SynchronousCommand><CommandLine>cmd /c echo First logon command example > %temp%\\FirstLogonCommandOutput.txt</CommandLine><Description>Example FirstLogonCommand</Description><Order>1</Order></SynchronousCommand></FirstLogonCommands>'
        settingName: 'FirstLogonCommands'
      }
    ]
    adminPassword: '<adminPassword>'
    autoShutdownConfig: {
      dailyRecurrenceTime: '19:00'
      notificationSettings: {
        emailRecipient: 'test@contoso.com'
        notificationLocale: 'en'
        status: 'Enabled'
        timeInMinutes: 30
      }
      status: 'Enabled'
      timeZone: 'UTC'
    }
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: '<computerName>'
    dataDisks: [
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        lun: 0
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        name: 'datadisk01'
      }
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: 128
        lun: 1
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        name: 'datadisk02'
      }
      {
        lun: 2
        managedDisk: {
          id: '<id>'
        }
      }
    ]
    enableAutomaticUpdates: true
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      name: 'myAADLogin'
      settings: {
        mdmId: ''
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionAntiMalwareConfig: {
      enabled: true
      name: 'myMicrosoftAntiMalware'
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
      name: 'myAzureDiskEncryption'
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
      name: 'myCustomScript'
      protectedSettings: {
        fileUris: [
          '<value>'
        ]
      }
      settings: {
        commandToExecute: '<commandToExecute>'
      }
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDependencyAgentConfig: {
      enableAMA: true
      enabled: true
      name: 'myDependencyAgent'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: true
      name: 'myDesiredStateConfiguration'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      dataCollectionRuleAssociations: [
        {
          dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
          name: 'SendMetricsToLAW'
        }
      ]
      enabled: true
      name: 'myMonitoringAgent'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      name: 'myNetworkWatcherAgent'
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
    rebootSetting: 'IfRequired'
    roleAssignments: [
      {
        name: 'c70e8c48-6945-4607-9695-1098ba5a86ed'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdmin"
    },
    "availabilityZone": {
      "value": 2
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
          "enableIPForwarding": true,
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
                "diagnosticSettings": [
                  {
                    "workspaceResourceId": "<workspaceResourceId>"
                  }
                ],
                "publicIPAddressResourceId": "<publicIPAddressResourceId>",
                "roleAssignments": [
                  {
                    "name": "e962e7c1-261a-4afd-b5ad-17a640a0b7bc",
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
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "name": "nic-test-01",
          "roleAssignments": [
            {
              "name": "95fc1cc2-05ed-4f5a-a22c-a6ca852df7e7",
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
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadWrite",
        "createOption": "FromImage",
        "deleteOption": "Delete",
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        },
        "name": "osdisk01"
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "additionalUnattendContent": {
      "value": [
        {
          "content": "<FirstLogonCommands><SynchronousCommand><CommandLine>cmd /c echo First logon command example > %temp%\\FirstLogonCommandOutput.txt</CommandLine><Description>Example FirstLogonCommand</Description><Order>1</Order></SynchronousCommand></FirstLogonCommands>",
          "settingName": "FirstLogonCommands"
        }
      ]
    },
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "autoShutdownConfig": {
      "value": {
        "dailyRecurrenceTime": "19:00",
        "notificationSettings": {
          "emailRecipient": "test@contoso.com",
          "notificationLocale": "en",
          "status": "Enabled",
          "timeInMinutes": 30
        },
        "status": "Enabled",
        "timeZone": "UTC"
      }
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
      "value": "<computerName>"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": 128,
          "lun": 0,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          },
          "name": "datadisk01"
        },
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": 128,
          "lun": 1,
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          },
          "name": "datadisk02"
        },
        {
          "lun": 2,
          "managedDisk": {
            "id": "<id>"
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
        "name": "myAADLogin",
        "settings": {
          "mdmId": ""
        },
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
        "name": "myMicrosoftAntiMalware",
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
        "name": "myAzureDiskEncryption",
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
        "name": "myCustomScript",
        "protectedSettings": {
          "fileUris": [
            "<value>"
          ]
        },
        "settings": {
          "commandToExecute": "<commandToExecute>"
        },
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enableAMA": true,
        "enabled": true,
        "name": "myDependencyAgent",
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
        "name": "myDesiredStateConfiguration",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "dataCollectionRuleAssociations": [
          {
            "dataCollectionRuleResourceId": "<dataCollectionRuleResourceId>",
            "name": "SendMetricsToLAW"
          }
        ],
        "enabled": true,
        "name": "myMonitoringAgent",
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
        "name": "myNetworkWatcherAgent",
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
    "rebootSetting": {
      "value": "IfRequired"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c70e8c48-6945-4607-9695-1098ba5a86ed",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'VMAdmin'
param availabilityZone = 2
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2019-datacenter'
  version: 'latest'
}
param name = 'cvmwinmax'
param nicConfigurations = [
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
    enableIPForwarding: true
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
          diagnosticSettings: [
            {
              workspaceResourceId: '<workspaceResourceId>'
            }
          ]
          publicIPAddressResourceId: '<publicIPAddressResourceId>'
          roleAssignments: [
            {
              name: 'e962e7c1-261a-4afd-b5ad-17a640a0b7bc'
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
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nic-test-01'
    roleAssignments: [
      {
        name: '95fc1cc2-05ed-4f5a-a22c-a6ca852df7e7'
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
  }
]
param osDisk = {
  caching: 'ReadWrite'
  createOption: 'FromImage'
  deleteOption: 'Delete'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
  name: 'osdisk01'
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param additionalUnattendContent = [
  {
    content: '<FirstLogonCommands><SynchronousCommand><CommandLine>cmd /c echo First logon command example > %temp%\\FirstLogonCommandOutput.txt</CommandLine><Description>Example FirstLogonCommand</Description><Order>1</Order></SynchronousCommand></FirstLogonCommands>'
    settingName: 'FirstLogonCommands'
  }
]
param adminPassword = '<adminPassword>'
param autoShutdownConfig = {
  dailyRecurrenceTime: '19:00'
  notificationSettings: {
    emailRecipient: 'test@contoso.com'
    notificationLocale: 'en'
    status: 'Enabled'
    timeInMinutes: 30
  }
  status: 'Enabled'
  timeZone: 'UTC'
}
param backupPolicyName = '<backupPolicyName>'
param backupVaultName = '<backupVaultName>'
param backupVaultResourceGroup = '<backupVaultResourceGroup>'
param computerName = '<computerName>'
param dataDisks = [
  {
    caching: 'None'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    lun: 0
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
    name: 'datadisk01'
  }
  {
    caching: 'None'
    createOption: 'Empty'
    deleteOption: 'Delete'
    diskSizeGB: 128
    lun: 1
    managedDisk: {
      storageAccountType: 'Premium_LRS'
    }
    name: 'datadisk02'
  }
  {
    lun: 2
    managedDisk: {
      id: '<id>'
    }
  }
]
param enableAutomaticUpdates = true
param encryptionAtHost = false
param extensionAadJoinConfig = {
  enabled: true
  name: 'myAADLogin'
  settings: {
    mdmId: ''
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionAntiMalwareConfig = {
  enabled: true
  name: 'myMicrosoftAntiMalware'
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
param extensionAzureDiskEncryptionConfig = {
  enabled: true
  name: 'myAzureDiskEncryption'
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
param extensionCustomScriptConfig = {
  name: 'myCustomScript'
  protectedSettings: {
    fileUris: [
      '<value>'
    ]
  }
  settings: {
    commandToExecute: '<commandToExecute>'
  }
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDependencyAgentConfig = {
  enableAMA: true
  enabled: true
  name: 'myDependencyAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionDSCConfig = {
  enabled: true
  name: 'myDesiredStateConfiguration'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionMonitoringAgentConfig = {
  dataCollectionRuleAssociations: [
    {
      dataCollectionRuleResourceId: '<dataCollectionRuleResourceId>'
      name: 'SendMetricsToLAW'
    }
  ]
  enabled: true
  name: 'myMonitoringAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param extensionNetworkWatcherAgentConfig = {
  enabled: true
  name: 'myNetworkWatcherAgent'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param patchMode = 'AutomaticByPlatform'
param proximityPlacementGroupResourceId = '<proximityPlacementGroupResourceId>'
param rebootSetting = 'IfRequired'
param roleAssignments = [
  {
    name: 'c70e8c48-6945-4607-9695-1098ba5a86ed'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 10: _Deploy a VM with nVidia graphic card_

This instance deploys the module for a VM with dedicated nVidia graphic card.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwinnv'
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_NV6ads_A10_v5'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    extensionNvidiaGpuDriverWindows: {
      enabled: true
    }
    hibernationEnabled: true
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
      "value": "cvmwinnv"
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_NV6ads_A10_v5"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "extensionNvidiaGpuDriverWindows": {
      "value": {
        "enabled": true
      }
    },
    "hibernationEnabled": {
      "value": true
    },
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
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwinnv'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_NV6ads_A10_v5'
// Non-required parameters
param adminPassword = '<adminPassword>'
param extensionNvidiaGpuDriverWindows = {
  enabled: true
}
param hibernationEnabled = true
param location = '<location>'
```

</details>
<p>

### Example 11: _Using disk encryption set for the VM._

This instance deploys the module with disk enryption set.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'VMAdministrator'
    availabilityZone: -1
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
      diskSizeGB: 128
      managedDisk: {
        diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    dataDisks: [
      {
        diskSizeGB: 128
        managedDisk: {
          diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "VMAdministrator"
    },
    "availabilityZone": {
      "value": -1
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
        "diskSizeGB": 128,
        "managedDisk": {
          "diskEncryptionSetResourceId": "<diskEncryptionSetResourceId>",
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "dataDisks": {
      "value": [
        {
          "diskSizeGB": 128,
          "managedDisk": {
            "diskEncryptionSetResourceId": "<diskEncryptionSetResourceId>",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'VMAdministrator'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2019-datacenter'
  version: 'latest'
}
param name = 'cvmwincmk'
param nicConfigurations = [
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
param osDisk = {
  diskSizeGB: 128
  managedDisk: {
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param dataDisks = [
  {
    diskSizeGB: 128
    managedDisk: {
      diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
      storageAccountType: 'Premium_LRS'
    }
  }
]
param location = '<location>'
```

</details>
<p>

### Example 12: _Adding the VM to a VMSS._

This instance deploys the module with the minimum set of required parameters and adds it to a VMSS.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwinvmss'
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    location: '<location>'
    virtualMachineScaleSetResourceId: '<virtualMachineScaleSetResourceId>'
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": -1
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
      "value": "cvmwinvmss"
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "location": {
      "value": "<location>"
    },
    "virtualMachineScaleSetResourceId": {
      "value": "<virtualMachineScaleSetResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = -1
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwinvmss'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param location = '<location>'
param virtualMachineScaleSetResourceId = '<virtualMachineScaleSetResourceId>'
```

</details>
<p>

### Example 13: _Deploying Windows VM in a defined zone with a premium zrs data disk_

This instance deploys the module with a premium zrs data disk.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachine 'br/public:avm/res/compute/virtual-machine:<version>' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    availabilityZone: 2
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmwinzrs'
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_ZRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    dataDisks: [
      {
        caching: 'None'
        diskSizeGB: 1024
        managedDisk: {
          storageAccountType: 'Premium_ZRS'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "adminUsername": {
      "value": "localAdminUser"
    },
    "availabilityZone": {
      "value": 2
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
      "value": "cvmwinzrs"
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
        "diskSizeGB": 128,
        "managedDisk": {
          "storageAccountType": "Premium_ZRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "None",
          "diskSizeGB": 1024,
          "managedDisk": {
            "storageAccountType": "Premium_ZRS"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/virtual-machine:<version>'

// Required parameters
param adminUsername = 'localAdminUser'
param availabilityZone = 2
param imageReference = {
  offer: 'WindowsServer'
  publisher: 'MicrosoftWindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param name = 'cvmwinzrs'
param nicConfigurations = [
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
param osDisk = {
  caching: 'ReadWrite'
  diskSizeGB: 128
  managedDisk: {
    storageAccountType: 'Premium_ZRS'
  }
}
param osType = 'Windows'
param vmSize = 'Standard_D2s_v3'
// Non-required parameters
param adminPassword = '<adminPassword>'
param dataDisks = [
  {
    caching: 'None'
    diskSizeGB: 1024
    managedDisk: {
      storageAccountType: 'Premium_ZRS'
    }
  }
]
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminUsername`](#parameter-adminusername) | securestring | Administrator username. |
| [`availabilityZone`](#parameter-availabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
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
| [`autoShutdownConfig`](#parameter-autoshutdownconfig) | object | The configuration for auto-shutdown. |
| [`availabilitySetResourceId`](#parameter-availabilitysetresourceid) | string | Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set. |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault. |
| [`backupVaultName`](#parameter-backupvaultname) | string | Recovery service vault name to add VMs to backup. |
| [`backupVaultResourceGroup`](#parameter-backupvaultresourcegroup) | string | Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| [`bootDiagnostics`](#parameter-bootdiagnostics) | bool | Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled. |
| [`bootDiagnosticStorageAccountName`](#parameter-bootdiagnosticstorageaccountname) | string | Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided. |
| [`bootDiagnosticStorageAccountUri`](#parameter-bootdiagnosticstorageaccounturi) | string | Storage account boot diagnostic base URI. |
| [`bypassPlatformSafetyChecksOnUserSchedule`](#parameter-bypassplatformsafetychecksonuserschedule) | bool | Enables customer to schedule patching without accidental upgrades. |
| [`capacityReservationGroupResourceId`](#parameter-capacityreservationgroupresourceid) | string | Capacity reservation group resource id that should be used for allocating the virtual machine vm instances provided enough capacity has been reserved. |
| [`certificatesToBeInstalled`](#parameter-certificatestobeinstalled) | array | Specifies set of certificates that should be installed onto the virtual machine. |
| [`computerName`](#parameter-computername) | string | Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name. |
| [`configurationProfile`](#parameter-configurationprofile) | string | The configuration profile of automanage. Either '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction', 'providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest' or the resource Id of custom profile. |
| [`customData`](#parameter-customdata) | string | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| [`dataDisks`](#parameter-datadisks) | array | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`dedicatedHostResourceId`](#parameter-dedicatedhostresourceid) | string | Specifies resource ID about the dedicated host that the virtual machine resides in. |
| [`disablePasswordAuthentication`](#parameter-disablepasswordauthentication) | bool | Specifies whether password authentication should be disabled. |
| [`enableAutomaticUpdates`](#parameter-enableautomaticupdates) | bool | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| [`enableHotpatching`](#parameter-enablehotpatching) | bool | Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionAtHost`](#parameter-encryptionathost) | bool | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`evictionPolicy`](#parameter-evictionpolicy) | string | Specifies the eviction policy for the low priority virtual machine. |
| [`extensionAadJoinConfig`](#parameter-extensionaadjoinconfig) | object | The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. To enroll in Intune, add the setting mdmId: "0000000a-0000-0000-c000-000000000000". |
| [`extensionAntiMalwareConfig`](#parameter-extensionantimalwareconfig) | object | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionAzureDiskEncryptionConfig`](#parameter-extensionazurediskencryptionconfig) | object | The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys. |
| [`extensionCustomScriptConfig`](#parameter-extensioncustomscriptconfig) | object | The configuration for the [Custom Script] extension. |
| [`extensionDependencyAgentConfig`](#parameter-extensiondependencyagentconfig) | object | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinConfig`](#parameter-extensiondomainjoinconfig) | secureObject | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionDomainJoinPassword`](#parameter-extensiondomainjoinpassword) | securestring | Required if name is specified. Password of the user specified in user parameter. |
| [`extensionDSCConfig`](#parameter-extensiondscconfig) | object | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionGuestConfigurationExtension`](#parameter-extensionguestconfigurationextension) | object | The configuration for the [Guest Configuration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identity. |
| [`extensionGuestConfigurationExtensionProtectedSettings`](#parameter-extensionguestconfigurationextensionprotectedsettings) | secureObject | An object that contains the extension specific protected settings. |
| [`extensionHostPoolRegistration`](#parameter-extensionhostpoolregistration) | secureObject | The configuration for the [Host Pool Registration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identity. |
| [`extensionMonitoringAgentConfig`](#parameter-extensionmonitoringagentconfig) | object | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionNetworkWatcherAgentConfig`](#parameter-extensionnetworkwatcheragentconfig) | object | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionNvidiaGpuDriverWindows`](#parameter-extensionnvidiagpudriverwindows) | object | The configuration for the [Nvidia Gpu Driver Windows] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`galleryApplications`](#parameter-galleryapplications) | array | Specifies the gallery applications that should be made available to the VM/VMSS. |
| [`guestConfiguration`](#parameter-guestconfiguration) | object | The guest configuration for the virtual machine. Needs the Guest Configuration extension to be enabled. |
| [`hibernationEnabled`](#parameter-hibernationenabled) | bool | The flag that enables or disables hibernation capability on the VM. |
| [`licenseType`](#parameter-licensetype) | string | Specifies that the image or disk that is being used was licensed on-premises. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceConfigurationResourceId`](#parameter-maintenanceconfigurationresourceid) | string | The resource Id of a maintenance configuration for this VM. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True". |
| [`maxPriceForLowPriorityVm`](#parameter-maxpriceforlowpriorityvm) | string | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| [`networkAccessPolicy`](#parameter-networkaccesspolicy) | string | Policy for accessing the disk via network. |
| [`patchAssessmentMode`](#parameter-patchassessmentmode) | string | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| [`patchMode`](#parameter-patchmode) | string | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'. |
| [`plan`](#parameter-plan) | object | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| [`priority`](#parameter-priority) | string | Specifies the priority for the virtual machine. |
| [`provisionVMAgent`](#parameter-provisionvmagent) | bool | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | Resource ID of a proximity placement group. |
| [`publicKeys`](#parameter-publickeys) | array | The list of SSH public keys used to authenticate with linux based VMs. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Policy for controlling export on the disk. |
| [`rebootSetting`](#parameter-rebootsetting) | string | Specifies the reboot setting for all AutomaticByPlatform patch installation operations. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secureBootEnabled`](#parameter-securebootenabled) | bool | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`securityType`](#parameter-securitytype) | string | Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeZone`](#parameter-timezone) | string | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| [`ultraSSDEnabled`](#parameter-ultrassdenabled) | bool | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| [`userData`](#parameter-userdata) | string | UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here. |
| [`virtualMachineScaleSetResourceId`](#parameter-virtualmachinescalesetresourceid) | string | Resource ID of a virtual machine scale set, where the VM should be added. |
| [`vTpmEnabled`](#parameter-vtpmenabled) | bool | Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`winRMListeners`](#parameter-winrmlisteners) | array | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. |

### Parameter: `adminUsername`

Administrator username.

- Required: Yes
- Type: securestring

### Parameter: `availabilityZone`

If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    -1
    1
    2
    3
  ]
  ```

### Parameter: `imageReference`

OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`communityGalleryImageId`](#parameter-imagereferencecommunitygalleryimageid) | string | Specified the community gallery image unique id for vm deployment. This can be fetched from community gallery image GET call. |
| [`id`](#parameter-imagereferenceid) | string | The resource Id of the image reference. |
| [`offer`](#parameter-imagereferenceoffer) | string | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |
| [`publisher`](#parameter-imagereferencepublisher) | string | The image publisher. |
| [`sharedGalleryImageId`](#parameter-imagereferencesharedgalleryimageid) | string | Specified the shared gallery image unique id for vm deployment. This can be fetched from shared gallery image GET call. |
| [`sku`](#parameter-imagereferencesku) | string | The SKU of the image. |
| [`version`](#parameter-imagereferenceversion) | string | Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available. |

### Parameter: `imageReference.communityGalleryImageId`

Specified the community gallery image unique id for vm deployment. This can be fetched from community gallery image GET call.

- Required: No
- Type: string

### Parameter: `imageReference.id`

The resource Id of the image reference.

- Required: No
- Type: string

### Parameter: `imageReference.offer`

Specifies the offer of the platform image or marketplace image used to create the virtual machine.

- Required: No
- Type: string

### Parameter: `imageReference.publisher`

The image publisher.

- Required: No
- Type: string

### Parameter: `imageReference.sharedGalleryImageId`

Specified the shared gallery image unique id for vm deployment. This can be fetched from shared gallery image GET call.

- Required: No
- Type: string

### Parameter: `imageReference.sku`

The SKU of the image.

- Required: No
- Type: string

### Parameter: `imageReference.version`

Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available.

- Required: No
- Type: string

### Parameter: `name`

The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations`

Configures NICs and PIPs.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-nicconfigurationsipconfigurations) | array | The IP configurations of the network interface. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deleteOption`](#parameter-nicconfigurationsdeleteoption) | string | Specify what happens to the network interface when the VM is deleted. |
| [`diagnosticSettings`](#parameter-nicconfigurationsdiagnosticsettings) | array | The diagnostic settings of the IP configuration. |
| [`dnsServers`](#parameter-nicconfigurationsdnsservers) | array | List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection. |
| [`enableAcceleratedNetworking`](#parameter-nicconfigurationsenableacceleratednetworking) | bool | If the network interface is accelerated networking enabled. |
| [`enableIPForwarding`](#parameter-nicconfigurationsenableipforwarding) | bool | Indicates whether IP forwarding is enabled on this network interface. |
| [`enableTelemetry`](#parameter-nicconfigurationsenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`lock`](#parameter-nicconfigurationslock) | object | The lock settings of the service. |
| [`name`](#parameter-nicconfigurationsname) | string | The name of the NIC configuration. |
| [`networkSecurityGroupResourceId`](#parameter-nicconfigurationsnetworksecuritygroupresourceid) | string | The network security group (NSG) to attach to the network interface. |
| [`nicSuffix`](#parameter-nicconfigurationsnicsuffix) | string | The suffix to append to the NIC name. |
| [`roleAssignments`](#parameter-nicconfigurationsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-nicconfigurationstags) | object | The tags of the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations`

The IP configurations of the network interface.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-nicconfigurationsipconfigurationssubnetresourceid) | string | The resource ID of the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayBackendAddressPools`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspools) | array | The application gateway backend address pools. |
| [`applicationSecurityGroups`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroups) | array | The application security groups. |
| [`diagnosticSettings`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettings) | array | The diagnostic settings of the IP configuration. |
| [`enableTelemetry`](#parameter-nicconfigurationsipconfigurationsenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`gatewayLoadBalancer`](#parameter-nicconfigurationsipconfigurationsgatewayloadbalancer) | object | The gateway load balancer settings. |
| [`loadBalancerBackendAddressPools`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspools) | array | The load balancer backend address pools. |
| [`loadBalancerInboundNatRules`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrules) | array | The load balancer inbound NAT rules. |
| [`name`](#parameter-nicconfigurationsipconfigurationsname) | string | The name of the IP configuration. |
| [`pipConfiguration`](#parameter-nicconfigurationsipconfigurationspipconfiguration) | object | The public IP address configuration. |
| [`privateIPAddress`](#parameter-nicconfigurationsipconfigurationsprivateipaddress) | string | The private IP address. |
| [`privateIPAddressVersion`](#parameter-nicconfigurationsipconfigurationsprivateipaddressversion) | string | The private IP address version. |
| [`privateIPAllocationMethod`](#parameter-nicconfigurationsipconfigurationsprivateipallocationmethod) | string | The private IP address allocation method. |
| [`tags`](#parameter-nicconfigurationsipconfigurationstags) | object | The tags of the public IP address. |
| [`virtualNetworkTaps`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktaps) | array | The virtual network taps. |

### Parameter: `nicConfigurations.ipConfigurations.subnetResourceId`

The resource ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools`

The application gateway backend address pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsid) | string | Resource ID of the backend address pool. |
| [`name`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsname) | string | Name of the backend address pool that is unique within an Application Gateway. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsproperties) | object | Properties of the application gateway backend address pool. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.id`

Resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.name`

Name of the backend address pool that is unique within an Application Gateway.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties`

Properties of the application gateway backend address pool.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddresses`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddresses) | array | Backend addresses. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses`

Backend addresses.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesfqdn) | string | FQDN of the backend address. |
| [`ipAddress`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesipaddress) | string | IP address of the backend address. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.fqdn`

FQDN of the backend address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.ipAddress`

IP address of the backend address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups`

The application security groups.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupsid) | string | Resource ID of the application security group. |
| [`location`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupslocation) | string | Location of the application security group. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupsproperties) | object | Properties of the application security group. |
| [`tags`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupstags) | object | Tags of the application security group. |

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.id`

Resource ID of the application security group.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.location`

Location of the application security group.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.properties`

Properties of the application security group.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.tags`

Tags of the application security group.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings`

The diagnostic settings of the IP configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.gatewayLoadBalancer`

The gateway load balancer settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsgatewayloadbalancerid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.gatewayLoadBalancer.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools`

The load balancer backend address pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsid) | string | The resource ID of the backend address pool. |
| [`name`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsname) | string | The name of the backend address pool. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsproperties) | object | The properties of the backend address pool. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.id`

The resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.name`

The name of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.properties`

The properties of the backend address pool.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules`

The load balancer inbound NAT rules.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesid) | string | Resource ID of the inbound NAT rule. |
| [`name`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesname) | string | Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesproperties) | object | Properties of the inbound NAT rule. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.id`

Resource ID of the inbound NAT rule.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.name`

Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties`

Properties of the inbound NAT rule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPool`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspool) | object | A reference to backendAddressPool resource. |
| [`backendPort`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendport) | int | The port used for the internal endpoint. Acceptable values range from 1 to 65535. |
| [`enableFloatingIP`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesenablefloatingip) | bool | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| [`enableTcpReset`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesenabletcpreset) | bool | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| [`frontendIPConfiguration`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfiguration) | object | A reference to frontend IP addresses. |
| [`frontendPort`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendport) | int | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeEnd`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangeend) | int | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeStart`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangestart) | int | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`protocol`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesprotocol) | string | The reference to the transport protocol used by the load balancing rule. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool`

A reference to backendAddressPool resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspoolid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendPort`

The port used for the internal endpoint. Acceptable values range from 1 to 65535.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.enableFloatingIP`

Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.enableTcpReset`

Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration`

A reference to frontend IP addresses.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfigurationid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPort`

The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeEnd`

The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeStart`

The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.protocol`

The reference to the transport protocol used by the load balancing rule.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.name`

The name of the IP configuration.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration`

The public IP address configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-nicconfigurationsipconfigurationspipconfigurationavailabilityzones) | array | The zones of the public IP address. |
| [`ddosSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettings) | object | The DDoS protection plan configuration associated with the public IP address. |
| [`diagnosticSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettings) | array | Diagnostic settings for the public IP address. |
| [`dnsSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettings) | object | The DNS settings of the public IP address. |
| [`enableTelemetry`](#parameter-nicconfigurationsipconfigurationspipconfigurationenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`idleTimeoutInMinutes`](#parameter-nicconfigurationsipconfigurationspipconfigurationidletimeoutinminutes) | int | The idle timeout of the public IP address. |
| [`ipTags`](#parameter-nicconfigurationsipconfigurationspipconfigurationiptags) | array | The list of tags associated with the public IP address. |
| [`location`](#parameter-nicconfigurationsipconfigurationspipconfigurationlocation) | string | The idle timeout in minutes. |
| [`lock`](#parameter-nicconfigurationsipconfigurationspipconfigurationlock) | object | The lock settings of the public IP address. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationname) | string | The name of the Public IP Address. |
| [`publicIPAddressResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipaddressresourceid) | string | The resource ID of the public IP address. |
| [`publicIPAddressVersion`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipaddressversion) | string | The public IP address version. |
| [`publicIPAllocationMethod`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipallocationmethod) | string | The public IP address allocation method. |
| [`publicIpNameSuffix`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipnamesuffix) | string | The name suffix of the public IP address resource. |
| [`publicIpPrefixResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`roleAssignments`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-nicconfigurationsipconfigurationspipconfigurationskuname) | string | The SKU name of the public IP address. |
| [`skuTier`](#parameter-nicconfigurationsipconfigurationspipconfigurationskutier) | string | The SKU tier of the public IP address. |
| [`tags`](#parameter-nicconfigurationsipconfigurationspipconfigurationtags) | object | The tags of the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.availabilityZones`

The zones of the public IP address.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings`

The DDoS protection plan configuration associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionMode`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsprotectionmode) | string | The DDoS protection policy customizations. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlan`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsddosprotectionplan) | object | The DDoS protection plan associated with the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.protectionMode`

The DDoS protection policy customizations.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Enabled'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.ddosProtectionPlan`

The DDoS protection plan associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsddosprotectionplanid) | string | The resource ID of the DDOS protection plan associated with the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.ddosProtectionPlan.id`

The resource ID of the DDOS protection plan associated with the public IP address.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings`

Diagnostic settings for the public IP address.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings`

The DNS settings of the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabel`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsdomainnamelabel) | string | The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabelScope`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsdomainnamelabelscope) | string | The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. |
| [`fqdn`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsfqdn) | string | The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
| [`reverseFqdn`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsreversefqdn) | string | The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.domainNameLabel`

The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.domainNameLabelScope`

The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.fqdn`

The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.reverseFqdn`

The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.idleTimeoutInMinutes`

The idle timeout of the public IP address.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ipTags`

The list of tags associated with the public IP address.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-nicconfigurationsipconfigurationspipconfigurationiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-nicconfigurationsipconfigurationspipconfigurationiptagstag) | string | The IP tag. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.location`

The idle timeout in minutes.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock`

The lock settings of the public IP address.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-nicconfigurationsipconfigurationspipconfigurationlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-nicconfigurationsipconfigurationspipconfigurationlocknotes) | string | Specify the notes of the lock. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.kind`

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

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.name`

The name of the Public IP Address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAddressResourceId`

The resource ID of the public IP address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAddressVersion`

The public IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAllocationMethod`

The public IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIpNameSuffix`

The name suffix of the public IP address resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIpPrefixResourceId`

Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.principalType`

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

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.skuName`

The SKU name of the public IP address.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.skuTier`

The SKU tier of the public IP address.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.privateIPAddress`

The private IP address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.privateIPAddressVersion`

The private IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.privateIPAllocationMethod`

The private IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps`

The virtual network taps.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapsid) | string | Resource ID of the virtual network tap. |
| [`location`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapslocation) | string | Location of the virtual network tap. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapsproperties) | object | Properties of the virtual network tap. |
| [`tags`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapstags) | object | Tags of the virtual network tap. |

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.id`

Resource ID of the virtual network tap.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.location`

Location of the virtual network tap.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.properties`

Properties of the virtual network tap.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.tags`

Tags of the virtual network tap.

- Required: No
- Type: object

### Parameter: `nicConfigurations.deleteOption`

Specify what happens to the network interface when the VM is deleted.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `nicConfigurations.diagnosticSettings`

The diagnostic settings of the IP configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.dnsServers`

List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection.

- Required: No
- Type: array

### Parameter: `nicConfigurations.enableAcceleratedNetworking`

If the network interface is accelerated networking enabled.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.enableIPForwarding`

Indicates whether IP forwarding is enabled on this network interface.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-nicconfigurationslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-nicconfigurationslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-nicconfigurationslocknotes) | string | Specify the notes of the lock. |

### Parameter: `nicConfigurations.lock.kind`

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

### Parameter: `nicConfigurations.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.name`

The name of the NIC configuration.

- Required: No
- Type: string

### Parameter: `nicConfigurations.networkSecurityGroupResourceId`

The network security group (NSG) to attach to the network interface.

- Required: No
- Type: string

### Parameter: `nicConfigurations.nicSuffix`

The suffix to append to the NIC name.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-nicconfigurationsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-nicconfigurationsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-nicconfigurationsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-nicconfigurationsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-nicconfigurationsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-nicconfigurationsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-nicconfigurationsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-nicconfigurationsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `nicConfigurations.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `nicConfigurations.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.principalType`

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

### Parameter: `nicConfigurations.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `osDisk`

Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedDisk`](#parameter-osdiskmanageddisk) | object | The managed disk parameters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`caching`](#parameter-osdiskcaching) | string | Specifies the caching requirements. |
| [`createOption`](#parameter-osdiskcreateoption) | string | Specifies how the virtual machine should be created. |
| [`deleteOption`](#parameter-osdiskdeleteoption) | string | Specifies whether data disk should be deleted or detached upon VM deletion. |
| [`diffDiskSettings`](#parameter-osdiskdiffdisksettings) | object | Specifies the ephemeral Disk Settings for the operating system disk. |
| [`diskSizeGB`](#parameter-osdiskdisksizegb) | int | Specifies the size of an empty data disk in gigabytes. |
| [`name`](#parameter-osdiskname) | string | The disk name. |

### Parameter: `osDisk.managedDisk`

The managed disk parameters.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskEncryptionSetResourceId`](#parameter-osdiskmanageddiskdiskencryptionsetresourceid) | string | Specifies the customer managed disk encryption set resource id for the managed disk. |
| [`storageAccountType`](#parameter-osdiskmanageddiskstorageaccounttype) | string | Specifies the storage account type for the managed disk. |

### Parameter: `osDisk.managedDisk.diskEncryptionSetResourceId`

Specifies the customer managed disk encryption set resource id for the managed disk.

- Required: No
- Type: string

### Parameter: `osDisk.managedDisk.storageAccountType`

Specifies the storage account type for the managed disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'StandardSSD_ZRS'
    'UltraSSD_LRS'
  ]
  ```

### Parameter: `osDisk.caching`

Specifies the caching requirements.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `osDisk.createOption`

Specifies how the virtual machine should be created.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Attach'
    'Empty'
    'FromImage'
  ]
  ```

### Parameter: `osDisk.deleteOption`

Specifies whether data disk should be deleted or detached upon VM deletion.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `osDisk.diffDiskSettings`

Specifies the ephemeral Disk Settings for the operating system disk.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`placement`](#parameter-osdiskdiffdisksettingsplacement) | string | Specifies the ephemeral disk placement for the operating system disk. |

### Parameter: `osDisk.diffDiskSettings.placement`

Specifies the ephemeral disk placement for the operating system disk.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CacheDisk'
    'NvmeDisk'
    'ResourceDisk'
  ]
  ```

### Parameter: `osDisk.diskSizeGB`

Specifies the size of an empty data disk in gigabytes.

- Required: No
- Type: int

### Parameter: `osDisk.name`

The disk name.

- Required: No
- Type: string

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-additionalunattendcontentcontent) | string | Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted. |
| [`settingName`](#parameter-additionalunattendcontentsettingname) | string | Specifies the name of the setting to which the content applies. |

### Parameter: `additionalUnattendContent.content`

Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted.

- Required: No
- Type: string

### Parameter: `additionalUnattendContent.settingName`

Specifies the name of the setting to which the content applies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AutoLogon'
    'FirstLogonCommands'
  ]
  ```

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

### Parameter: `autoShutdownConfig`

The configuration for auto-shutdown.

- Required: No
- Type: object
- Default: `{}`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyRecurrenceTime`](#parameter-autoshutdownconfigdailyrecurrencetime) | string | The time of day the schedule will occur. |
| [`notificationSettings`](#parameter-autoshutdownconfignotificationsettings) | object | The resource ID of the schedule. |
| [`status`](#parameter-autoshutdownconfigstatus) | string | The status of the auto shutdown configuration. |
| [`timeZone`](#parameter-autoshutdownconfigtimezone) | string | The time zone ID (e.g. China Standard Time, Greenland Standard Time, Pacific Standard time, etc.). |

### Parameter: `autoShutdownConfig.dailyRecurrenceTime`

The time of day the schedule will occur.

- Required: No
- Type: string

### Parameter: `autoShutdownConfig.notificationSettings`

The resource ID of the schedule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailRecipient`](#parameter-autoshutdownconfignotificationsettingsemailrecipient) | string | The email address to send notifications to (can be a list of semi-colon separated email addresses). |
| [`notificationLocale`](#parameter-autoshutdownconfignotificationsettingsnotificationlocale) | string | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| [`status`](#parameter-autoshutdownconfignotificationsettingsstatus) | string | The status of the notification settings. |
| [`timeInMinutes`](#parameter-autoshutdownconfignotificationsettingstimeinminutes) | int | The time in minutes before shutdown to send notifications. |
| [`webhookUrl`](#parameter-autoshutdownconfignotificationsettingswebhookurl) | string | The webhook URL to which the notification will be sent. |

### Parameter: `autoShutdownConfig.notificationSettings.emailRecipient`

The email address to send notifications to (can be a list of semi-colon separated email addresses).

- Required: No
- Type: string

### Parameter: `autoShutdownConfig.notificationSettings.notificationLocale`

The locale to use when sending a notification (fallback for unsupported languages is EN).

- Required: No
- Type: string

### Parameter: `autoShutdownConfig.notificationSettings.status`

The status of the notification settings.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `autoShutdownConfig.notificationSettings.timeInMinutes`

The time in minutes before shutdown to send notifications.

- Required: No
- Type: int

### Parameter: `autoShutdownConfig.notificationSettings.webhookUrl`

The webhook URL to which the notification will be sent.

- Required: No
- Type: string

### Parameter: `autoShutdownConfig.status`

The status of the auto shutdown configuration.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `autoShutdownConfig.timeZone`

The time zone ID (e.g. China Standard Time, Greenland Standard Time, Pacific Standard time, etc.).

- Required: No
- Type: string

### Parameter: `availabilitySetResourceId`

Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `bypassPlatformSafetyChecksOnUserSchedule`

Enables customer to schedule patching without accidental upgrades.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `capacityReservationGroupResourceId`

Capacity reservation group resource id that should be used for allocating the virtual machine vm instances provided enough capacity has been reserved.

- Required: No
- Type: string
- Default: `''`

### Parameter: `certificatesToBeInstalled`

Specifies set of certificates that should be installed onto the virtual machine.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sourceVault`](#parameter-certificatestobeinstalledsourcevault) | object | The relative URL of the Key Vault containing all of the certificates in VaultCertificates. |
| [`vaultCertificates`](#parameter-certificatestobeinstalledvaultcertificates) | array | The list of key vault references in SourceVault which contain certificates. |

### Parameter: `certificatesToBeInstalled.sourceVault`

The relative URL of the Key Vault containing all of the certificates in VaultCertificates.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-certificatestobeinstalledsourcevaultid) | string | Resource ID of the sub resource. |

### Parameter: `certificatesToBeInstalled.sourceVault.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `certificatesToBeInstalled.vaultCertificates`

The list of key vault references in SourceVault which contain certificates.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateStore`](#parameter-certificatestobeinstalledvaultcertificatescertificatestore) | string | For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name <UppercaseThumbprint>.crt for the X509 certificate file and <UppercaseThumbprint>.prv for private key. Both of these files are .pem formatted. |
| [`certificateUrl`](#parameter-certificatestobeinstalledvaultcertificatescertificateurl) | string | This is the URL of a certificate that has been uploaded to Key Vault as a secret. |

### Parameter: `certificatesToBeInstalled.vaultCertificates.certificateStore`

For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name <UppercaseThumbprint>.crt for the X509 certificate file and <UppercaseThumbprint>.prv for private key. Both of these files are .pem formatted.

- Required: No
- Type: string

### Parameter: `certificatesToBeInstalled.vaultCertificates.certificateUrl`

This is the URL of a certificate that has been uploaded to Key Vault as a secret.

- Required: No
- Type: string

### Parameter: `computerName`

Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `configurationProfile`

The configuration profile of automanage. Either '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction', 'providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest' or the resource Id of custom profile.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customData`

Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataDisks`

Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedDisk`](#parameter-datadisksmanageddisk) | object | The managed disk parameters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`caching`](#parameter-datadiskscaching) | string | Specifies the caching requirements. This property is automatically set to 'None' when attaching a pre-existing disk. |
| [`createOption`](#parameter-datadiskscreateoption) | string | Specifies how the virtual machine should be created. This property is automatically set to 'Attach' when attaching a pre-existing disk. |
| [`deleteOption`](#parameter-datadisksdeleteoption) | string | Specifies whether data disk should be deleted or detached upon VM deletion. This property is automatically set to 'Detach' when attaching a pre-existing disk. |
| [`diskIOPSReadWrite`](#parameter-datadisksdiskiopsreadwrite) | int | The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. Ignored when attaching a pre-existing disk. |
| [`diskMBpsReadWrite`](#parameter-datadisksdiskmbpsreadwrite) | int | The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10. Ignored when attaching a pre-existing disk. |
| [`diskSizeGB`](#parameter-datadisksdisksizegb) | int | Specifies the size of an empty data disk in gigabytes. This property is ignored when attaching a pre-existing disk. |
| [`lun`](#parameter-datadiskslun) | int | Specifies the logical unit number of the data disk. |
| [`name`](#parameter-datadisksname) | string | The disk name. When attaching a pre-existing disk, this name is ignored and the name of the existing disk is used. |
| [`tags`](#parameter-datadiskstags) | object | The tags of the public IP address. Valid only when creating a new managed disk. |

### Parameter: `dataDisks.managedDisk`

The managed disk parameters.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskEncryptionSetResourceId`](#parameter-datadisksmanageddiskdiskencryptionsetresourceid) | string | Specifies the customer managed disk encryption set resource id for the managed disk. |
| [`id`](#parameter-datadisksmanageddiskid) | string | Specifies the resource id of a pre-existing managed disk. If the disk should be created, this property should be empty. |
| [`storageAccountType`](#parameter-datadisksmanageddiskstorageaccounttype) | string | Specifies the storage account type for the managed disk. Ignored when attaching a pre-existing disk. |

### Parameter: `dataDisks.managedDisk.diskEncryptionSetResourceId`

Specifies the customer managed disk encryption set resource id for the managed disk.

- Required: No
- Type: string

### Parameter: `dataDisks.managedDisk.id`

Specifies the resource id of a pre-existing managed disk. If the disk should be created, this property should be empty.

- Required: No
- Type: string

### Parameter: `dataDisks.managedDisk.storageAccountType`

Specifies the storage account type for the managed disk. Ignored when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'StandardSSD_ZRS'
    'UltraSSD_LRS'
  ]
  ```

### Parameter: `dataDisks.caching`

Specifies the caching requirements. This property is automatically set to 'None' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `dataDisks.createOption`

Specifies how the virtual machine should be created. This property is automatically set to 'Attach' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Attach'
    'Empty'
    'FromImage'
  ]
  ```

### Parameter: `dataDisks.deleteOption`

Specifies whether data disk should be deleted or detached upon VM deletion. This property is automatically set to 'Detach' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `dataDisks.diskIOPSReadWrite`

The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. Ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.diskMBpsReadWrite`

The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10. Ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.diskSizeGB`

Specifies the size of an empty data disk in gigabytes. This property is ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.lun`

Specifies the logical unit number of the data disk.

- Required: No
- Type: int

### Parameter: `dataDisks.name`

The disk name. When attaching a pre-existing disk, this name is ignored and the name of the existing disk is used.

- Required: No
- Type: string

### Parameter: `dataDisks.tags`

The tags of the public IP address. Valid only when creating a new managed disk.

- Required: No
- Type: object

### Parameter: `dedicatedHostResourceId`

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

### Parameter: `enableHotpatching`

Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'.

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
- Default: `False`

### Parameter: `evictionPolicy`

Specifies the eviction policy for the low priority virtual machine.

- Required: No
- Type: string
- Default: `'Deallocate'`
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `extensionAadJoinConfig`

The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. To enroll in Intune, add the setting mdmId: "0000000a-0000-0000-c000-000000000000".

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
- Default: `[if(equals(parameters('osType'), 'Windows'), createObject('enabled', true()), createObject('enabled', false()))]`

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
- Default: `{}`

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

### Parameter: `extensionGuestConfigurationExtension`

The configuration for the [Guest Configuration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identity.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionGuestConfigurationExtensionProtectedSettings`

An object that contains the extension specific protected settings.

- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `extensionHostPoolRegistration`

The configuration for the [Host Pool Registration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identity.

- Required: No
- Type: secureObject
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
      dataCollectionRuleAssociations: []
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

### Parameter: `extensionNvidiaGpuDriverWindows`

The configuration for the [Nvidia Gpu Driver Windows] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `galleryApplications`

Specifies the gallery applications that should be made available to the VM/VMSS.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`packageReferenceId`](#parameter-galleryapplicationspackagereferenceid) | string | Specifies the GalleryApplicationVersion resource id on the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationReference`](#parameter-galleryapplicationsconfigurationreference) | string | Specifies the uri to an azure blob that will replace the default configuration for the package if provided. |
| [`enableAutomaticUpgrade`](#parameter-galleryapplicationsenableautomaticupgrade) | bool | If set to true, when a new Gallery Application version is available in PIR/SIG, it will be automatically updated for the VM/VMSS. |
| [`order`](#parameter-galleryapplicationsorder) | int | Specifies the order in which the packages have to be installed. |
| [`tags`](#parameter-galleryapplicationstags) | string | Specifies a passthrough value for more generic context. |
| [`treatFailureAsDeploymentFailure`](#parameter-galleryapplicationstreatfailureasdeploymentfailure) | bool | If true, any failure for any operation in the VmApplication will fail the deployment. |

### Parameter: `galleryApplications.packageReferenceId`

Specifies the GalleryApplicationVersion resource id on the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}.

- Required: Yes
- Type: string

### Parameter: `galleryApplications.configurationReference`

Specifies the uri to an azure blob that will replace the default configuration for the package if provided.

- Required: No
- Type: string

### Parameter: `galleryApplications.enableAutomaticUpgrade`

If set to true, when a new Gallery Application version is available in PIR/SIG, it will be automatically updated for the VM/VMSS.

- Required: No
- Type: bool

### Parameter: `galleryApplications.order`

Specifies the order in which the packages have to be installed.

- Required: No
- Type: int

### Parameter: `galleryApplications.tags`

Specifies a passthrough value for more generic context.

- Required: No
- Type: string

### Parameter: `galleryApplications.treatFailureAsDeploymentFailure`

If true, any failure for any operation in the VmApplication will fail the deployment.

- Required: No
- Type: bool

### Parameter: `guestConfiguration`

The guest configuration for the virtual machine. Needs the Guest Configuration extension to be enabled.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `hibernationEnabled`

The flag that enables or disables hibernation capability on the VM.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `licenseType`

Specifies that the image or disk that is being used was licensed on-premises.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'RHEL_BYOS'
    'SLES_BYOS'
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

### Parameter: `maintenanceConfigurationResourceId`

The resource Id of a maintenance configuration for this VM.

- Required: No
- Type: string
- Default: `''`

### Parameter: `managedIdentities`

The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True".

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

### Parameter: `maxPriceForLowPriorityVm`

Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.

- Required: No
- Type: string
- Default: `''`

### Parameter: `networkAccessPolicy`

Policy for accessing the disk via network.

- Required: No
- Type: string
- Default: `'DenyAll'`
- Allowed:
  ```Bicep
  [
    'AllowAll'
    'AllowPrivate'
    'DenyAll'
  ]
  ```

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-planname) | string | The name of the plan. |
| [`product`](#parameter-planproduct) | string | Specifies the product of the image from the marketplace. |
| [`promotionCode`](#parameter-planpromotioncode) | string | The promotion code. |
| [`publisher`](#parameter-planpublisher) | string | The publisher ID. |

### Parameter: `plan.name`

The name of the plan.

- Required: No
- Type: string

### Parameter: `plan.product`

Specifies the product of the image from the marketplace.

- Required: No
- Type: string

### Parameter: `plan.promotionCode`

The promotion code.

- Required: No
- Type: string

### Parameter: `plan.publisher`

The publisher ID.

- Required: No
- Type: string

### Parameter: `priority`

Specifies the priority for the virtual machine.

- Required: No
- Type: string
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyData`](#parameter-publickeyskeydata) | string | Specifies the SSH public key data used to authenticate through ssh. |
| [`path`](#parameter-publickeyspath) | string | Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file. |

### Parameter: `publicKeys.keyData`

Specifies the SSH public key data used to authenticate through ssh.

- Required: Yes
- Type: string

### Parameter: `publicKeys.path`

Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file.

- Required: Yes
- Type: string

### Parameter: `publicNetworkAccess`

Policy for controlling export on the disk.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

### Parameter: `secureBootEnabled`

Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `securityType`

Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'ConfidentialVM'
    'TrustedLaunch'
  ]
  ```

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

### Parameter: `userData`

UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here.

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualMachineScaleSetResourceId`

Resource ID of a virtual machine scale set, where the VM should be added.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vTpmEnabled`

Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `winRMListeners`

Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateUrl`](#parameter-winrmlistenerscertificateurl) | string | The URL of a certificate that has been uploaded to Key Vault as a secret. |
| [`protocol`](#parameter-winrmlistenersprotocol) | string | Specifies the protocol of WinRM listener. |

### Parameter: `winRMListeners.certificateUrl`

The URL of a certificate that has been uploaded to Key Vault as a secret.

- Required: No
- Type: string

### Parameter: `winRMListeners.protocol`

Specifies the protocol of WinRM listener.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Https'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VM. |
| `nicConfigurations` | array | The list of NIC configurations of the virtual machine. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the VM. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/network-interface:0.5.1` | Remote reference |
| `br/public:avm/res/network/network-interface:0.5.2` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.8.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.9.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Notes

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
