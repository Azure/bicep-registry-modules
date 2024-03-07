# Eventgrid Namespace Clients `[Microsoft.EventGrid/namespaces/clients]`

This module deploys an Eventgrid Namespace Client.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
