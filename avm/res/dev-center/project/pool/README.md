# Dev Center Project Pool `[Microsoft.DevCenter/projects/pools]`

This module deploys a Dev Center Project Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevCenter/projects/pools` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools) |
| `Microsoft.DevCenter/projects/pools/schedules` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools/schedules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionName`](#parameter-devboxdefinitionname) | string | Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev"). |
| [`localAdministrator`](#parameter-localadministrator) | string | Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box. |
| [`name`](#parameter-name) | string | The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes. |
| [`virtualNetworkType`](#parameter-virtualnetworktype) | string | Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinition`](#parameter-devboxdefinition) | object | A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value". |
| [`managedVirtualNetworkRegion`](#parameter-managedvirtualnetworkregion) | string | The region of the managed virtual network. Required if virtualNetworkType is "Managed". |
| [`networkConnectionName`](#parameter-networkconnectionname) | string | Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed". |
| [`projectName`](#parameter-projectname) | string | The name of the parent dev center project. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionType`](#parameter-devboxdefinitiontype) | string | Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. |
| [`displayName`](#parameter-displayname) | string | The display name of the pool. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`schedule`](#parameter-schedule) | object | The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration. |
| [`singleSignOnStatus`](#parameter-singlesignonstatus) | string | Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes. |
| [`stopOnDisconnect`](#parameter-stopondisconnect) | object | Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects. |
| [`stopOnNoConnect`](#parameter-stoponnoconnect) | object | Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects. |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the pool. |

### Parameter: `devBoxDefinitionName`

Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev").

- Required: Yes
- Type: string

### Parameter: `localAdministrator`

Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `name`

The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkType`

Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Managed'
    'Unmanaged'
  ]
  ```

### Parameter: `devBoxDefinition`

A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageReferenceResourceId`](#parameter-devboxdefinitionimagereferenceresourceid) | string | The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}". |
| [`sku`](#parameter-devboxdefinitionsku) | object | The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs. |

### Parameter: `devBoxDefinition.imageReferenceResourceId`

The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}".

- Required: Yes
- Type: string

### Parameter: `devBoxDefinition.sku`

The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-devboxdefinitionskuname) | string | The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-devboxdefinitionskucapacity) | int | If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. |
| [`family`](#parameter-devboxdefinitionskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2". |
| [`size`](#parameter-devboxdefinitionskusize) | string | The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. |

### Parameter: `devBoxDefinition.sku.name`

The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.

- Required: Yes
- Type: string

### Parameter: `devBoxDefinition.sku.capacity`

If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.

- Required: No
- Type: int

### Parameter: `devBoxDefinition.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".

- Required: No
- Type: string

### Parameter: `devBoxDefinition.sku.size`

The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.

- Required: No
- Type: string

### Parameter: `managedVirtualNetworkRegion`

The region of the managed virtual network. Required if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `networkConnectionName`

Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `projectName`

The name of the parent dev center project. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `devBoxDefinitionType`

Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly.

- Required: No
- Type: string
- Default: `'Reference'`
- Allowed:
  ```Bicep
  [
    'Reference'
    'Value'
  ]
  ```

### Parameter: `displayName`

The display name of the pool.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `schedule`

The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-schedulestate) | string | Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled. |
| [`time`](#parameter-scheduletime) | string | The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM. |
| [`timeZone`](#parameter-scheduletimezone) | string | The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central". |

### Parameter: `schedule.state`

Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `schedule.time`

The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.

- Required: Yes
- Type: string

### Parameter: `schedule.timeZone`

The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".

- Required: Yes
- Type: string

### Parameter: `singleSignOnStatus`

Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `stopOnDisconnect`

Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-stopondisconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box once disconnect is detected. |
| [`status`](#parameter-stopondisconnectstatus) | string | Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled. |

### Parameter: `stopOnDisconnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box once disconnect is detected.

- Required: Yes
- Type: int

### Parameter: `stopOnDisconnect.status`

Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `stopOnNoConnect`

Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-stoponnoconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box if no connection is made. |
| [`status`](#parameter-stoponnoconnectstatus) | string | Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed. |

### Parameter: `stopOnNoConnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box if no connection is made.

- Required: Yes
- Type: int

### Parameter: `stopOnNoConnect.status`

Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `tags`

Resource tags to apply to the pool.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the pool. |
| `resourceGroupName` | string | The name of the resource group the pool was created in. |
| `resourceId` | string | The resource ID of the pool. |
