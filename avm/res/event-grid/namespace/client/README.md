# Eventgrid Namespace Clients `[Microsoft.EventGrid/namespaces/clients]`

This module deploys an Eventgrid Namespace Client.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/namespaces/clients` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/clients) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Client. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientCertificateAuthenticationAllowedThumbprints`](#parameter-clientcertificateauthenticationallowedthumbprints) | array | The list of thumbprints that are allowed during client authentication. Required if the clientCertificateAuthenticationValidationSchema is 'ThumbprintMatch'. |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-attributes) | object | Attributes for the client. Supported values are int, bool, string, string[]. |
| [`authenticationName`](#parameter-authenticationname) | string | The name presented by the client for authentication. The default value is the name of the resource. |
| [`clientCertificateAuthenticationValidationSchema`](#parameter-clientcertificateauthenticationvalidationschema) | string | The validation scheme used to authenticate the client. |
| [`description`](#parameter-description) | string | Description of the Client resource. |
| [`state`](#parameter-state) | string | Indicates if the client is enabled or not. |

### Parameter: `name`

Name of the Client.

- Required: Yes
- Type: string

### Parameter: `clientCertificateAuthenticationAllowedThumbprints`

The list of thumbprints that are allowed during client authentication. Required if the clientCertificateAuthenticationValidationSchema is 'ThumbprintMatch'.

- Required: No
- Type: array

### Parameter: `namespaceName`

The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `attributes`

Attributes for the client. Supported values are int, bool, string, string[].

- Required: No
- Type: object

### Parameter: `authenticationName`

The name presented by the client for authentication. The default value is the name of the resource.

- Required: No
- Type: string

### Parameter: `clientCertificateAuthenticationValidationSchema`

The validation scheme used to authenticate the client.

- Required: No
- Type: string
- Default: `'SubjectMatchesAuthenticationName'`
- Allowed:
  ```Bicep
  [
    'DnsMatchesAuthenticationName'
    'EmailMatchesAuthenticationName'
    'IpMatchesAuthenticationName'
    'SubjectMatchesAuthenticationName'
    'ThumbprintMatch'
    'UriMatchesAuthenticationName'
  ]
  ```

### Parameter: `description`

Description of the Client resource.

- Required: No
- Type: string

### Parameter: `state`

Indicates if the client is enabled or not.

- Required: No
- Type: string
- Default: `'Enabled'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Client. |
| `resourceGroupName` | string | The name of the resource group the Client was created in. |
| `resourceId` | string | The resource ID of the Client. |
