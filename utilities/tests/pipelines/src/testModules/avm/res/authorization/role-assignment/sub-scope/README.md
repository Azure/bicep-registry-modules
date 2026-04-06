# Multi-scope module `[Microsoft.Authorization/roleAssignments]`

This is a multi-scope module for tests.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/authorization/role-assignment/sub-scope:<version>`.

- [Test case name](#example-1-test-case-name)

### Example 1: _Test case name_

This file deploys the module with some example parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sub-scope.test]


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>' = {
  params: {
    // Required parameters
    requiredParam: 'my-test'
    // Non-required parameters
    optionalParam: 'opt'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "requiredParam": {
      "value": "my-test"
    },
    // Non-required parameters
    "optionalParam": {
      "value": "opt"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>'

// Required parameters
param requiredParam = 'my-test'
// Non-required parameters
param optionalParam = 'opt'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`requiredParam`](#parameter-requiredparam) | string | An required param. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`optionalParam`](#parameter-optionalparam) | string | An optional param. |

### Parameter: `requiredParam`

An required param.

- Required: Yes
- Type: string

### Parameter: `optionalParam`

An optional param.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `anOutput` | string | An output value. |
