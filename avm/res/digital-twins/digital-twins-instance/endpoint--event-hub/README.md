# Digital Twins Instance EventHub Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance EventHub Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
- Nullable: No
- Default: `''`

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `authenticationType`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified.

- Required: No
- Type: string
- Nullable: No
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
- Nullable: No
- Default: `''`

### Parameter: `deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring
- Nullable: No
- Default: `''`

### Parameter: `deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string
- Nullable: No
- Default: `''`

### Parameter: `endpointUri`

The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://' (i.e. sb://xyz.servicebus.windows.net).

- Required: No
- Type: string
- Nullable: No
- Default: `''`

### Parameter: `entityPath`

The EventHub name in the EventHub namespace for identity-based authentication.

- Required: No
- Type: string
- Nullable: No
- Default: `''`

### Parameter: `managedIdentities`

The managed identity definition for this resource.  Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object
- Nullable: No

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceId`](#parameter-managedidentitiesuserassignedresourceid) | string | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool
- Nullable: Yes

### Parameter: `managedIdentities.userAssignedResourceId`

The resource ID(s) to assign to the resource.

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `name`

The name of the Digital Twin Endpoint.

- Required: No
- Type: string
- Nullable: No
- Default: `'EventHubEndpoint'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. Note: As of 2024-03 is not exported by API. |
