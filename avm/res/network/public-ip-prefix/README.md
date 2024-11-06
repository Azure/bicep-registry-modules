# Public IP Prefixes `[Microsoft.Network/publicIPPrefixes]`

This module deploys a Public IP Prefix.

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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/publicIPPrefixes` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/publicIPPrefixes) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/public-ip-prefix:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [IPv6 Public IP Prefix](#example-2-ipv6-public-ip-prefix)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module publicIpPrefix 'br/public:avm/res/network/public-ip-prefix:<version>' = {
  name: 'publicIpPrefixDeployment'
  params: {
    // Required parameters
    name: 'npipmin001'
    prefixLength: 28
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
    "name": {
      "value": "npipmin001"
    },
    "prefixLength": {
      "value": 28
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
using 'br/public:avm/res/network/public-ip-prefix:<version>'

// Required parameters
param name = 'npipmin001'
param prefixLength = 28
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _IPv6 Public IP Prefix_

This instance deploys the module using the IPv6 version of the Public IP Prefix.


<details>

<summary>via Bicep module</summary>

```bicep
module publicIpPrefix 'br/public:avm/res/network/public-ip-prefix:<version>' = {
  name: 'publicIpPrefixDeployment'
  params: {
    // Required parameters
    name: 'npipip6001'
    prefixLength: 127
    // Non-required parameters
    location: '<location>'
    publicIPAddressVersion: 'IPv6'
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
    "name": {
      "value": "npipip6001"
    },
    "prefixLength": {
      "value": 127
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "publicIPAddressVersion": {
      "value": "IPv6"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/public-ip-prefix:<version>'

// Required parameters
param name = 'npipip6001'
param prefixLength = 127
// Non-required parameters
param location = '<location>'
param publicIPAddressVersion = 'IPv6'
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module publicIpPrefix 'br/public:avm/res/network/public-ip-prefix:<version>' = {
  name: 'publicIpPrefixDeployment'
  params: {
    // Required parameters
    name: 'npipmax001'
    prefixLength: 28
    // Non-required parameters
    ipTags: [
      {
        ipTagType: 'RoutingPreference'
        tag: 'Internet'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'bf62ed65-07be-48e8-b760-2d59795cd282'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zones: [
      1
      2
    ]
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
    "name": {
      "value": "npipmax001"
    },
    "prefixLength": {
      "value": 28
    },
    // Non-required parameters
    "ipTags": {
      "value": [
        {
          "ipTagType": "RoutingPreference",
          "tag": "Internet"
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
          "name": "bf62ed65-07be-48e8-b760-2d59795cd282",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
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
    "zones": {
      "value": [
        1,
        2
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/public-ip-prefix:<version>'

// Required parameters
param name = 'npipmax001'
param prefixLength = 28
// Non-required parameters
param ipTags = [
  {
    ipTagType: 'RoutingPreference'
    tag: 'Internet'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: 'bf62ed65-07be-48e8-b760-2d59795cd282'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zones = [
  1
  2
]
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module publicIpPrefix 'br/public:avm/res/network/public-ip-prefix:<version>' = {
  name: 'publicIpPrefixDeployment'
  params: {
    // Required parameters
    name: 'npipwaf001'
    prefixLength: 28
    // Non-required parameters
    location: '<location>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "npipwaf001"
    },
    "prefixLength": {
      "value": 28
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/public-ip-prefix:<version>'

// Required parameters
param name = 'npipwaf001'
param prefixLength = 28
// Non-required parameters
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Public IP Prefix. |
| [`prefixLength`](#parameter-prefixlength) | int | Length of the Public IP Prefix. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customIPPrefix`](#parameter-customipprefix) | object | The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipTags`](#parameter-iptags) | array | The list of tags associated with the public IP prefix. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`publicIPAddressVersion`](#parameter-publicipaddressversion) | string | The public IP address version. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tier`](#parameter-tier) | string | Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty. |
| [`zones`](#parameter-zones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes. |

### Parameter: `name`

The name of the Public IP Prefix.

- Required: Yes
- Type: string

### Parameter: `prefixLength`

Length of the Public IP Prefix.

- Required: Yes
- Type: int

### Parameter: `customIPPrefix`

The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ipTags`

The list of tags associated with the public IP prefix.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-iptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-iptagstag) | string | The IP tag. |

### Parameter: `ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `publicIPAddressVersion`

The public IP address version.

- Required: No
- Type: string
- Default: `'IPv4'`
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tier`

Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty.

- Required: No
- Type: string
- Default: `'Regional'`
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `zones`

A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the public IP prefix. |
| `resourceGroupName` | string | The resource group the public IP prefix was deployed into. |
| `resourceId` | string | The resource ID of the public IP prefix. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
