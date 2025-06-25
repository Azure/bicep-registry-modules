# Dev Center Gallery `[Microsoft.DevCenter/devcenters/galleries]`

This module deploys a Dev Center Gallery.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevCenter/devcenters/galleries` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/galleries) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryResourceId`](#parameter-galleryresourceid) | string | The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery. |
| [`name`](#parameter-name) | string | It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devcenterName`](#parameter-devcentername) | string | The name of the parent dev center. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devCenterIdentityPrincipalId`](#parameter-devcenteridentityprincipalid) | string | The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically. |

### Parameter: `galleryResourceId`

The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.

- Required: Yes
- Type: string

### Parameter: `name`

It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_".

- Required: Yes
- Type: string

### Parameter: `devcenterName`

The name of the parent dev center. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `devCenterIdentityPrincipalId`

The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Dev Center Gallery. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Gallery was created in. |
| `resourceId` | string | The resource ID of the Dev Center Gallery. |
