# Digital Twins Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Digital Twin Endpoint. |
| [`properties`](#parameter-properties) | object | The properties of the endpoint. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`digitalTwinInstanceName`](#parameter-digitaltwininstancename) | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the Digital Twin Endpoint.

- Required: Yes
- Type: string

### Parameter: `properties`

The properties of the endpoint.

- Required: Yes
- Type: object
- Discriminator: `endpointType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`EventGrid`](#variant-propertiesendpointtype-eventgrid) | The type for an event grid endpoint. |
| [`EventHub`](#variant-propertiesendpointtype-eventhub) | The type for an event hub endpoint. |
| [`ServiceBus`](#variant-propertiesendpointtype-servicebus) | The type for a service bus endpoint. |

### Variant: `properties.endpointType-EventGrid`
The type for an event grid endpoint.

To use this variant, set the property `endpointType` to `EventGrid`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpointType`](#parameter-propertiesendpointtype-eventgridendpointtype) | string | The type of endpoint to create. |
| [`eventGridTopicResourceId`](#parameter-propertiesendpointtype-eventgrideventgridtopicresourceid) | string | The resource ID of the Event Grid Topic to get access keys from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterSecret`](#parameter-propertiesendpointtype-eventgriddeadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-propertiesendpointtype-eventgriddeadletteruri) | string | Dead letter storage URL for identity-based authentication. |

### Parameter: `properties.endpointType-EventGrid.endpointType`

The type of endpoint to create.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'EventGrid'
  ]
  ```

### Parameter: `properties.endpointType-EventGrid.eventGridTopicResourceId`

The resource ID of the Event Grid Topic to get access keys from.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-EventGrid.deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring

### Parameter: `properties.endpointType-EventGrid.deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string

### Variant: `properties.endpointType-EventHub`
The type for an event hub endpoint.

To use this variant, set the property `endpointType` to `EventHub`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authentication`](#parameter-propertiesendpointtype-eventhubauthentication) | object | Specifies the authentication type being used for connecting to the endpoint. |
| [`endpointType`](#parameter-propertiesendpointtype-eventhubendpointtype) | string | The type of endpoint to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterSecret`](#parameter-propertiesendpointtype-eventhubdeadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-propertiesendpointtype-eventhubdeadletteruri) | string | Dead letter storage URL for identity-based authentication. |

### Parameter: `properties.endpointType-EventHub.authentication`

Specifies the authentication type being used for connecting to the endpoint.

- Required: Yes
- Type: object
- Discriminator: `type`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`IdentityBased`](#variant-propertiesendpointtype-eventhubauthenticationtype-identitybased) |  |
| [`KeyBased`](#variant-propertiesendpointtype-eventhubauthenticationtype-keybased) |  |

### Variant: `properties.endpointType-EventHub.authentication.type-IdentityBased`


To use this variant, set the property `type` to `IdentityBased`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubResourceId`](#parameter-propertiesendpointtype-eventhubauthenticationtype-identitybasedeventhubresourceid) | string | The resource ID of the Event Hub Namespace Event Hub. |
| [`type`](#parameter-propertiesendpointtype-eventhubauthenticationtype-identitybasedtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-propertiesendpointtype-eventhubauthenticationtype-identitybasedmanagedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |

### Parameter: `properties.endpointType-EventHub.authentication.type-IdentityBased.eventHubResourceId`

The resource ID of the Event Hub Namespace Event Hub.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-EventHub.authentication.type-IdentityBased.type`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IdentityBased'
  ]
  ```

### Parameter: `properties.endpointType-EventHub.authentication.type-IdentityBased.managedIdentities`

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-propertiesendpointtype-eventhubauthenticationtype-identitybasedmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceId`](#parameter-propertiesendpointtype-eventhubauthenticationtype-identitybasedmanagedidentitiesuserassignedresourceid) | string | The resource ID(s) to assign to the resource. |

### Parameter: `properties.endpointType-EventHub.authentication.type-IdentityBased.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `properties.endpointType-EventHub.authentication.type-IdentityBased.managedIdentities.userAssignedResourceId`

The resource ID(s) to assign to the resource.

- Required: No
- Type: string

### Variant: `properties.endpointType-EventHub.authentication.type-KeyBased`


To use this variant, set the property `type` to `KeyBased`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleName`](#parameter-propertiesendpointtype-eventhubauthenticationtype-keybasedeventhubauthorizationrulename) | string | The name of the Event Hub Namespace Event Hub Authorization Rule. |
| [`eventHubResourceId`](#parameter-propertiesendpointtype-eventhubauthenticationtype-keybasedeventhubresourceid) | string | The resource ID of the Event Hub Namespace Event Hub. |
| [`type`](#parameter-propertiesendpointtype-eventhubauthenticationtype-keybasedtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified. |

### Parameter: `properties.endpointType-EventHub.authentication.type-KeyBased.eventHubAuthorizationRuleName`

The name of the Event Hub Namespace Event Hub Authorization Rule.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-EventHub.authentication.type-KeyBased.eventHubResourceId`

The resource ID of the Event Hub Namespace Event Hub.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-EventHub.authentication.type-KeyBased.type`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'KeyBased'
  ]
  ```

### Parameter: `properties.endpointType-EventHub.endpointType`

The type of endpoint to create.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'EventHub'
  ]
  ```

### Parameter: `properties.endpointType-EventHub.deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring

