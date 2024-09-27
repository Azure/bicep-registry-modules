# Policy Insights Remediations `[PolicyInsights/Remediation]`

This module deploys a Policy Insights Remediation.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.PolicyInsights/remediations` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.PolicyInsights/2021-10-01/remediations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/policy-insights/remediation:<version>`.

- [Policy Remediation (Management Group scope)](#example-1-policy-remediation-management-group-scope)
- [Policy Remediation (Management Group scope)](#example-2-policy-remediation-management-group-scope)
- [Policy Remediation (Resource Group scope)](#example-3-policy-remediation-resource-group-scope)
- [Policy Remediation (Resource Group scope)](#example-4-policy-remediation-resource-group-scope)
- [Policy Remediation (Subscription scope)](#example-5-policy-remediation-subscription-scope)
- [Policy Remediation (Subscription scope)](#example-6-policy-remediation-subscription-scope)

### Example 1: _Policy Remediation (Management Group scope)_

This module runs a Policy remediation task at Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirmgmin001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    location: '<location>'
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirmgmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    }
  }
}
```

</details>
<p>

### Example 2: _Policy Remediation (Management Group scope)_

This module runs a Policy remediation task at Management Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirmgmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    failureThresholdPercentage: '0.5'
    filtersLocations: []
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
    resourceCount: 10
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirmgmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    },
    "resourceCount": {
      "value": 10
    }
  }
}
```

</details>
<p>

### Example 3: _Policy Remediation (Resource Group scope)_

This module runs a Policy remediation task at Resource Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirrgmin001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    location: '<location>'
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirrgmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 4: _Policy Remediation (Resource Group scope)_

This module runs a Policy remediation task at Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirrgmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    failureThresholdPercentage: '0.5'
    filtersLocations: []
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
    resourceCount: 10
    resourceDiscoveryMode: 'ReEvaluateCompliance'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirrgmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ReEvaluateCompliance"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 5: _Policy Remediation (Subscription scope)_

This module runs a Policy remediation task at subscription scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirsubmin001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    location: '<location>'
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
    subscriptionId: '<subscriptionId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirsubmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 6: _Policy Remediation (Subscription scope)_

This module runs a Policy remediation task at subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirsubmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    failureThresholdPercentage: '0.5'
    filtersLocations: []
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
    resourceCount: 10
    resourceDiscoveryMode: 'ReEvaluateCompliance'
    subscriptionId: '<subscriptionId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "pirsubmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "Prerequisite_DeployExtensionWindows"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ReEvaluateCompliance"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy remediation. |
| [`policyAssignmentId`](#parameter-policyassignmentid) | string | The resource ID of the policy assignment that should be remediated. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`failureThresholdPercentage`](#parameter-failurethresholdpercentage) | string | The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail. |
| [`filtersLocations`](#parameter-filterslocations) | array | The filters that will be applied to determine which resources to remediate. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The target scope for the remediation. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| [`parallelDeployments`](#parameter-paralleldeployments) | int | Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used. |
| [`policyDefinitionReferenceId`](#parameter-policydefinitionreferenceid) | string | The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. |
| [`resourceCount`](#parameter-resourcecount) | int | Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used. |
| [`resourceDiscoveryMode`](#parameter-resourcediscoverymode) | string | The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The target scope for the remediation. The name of the resource group for the policy assignment. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The target scope for the remediation. The subscription ID of the subscription for the policy assignment. |

### Parameter: `name`

Specifies the name of the policy remediation.

- Required: Yes
- Type: string

### Parameter: `policyAssignmentId`

The resource ID of the policy assignment that should be remediated.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `failureThresholdPercentage`

The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `filtersLocations`

The filters that will be applied to determine which resources to remediate.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The target scope for the remediation. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment.

- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `parallelDeployments`

Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used.

- Required: No
- Type: int
- Default: `10`

### Parameter: `policyDefinitionReferenceId`

The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition.

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceCount`

Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used.

- Required: No
- Type: int
- Default: `500`

### Parameter: `resourceDiscoveryMode`

The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified.

- Required: No
- Type: string
- Default: `'ExistingNonCompliant'`
- Allowed:
  ```Bicep
  [
    'ExistingNonCompliant'
    'ReEvaluateCompliance'
  ]
  ```

### Parameter: `resourceGroupName`

The target scope for the remediation. The name of the resource group for the policy assignment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionId`

The target scope for the remediation. The subscription ID of the subscription for the policy assignment.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remediation. |
| `resourceId` | string | The resource ID of the remediation. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
