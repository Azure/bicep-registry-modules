# Policy Insights Remediations `[Microsoft.PolicyInsights/remediations]`

This module deploys a Policy Insights Remediation.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.PolicyInsights/remediations` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.PolicyInsights/2021-10-01/remediations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/policy-insights/remediation:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using only defaults](#example-2-using-only-defaults)
- [Using only defaults](#example-3-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirsubdef001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    filtersLocations: []
    location: '<location>'
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
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
      "value": "pirsubdef001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "filtersLocations": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "policyDefinitionReferenceId": {
      "value": "<policyDefinitionReferenceId>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


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
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
    resourceCount: 10
    resourceDiscoveryMode: 'ReEvaluateCompliance'
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
      "value": "<policyDefinitionReferenceId>"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ReEvaluateCompliance"
    }
  }
}
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module remediation 'br/public:avm/ptn/policy-insights/remediation:<version>' = {
  name: 'remediationDeployment'
  params: {
    // Required parameters
    name: 'pirsubwaf001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    failureThresholdPercentage: '0.5'
    filtersLocations: []
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
    resourceCount: 10
    resourceDiscoveryMode: 'ReEvaluateCompliance'
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
      "value": "pirsubwaf001"
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
      "value": "<policyDefinitionReferenceId>"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ReEvaluateCompliance"
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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
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

Enable telemetry via a Globally Unique Identifier (GUID).

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
