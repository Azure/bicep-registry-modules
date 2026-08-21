# App ManagedEnvironments Certificates `[Microsoft.App/managedEnvironments/storages]`

This module deploys a App Managed Environment Certificate.

You can reference the module as follows:
```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment/storage:<version>' = {
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
| `Microsoft.App/managedEnvironments/storages` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/storages)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-accessmode) | string | The access mode for the storage. |
| [`kind`](#parameter-kind) | string | Type of storage: "SMB" or "NFS". |
| [`name`](#parameter-name) | string | The name of the file share. |
| [`storageAccountName`](#parameter-storageaccountname) | string | Storage account name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedEnvironmentName`](#parameter-managedenvironmentname) | string | The name of the parent app managed environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `accessMode`

The access mode for the storage.

- Required: Yes
- Type: string

### Parameter: `kind`

Type of storage: "SMB" or "NFS".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `name`

The name of the file share.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

Storage account name.

- Required: Yes
- Type: string

### Parameter: `managedEnvironmentName`

The name of the parent app managed environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the file share. |
| `resourceGroupName` | string | The resource group the file share was deployed into. |
| `resourceId` | string | The resource ID of the file share. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
