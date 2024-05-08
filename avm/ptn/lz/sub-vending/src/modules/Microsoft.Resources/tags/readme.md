# Resources Tags `[Microsoft.Resources/tags]`

This module deploys Resources Tags on a subscription or resource group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Resources/tags` | [2019-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/tags) |

## Parameters

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `onlyUpdate` | bool | `False` | Instead of overwriting the existing tags, combine them with the new tags. |
| `resourceGroupName` | string | `''` | Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
| `subscriptionId` | string | `[subscription().id]` | Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
| `tags` | object | `{object}` | Tags for the resource group. If not provided, removes existing tags. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the tags resource. |
| `resourceId` | string | The resource ID of the applied tags. |
| `tags` | object | The applied tags. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {}
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module tags './Microsoft.Resources/tags/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-tags'
  params: {
  
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "onlyUpdate": {
            "value": false
        },
        "tags": {
            "value": {
                "Test": "Yes",
                "TestToo": "No"
            }
        },
        "resourceGroupName": {
            "value": "validation-rg"
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module tags './Microsoft.Resources/tags/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-tags'
  params: {
    onlyUpdate: false
    tags: {
      Test: 'Yes'
      TestToo: 'No'
    }
    resourceGroupName: 'validation-rg'
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "onlyUpdate": {
            "value": true
        },
        "tags": {
            "value": {
                "Test": "Yes",
                "TestToo": "No"
            }
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module tags './Microsoft.Resources/tags/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-tags'
  params: {
    onlyUpdate: true
    tags: {
      Test: 'Yes'
      TestToo: 'No'
    }
  }
}
```

</details>
<p>
