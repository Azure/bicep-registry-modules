# Azure Local Gallery Image `[Microsoft.AzureStackHCI/galleryImages]`

This module imports a prepared customer-provided OS image into Azure Local. It does not build, harden, or patch the source image.

You can reference the module as follows:
```bicep
module galleryImage 'br/public:avm/res/azure-stack-hci/gallery-image:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.AzureStackHCI/galleryImages` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.azurestackhci_galleryimages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-01-01/galleryImages)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/gallery-image:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance imports a prepared customer image with the minimum required parameters and tests unchanged redeployment. Supply an existing Azure Local environment, its Azure region, the source OS type, and a secure image path. Preparing or uploading the source is outside this module.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module galleryImage 'br/public:avm/res/azure-stack-hci/gallery-image:<version>' = {
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    imagePath: '<imagePath>'
    name: 'ashgimin001'
    osType: '<osType>'
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
    "imagePath": {
      "value": "<imagePath>"
    },
    "name": {
      "value": "ashgimin001"
    },
    "osType": {
      "value": "<osType>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param imagePath = '<imagePath>'
param name = 'ashgimin001'
param osType = '<osType>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance exercises optional GA image metadata, storage placement, tags, locks, role assignments, and disabled telemetry, with unchanged redeployment. Supply a prepared Linux Gen2 image compatible with NoCloud and an existing storage container. Run with both local VHDX and Azure Storage page-blob sources to validate both routes; no source image is built by this test.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module galleryImage 'br/public:avm/res/azure-stack-hci/gallery-image:<version>' = {
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    imagePath: '<imagePath>'
    name: 'ashgimax001'
    osType: 'Linux'
    // Non-required parameters
    cloudInitDataSource: 'NoCloud'
    containerResourceId: '<containerResourceId>'
    enableTelemetry: false
    hyperVGeneration: 'V2'
    identifier: {
      offer: 'ExampleLinux'
      publisher: 'ExamplePublisher'
      sku: 'gen2'
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'ashgimax-lock'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
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
      environment: 'validation'
      workload: 'customer-image'
    }
    version: {
      name: '1.0.0'
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
    "imagePath": {
      "value": "<imagePath>"
    },
    "name": {
      "value": "ashgimax001"
    },
    "osType": {
      "value": "Linux"
    },
    // Non-required parameters
    "cloudInitDataSource": {
      "value": "NoCloud"
    },
    "containerResourceId": {
      "value": "<containerResourceId>"
    },
    "enableTelemetry": {
      "value": false
    },
    "hyperVGeneration": {
      "value": "V2"
    },
    "identifier": {
      "value": {
        "offer": "ExampleLinux",
        "publisher": "ExamplePublisher",
        "sku": "gen2"
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "ashgimax-lock"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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
        "environment": "validation",
        "workload": "customer-image"
      }
    },
    "version": {
      "value": {
        "name": "1.0.0"
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
using 'br/public:avm/res/azure-stack-hci/gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param imagePath = '<imagePath>'
param name = 'ashgimax001'
param osType = 'Linux'
// Non-required parameters
param cloudInitDataSource = 'NoCloud'
param containerResourceId = '<containerResourceId>'
param enableTelemetry = false
param hyperVGeneration = 'V2'
param identifier = {
  offer: 'ExampleLinux'
  publisher: 'ExamplePublisher'
  sku: 'gen2'
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'ashgimax-lock'
}
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Reader'
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
  environment: 'validation'
  workload: 'customer-image'
}
param version = {
  name: '1.0.0'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance imports a prepared Gen2 image using secure source delivery, explicit existing storage placement, and read-only image access, then tests unchanged redeployment. Supply an existing Azure Local environment, a suitable prepared image, and its storage container. Importing does not harden the guest OS.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module galleryImage 'br/public:avm/res/azure-stack-hci/gallery-image:<version>' = {
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    imagePath: '<imagePath>'
    name: 'ashgiwaf001'
    osType: '<osType>'
    // Non-required parameters
    containerResourceId: '<containerResourceId>'
    hyperVGeneration: 'V2'
    location: '<location>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure Stack HCI VM Reader'
      }
    ]
    tags: {
      workload: 'customer-image'
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
    "imagePath": {
      "value": "<imagePath>"
    },
    "name": {
      "value": "ashgiwaf001"
    },
    "osType": {
      "value": "<osType>"
    },
    // Non-required parameters
    "containerResourceId": {
      "value": "<containerResourceId>"
    },
    "hyperVGeneration": {
      "value": "V2"
    },
    "location": {
      "value": "<location>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Azure Stack HCI VM Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "workload": "customer-image"
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
using 'br/public:avm/res/azure-stack-hci/gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param imagePath = '<imagePath>'
param name = 'ashgiwaf001'
param osType = '<osType>'
// Non-required parameters
param containerResourceId = '<containerResourceId>'
param hyperVGeneration = 'V2'
param location = '<location>'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure Stack HCI VM Reader'
  }
]
param tags = {
  workload: 'customer-image'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | Resource ID of the Azure Local custom location on which to import the image. |
| [`imagePath`](#parameter-imagepath) | securestring | Path to a prepared source image: a VHDX on a cluster shared volume accessible to the Azure Local instance, or an HTTPS SAS URL for a VHD/VHDX page blob in Azure Storage. This is not a path on the deployment client. Treat the entire value as a secret; do not log it or place it in outputs. Image preparation, activation, upload, and SAS generation are caller responsibilities. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`osType`](#parameter-ostype) | string | Operating system of the prepared source image. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudInitDataSource`](#parameter-cloudinitdatasource) | string | Cloud-init data source supported by the prepared image, such as NoCloud or Azure. Omit when not applicable. |
| [`containerResourceId`](#parameter-containerresourceid) | string | Resource ID of an existing Azure Local storage container associated with the same custom location. Use the storage-container module resourceId output, not its filesystem path. When omitted, Azure Local selects the storage placement. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | Hyper-V generation of the prepared source image. Use V1 or V2 to match the source; VHDX sources require V2. |
| [`identifier`](#parameter-identifier) | object | Image identifier containing publisher, offer, and SKU. This describes the customer image; it does not select a Marketplace image. |
| [`location`](#parameter-location) | string | Azure region of the associated custom location. Defaults to the resource group location. |
| [`lock`](#parameter-lock) | object | The lock settings of the resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`version`](#parameter-version) | object | Gallery image version metadata. This does not import an Azure Compute Gallery version or guarantee that changing the source or version in place is supported. Image properties may be creation-only; validate unchanged redeployment before relying on idempotency. |

### Parameter: `customLocationResourceId`

Resource ID of the Azure Local custom location on which to import the image.

- Required: Yes
- Type: string

### Parameter: `imagePath`

Path to a prepared source image: a VHDX on a cluster shared volume accessible to the Azure Local instance, or an HTTPS SAS URL for a VHD/VHDX page blob in Azure Storage. This is not a path on the deployment client. Treat the entire value as a secret; do not log it or place it in outputs. Image preparation, activation, upload, and SAS generation are caller responsibilities.

- Required: Yes
- Type: securestring

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `osType`

Operating system of the prepared source image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `cloudInitDataSource`

Cloud-init data source supported by the prepared image, such as NoCloud or Azure. Omit when not applicable.

- Required: No
- Type: string

### Parameter: `containerResourceId`

Resource ID of an existing Azure Local storage container associated with the same custom location. Use the storage-container module resourceId output, not its filesystem path. When omitted, Azure Local selects the storage placement.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hyperVGeneration`

Hyper-V generation of the prepared source image. Use V1 or V2 to match the source; VHDX sources require V2.

- Required: No
- Type: string
- Default: `'V2'`

### Parameter: `identifier`

Image identifier containing publisher, offer, and SKU. This describes the customer image; it does not select a Marketplace image.

- Required: No
- Type: object

### Parameter: `location`

Azure region of the associated custom location. Defaults to the resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the resource.

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Stack HCI Administrator'`
  - `'Azure Stack HCI VM Contributor'`
  - `'Azure Stack HCI VM Reader'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `version`

Gallery image version metadata. This does not import an Azure Compute Gallery version or guarantee that changing the source or version in place is supported. Image properties may be creation-only; validate unchanged redeployment before relying on idempotency.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the gallery image was deployed into. |
| `name` | string | The name of the gallery image. |
| `resourceGroupName` | string | The resource group the gallery image was deployed into. |
| `resourceId` | string | The resource ID of the gallery image. Pass this to the virtual-machine-instance module storageProfile.imageReference.id. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
