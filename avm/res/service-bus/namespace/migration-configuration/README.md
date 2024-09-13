# Service Bus Namespace Migration Configuration `[Microsoft.ServiceBus/namespaces/migrationConfigurations]`

This module deploys a Service Bus Namespace Migration Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/migrationConfigurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`postMigrationName`](#parameter-postmigrationname) | string | Name to access Standard Namespace after migration. |
| [`targetNamespaceResourceId`](#parameter-targetnamespaceresourceid) | string | Existing premium Namespace resource ID which has no entities, will be used for migration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

### Parameter: `postMigrationName`

Name to access Standard Namespace after migration.

- Required: Yes
- Type: string

### Parameter: `targetNamespaceResourceId`

Existing premium Namespace resource ID which has no entities, will be used for migration.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the migration configuration. |
| `resourceGroupName` | string | The name of the Resource Group the migration configuration was created in. |
| `resourceId` | string | The Resource ID of the migration configuration. |
