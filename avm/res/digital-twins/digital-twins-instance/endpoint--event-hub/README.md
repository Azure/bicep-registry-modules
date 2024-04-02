# Digital Twins Instance EventHub Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance EventHub Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionStringPrimaryKey`](#parameter-connectionstringprimarykey) | securestring | PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased". |
| [`digitalTwinInstanceName`](#parameter-digitaltwininstancename) | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authenticationType`](#parameter-authenticationtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified. |
| [`connectionStringSecondaryKey`](#parameter-connectionstringsecondarykey) | securestring | SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Only used if the `authenticationType` is "KeyBased". |
| [`deadLetterSecret`](#parameter-deadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-deadletteruri) | string | Dead letter storage URL for identity-based authentication. |
| [`endpointUri`](#parameter-endpointuri) | string | The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://' (i.e. sb://xyz.servicebus.windows.net). |
| [`entityPath`](#parameter-entitypath) | string | The EventHub name in the EventHub namespace for identity-based authentication. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource.  Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`name`](#parameter-name) | string | The name of the Digital Twin Endpoint. |

### Parameter: `connectionStringPrimaryKey`

PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased".

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authenticationType`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified.

- Required: No
- Type: string
- Default: `'IdentityBased'`
- Allowed:
  ```Bicep
  [
    'IdentityBased'
    'KeyBased'
  ]
  ```

### Parameter: `connectionStringSecondaryKey`

SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Only used if the `authenticationType` is "KeyBased".

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string
- Default: `''`

### Parameter: `endpointUri`

The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://' (i.e. sb://xyz.servicebus.windows.net).

- Required: No
- Type: string
- Default: `''`

### Parameter: `entityPath`

The EventHub name in the EventHub namespace for identity-based authentication.

- Required: No
- Type: string
- Default: `''`

### Parameter: `managedIdentities`

The managed identity definition for this resource.  Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceId`](#parameter-managedidentitiesuserassignedresourceid) | string | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceId`

The resource ID(s) to assign to the resource.

- Required: No
- Type: string

### Parameter: `name`

The name of the Digital Twin Endpoint.

- Required: No
- Type: string
- Default: `'EventHubEndpoint'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. Note: As of 2024-03 is not exported by API. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
