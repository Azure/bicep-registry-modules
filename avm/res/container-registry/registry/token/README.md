# Container Registries Tokens `[Microsoft.ContainerRegistry/registries/tokens]`

Deploys an Azure Container Registry (ACR) Token.

You can reference the module as follows:
```bicep
module registry 'br/public:avm/res/container-registry/registry/token:<version>' = {
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
| `Microsoft.ContainerRegistry/registries/tokens` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tokens.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/tokens)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the token. |
| [`scopeMapResourceId`](#parameter-scopemapresourceid) | string | The resource ID of the scope map to which the token will be associated with. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-credentials) | object | The credentials associated with the token for authentication. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`status`](#parameter-status) | string | The status of the token. Default is enabled. |

### Parameter: `name`

The name of the token.

- Required: Yes
- Type: string

### Parameter: `scopeMapResourceId`

The resource ID of the scope map to which the token will be associated with.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentials`

The credentials associated with the token for authentication.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `status`

The status of the token. Default is enabled.

- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the token. |
| `resourceGroupName` | string | The name of the resource group the token was created in. |
| `resourceId` | string | The resource ID of the token. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