### Parameter: `properties.endpointType-EventHub.deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string

### Variant: `properties.endpointType-ServiceBus`
The type for a service bus endpoint.

To use this variant, set the property `endpointType` to `ServiceBus`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authentication`](#parameter-propertiesendpointtype-servicebusauthentication) | object | Specifies the authentication type being used for connecting to the endpoint. |
| [`endpointType`](#parameter-propertiesendpointtype-servicebusendpointtype) | string | The type of endpoint to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterSecret`](#parameter-propertiesendpointtype-servicebusdeadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-propertiesendpointtype-servicebusdeadletteruri) | string | Dead letter storage URL for identity-based authentication. |

### Parameter: `properties.endpointType-ServiceBus.authentication`

Specifies the authentication type being used for connecting to the endpoint.

- Required: Yes
- Type: object
- Discriminator: `type`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`IdentityBased`](#variant-propertiesendpointtype-servicebusauthenticationtype-identitybased) |  |
| [`KeyBased`](#variant-propertiesendpointtype-servicebusauthenticationtype-keybased) |  |

### Variant: `properties.endpointType-ServiceBus.authentication.type-IdentityBased`


To use this variant, set the property `type` to `IdentityBased`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceBusNamespaceTopicResourceId`](#parameter-propertiesendpointtype-servicebusauthenticationtype-identitybasedservicebusnamespacetopicresourceid) | string | The ServiceBus Namespace Topic resource ID. |
| [`type`](#parameter-propertiesendpointtype-servicebusauthenticationtype-identitybasedtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-propertiesendpointtype-servicebusauthenticationtype-identitybasedmanagedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |

### Parameter: `properties.endpointType-ServiceBus.authentication.type-IdentityBased.serviceBusNamespaceTopicResourceId`

The ServiceBus Namespace Topic resource ID.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-ServiceBus.authentication.type-IdentityBased.type`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IdentityBased'
  ]
  ```

### Parameter: `properties.endpointType-ServiceBus.authentication.type-IdentityBased.managedIdentities`

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-propertiesendpointtype-servicebusauthenticationtype-identitybasedmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceId`](#parameter-propertiesendpointtype-servicebusauthenticationtype-identitybasedmanagedidentitiesuserassignedresourceid) | string | The resource ID(s) to assign to the resource. |

### Parameter: `properties.endpointType-ServiceBus.authentication.type-IdentityBased.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `properties.endpointType-ServiceBus.authentication.type-IdentityBased.managedIdentities.userAssignedResourceId`

The resource ID(s) to assign to the resource.

- Required: No
- Type: string

### Variant: `properties.endpointType-ServiceBus.authentication.type-KeyBased`


To use this variant, set the property `type` to `KeyBased`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceBusNamespaceTopicAuthorizationRuleName`](#parameter-propertiesendpointtype-servicebusauthenticationtype-keybasedservicebusnamespacetopicauthorizationrulename) | string | The ServiceBus Namespace Topic Authorization Rule name. |
| [`serviceBusNamespaceTopicResourceId`](#parameter-propertiesendpointtype-servicebusauthenticationtype-keybasedservicebusnamespacetopicresourceid) | string | The ServiceBus Namespace Topic resource ID. |
| [`type`](#parameter-propertiesendpointtype-servicebusauthenticationtype-keybasedtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified. |

### Parameter: `properties.endpointType-ServiceBus.authentication.type-KeyBased.serviceBusNamespaceTopicAuthorizationRuleName`

The ServiceBus Namespace Topic Authorization Rule name.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-ServiceBus.authentication.type-KeyBased.serviceBusNamespaceTopicResourceId`

The ServiceBus Namespace Topic resource ID.

- Required: Yes
- Type: string

### Parameter: `properties.endpointType-ServiceBus.authentication.type-KeyBased.type`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is select, the endpointUri and entityPath properties must be specified.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'KeyBased'
  ]
  ```

### Parameter: `properties.endpointType-ServiceBus.endpointType`

The type of endpoint to create.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ServiceBus'
  ]
  ```

### Parameter: `properties.endpointType-ServiceBus.deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring

### Parameter: `properties.endpointType-ServiceBus.deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. Note: As of 2024-03 is not exported by API. |
