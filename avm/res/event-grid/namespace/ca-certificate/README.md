# Eventgrid Namespace CA Certificates `[Microsoft.EventGrid/namespaces/caCertificates]`

This module deploys an Eventgrid Namespace CA Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/namespaces/caCertificates` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/caCertificates) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`encodedCertificate`](#parameter-encodedcertificate) | string | Base64 encoded PEM (Privacy Enhanced Mail) format certificate data. |
| [`name`](#parameter-name) | string | Name of the CA certificate. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description for the CA Certificate resource. |

### Parameter: `encodedCertificate`

Base64 encoded PEM (Privacy Enhanced Mail) format certificate data.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the CA certificate.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description for the CA Certificate resource.

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the CA certificate. |
| `resourceGroupName` | string | The name of the resource group the CA certificate was created in. |
| `resourceId` | string | The resource ID of the CA certificate. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
