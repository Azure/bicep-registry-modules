# Integration Account Assemblies `[Microsoft.Logic/integrationAccounts/assemblies]`

This module deploys an Integration Account Assembly.

You can reference the module as follows:
```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account/assembly:<version>' = {
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
| `Microsoft.Logic/integrationAccounts/assemblies` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_assemblies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/assemblies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assemblyName`](#parameter-assemblyname) | string | The assembly name. |
| [`content`](#parameter-content) | securestring | The Base64-encoded assembly content. |
| [`name`](#parameter-name) | string | The Name of the assembly resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The assembly content type. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) |  | The assembly metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `assemblyName`

The assembly name.

- Required: Yes
- Type: string

### Parameter: `content`

The Base64-encoded assembly content.

- Required: Yes
- Type: securestring

### Parameter: `name`

The Name of the assembly resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The assembly content type.

- Required: No
- Type: string
- Default: `'application/octet-stream'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The assembly metadata.

- Required: No
- Type: 

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account assembly. |
| `resourceGroupName` | string | The resource group the integration account assembly was deployed into. |
| `resourceId` | string | The resource ID of the integration account assembly. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
