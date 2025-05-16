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
| [`kafkaConfig`](#parameter-kafkaconfig) | object | The Kafka configuration properties. |

### Parameter: `accountName`

The name of the Purview account.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig`

The Kafka configuration properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consumerGroup`](#parameter-kafkaconfigconsumergroup) | string | The consumer group for the hook event hub. |
| [`credentials`](#parameter-kafkaconfigcredentials) | object | The credentials for the event streaming service. |
| [`eventHubResourceId`](#parameter-kafkaconfigeventhubresourceid) | string | The event hub resource ID of the Kafka configuration. |
| [`eventHubType`](#parameter-kafkaconfigeventhubtype) | string | The event hub type. |
| [`eventStreamingState`](#parameter-kafkaconfigeventstreamingstate) | string | The event streaming state. |
| [`eventStreamingType`](#parameter-kafkaconfigeventstreamingtype) | string | The event streaming type. |
| [`name`](#parameter-kafkaconfigname) | string | The name of the Kafka configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubPartitionId`](#parameter-kafkaconfigeventhubpartitionid) | string | The partition ID for the notification event hub. If not set, all partitions will be used. |

### Parameter: `kafkaConfig.consumerGroup`

The consumer group for the hook event hub.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.credentials`

The credentials for the event streaming service.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityId`](#parameter-kafkaconfigcredentialsidentityid) | string | The identity ID of the Kafka configuration. |
| [`type`](#parameter-kafkaconfigcredentialstype) | string | The type of the credentials for the Kafka configuration. |

### Parameter: `kafkaConfig.credentials.identityId`

The identity ID of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.credentials.type`

The type of the credentials for the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.eventHubResourceId`

The event hub resource ID of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.eventHubType`

The event hub type.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.eventStreamingState`

The event streaming state.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.eventStreamingType`

The event streaming type.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.name`

The name of the Kafka configuration.

- Required: Yes
- Type: string

### Parameter: `kafkaConfig.eventHubPartitionId`

The partition ID for the notification event hub. If not set, all partitions will be used.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Kafka configuration. |
| `resourceGroupName` | string | The name of the Resource Group the Kafka configuration was created in. |
| `resourceId` | string | The resource ID of the Kafka configuration. |
