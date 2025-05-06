# Security Insights (Microsoft Sentinel) `[Microsoft.SecurityInsights/onboardingStates]`

This module deploys Security Insights (Microsoft Sentinel) instance and its resources.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.SecurityInsights/onboardingStates` | [2025-01-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2025-01-01-preview/onboardingStates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/security-insights/onboarding-states:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module onboardingStates 'br/public:avm/res/security-insights/onboarding-states:<version>' = {
  name: 'onboardingStatesDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    location: '<location>'
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
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/onboarding-states:<version>'

// Required parameters
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module onboardingStates 'br/public:avm/res/security-insights/onboarding-states:<version>' = {
  name: 'onboardingStatesDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    location: '<location>'
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
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/onboarding-states:<version>'

// Required parameters
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module onboardingStates 'br/public:avm/res/security-insights/onboarding-states:<version>' = {
  name: 'onboardingStatesDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    location: '<location>'
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
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/onboarding-states:<version>'

// Required parameters
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace where Security Insights (Microsoft Sentinel) will be deployed. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerManagedKey`](#parameter-customermanagedkey) | bool | Status of the CMK setting |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `workspaceResourceId`

The resource ID of the Log Analytics workspace where Security Insights (Microsoft Sentinel) will be deployed.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey`

Status of the CMK setting

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Security Insights (Microsoft Sentinel) instance. |
| `resourceGroupName` | string | The resource group where the Security Insights (Microsoft Sentinel) instance is deployed. |
| `resourceId` | string | The resource ID of the deployed Security Insights (Microsoft Sentinel) instance. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
