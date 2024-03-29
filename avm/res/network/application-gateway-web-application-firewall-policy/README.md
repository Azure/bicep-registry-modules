# Application Gateway Web Application Firewall (WAF) Policies `[Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies]`

This module deploys an Application Gateway Web Application Firewall (WAF) Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/ApplicationGatewayWebApplicationFirewallPolicies) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.application-gateway-web-application-firewall-policy:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module applicationGatewayWebApplicationFirewallPolicy 'br:bicep/modules/network.application-gateway-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpmax'
  params: {
    // Required parameters
    name: 'nagwafpmax001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedRules: {
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleGroupOverrides: []
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
    policySettings: {
      fileUploadLimitInMb: 10
      mode: 'Prevention'
      state: 'Enabled'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "nagwafpmax001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedRules": {
      "value": {
        "managedRuleSets": [
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "OWASP",
            "ruleSetVersion": "3.2"
          },
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "Microsoft_BotManagerRuleSet",
            "ruleSetVersion": "0.1"
          }
        ]
      }
    },
    "policySettings": {
      "value": {
        "fileUploadLimitInMb": 10,
        "mode": "Prevention",
        "state": "Enabled"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module applicationGatewayWebApplicationFirewallPolicy 'br:bicep/modules/network.application-gateway-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpwaf'
  params: {
    // Required parameters
    name: 'nagwafpwaf001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedRules: {
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleGroupOverrides: []
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
    policySettings: {
      fileUploadLimitInMb: 10
      mode: 'Prevention'
      state: 'Enabled'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "nagwafpwaf001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedRules": {
      "value": {
        "managedRuleSets": [
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "OWASP",
            "ruleSetVersion": "3.2"
          },
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "Microsoft_BotManagerRuleSet",
            "ruleSetVersion": "0.1"
          }
        ]
      }
    },
    "policySettings": {
      "value": {
        "fileUploadLimitInMb": 10,
        "mode": "Prevention",
        "state": "Enabled"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
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
| [`name`](#parameter-name) | string | Name of the Application Gateway WAF policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customRules`](#parameter-customrules) | array | The custom rules inside the policy. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managedRules`](#parameter-managedrules) | object | Describes the managedRules structure. |
| [`policySettings`](#parameter-policysettings) | object | The PolicySettings for policy. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

Name of the Application Gateway WAF policy.

- Required: Yes
- Type: string

### Parameter: `customRules`

The custom rules inside the policy.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `managedRules`

Describes the managedRules structure.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `policySettings`

The PolicySettings for policy.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the application gateway WAF policy. |
| `resourceGroupName` | string | The resource group the application gateway WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the application gateway WAF policy. |

## Cross-referenced modules

_None_
