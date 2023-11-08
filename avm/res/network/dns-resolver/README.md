# DNS Resolvers `[Microsoft.Network/dnsResolvers]`

This module deploys a DNS Resolver.

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
| `Microsoft.Network/dnsResolvers` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers) |
| `Microsoft.Network/dnsResolvers/inboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/inboundEndpoints) |
| `Microsoft.Network/dnsResolvers/outboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/outboundEndpoints) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/dns-resolver:0.1.1`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.
> **Note:** The test currently implements additional non-required parameters to cater for a test-specific limitation.



<details>

<summary>via Bicep module</summary>

```bicep
module dnsResolver 'br/public:avm/res/network/dns-resolver:0.1.1' = {
  name: '${uniqueString(deployment().name, location)}-test-ndrmin'
  params: {
    // Required parameters
    name: 'ndrmin001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    inboundEndpoints: []
    location: '<location>'
    lock: {}
    outboundEndpoints: []
    roleAssignments: []
    tags: {}
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
      "value": "ndrmin001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "inboundEndpoints": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {}
    },
    "outboundEndpoints": {
      "value": []
    },
    "roleAssignments": {
      "value": []
    },
    "tags": {
      "value": {}
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
module dnsResolver 'br/public:avm/res/network/dns-resolver:0.1.1' = {
  name: '${uniqueString(deployment().name, location)}-test-ndrmax'
  params: {
    // Required parameters
    name: 'ndrmax001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    inboundEndpoints: [
      {
        name: 'ndrmax-az-pdnsin-x-001'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    outboundEndpoints: [
      {
        name: 'ndrmax-az-pdnsout-x-001'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
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
      "value": "ndrmax001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "inboundEndpoints": {
      "value": [
        {
          "name": "ndrmax-az-pdnsin-x-001",
          "subnetResourceId": "<subnetResourceId>"
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
    "outboundEndpoints": {
      "value": [
        {
          "name": "ndrmax-az-pdnsout-x-001",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
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
module dnsResolver 'br/public:avm/res/network/dns-resolver:0.1.1' = {
  name: '${uniqueString(deployment().name, location)}-test-ndrwaf'
  params: {
    // Required parameters
    name: 'ndrwaf001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    inboundEndpoints: [
      {
        name: 'ndrwaf-az-pdnsin-x-001'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    outboundEndpoints: [
      {
        name: 'ndrwaf-az-pdnsout-x-001'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    roleAssignments: []
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
      "value": "ndrwaf001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "inboundEndpoints": {
      "value": [
        {
          "name": "ndrwaf-az-pdnsin-x-001",
          "subnetResourceId": "<subnetResourceId>"
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
    "outboundEndpoints": {
      "value": [
        {
          "name": "ndrwaf-az-pdnsout-x-001",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
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
| [`name`](#parameter-name) | string | Name of the Private DNS Resolver. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | ResourceId of the virtual network to attach the Private DNS Resolver to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`inboundEndpoints`](#parameter-inboundendpoints) | array | Inbound Endpoints for Private DNS Resolver. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`outboundEndpoints`](#parameter-outboundendpoints) | array | Outbound Endpoints for Private DNS Resolver. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `enableTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `inboundEndpoints`

Inbound Endpoints for Private DNS Resolver.
- Required: No
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

Name of the Private DNS Resolver.
- Required: Yes
- Type: string

### Parameter: `outboundEndpoints`

Outbound Endpoints for Private DNS Resolver.
- Required: No
- Type: array

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

### Parameter: `virtualNetworkResourceId`

ResourceId of the virtual network to attach the Private DNS Resolver to.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Private DNS Resolver. |
| `resourceGroupName` | string | The resource group the Private DNS Resolver was deployed into. |
| `resourceId` | string | The resource ID of the Private DNS Resolver. |

## Cross-referenced modules

_None_
