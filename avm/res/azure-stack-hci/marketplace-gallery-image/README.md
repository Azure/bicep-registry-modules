# Azure Stack HCI Marketplace Gallery Image `[Microsoft.AzureStackHCI/marketplaceGalleryImages]`

This module deploys an Azure Stack HCI Marketplace Gallery Image.

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
| `Microsoft.AzureStackHCI/marketplaceGalleryImages` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2025-04-01-preview/marketplaceGalleryImages) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

<details>

<summary>via Bicep module</summary>

```bicep
module marketplaceGalleryImage 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>' = {
  name: 'marketplaceGalleryImageDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    identifier: {
      offer: 'WindowsServer'
      publisher: 'Microsoft'
      sku: '2022-Datacenter'
    }
    name: 'ashmgiminmarketplacegalleryimage'
    osType: 'Windows'
    // Non-required parameters
    hyperVGeneration: 'V2'
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
    "identifier": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "Microsoft",
        "sku": "2022-Datacenter"
      }
    },
    "name": {
      "value": "ashmgiminmarketplacegalleryimage"
    },
    "osType": {
      "value": "Windows"
    },
    // Non-required parameters
    "hyperVGeneration": {
      "value": "V2"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param identifier = {
  offer: 'WindowsServer'
  publisher: 'Microsoft'
  sku: '2022-Datacenter'
}
param name = 'ashmgiminmarketplacegalleryimage'
param osType = 'Windows'
// Non-required parameters
param hyperVGeneration = 'V2'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

<details>

<summary>via Bicep module</summary>

```bicep
module marketplaceGalleryImage 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>' = {
  name: 'marketplaceGalleryImageDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    identifier: {
      offer: 'WindowsServer'
      publisher: 'Microsoft'
      sku: '2022-Datacenter'
    }
    name: 'ashmgiwafmarketplacegalleryimage'
    osType: 'Windows'
    // Non-required parameters
    hyperVGeneration: 'V2'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    version: {
      name: '1.0.0'
      properties: {
        storageProfile: {
          osDiskImage: {}
        }
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
    "identifier": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "Microsoft",
        "sku": "2022-Datacenter"
      }
    },
    "name": {
      "value": "ashmgiwafmarketplacegalleryimage"
    },
    "osType": {
      "value": "Windows"
    },
    // Non-required parameters
    "hyperVGeneration": {
      "value": "V2"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "version": {
      "value": {
        "name": "1.0.0",
        "properties": {
          "storageProfile": {
            "osDiskImage": {}
          }
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
using 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param identifier = {
  offer: 'WindowsServer'
  publisher: 'Microsoft'
  sku: '2022-Datacenter'
}
param name = 'ashmgiwafmarketplacegalleryimage'
param osType = 'Windows'
// Non-required parameters
param hyperVGeneration = 'V2'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Reader'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param version = {
  name: '1.0.0'
  properties: {
    storageProfile: {
      osDiskImage: {}
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
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | The custom location ID. |
| [`identifier`](#parameter-identifier) | object | Image identifier information. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`osType`](#parameter-ostype) | string | Operating system type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudInitDataSource`](#parameter-cloudinitdatasource) | string | Cloud init data source. |
| [`containerId`](#parameter-containerid) | string | Container ID for the image. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | Hyper-V generation for the image. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags for the marketplace gallery image. |
| [`version`](#parameter-version) | object | Version information for the image. |

### Parameter: `customLocationResourceId`

The custom location ID.

- Required: Yes
- Type: string

### Parameter: `identifier`

Image identifier information.

- Required: Yes
- Type: object

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `osType`

Operating system type.

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

Cloud init data source.

- Required: No
- Type: string

### Parameter: `containerId`

Container ID for the image.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hyperVGeneration`

Hyper-V generation for the image.

- Required: No
- Type: string
- Default: `'V2'`
- Allowed:
  ```Bicep
  [
    'V1'
    'V2'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

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

Tags for the marketplace gallery image.

- Required: No
- Type: object

### Parameter: `version`

Version information for the image.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the marketplace gallery image. |
| `name` | string | The name of the marketplace gallery image. |
| `resourceGroupName` | string | The resource group of the marketplace gallery image. |
| `resourceId` | string | The resource ID of the marketplace gallery image. |

## Cross-referenced modules

This module references the following modules:

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There may also be some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
