# AI Platform Baseline `[AiPlatform/Baseline]`

This module provides a secure and scalable environment for deploying AI applications on Azure.
The module encompasses all essential components required for building, managing, and observing AI solutions, including a machine learning workspace, observability tools, and necessary data management services.
By integrating with Microsoft Entra ID for secure identity management and utilizing private endpoints for services like Key Vault and Blob Storage, the module ensures secure communication and data access.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates) |
| `Microsoft.Compute/virtualMachines` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-09-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Network/bastionHosts` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/bastionHosts) |
| `Microsoft.Network/networkInterfaces` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/subnets) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/ai-platform/baseline:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Without virtual machine](#example-3-without-virtual-machine)
- [Without virtual network](#example-4-without-virtual-network)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    virtualMachineConfiguration: {
      adminPassword: '<adminPassword>'
      adminUsername: 'localAdminUser'
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
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "virtualMachineConfiguration": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "localAdminUser"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: 'aipbmax'
    // Non-required parameters
    applicationInsightsConfiguration: {
      name: 'appi-aipbmax'
    }
    bastionConfiguration: {
      disableCopyPaste: true
      enabled: true
      enableFileCopy: true
      enableIpConnect: true
      enableKerberos: true
      enableShareableLink: true
      name: 'bas-aipbmax'
      networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      scaleUnits: 3
      sku: 'Standard'
      subnetAddressPrefix: '10.1.1.0/26'
    }
    containerRegistryConfiguration: {
      name: 'craipbmax'
      trustPolicyStatus: 'disabled'
    }
    keyVaultConfiguration: {
      enablePurgeProtection: false
      name: '<name>'
    }
    logAnalyticsConfiguration: {
      name: 'log-aipbmax'
    }
    managedIdentityConfiguration: {
      hubName: 'id-hub-aipbmax'
      projectName: 'id-project-aipbmax'
    }
    storageAccountConfiguration: {
      allowSharedKeyAccess: true
      name: 'staipbmax'
      sku: 'Standard_GRS'
    }
    virtualMachineConfiguration: {
      adminPassword: '<adminPassword>'
      adminUsername: 'localAdminUser'
      enableAadLoginExtension: true
      enableAzureMonitorAgent: true
      enabled: true
      encryptionAtHost: false
      imageReference: {
        offer: 'dsvm-win-2022'
        publisher: 'microsoft-dsvm'
        sku: 'winserver-2022'
        version: 'latest'
      }
      maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
      name: '<name>'
      nicConfigurationConfiguration: {
        ipConfigName: 'ipcfg-aipbmax'
        name: 'nic-aipbmax'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
        privateIPAllocationMethod: 'Dynamic'
      }
      osDisk: {
        caching: 'ReadOnly'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        diskSizeGB: 256
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        name: 'disk-aipbmax'
      }
      patchMode: 'AutomaticByPlatform'
      size: 'Standard_DS1_v2'
      zone: 0
    }
    virtualNetworkConfiguration: {
      addressPrefix: '10.1.0.0/16'
      enabled: true
      name: 'vnet-aipbmax'
      subnet: {
        addressPrefix: '10.1.0.0/24'
        name: 'snet-aipbmax'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
    }
    workspaceConfiguration: {
      computes: [
        {
          computeType: 'ComputeInstance'
          description: 'Default'
          location: '<location>'
          name: '<name>'
          properties: {
            vmSize: 'STANDARD_DS11_V2'
          }
          sku: 'Standard'
        }
      ]
      name: 'hub-aipbmax'
      networkIsolationMode: 'AllowOnlyApprovedOutbound'
      networkOutboundRules: {
        rule1: {
          category: 'UserDefined'
          destination: 'pypi.org'
          type: 'FQDN'
        }
      }
      projectName: 'project-aipbmax'
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
    "name": {
      "value": "aipbmax"
    },
    // Non-required parameters
    "applicationInsightsConfiguration": {
      "value": {
        "name": "appi-aipbmax"
      }
    },
    "bastionConfiguration": {
      "value": {
        "disableCopyPaste": true,
        "enabled": true,
        "enableFileCopy": true,
        "enableIpConnect": true,
        "enableKerberos": true,
        "enableShareableLink": true,
        "name": "bas-aipbmax",
        "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
        "scaleUnits": 3,
        "sku": "Standard",
        "subnetAddressPrefix": "10.1.1.0/26"
      }
    },
    "containerRegistryConfiguration": {
      "value": {
        "name": "craipbmax",
        "trustPolicyStatus": "disabled"
      }
    },
    "keyVaultConfiguration": {
      "value": {
        "enablePurgeProtection": false,
        "name": "<name>"
      }
    },
    "logAnalyticsConfiguration": {
      "value": {
        "name": "log-aipbmax"
      }
    },
    "managedIdentityConfiguration": {
      "value": {
        "hubName": "id-hub-aipbmax",
        "projectName": "id-project-aipbmax"
      }
    },
    "storageAccountConfiguration": {
      "value": {
        "allowSharedKeyAccess": true,
        "name": "staipbmax",
        "sku": "Standard_GRS"
      }
    },
    "virtualMachineConfiguration": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "localAdminUser",
        "enableAadLoginExtension": true,
        "enableAzureMonitorAgent": true,
        "enabled": true,
        "encryptionAtHost": false,
        "imageReference": {
          "offer": "dsvm-win-2022",
          "publisher": "microsoft-dsvm",
          "sku": "winserver-2022",
          "version": "latest"
        },
        "maintenanceConfigurationResourceId": "<maintenanceConfigurationResourceId>",
        "name": "<name>",
        "nicConfigurationConfiguration": {
          "ipConfigName": "ipcfg-aipbmax",
          "name": "nic-aipbmax",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
          "privateIPAllocationMethod": "Dynamic"
        },
        "osDisk": {
          "caching": "ReadOnly",
          "createOption": "FromImage",
          "deleteOption": "Delete",
          "diskSizeGB": 256,
          "managedDisk": {
            "storageAccountType": "Standard_LRS"
          },
          "name": "disk-aipbmax"
        },
        "patchMode": "AutomaticByPlatform",
        "size": "Standard_DS1_v2",
        "zone": 0
      }
    },
    "virtualNetworkConfiguration": {
      "value": {
        "addressPrefix": "10.1.0.0/16",
        "enabled": true,
        "name": "vnet-aipbmax",
        "subnet": {
          "addressPrefix": "10.1.0.0/24",
          "name": "snet-aipbmax",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        }
      }
    },
    "workspaceConfiguration": {
      "value": {
        "computes": [
          {
            "computeType": "ComputeInstance",
            "description": "Default",
            "location": "<location>",
            "name": "<name>",
            "properties": {
              "vmSize": "STANDARD_DS11_V2"
            },
            "sku": "Standard"
          }
        ],
        "name": "hub-aipbmax",
        "networkIsolationMode": "AllowOnlyApprovedOutbound",
        "networkOutboundRules": {
          "rule1": {
            "category": "UserDefined",
            "destination": "pypi.org",
            "type": "FQDN"
          }
        },
        "projectName": "project-aipbmax"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Without virtual machine_

This instance deploys the module with a virtual network, but no virtual machine or Azure Bastion host.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    bastionConfiguration: {
      enabled: false
    }
    virtualMachineConfiguration: {
      enabled: false
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
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "bastionConfiguration": {
      "value": {
        "enabled": false
      }
    },
    "virtualMachineConfiguration": {
      "value": {
        "enabled": false
      }
    }
  }
}
```

