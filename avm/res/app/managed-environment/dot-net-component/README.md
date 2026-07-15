# App ManagedEnvironments DotNetComponents `[Microsoft.App/managedEnvironments/dotNetComponents]`

This module deploys an App Managed Environment .NET Component.

You can reference the module as follows:
```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment/dot-net-component:<version>' = {
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
| `Microsoft.App/managedEnvironments/dotNetComponents` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_dotnetcomponents.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/dotNetComponents)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`componentType`](#parameter-componenttype) | string | Type of the .NET Component. |
| [`name`](#parameter-name) | string | Name of the .NET Component. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedEnvironmentName`](#parameter-managedenvironmentname) | string | The name of the parent app managed environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurations`](#parameter-configurations) | array | List of .NET Components configuration properties. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`serviceBinds`](#parameter-servicebinds) | array | List of .NET Components that are bound to the .NET component. |

### Parameter: `componentType`

Type of the .NET Component.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the .NET Component.

- Required: Yes
- Type: string

### Parameter: `managedEnvironmentName`

The name of the parent app managed environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `configurations`

List of .NET Components configuration properties.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`propertyName`](#parameter-configurationspropertyname) | string | The name of the property. |
| [`value`](#parameter-configurationsvalue) | string | The value of the property. |

### Parameter: `configurations.propertyName`

The name of the property.

- Required: No
- Type: string

### Parameter: `configurations.value`

The value of the property.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `serviceBinds`

List of .NET Components that are bound to the .NET component.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-servicebindsname) | string | Name of the service bind. |
| [`serviceId`](#parameter-servicebindsserviceid) | string | Resource id of the target service. |

### Parameter: `serviceBinds.name`

Name of the service bind.

- Required: No
- Type: string

### Parameter: `serviceBinds.serviceId`

Resource id of the target service.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the .NET Component. |
| `resourceGroupName` | string | The resource group the .NET Component was deployed into. |
| `resourceId` | string | The resource ID of the .NET Component. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
