# Purview Account Kafka Configuration `[Microsoft.Purview/accounts/kafkaConfigurations]`

This module deploys a Purview Account Kafka Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Purview/accounts/kafkaConfigurations` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Purview/2024-04-01-preview/accounts/kafkaConfigurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accountName`](#parameter-accountname) | string | The name of the Purview account. |
| [`name`](#parameter-name) | string | The name of the Kafka configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kakfaConfiguration`](#parameter-kakfaconfiguration) | object | The Kafka configuration properties. |

### Parameter: `accountName`

The name of the Purview account.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration`

The Kafka configuration properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consumerGroup`](#parameter-kakfaconfigurationconsumergroup) | string | The consumer group for the hook event hub. |
| [`credentials`](#parameter-kakfaconfigurationcredentials) | object | The credentials for the event streaming service. |
| [`eventHubResourceId`](#parameter-kakfaconfigurationeventhubresourceid) | string | The event hub resource ID of the Kafka configuration. |
| [`eventHubType`](#parameter-kakfaconfigurationeventhubtype) | string | The event hub type. |
| [`eventStreamingState`](#parameter-kakfaconfigurationeventstreamingstate) | string | The event streaming state. |
| [`eventStreamingType`](#parameter-kakfaconfigurationeventstreamingtype) | string | The event streaming type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubPartitionId`](#parameter-kakfaconfigurationeventhubpartitionid) | string | The partition ID for the notification event hub. If not set, all partitions will be used. |

### Parameter: `kakfaConfiguration.consumerGroup`

The consumer group for the hook event hub.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.credentials`

The credentials for the event streaming service.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityId`](#parameter-kakfaconfigurationcredentialsidentityid) | string | The identity ID of the Kafka configuration. |
| [`type`](#parameter-kakfaconfigurationcredentialstype) | string | The type of the credentials for the Kafka configuration. |

### Parameter: `kakfaConfiguration.credentials.identityId`

The identity ID of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.credentials.type`

The type of the credentials for the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.eventHubResourceId`

The event hub resource ID of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.eventHubType`

The event hub type.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.eventStreamingState`

The event streaming state.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.eventStreamingType`

The event streaming type.

- Required: Yes
- Type: string

### Parameter: `kakfaConfiguration.eventHubPartitionId`

The partition ID for the notification event hub. If not set, all partitions will be used.

- Required: No
- Type: string

## Outputs

_None_
