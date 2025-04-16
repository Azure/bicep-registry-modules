# DevTest Lab Policy Sets Policies `[Microsoft.DevTestLab/labs/policysets/policies]`

This module deploys a DevTest Lab Policy Sets Policy.

DevTest lab policies are used to modify the lab settings such as only allowing certain VM Size SKUs, marketplace image types, number of VMs allowed per user and other settings.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/policysets/policies` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/policysets/policies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`evaluatorType`](#parameter-evaluatortype) | string | The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy). |
| [`factName`](#parameter-factname) | string | The fact name of the policy. |
| [`name`](#parameter-name) | string | The name of the policy. |
| [`threshold`](#parameter-threshold) | string | The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the policy. |
| [`factData`](#parameter-factdata) | string | The fact data of the policy. |
| [`status`](#parameter-status) | string | The status of the policy. |

### Parameter: `evaluatorType`

The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowedValuesPolicy'
    'MaxValuePolicy'
  ]
  ```

### Parameter: `factName`

The fact name of the policy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'EnvironmentTemplate'
    'GalleryImage'
    'LabPremiumVmCount'
    'LabTargetCost'
    'LabVmCount'
    'LabVmSize'
    'ScheduleEditPermission'
    'UserOwnedLabPremiumVmCount'
    'UserOwnedLabVmCount'
    'UserOwnedLabVmCountInSubnet'
  ]
  ```

### Parameter: `name`

The name of the policy.

- Required: Yes
- Type: string

### Parameter: `threshold`

The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy).

- Required: Yes
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the policy.

- Required: No
- Type: string
- Default: `''`

### Parameter: `factData`

The fact data of the policy.

- Required: No
- Type: string
- Default: `''`

### Parameter: `status`

The status of the policy.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the policy. |
| `resourceGroupName` | string | The name of the resource group the policy was created in. |
| `resourceId` | string | The resource ID of the policy. |
