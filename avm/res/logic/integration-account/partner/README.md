# Integration Account Partners `[Microsoft.Logic/integrationAccounts/partners]`

This module deploys an Integration Account Partner.

You can reference the module as follows:
```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account/partner:<version>' = {
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
| `Microsoft.Logic/integrationAccounts/partners` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_partners.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/partners)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The Name of the partner resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`b2b`](#parameter-b2b) | object | B2B partner content settings. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) | object | The metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

The Name of the partner resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `b2b`

B2B partner content settings.

- Required: No
- Type: object

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

The metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-metadata>any_other_property<) | string | A metadata key-value pair. |

### Parameter: `metadata.>Any_other_property<`

A metadata key-value pair.

- Required: No
- Type: string

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account partner. |
| `resourceGroupName` | string | The resource group the integration account partner was deployed into. |
| `resourceId` | string | The resource ID of the integration account partner. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
