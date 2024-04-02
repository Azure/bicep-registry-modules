# Hosting Environment Custom DNS Suffix Configuration `[Microsoft.Web/hostingEnvironments/configurations]`

This module deploys a Hosting Environment Custom DNS Suffix Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
