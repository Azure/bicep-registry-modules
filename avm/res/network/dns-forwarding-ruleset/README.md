# Dns Forwarding Rulesets `[Microsoft.Network/dnsForwardingRulesets]`

This template deploys an dns forwarding ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/dnsForwardingRulesets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets) |
| `Microsoft.Network/dnsForwardingRulesets/forwardingRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/forwardingRules) |
| `Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/virtualNetworkLinks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/dns-forwarding-ruleset:0.2.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.
> **Note:** The test currently implements additional non-required parameters to cater for a test-specific limitation.



<details>

<summary>via Bicep module</summary>

```bicep
module dnsForwardingRuleset 'br/public:avm/res/network/dns-forwarding-ruleset:0.2.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrsmin'
  params: {
    // Required parameters
    dnsForwardingRulesetOutboundEndpointResourceIds: [
      '<dnsResolverOutboundEndpointsResourceId>'
    ]
    name: 'ndfrsmin001'
    // Non-required parameters
    forwardingRules: []
    location: '<location>'
    lock: {}
    roleAssignments: []
    tags: {}
    vNetLinks: []
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
    "dnsForwardingRulesetOutboundEndpointResourceIds": {
      "value": [
        "<dnsResolverOutboundEndpointsResourceId>"
      ]
    },
    "name": {
      "value": "ndfrsmin001"
    },
    // Non-required parameters
    "forwardingRules": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {}
    },
    "roleAssignments": {
      "value": []
    },
    "tags": {
      "value": {}
    },
    "vNetLinks": {
      "value": []
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
module dnsForwardingRuleset 'br/public:avm/res/network/dns-forwarding-ruleset:0.2.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrsmax'
  params: {
    // Required parameters
    dnsForwardingRulesetOutboundEndpointResourceIds: [
      '<dnsResolverOutboundEndpointsId>'
    ]
    name: 'ndfrsmax001'
    // Non-required parameters
    forwardingRules: [
      {
        domainName: 'contoso.'
        forwardingRuleState: 'Enabled'
        name: 'rule1'
        targetDnsServers: [
          {
            ipAddress: '192.168.0.1'
            port: '53'
          }
        ]
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetLinks: [
      '<virtualNetworkResourceId>'
    ]
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
    "dnsForwardingRulesetOutboundEndpointResourceIds": {
      "value": [
        "<dnsResolverOutboundEndpointsId>"
      ]
    },
    "name": {
      "value": "ndfrsmax001"
    },
    // Non-required parameters
    "forwardingRules": {
      "value": [
        {
          "domainName": "contoso.",
          "forwardingRuleState": "Enabled",
          "name": "rule1",
          "targetDnsServers": [
            {
              "ipAddress": "192.168.0.1",
              "port": "53"
            }
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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
    "vNetLinks": {
      "value": [
        "<virtualNetworkResourceId>"
      ]
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
module dnsForwardingRuleset 'br/public:avm/res/network/dns-forwarding-ruleset:0.2.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrswaf'
  params: {
    // Required parameters
    dnsForwardingRulesetOutboundEndpointResourceIds: [
      '<dnsResolverOutboundEndpointsId>'
    ]
    name: 'ndfrswaf001'
    // Non-required parameters
    forwardingRules: []
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: []
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetLinks: []
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
    "dnsForwardingRulesetOutboundEndpointResourceIds": {
      "value": [
        "<dnsResolverOutboundEndpointsId>"
      ]
    },
    "name": {
      "value": "ndfrswaf001"
    },
    // Non-required parameters
    "forwardingRules": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": []
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetLinks": {
      "value": []
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
| [`dnsForwardingRulesetOutboundEndpointResourceIds`](#parameter-dnsforwardingrulesetoutboundendpointresourceids) | array | The reference to the DNS resolver outbound endpoints that are used to route DNS queries matching the forwarding rules in the ruleset to the target DNS servers. |
| [`name`](#parameter-name) | string | Name of the DNS Forwarding Ruleset. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`forwardingRules`](#parameter-forwardingrules) | array | Array of forwarding rules. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vNetLinks`](#parameter-vnetlinks) | array | Array of virtual network links. |

### Parameter: `dnsForwardingRulesetOutboundEndpointResourceIds`

The reference to the DNS resolver outbound endpoints that are used to route DNS queries matching the forwarding rules in the ruleset to the target DNS servers.
- Required: Yes
- Type: array

### Parameter: `enableTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `forwardingRules`

Array of forwarding rules.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`domainName`](#parameter-forwardingrulesdomainname) | Yes | string | Required. The domain name to forward. |
| [`forwardingRuleState`](#parameter-forwardingrulesforwardingrulestate) | No | string | Optional. The state of the forwarding rule. |
| [`metadata`](#parameter-forwardingrulesmetadata) | No | string | Optional. Metadata attached to the forwarding rule. |
| [`name`](#parameter-forwardingrulesname) | Yes | string | Required. The name of the forwarding rule. |
| [`targetDnsServers`](#parameter-forwardingrulestargetdnsservers) | Yes | array | Required. The target DNS servers to forward to. |

### Parameter: `forwardingRules.domainName`

Required. The domain name to forward.

- Required: Yes
- Type: string

### Parameter: `forwardingRules.forwardingRuleState`

Optional. The state of the forwarding rule.

- Required: No
- Type: string
- Allowed: `[Disabled, Enabled]`

### Parameter: `forwardingRules.metadata`

Optional. Metadata attached to the forwarding rule.

- Required: No
- Type: string

### Parameter: `forwardingRules.name`

Required. The name of the forwarding rule.

- Required: Yes
- Type: string

### Parameter: `forwardingRules.targetDnsServers`

Required. The target DNS servers to forward to.

- Required: Yes
- Type: array

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `name`

Name of the DNS Forwarding Ruleset.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `vNetLinks`

Array of virtual network links.
- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the DNS Forwarding Ruleset. |
| `resourceGroupName` | string | The resource group the DNS Forwarding Ruleset was deployed into. |
| `resourceId` | string | The resource ID of the DNS Forwarding Ruleset. |

## Cross-referenced modules

_None_
