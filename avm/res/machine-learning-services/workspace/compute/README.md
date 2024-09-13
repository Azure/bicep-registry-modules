# Machine Learning Services Workspaces Computes `[Microsoft.MachineLearningServices/workspaces/computes]`

This module deploys a Machine Learning Services Workspaces Compute.

Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML (see parameter `deployCompute`).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeType`](#parameter-computetype) | string | Set the object type. |
| [`name`](#parameter-name) | string | Name of the compute. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`machineLearningWorkspaceName`](#parameter-machinelearningworkspacename) | string | The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeLocation`](#parameter-computelocation) | string | Location for the underlying compute. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |
| [`deployCompute`](#parameter-deploycompute) | bool | Flag to specify whether to deploy the compute. Required only for attach (i.e. providing a resource ID), as in this case the operation is not idempotent, i.e. a second deployment will fail. Therefore, this flag needs to be set to "false" as long as the compute resource exists. |
| [`description`](#parameter-description) | string | The description of the Machine Learning compute. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication. |
| [`location`](#parameter-location) | string | Specifies the location of the resource. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`properties`](#parameter-properties) | object | The properties of the compute. Will be ignored in case "resourceId" is set. |
| [`resourceId`](#parameter-resourceid) | string | ARM resource ID of the underlying compute. |
| [`sku`](#parameter-sku) | string | Specifies the sku, also referred as "edition". Required for creating a compute resource. |
| [`tags`](#parameter-tags) | object | Contains resource tags defined as key-value pairs. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |

### Parameter: `computeType`

Set the object type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AKS'
    'AmlCompute'
    'ComputeInstance'
    'Databricks'
    'DataFactory'
    'DataLakeAnalytics'
    'HDInsight'
    'Kubernetes'
    'SynapseSpark'
    'VirtualMachine'
  ]
  ```

### Parameter: `name`

Name of the compute.

- Required: Yes
- Type: string

### Parameter: `machineLearningWorkspaceName`

The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `computeLocation`

Location for the underlying compute. Ignored when attaching a compute resource, i.e. when you provide a resource ID.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `deployCompute`

Flag to specify whether to deploy the compute. Required only for attach (i.e. providing a resource ID), as in this case the operation is not idempotent, i.e. a second deployment will fail. Therefore, this flag needs to be set to "false" as long as the compute resource exists.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `description`

The description of the Machine Learning compute.

- Required: No
- Type: string

### Parameter: `disableLocalAuth`

Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Specifies the location of the resource.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `properties`

The properties of the compute. Will be ignored in case "resourceId" is set.

- Required: No
- Type: object

### Parameter: `resourceId`

ARM resource ID of the underlying compute.

- Required: No
- Type: string

### Parameter: `sku`

Specifies the sku, also referred as "edition". Required for creating a compute resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `tags`

Contains resource tags defined as key-value pairs. Ignored when attaching a compute resource, i.e. when you provide a resource ID.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the compute. |
| `resourceGroupName` | string | The resource group the compute was deployed into. |
| `resourceId` | string | The resource ID of the compute. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
