# Eventgrid Namespace CA Certificates `[Microsoft.EventGrid/namespaces/caCertificates]`

This module deploys an Eventgrid Namespace CA Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
