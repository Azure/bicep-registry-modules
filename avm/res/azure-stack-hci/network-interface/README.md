# Azure Stack HCI Network Interface `[Microsoft.AzureStackHCI/networkInterfaces]`

This module deploys an Azure Stack HCI network interface.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/networkInterfaces` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-01-01/networkInterfaces) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/network-interface:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br/public:avm/res/azure-stack-hci/network-interface:<version>' = {
  name: 'networkInterfaceDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    ipConfigurations: [
      {
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    name: 'ashniminnetworkinterface'
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
    "ipConfigurations": {
      "value": [
        {
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "name": {
      "value": "ashniminnetworkinterface"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/network-interface:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param ipConfigurations = [
  {
    properties: {
      subnet: {
        id: '<id>'
      }
    }
  }
]
param name = 'ashniminnetworkinterface'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br/public:avm/res/azure-stack-hci/network-interface:<version>' = {
  name: 'networkInterfaceDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    ipConfigurations: [
      {
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    name: 'ashniwafnetworkinterface'
    // Non-required parameters
    dnsServers: [
      '172.20.0.1'
    ]
    enableTelemetry: true
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "ipConfigurations": {
      "value": [
        {
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "name": {
      "value": "ashniwafnetworkinterface"
    },
    // Non-required parameters
    "dnsServers": {
      "value": [
        "172.20.0.1"
      ]
    },
    "enableTelemetry": {
      "value": true
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
using 'br/public:avm/res/azure-stack-hci/network-interface:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param ipConfigurations = [
  {
    properties: {
      subnet: {
        id: '<id>'
      }
    }
  }
]
param name = 'ashniwafnetworkinterface'
// Non-required parameters
param dnsServers = [
  '172.20.0.1'
]
param enableTelemetry = true
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | Resource ID of the associated custom location. |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | A list of IPConfigurations of the network interface. |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsServers`](#parameter-dnsservers) | array | DNS servers array for NIC. These are only applied during NIC creation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `customLocationResourceId`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations`

A list of IPConfigurations of the network interface.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`properties`](#parameter-ipconfigurationsproperties) | object | InterfaceIPConfigurationPropertiesFormat properties of IP configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-ipconfigurationsname) | string | The name of the resource that is unique within a resource group. This name can be used to access the resource. |

### Parameter: `ipConfigurations.properties`

InterfaceIPConfigurationPropertiesFormat properties of IP configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnet`](#parameter-ipconfigurationspropertiessubnet) | object | Name of Subnet bound to the IP configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateIPAddress`](#parameter-ipconfigurationspropertiesprivateipaddress) | string | Private IP address of the IP configuration. |

### Parameter: `ipConfigurations.properties.subnet`

Name of Subnet bound to the IP configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationspropertiessubnetid) | string | The ARM ID for a Logical Network. |

### Parameter: `ipConfigurations.properties.subnet.id`

The ARM ID for a Logical Network.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.properties.privateIPAddress`

Private IP address of the IP configuration.

- Required: No
- Type: string

### Parameter: `ipConfigurations.name`

The name of the resource that is unique within a resource group. This name can be used to access the resource.

- Required: No
- Type: string

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `dnsServers`

DNS servers array for NIC. These are only applied during NIC creation.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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
  - `'Owner'`
  - `'Reader'`
  - `'Azure Stack HCI VM Contributor'`
  - `'Azure Stack HCI VM Reader'`
  - `'Azure Stack HCI Administrator'`

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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the resource. |
| `resourceGroupName` | string | The resource group name of the resource. |
| `resourceId` | string | The resource ID of the resource. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
