# Hosting Environment Custom DNS Suffix Configuration `[Microsoft.Web/hostingEnvironments/configurations]`

This module deploys a Hosting Environment Custom DNS Suffix Configuration.

You can reference the module as follows:
```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment/configuration:<version>' = {
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
| `Microsoft.Web/hostingEnvironments/configurations` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_hostingenvironments_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/hostingEnvironments/configurations)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateUrl`](#parameter-certificateurl) | string | The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | Enable the default custom domain suffix to use for all sites deployed on the ASE. |
| [`keyVaultReferenceIdentity`](#parameter-keyvaultreferenceidentity) | string | The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostingEnvironmentName`](#parameter-hostingenvironmentname) | string | The name of the parent Hosting Environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `certificateUrl`

The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix.

- Required: Yes
- Type: string

### Parameter: `dnsSuffix`

Enable the default custom domain suffix to use for all sites deployed on the ASE.

- Required: Yes
- Type: string

### Parameter: `keyVaultReferenceIdentity`

The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available.

- Required: Yes
- Type: string

### Parameter: `hostingEnvironmentName`

The name of the parent Hosting Environment. Required if the template is used in a standalone deployment.

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
| `name` | string | The name of the configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
