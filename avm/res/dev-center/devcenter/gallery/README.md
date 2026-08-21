# Dev Center Gallery `[Microsoft.DevCenter/devcenters/galleries]`

This module deploys a Dev Center Gallery.

You can reference the module as follows:
```bicep
module devcenter 'br/public:avm/res/dev-center/devcenter/gallery:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DevCenter/devcenters/galleries` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devcenter_devcenters_galleries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/galleries)</li></ul> |

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
| [`devCenterIdentityPrincipalId`](#parameter-devcenteridentityprincipalid) | string | The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically. Note that the identity performing the deployment must have permissions to perform role assignments on the resource group of the gallery to assign the role, otherwise the deployment will fail. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

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

The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically. Note that the identity performing the deployment must have permissions to perform role assignments on the resource group of the gallery to assign the role, otherwise the deployment will fail.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Dev Center Gallery. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Gallery was created in. |
| `resourceId` | string | The resource ID of the Dev Center Gallery. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
