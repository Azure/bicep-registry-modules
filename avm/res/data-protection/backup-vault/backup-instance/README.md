# Data Protection Backup Vault Backup Instances `[Microsoft.DataProtection/backupVaults/backupInstances]`

This module deploys a Data Protection Backup Vault Backup Instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DataProtection/backupVaults/backupInstances` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupInstances) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataSourceInfo`](#parameter-datasourceinfo) | object | Gets or sets the data source information. |
| [`name`](#parameter-name) | string | The name of the backup instance. |
| [`policyInfo`](#parameter-policyinfo) | object | Gets or sets the policy information. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the parent Backup Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`friendlyName`](#parameter-friendlyname) | string | The friendly name of the backup instance. |

### Parameter: `dataSourceInfo`

Gets or sets the data source information.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`datasourceType`](#parameter-datasourceinfodatasourcetype) | string | The data source type of the resource. |
| [`resourceID`](#parameter-datasourceinforesourceid) | string | The resource ID of the resource. |
| [`resourceLocation`](#parameter-datasourceinforesourcelocation) | string | The location of the data source. |
| [`resourceName`](#parameter-datasourceinforesourcename) | string | Unique identifier of the resource in the context of parent. |
| [`resourceType`](#parameter-datasourceinforesourcetype) | string | The resource type of the data source. |
| [`resourceUri`](#parameter-datasourceinforesourceuri) | string | The Uri of the resource. |

### Parameter: `dataSourceInfo.datasourceType`

The data source type of the resource.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceID`

The resource ID of the resource.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceLocation`

The location of the data source.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceName`

Unique identifier of the resource in the context of parent.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceType`

The resource type of the data source.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceUri`

The Uri of the resource.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the backup instance.

- Required: Yes
- Type: string

### Parameter: `policyInfo`

Gets or sets the policy information.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`policyName`](#parameter-policyinfopolicyname) | string | The name of the backup instance policy. |
| [`policyParameters`](#parameter-policyinfopolicyparameters) | object | Policy parameters for the backup instance. |

### Parameter: `policyInfo.policyName`

The name of the backup instance policy.

- Required: Yes
- Type: string

### Parameter: `policyInfo.policyParameters`

Policy parameters for the backup instance.

- Required: Yes
- Type: object

### Parameter: `backupVaultName`

The name of the parent Backup Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `friendlyName`

The friendly name of the backup instance.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup instance. |
| `resourceGroupName` | string | The name of the resource group the backup instance was created in. |
| `resourceId` | string | The resource ID of the backup instance. |
