# Firewall Policies `[Microsoft.Network/firewallPolicies]`

This module deploys a Firewall Policy.

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
| `Microsoft.Network/firewallPolicies` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/firewallPolicies) |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/firewallPolicies/ruleCollectionGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/firewall-policy:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module firewallPolicy 'br/public:avm/res/network/firewall-policy:<version>' = {
  name: 'firewallPolicyDeployment'
  params: {
    // Required parameters
    name: 'nfpmin001'
    // Non-required parameters
    location: '<location>'
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
      "value": "nfpmin001"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module firewallPolicy 'br/public:avm/res/network/firewall-policy:<version>' = {
  name: 'firewallPolicyDeployment'
  params: {
    // Required parameters
    name: 'nfpmax001'
    // Non-required parameters
    allowSqlRedirect: true
    autoLearnPrivateRanges: 'Enabled'
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    mode: 'Alert'
    ruleCollectionGroups: [
      {
        name: 'rule-001'
        priority: 5000
        ruleCollections: [
          {
            action: {
              type: 'Allow'
            }
            name: 'collection002'
            priority: 5555
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            rules: [
              {
                destinationAddresses: [
                  '*'
                ]
                destinationFqdns: []
                destinationIpGroups: []
                destinationPorts: [
                  '80'
                ]
                ipProtocols: [
                  'TCP'
                  'UDP'
                ]
                name: 'rule002'
                ruleType: 'NetworkRule'
                sourceAddresses: [
                  '*'
                ]
                sourceIpGroups: []
              }
            ]
          }
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    tier: 'Premium'
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
      "value": "nfpmax001"
    },
    // Non-required parameters
    "allowSqlRedirect": {
      "value": true
    },
    "autoLearnPrivateRanges": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "mode": {
      "value": "Alert"
    },
    "ruleCollectionGroups": {
      "value": [
        {
          "name": "rule-001",
          "priority": 5000,
          "ruleCollections": [
            {
              "action": {
                "type": "Allow"
              },
              "name": "collection002",
              "priority": 5555,
              "ruleCollectionType": "FirewallPolicyFilterRuleCollection",
              "rules": [
                {
                  "destinationAddresses": [
                    "*"
                  ],
                  "destinationFqdns": [],
                  "destinationIpGroups": [],
                  "destinationPorts": [
                    "80"
                  ],
                  "ipProtocols": [
                    "TCP",
                    "UDP"
                  ],
                  "name": "rule002",
                  "ruleType": "NetworkRule",
                  "sourceAddresses": [
                    "*"
                  ],
                  "sourceIpGroups": []
                }
              ]
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "tier": {
      "value": "Premium"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module firewallPolicy 'br/public:avm/res/network/firewall-policy:<version>' = {
  name: 'firewallPolicyDeployment'
  params: {
    // Required parameters
    name: 'nfpwaf001'
    // Non-required parameters
    allowSqlRedirect: true
    autoLearnPrivateRanges: 'Enabled'
    location: '<location>'
    ruleCollectionGroups: [
      {
        name: 'rule-001'
        priority: 5000
        ruleCollections: [
          {
            action: {
              type: 'Allow'
            }
            name: 'collection002'
            priority: 5555
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            rules: [
              {
                destinationAddresses: [
                  '*'
                ]
                destinationFqdns: []
                destinationIpGroups: []
                destinationPorts: [
                  '80'
                ]
                ipProtocols: [
                  'TCP'
                  'UDP'
                ]
                name: 'rule002'
                ruleType: 'NetworkRule'
                sourceAddresses: [
                  '*'
                ]
                sourceIpGroups: []
              }
            ]
          }
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    threatIntelMode: 'Deny'
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
      "value": "nfpwaf001"
    },
    // Non-required parameters
    "allowSqlRedirect": {
      "value": true
    },
    "autoLearnPrivateRanges": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "ruleCollectionGroups": {
      "value": [
        {
          "name": "rule-001",
          "priority": 5000,
          "ruleCollections": [
            {
              "action": {
                "type": "Allow"
              },
              "name": "collection002",
              "priority": 5555,
              "ruleCollectionType": "FirewallPolicyFilterRuleCollection",
              "rules": [
                {
                  "destinationAddresses": [
                    "*"
                  ],
                  "destinationFqdns": [],
                  "destinationIpGroups": [],
                  "destinationPorts": [
                    "80"
                  ],
                  "ipProtocols": [
                    "TCP",
                    "UDP"
                  ],
                  "name": "rule002",
                  "ruleType": "NetworkRule",
                  "sourceAddresses": [
                    "*"
                  ],
                  "sourceIpGroups": []
                }
              ]
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "threatIntelMode": {
      "value": "Deny"
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
| [`name`](#parameter-name) | string | Name of the Firewall Policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowSqlRedirect`](#parameter-allowsqlredirect) | bool | A flag to indicate if SQL Redirect traffic filtering is enabled. Turning on the flag requires no rule using port 11000-11999. |
| [`autoLearnPrivateRanges`](#parameter-autolearnprivateranges) | string | The operation mode for automatically learning private ranges to not be SNAT. |
| [`basePolicyResourceId`](#parameter-basepolicyresourceid) | string | Resource ID of the base policy. |
| [`bypassTrafficSettings`](#parameter-bypasstrafficsettings) | array | List of rules for traffic to bypass. |
| [`certificateName`](#parameter-certificatename) | string | Name of the CA certificate. |
| [`defaultWorkspaceId`](#parameter-defaultworkspaceid) | string | Default Log Analytics Resource ID for Firewall Policy Insights. |
| [`enableProxy`](#parameter-enableproxy) | bool | Enable DNS Proxy on Firewalls attached to the Firewall Policy. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`fqdns`](#parameter-fqdns) | array | List of FQDNs for the ThreatIntel Allowlist. |
| [`insightsIsEnabled`](#parameter-insightsisenabled) | bool | A flag to indicate if the insights are enabled on the policy. |
| [`ipAddresses`](#parameter-ipaddresses) | array | List of IP addresses for the ThreatIntel Allowlist. |
| [`keyVaultSecretId`](#parameter-keyvaultsecretid) | string | Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`mode`](#parameter-mode) | string | The configuring of intrusion detection. |
| [`privateRanges`](#parameter-privateranges) | array | List of private IP addresses/IP address ranges to not be SNAT. |
| [`retentionDays`](#parameter-retentiondays) | int | Number of days the insights should be enabled on the policy. |
| [`ruleCollectionGroups`](#parameter-rulecollectiongroups) | array | Rule collection groups. |
| [`servers`](#parameter-servers) | array | List of Custom DNS Servers. |
| [`signatureOverrides`](#parameter-signatureoverrides) | array | List of specific signatures states. |
| [`tags`](#parameter-tags) | object | Tags of the Firewall policy resource. |
| [`threatIntelMode`](#parameter-threatintelmode) | string | The operation mode for Threat Intel. |
| [`tier`](#parameter-tier) | string | Tier of Firewall Policy. |
| [`workspaces`](#parameter-workspaces) | array | List of workspaces for Firewall Policy Insights. |

### Parameter: `name`

Name of the Firewall Policy.

- Required: Yes
- Type: string

### Parameter: `allowSqlRedirect`

A flag to indicate if SQL Redirect traffic filtering is enabled. Turning on the flag requires no rule using port 11000-11999.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `autoLearnPrivateRanges`

The operation mode for automatically learning private ranges to not be SNAT.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `basePolicyResourceId`

Resource ID of the base policy.

- Required: No
- Type: string

### Parameter: `bypassTrafficSettings`

List of rules for traffic to bypass.

- Required: No
- Type: array

### Parameter: `certificateName`

Name of the CA certificate.

- Required: No
- Type: string

### Parameter: `defaultWorkspaceId`

Default Log Analytics Resource ID for Firewall Policy Insights.

- Required: No
- Type: string

### Parameter: `enableProxy`

Enable DNS Proxy on Firewalls attached to the Firewall Policy.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `fqdns`

List of FQDNs for the ThreatIntel Allowlist.

- Required: No
- Type: array

### Parameter: `insightsIsEnabled`

A flag to indicate if the insights are enabled on the policy.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `ipAddresses`

List of IP addresses for the ThreatIntel Allowlist.

- Required: No
- Type: array

### Parameter: `keyVaultSecretId`

Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `mode`

The configuring of intrusion detection.

- Required: No
- Type: string
- Default: `'Off'`
- Allowed:
  ```Bicep
  [
    'Alert'
    'Deny'
    'Off'
  ]
  ```

### Parameter: `privateRanges`

List of private IP addresses/IP address ranges to not be SNAT.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `retentionDays`

Number of days the insights should be enabled on the policy.

- Required: No
- Type: int
- Default: `365`

### Parameter: `ruleCollectionGroups`

Rule collection groups.

- Required: No
- Type: array

### Parameter: `servers`

List of Custom DNS Servers.

- Required: No
- Type: array

### Parameter: `signatureOverrides`

List of specific signatures states.

- Required: No
- Type: array

### Parameter: `tags`

Tags of the Firewall policy resource.

- Required: No
- Type: object

### Parameter: `threatIntelMode`

The operation mode for Threat Intel.

- Required: No
- Type: string
- Default: `'Off'`
- Allowed:
  ```Bicep
  [
    'Alert'
    'Deny'
    'Off'
  ]
  ```

### Parameter: `tier`

Tier of Firewall Policy.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `workspaces`

List of workspaces for Firewall Policy Insights.

- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed firewall policy. |
| `resourceGroupName` | string | The resource group of the deployed firewall policy. |
| `resourceId` | string | The resource ID of the deployed firewall policy. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