</details>
<p>

### Example 4: _Without virtual network_

This instance deploys the module without a virtual network, virtual machine or Azure Bastion host.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    virtualNetworkConfiguration: {
      enabled: false
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
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "virtualNetworkConfiguration": {
      "value": {
        "enabled": false
      }
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    virtualMachineConfiguration: {
      adminPassword: '<adminPassword>'
      adminUsername: 'localAdminUser'
      enableAadLoginExtension: true
      enableAzureMonitorAgent: true
      maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
      patchMode: 'AutomaticByPlatform'
      zone: 1
    }
    workspaceConfiguration: {
      networkIsolationMode: 'AllowOnlyApprovedOutbound'
      networkOutboundRules: {
        rule: {
          category: 'UserDefined'
          destination: {
            serviceResourceId: '<serviceResourceId>'
            subresourceTarget: 'blob'
          }
          type: 'PrivateEndpoint'
        }
      }
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
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "virtualMachineConfiguration": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "localAdminUser",
        "enableAadLoginExtension": true,
        "enableAzureMonitorAgent": true,
        "maintenanceConfigurationResourceId": "<maintenanceConfigurationResourceId>",
        "patchMode": "AutomaticByPlatform",
        "zone": 1
      }
    },
    "workspaceConfiguration": {
      "value": {
        "networkIsolationMode": "AllowOnlyApprovedOutbound",
        "networkOutboundRules": {
          "rule": {
            "category": "UserDefined",
            "destination": {
              "serviceResourceId": "<serviceResourceId>",
              "subresourceTarget": "blob"
            },
            "type": "PrivateEndpoint"
          }
        }
      }
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
| [`name`](#parameter-name) | string | Alphanumberic suffix to use for resource naming. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightsConfiguration`](#parameter-applicationinsightsconfiguration) | object | Configuration for Application Insights. |
| [`bastionConfiguration`](#parameter-bastionconfiguration) | object | Configuration for the Azure Bastion host. |
| [`containerRegistryConfiguration`](#parameter-containerregistryconfiguration) | object | Configuration for the container registry. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`keyVaultConfiguration`](#parameter-keyvaultconfiguration) | object | Configuration for the key vault. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`logAnalyticsConfiguration`](#parameter-loganalyticsconfiguration) | object | Configuration for the Log Analytics workspace. |
| [`managedIdentityConfiguration`](#parameter-managedidentityconfiguration) | object | Configuration for the user-assigned managed identities. |
| [`storageAccountConfiguration`](#parameter-storageaccountconfiguration) | object | Configuration for the storage account. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`virtualMachineConfiguration`](#parameter-virtualmachineconfiguration) | secureObject | Configuration for the virtual machine. |
| [`virtualNetworkConfiguration`](#parameter-virtualnetworkconfiguration) | object | Configuration for the virtual network. |
| [`workspaceConfiguration`](#parameter-workspaceconfiguration) | object | Configuration for the AI Studio workspace. |

### Parameter: `name`

Alphanumberic suffix to use for resource naming.

- Required: Yes
- Type: string

### Parameter: `applicationInsightsConfiguration`

Configuration for Application Insights.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-applicationinsightsconfigurationname) | string | The name of the Application Insights resource. |

### Parameter: `applicationInsightsConfiguration.name`

The name of the Application Insights resource.

- Required: No
- Type: string

### Parameter: `bastionConfiguration`

Configuration for the Azure Bastion host.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableCopyPaste`](#parameter-bastionconfigurationdisablecopypaste) | bool | Choose to disable or enable Copy Paste. |
| [`enabled`](#parameter-bastionconfigurationenabled) | bool | Whether to create a Bastion host in the virtual network. Defaults to 'true'. |
| [`enableFileCopy`](#parameter-bastionconfigurationenablefilecopy) | bool | Choose to disable or enable File Copy. |
| [`enableIpConnect`](#parameter-bastionconfigurationenableipconnect) | bool | Choose to disable or enable IP Connect. |
| [`enableKerberos`](#parameter-bastionconfigurationenablekerberos) | bool | Choose to disable or enable Kerberos authentication. |
| [`enableShareableLink`](#parameter-bastionconfigurationenableshareablelink) | bool | Choose to disable or enable Shareable Link. |
| [`name`](#parameter-bastionconfigurationname) | string | The name of the Bastion host to create. |
| [`networkSecurityGroupResourceId`](#parameter-bastionconfigurationnetworksecuritygroupresourceid) | string | The resource ID of an existing network security group to associate with the Azure Bastion subnet. |
| [`scaleUnits`](#parameter-bastionconfigurationscaleunits) | int | The scale units for the Bastion Host resource. |
| [`sku`](#parameter-bastionconfigurationsku) | string | The SKU of the Bastion host to create. |
| [`subnetAddressPrefix`](#parameter-bastionconfigurationsubnetaddressprefix) | string | The address prefix of the Azure Bastion subnet. |

### Parameter: `bastionConfiguration.disableCopyPaste`

Choose to disable or enable Copy Paste.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.enabled`

Whether to create a Bastion host in the virtual network. Defaults to 'true'.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.enableFileCopy`

Choose to disable or enable File Copy.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.enableIpConnect`

Choose to disable or enable IP Connect.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.enableKerberos`

Choose to disable or enable Kerberos authentication.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.enableShareableLink`

Choose to disable or enable Shareable Link.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.name`

The name of the Bastion host to create.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.networkSecurityGroupResourceId`

The resource ID of an existing network security group to associate with the Azure Bastion subnet.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.scaleUnits`

The scale units for the Bastion Host resource.

- Required: No
- Type: int

### Parameter: `bastionConfiguration.sku`

The SKU of the Bastion host to create.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `bastionConfiguration.subnetAddressPrefix`

The address prefix of the Azure Bastion subnet.

- Required: No
- Type: string

### Parameter: `containerRegistryConfiguration`

Configuration for the container registry.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerregistryconfigurationname) | string | The name of the container registry. |
| [`trustPolicyStatus`](#parameter-containerregistryconfigurationtrustpolicystatus) | string | Whether the trust policy is enabled for the container registry. Defaults to 'enabled'. |

### Parameter: `containerRegistryConfiguration.name`

The name of the container registry.

- Required: No
- Type: string

### Parameter: `containerRegistryConfiguration.trustPolicyStatus`

Whether the trust policy is enabled for the container registry. Defaults to 'enabled'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultConfiguration`

Configuration for the key vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enablePurgeProtection`](#parameter-keyvaultconfigurationenablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. Defaults to 'true'. |
| [`name`](#parameter-keyvaultconfigurationname) | string | The name of the key vault. |

### Parameter: `keyVaultConfiguration.enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature. Defaults to 'true'.

- Required: No
- Type: bool

### Parameter: `keyVaultConfiguration.name`

The name of the key vault.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsConfiguration`

Configuration for the Log Analytics workspace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-loganalyticsconfigurationname) | string | The name of the Log Analytics workspace. |

### Parameter: `logAnalyticsConfiguration.name`

The name of the Log Analytics workspace.

- Required: No
- Type: string

### Parameter: `managedIdentityConfiguration`

Configuration for the user-assigned managed identities.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubName`](#parameter-managedidentityconfigurationhubname) | string | The name of the workspace hub user-assigned managed identity. |
| [`projectName`](#parameter-managedidentityconfigurationprojectname) | string | The name of the workspace project user-assigned managed identity. |

### Parameter: `managedIdentityConfiguration.hubName`

The name of the workspace hub user-assigned managed identity.

- Required: No
- Type: string

### Parameter: `managedIdentityConfiguration.projectName`

The name of the workspace project user-assigned managed identity.

- Required: No
- Type: string

### Parameter: `storageAccountConfiguration`

Configuration for the storage account.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowSharedKeyAccess`](#parameter-storageaccountconfigurationallowsharedkeyaccess) | bool | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to 'false'. |
| [`name`](#parameter-storageaccountconfigurationname) | string | The name of the storage account. |
| [`sku`](#parameter-storageaccountconfigurationsku) | string | Storage account SKU. Defaults to 'Standard_RAGZRS'. |

### Parameter: `storageAccountConfiguration.allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to 'false'.

- Required: No
- Type: bool

### Parameter: `storageAccountConfiguration.name`

The name of the storage account.

- Required: No
- Type: string

### Parameter: `storageAccountConfiguration.sku`

Storage account SKU. Defaults to 'Standard_RAGZRS'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `virtualMachineConfiguration`

Configuration for the virtual machine.

- Required: No
- Type: secureObject

### Parameter: `virtualNetworkConfiguration`

Configuration for the virtual network.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-virtualnetworkconfigurationaddressprefix) | string | The address prefix of the virtual network to create. |
| [`enabled`](#parameter-virtualnetworkconfigurationenabled) | bool | Whether to create an associated virtual network. Defaults to 'true'. |
| [`name`](#parameter-virtualnetworkconfigurationname) | string | The name of the virtual network to create. |
| [`subnet`](#parameter-virtualnetworkconfigurationsubnet) | object | Configuration for the virual network subnet. |

### Parameter: `virtualNetworkConfiguration.addressPrefix`

The address prefix of the virtual network to create.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.enabled`

Whether to create an associated virtual network. Defaults to 'true'.

- Required: No
- Type: bool

### Parameter: `virtualNetworkConfiguration.name`

The name of the virtual network to create.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnet`

Configuration for the virual network subnet.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-virtualnetworkconfigurationsubnetaddressprefix) | string | The address prefix of the subnet to create. |
| [`name`](#parameter-virtualnetworkconfigurationsubnetname) | string | The name of the subnet to create. |
| [`networkSecurityGroupResourceId`](#parameter-virtualnetworkconfigurationsubnetnetworksecuritygroupresourceid) | string | The resource ID of an existing network security group to associate with the subnet. |

### Parameter: `virtualNetworkConfiguration.subnet.addressPrefix`

The address prefix of the subnet to create.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnet.name`

The name of the subnet to create.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnet.networkSecurityGroupResourceId`

The resource ID of an existing network security group to associate with the subnet.

- Required: No
- Type: string

### Parameter: `workspaceConfiguration`

Configuration for the AI Studio workspace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computes`](#parameter-workspaceconfigurationcomputes) | array | Computes to create and attach to the workspace hub. |
| [`name`](#parameter-workspaceconfigurationname) | string | The name of the AI Studio workspace hub. |
| [`networkIsolationMode`](#parameter-workspaceconfigurationnetworkisolationmode) | string | The network isolation mode of the workspace hub. Defaults to 'AllowInternetOutbound'. |
| [`networkOutboundRules`](#parameter-workspaceconfigurationnetworkoutboundrules) | object | The outbound rules for the managed network of the workspace hub. |
| [`projectName`](#parameter-workspaceconfigurationprojectname) | string | The name of the AI Studio workspace project. |

### Parameter: `workspaceConfiguration.computes`

Computes to create and attach to the workspace hub.

- Required: No
- Type: array

### Parameter: `workspaceConfiguration.name`

The name of the AI Studio workspace hub.

- Required: No
- Type: string

### Parameter: `workspaceConfiguration.networkIsolationMode`

The network isolation mode of the workspace hub. Defaults to 'AllowInternetOutbound'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowInternetOutbound'
    'AllowOnlyApprovedOutbound'
  ]
  ```

### Parameter: `workspaceConfiguration.networkOutboundRules`

The outbound rules for the managed network of the workspace hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-workspaceconfigurationnetworkoutboundrules>any_other_property<) | object | The outbound rule. The name of the rule is the object key. |

### Parameter: `workspaceConfiguration.networkOutboundRules.>Any_other_property<`

The outbound rule. The name of the rule is the object key.

- Required: Yes
- Type: object

### Parameter: `workspaceConfiguration.projectName`

The name of the AI Studio workspace project.

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationInsightsApplicationId` | string | The application ID of the application insights component. |
| `applicationInsightsConnectionString` | string | The connection string of the application insights component. |
| `applicationInsightsInstrumentationKey` | string | The instrumentation key of the application insights component. |
| `applicationInsightsName` | string | The name of the application insights component. |
| `applicationInsightsResourceId` | string | The resource ID of the application insights component. |
| `bastionName` | string | The name of the Azure Bastion host. |
| `bastionResourceId` | string | The resource ID of the Azure Bastion host. |
| `containerRegistryName` | string | The name of the container registry. |
| `containerRegistryResourceId` | string | The resource ID of the container registry. |
| `keyVaultName` | string | The name of the key vault. |
| `keyVaultResourceId` | string | The resource ID of the key vault. |
| `keyVaultUri` | string | The URI of the key vault. |
| `location` | string | The location the module was deployed to. |
| `logAnalyticsWorkspaceName` | string | The name of the log analytics workspace. |
| `logAnalyticsWorkspaceResourceId` | string | The resource ID of the log analytics workspace. |
| `managedIdentityHubClientId` | string | The client ID of the workspace hub user assigned managed identity. |
| `managedIdentityHubName` | string | The name of the workspace hub user assigned managed identity. |
| `managedIdentityHubPrincipalId` | string | The principal ID of the workspace hub user assigned managed identity. |
| `managedIdentityHubResourceId` | string | The resource ID of the workspace hub user assigned managed identity. |
| `managedIdentityProjectClientId` | string | The client ID of the workspace project user assigned managed identity. |
| `managedIdentityProjectName` | string | The name of the workspace project user assigned managed identity. |
| `managedIdentityProjectPrincipalId` | string | The principal ID of the workspace project user assigned managed identity. |
| `managedIdentityProjectResourceId` | string | The resource ID of the workspace project user assigned managed identity. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `storageAccountName` | string | The name of the storage account. |
| `storageAccountResourceId` | string | The resource ID of the storage account. |
| `virtualMachineName` | string | The name of the virtual machine. |
| `virtualMachineResourceId` | string | The resource ID of the virtual machine. |
| `virtualNetworkName` | string | The name of the virtual network. |
| `virtualNetworkResourceId` | string | The resource ID of the virtual network. |
| `virtualNetworkSubnetName` | string | The name of the subnet in the virtual network. |
| `virtualNetworkSubnetResourceId` | string | The resource ID of the subnet in the virtual network. |
| `workspaceHubName` | string | The name of the workspace hub. |
| `workspaceHubResourceId` | string | The resource ID of the workspace hub. |
| `workspaceProjectName` | string | The name of the workspace project. |
| `workspaceProjectResourceId` | string | The resource ID of the workspace project. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/compute/virtual-machine:0.5.3` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.3.1` | Remote reference |
| `br/public:avm/res/insights/component:0.3.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.2` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.5.0` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.2.2` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.3.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.3.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.11.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
