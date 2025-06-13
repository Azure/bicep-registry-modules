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
| `Microsoft.AzureStackHCI/marketplaceGalleryImages` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-10-01-preview/marketplaceGalleryImages) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>`.

- [Deploy Aks Arc in default configuration](#example-1-deploy-aks-arc-in-default-configuration)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Deploy Aks Arc in default configuration_

This test deploys a marketplace gallery image.


<details>

<summary>via Bicep module</summary>

```bicep
module marketplaceGalleryImage 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>' = {
  name: 'marketplaceGalleryImageDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    marketplaceGalleryImageProperties: {
      containerId: '<containerId>'
      hyperVGeneration: 'V2'
      identifier: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2022-datacenter-azure-edition'
      }
      osType: 'Windows'
      version: {
        name: '20348.2461.240510'
      }
    }
    name: 'ashgimin1'
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
    "marketplaceGalleryImageProperties": {
      "value": {
        "containerId": "<containerId>",
        "hyperVGeneration": "V2",
        "identifier": {
          "offer": "WindowsServer",
          "publisher": "MicrosoftWindowsServer",
          "sku": "2022-datacenter-azure-edition"
        },
        "osType": "Windows",
        "version": {
          "name": "20348.2461.240510"
        }
      }
    },
    "name": {
      "value": "ashgimin1"
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
param marketplaceGalleryImageProperties = {
  containerId: '<containerId>'
  hyperVGeneration: 'V2'
  identifier: {
    offer: 'WindowsServer'
    publisher: 'MicrosoftWindowsServer'
    sku: '2022-datacenter-azure-edition'
  }
  osType: 'Windows'
  version: {
    name: '20348.2461.240510'
  }
}
param name = 'ashgimin1'
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
    marketplaceGalleryImageProperties: {
      containerId: '<containerId>'
      hyperVGeneration: 'V2'
      identifier: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2022-datacenter-azure-edition'
      }
      osType: 'Windows'
      version: {
        name: '20348.2461.240510'
        properties: {
          storageProfile: {
            osDiskImage: {}
          }
        }
      }
    }
    name: 'ashgiwaf1'
    // Non-required parameters
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
    "marketplaceGalleryImageProperties": {
      "value": {
        "containerId": "<containerId>",
        "hyperVGeneration": "V2",
        "identifier": {
          "offer": "WindowsServer",
          "publisher": "MicrosoftWindowsServer",
          "sku": "2022-datacenter-azure-edition"
        },
        "osType": "Windows",
        "version": {
          "name": "20348.2461.240510",
          "properties": {
            "storageProfile": {
              "osDiskImage": {}
            }
          }
        }
      }
    },
    "name": {
      "value": "ashgiwaf1"
    },
    // Non-required parameters
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
using 'br/public:avm/res/azure-stack-hci/marketplace-gallery-image:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param marketplaceGalleryImageProperties = {
  containerId: '<containerId>'
  hyperVGeneration: 'V2'
  identifier: {
    offer: 'WindowsServer'
    publisher: 'MicrosoftWindowsServer'
    sku: '2022-datacenter-azure-edition'
  }
  osType: 'Windows'
  version: {
    name: '20348.2461.240510'
    properties: {
      storageProfile: {
        osDiskImage: {}
      }
    }
  }
}
param name = 'ashgiwaf1'
// Non-required parameters
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
| [`marketplaceGalleryImageProperties`](#parameter-marketplacegalleryimageproperties) | object | The properties of the marketplace gallery image. |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `customLocationResourceId`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `marketplaceGalleryImageProperties`

The properties of the marketplace gallery image.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hyperVGeneration`](#parameter-marketplacegalleryimagepropertieshypervgeneration) | string | The container URI. |
| [`identifier`](#parameter-marketplacegalleryimagepropertiesidentifier) | object | The identifier of the gallery image. |
| [`osType`](#parameter-marketplacegalleryimagepropertiesostype) | string | The OS type of the gallery image. |
| [`version`](#parameter-marketplacegalleryimagepropertiesversion) | object | The version of the gallery image. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudInitDataSource`](#parameter-marketplacegalleryimagepropertiescloudinitdatasource) | string | The container ID. |
| [`containerId`](#parameter-marketplacegalleryimagepropertiescontainerid) | string | The container ID. |

### Parameter: `marketplaceGalleryImageProperties.hyperVGeneration`

The container URI.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'V1'
    'V2'
  ]
  ```

### Parameter: `marketplaceGalleryImageProperties.identifier`

The identifier of the gallery image.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`offer`](#parameter-marketplacegalleryimagepropertiesidentifieroffer) | string | The name of the gallery image definition offer. |
| [`publisher`](#parameter-marketplacegalleryimagepropertiesidentifierpublisher) | string | The name of the gallery image definition publisher. |
| [`sku`](#parameter-marketplacegalleryimagepropertiesidentifiersku) | string | The name of the gallery image definition SKU. |

### Parameter: `marketplaceGalleryImageProperties.identifier.offer`

The name of the gallery image definition offer.

- Required: Yes
- Type: string

### Parameter: `marketplaceGalleryImageProperties.identifier.publisher`

The name of the gallery image definition publisher.

- Required: Yes
- Type: string

### Parameter: `marketplaceGalleryImageProperties.identifier.sku`

The name of the gallery image definition SKU.

- Required: Yes
- Type: string

### Parameter: `marketplaceGalleryImageProperties.osType`

The OS type of the gallery image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `marketplaceGalleryImageProperties.version`

The version of the gallery image.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-marketplacegalleryimagepropertiesversionname) | string | This is the version of the gallery image. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`properties`](#parameter-marketplacegalleryimagepropertiesversionproperties) | object | Describes the properties of a gallery image version. |

### Parameter: `marketplaceGalleryImageProperties.version.name`

This is the version of the gallery image.

- Required: Yes
- Type: string

### Parameter: `marketplaceGalleryImageProperties.version.properties`

Describes the properties of a gallery image version.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageProfile`](#parameter-marketplacegalleryimagepropertiesversionpropertiesstorageprofile) | object | This is the storage profile of a Gallery Image Version. |

### Parameter: `marketplaceGalleryImageProperties.version.properties.storageProfile`

This is the storage profile of a Gallery Image Version.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`osDiskImage`](#parameter-marketplacegalleryimagepropertiesversionpropertiesstorageprofileosdiskimage) | object | This is the OS disk image. |

### Parameter: `marketplaceGalleryImageProperties.version.properties.storageProfile.osDiskImage`

This is the OS disk image.

- Required: Yes
- Type: object

### Parameter: `marketplaceGalleryImageProperties.cloudInitDataSource`

The container ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Azure'
    'NoCloud'
  ]
  ```

### Parameter: `marketplaceGalleryImageProperties.containerId`

The container ID.

- Required: No
- Type: string

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

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
  - `'User Access Administrator'`
  - `'Role Based Access Control Administrator (Preview)'`

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
| `location` | string | The location of the marketplace gallery images. |
| `name` | string | The name of the marketplace gallery images. |
| `resourceGroupName` | string | The resource group of the marketplace gallery images. |
| `resourceId` | string | The resource ID of the marketplace gallery images. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
