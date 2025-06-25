# Dev Center DevBox Definition `[Microsoft.DevCenter/devcenters/devboxdefinitions]`

This module deploys a Dev Center DevBox Definition.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevCenter/devcenters/devboxdefinitions` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/devboxdefinitions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageResourceId`](#parameter-imageresourceid) | string | The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements. |
| [`name`](#parameter-name) | string | The name of the DevBox definition. |
| [`sku`](#parameter-sku) | object | The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devcenterName`](#parameter-devcentername) | string | The name of the parent dev center. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hibernateSupport`](#parameter-hibernatesupport) | string | Settings for hibernation support. |
| [`location`](#parameter-location) | string | Location for the DevBox definition. Defaults to resource group location. |
| [`tags`](#parameter-tags) | object | Tags for the DevBox definition. |

### Parameter: `imageResourceId`

The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the DevBox definition.

- Required: Yes
- Type: string

### Parameter: `sku`

The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-skuname) | string | The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-skucapacity) | int | If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. |
| [`family`](#parameter-skufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2". |
| [`size`](#parameter-skusize) | string | The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. |

### Parameter: `sku.name`

The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.

- Required: Yes
- Type: string

### Parameter: `sku.capacity`

If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.

- Required: No
- Type: int

### Parameter: `sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".

- Required: No
- Type: string

### Parameter: `sku.size`

The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.

- Required: No
- Type: string

### Parameter: `devcenterName`

The name of the parent dev center. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `hibernateSupport`

Settings for hibernation support.

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

### Parameter: `location`

Location for the DevBox definition. Defaults to resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags for the DevBox definition.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the DevBox Definition was deployed into. |
| `name` | string | The name of the DevBox Definition. |
| `resourceGroupName` | string | The name of the resource group the DevBox Definition was created in. |
| `resourceId` | string | The resource ID of the DevBox Definition. |
