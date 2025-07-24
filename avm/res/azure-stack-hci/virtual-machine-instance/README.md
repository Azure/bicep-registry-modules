# Azure Stack HCI Virtual Machine Instance `[Microsoft.AzureStackHCI/virtualMachineInstances]`

This module deploys an Azure Stack HCI virtual machine.

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
| `Microsoft.AzureStackHCI/virtualMachineInstances` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-01-01/virtualMachineInstances) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.HybridCompute/machines` | [2024-07-10](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridCompute/2024-07-10/machines) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>`.

- [Using default config](#example-1-using-default-config)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using default config_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    hardwareProfile: {
      memoryMB: 4096
      processors: 2
    }
    name: '<name>'
    networkProfile: {}
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'Administrator'
      computerName: 'ashvmiminvm'
      linuxConfiguration: {}
      windowsConfiguration: {
        provisionVMAgent: true
        provisionVMConfigAgent: true
      }
    }
    storageProfile: {
      imageReference: '<imageReference>'
      osDisk: {
        osType: 'Windows'
      }
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "hardwareProfile": {
      "value": {
        "memoryMB": 4096,
        "processors": 2
      }
    },
    "name": {
      "value": "<name>"
    },
    "networkProfile": {
      "value": {}
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "Administrator",
        "computerName": "ashvmiminvm",
        "linuxConfiguration": {},
        "windowsConfiguration": {
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true
        }
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": "<imageReference>",
        "osDisk": {
          "osType": "Windows"
        }
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
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param hardwareProfile = {
  memoryMB: 4096
  processors: 2
}
param name = '<name>'
param networkProfile = {}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'Administrator'
  computerName: 'ashvmiminvm'
  linuxConfiguration: {}
  windowsConfiguration: {
    provisionVMAgent: true
    provisionVMConfigAgent: true
  }
}
param storageProfile = {
  imageReference: '<imageReference>'
  osDisk: {
    osType: 'Windows'
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    hardwareProfile: {
      dynamicMemoryConfig: {
        maximumMemoryMB: 8192
        minimumMemoryMB: 512
        targetMemoryBuffer: 20
      }
      memoryMB: 4096
      processors: 2
      vmSize: 'Custom'
    }
    name: '<name>'
    networkProfile: {}
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'Administrator'
      computerName: 'ashvmiwafvm'
      linuxConfiguration: {}
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        provisionVMConfigAgent: true
      }
    }
    storageProfile: {
      imageReference: '<imageReference>'
      osDisk: {
        osType: 'Windows'
      }
    }
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "hardwareProfile": {
      "value": {
        "dynamicMemoryConfig": {
          "maximumMemoryMB": 8192,
          "minimumMemoryMB": 512,
          "targetMemoryBuffer": 20
        },
        "memoryMB": 4096,
        "processors": 2,
        "vmSize": "Custom"
      }
    },
    "name": {
      "value": "<name>"
    },
    "networkProfile": {
      "value": {}
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "Administrator",
        "computerName": "ashvmiwafvm",
        "linuxConfiguration": {},
        "windowsConfiguration": {
          "enableAutomaticUpdates": true,
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true
        }
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": "<imageReference>",
        "osDisk": {
          "osType": "Windows"
        }
      }
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
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param hardwareProfile = {
  dynamicMemoryConfig: {
    maximumMemoryMB: 8192
    minimumMemoryMB: 512
    targetMemoryBuffer: 20
  }
  memoryMB: 4096
  processors: 2
  vmSize: 'Custom'
}
param name = '<name>'
param networkProfile = {}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'Administrator'
  computerName: 'ashvmiwafvm'
  linuxConfiguration: {}
  windowsConfiguration: {
    enableAutomaticUpdates: true
    provisionVMAgent: true
    provisionVMConfigAgent: true
  }
}
param storageProfile = {
  imageReference: '<imageReference>'
  osDisk: {
    osType: 'Windows'
  }
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | Resource ID of the associated custom location. |
| [`hardwareProfile`](#parameter-hardwareprofile) | object | Hardware profile configuration. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`networkProfile`](#parameter-networkprofile) | object | Network profile configuration. |
| [`osProfile`](#parameter-osprofile) | object | OS profile configuration. |
| [`storageProfile`](#parameter-storageprofile) | object | Storage profile configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | HTTP proxy configuration. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityProfile`](#parameter-securityprofile) | object | Security profile configuration. |

### Parameter: `customLocationResourceId`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `hardwareProfile`

Hardware profile configuration.

- Required: Yes
- Type: object

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `networkProfile`

Network profile configuration.

- Required: Yes
- Type: object

### Parameter: `osProfile`

OS profile configuration.

- Required: Yes
- Type: object

### Parameter: `storageProfile`

Storage profile configuration.

- Required: Yes
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `httpProxyConfig`

HTTP proxy configuration.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Reader'`
  - `'User Access Administrator'`
  - `'Role Based Access Control Administrator'`

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

### Parameter: `securityProfile`

Security profile configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      uefiSettings: {
        secureBootEnabled: true
      }
  }
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual machine instance. |
| `resourceGroupName` | string | The resource group of the virtual machine instance. |
| `resourceId` | string | The resource ID of the virtual machine instance. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/hybrid-compute/machine:0.4.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
