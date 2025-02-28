# ExpressRoute Ports `[Microsoft.Network/ExpressRoutePorts]`

This module deploys an Express Route Port resource used by Express Route Direct.

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
| `Microsoft.Network/ExpressRoutePorts` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/ExpressRoutePorts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/express-route-port:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRoutePort 'br/public:avm/res/network/express-route-port:<version>' = {
  name: 'expressRoutePortDeployment'
  params: {
    // Required parameters
    bandwidthInGbps: 10
    name: 'nerpmin001'
    peeringLocation: 'Airtel-Chennai2-CLS'
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
    "bandwidthInGbps": {
      "value": 10
    },
    "name": {
      "value": "nerpmin001"
    },
    "peeringLocation": {
      "value": "Airtel-Chennai2-CLS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-port:<version>'

// Required parameters
param bandwidthInGbps = 10
param name = 'nerpmin001'
param peeringLocation = 'Airtel-Chennai2-CLS'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRoutePort 'br/public:avm/res/network/express-route-port:<version>' = {
  name: 'expressRoutePortDeployment'
  params: {
    // Required parameters
    bandwidthInGbps: 10
    name: 'nerpmax001'
    peeringLocation: 'Airtel-Chennai2-CLS'
    // Non-required parameters
    billingType: 'MeteredData'
    encapsulation: 'Dot1Q'
    links: [
      {
        name: 'link1'
        properties: {
          adminState: 'Disabled'
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'd7aa3dfa-6ba6-4ed8-b561-2164fbb1327e'
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
    "bandwidthInGbps": {
      "value": 10
    },
    "name": {
      "value": "nerpmax001"
    },
    "peeringLocation": {
      "value": "Airtel-Chennai2-CLS"
    },
    // Non-required parameters
    "billingType": {
      "value": "MeteredData"
    },
    "encapsulation": {
      "value": "Dot1Q"
    },
    "links": {
      "value": [
        {
          "name": "link1",
          "properties": {
            "adminState": "Disabled"
          }
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
          "name": "d7aa3dfa-6ba6-4ed8-b561-2164fbb1327e",
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-port:<version>'

// Required parameters
param bandwidthInGbps = 10
param name = 'nerpmax001'
param peeringLocation = 'Airtel-Chennai2-CLS'
// Non-required parameters
param billingType = 'MeteredData'
param encapsulation = 'Dot1Q'
param links = [
  {
    name: 'link1'
    properties: {
      adminState: 'Disabled'
    }
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: 'd7aa3dfa-6ba6-4ed8-b561-2164fbb1327e'
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
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRoutePort 'br/public:avm/res/network/express-route-port:<version>' = {
  name: 'expressRoutePortDeployment'
  params: {
    // Required parameters
    bandwidthInGbps: 10
    name: 'nerpwaf001'
    peeringLocation: 'Airtel-Chennai2-CLS'
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
    "bandwidthInGbps": {
      "value": 10
    },
    "name": {
      "value": "nerpwaf001"
    },
    "peeringLocation": {
      "value": "Airtel-Chennai2-CLS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-port:<version>'

// Required parameters
param bandwidthInGbps = 10
param name = 'nerpwaf001'
param peeringLocation = 'Airtel-Chennai2-CLS'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bandwidthInGbps`](#parameter-bandwidthingbps) | int | This is the bandwidth in Gbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call. |
| [`name`](#parameter-name) | string | This is the name of the ExpressRoute Port Resource. |
| [`peeringLocation`](#parameter-peeringlocation) | string | This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`billingType`](#parameter-billingtype) | string | Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encapsulation`](#parameter-encapsulation) | string | Encapsulation method on physical ports. |
| [`links`](#parameter-links) | array | Properties of the ExpressRouteLink. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `bandwidthInGbps`

This is the bandwidth in Gbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.

- Required: Yes
- Type: int

### Parameter: `name`

This is the name of the ExpressRoute Port Resource.

- Required: Yes
- Type: string

### Parameter: `peeringLocation`

This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.

- Required: Yes
- Type: string

### Parameter: `billingType`

Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.

- Required: No
- Type: string
- Default: `'MeteredData'`
- Allowed:
  ```Bicep
  [
    'MeteredData'
    'UnlimitedData'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encapsulation`

Encapsulation method on physical ports.

- Required: No
- Type: string
- Default: `'Dot1Q'`
- Allowed:
  ```Bicep
  [
    'Dot1Q'
    'QinQ'
  ]
  ```

### Parameter: `links`

Properties of the ExpressRouteLink.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-linksname) | string | The name of the link to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-linksid) | string | Resource Id of the existing Link. |
| [`properties`](#parameter-linksproperties) | object | Properties of the Link. |

### Parameter: `links.name`

The name of the link to be created.

- Required: Yes
- Type: string

### Parameter: `links.id`

Resource Id of the existing Link.

- Required: No
- Type: string

### Parameter: `links.properties`

Properties of the Link.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminState`](#parameter-linkspropertiesadminstate) | string | Administrative state of the physical port. Must be set to 'Disabled' for initial deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`macSecConfig`](#parameter-linkspropertiesmacsecconfig) | object | MacSec Configuration of the link. |

### Parameter: `links.properties.adminState`

Administrative state of the physical port. Must be set to 'Disabled' for initial deployment.

- Required: Yes
- Type: string

### Parameter: `links.properties.macSecConfig`

MacSec Configuration of the link.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cakSecretIdentifier`](#parameter-linkspropertiesmacsecconfigcaksecretidentifier) | string | Keyvault Secret Identifier URL containing Mac security CAK key. |
| [`cipher`](#parameter-linkspropertiesmacsecconfigcipher) | string | Mac security cipher. |
| [`cknSecretIdentifier`](#parameter-linkspropertiesmacsecconfigcknsecretidentifier) | string | Keyvault Secret Identifier URL containing Mac security CKN key. |
| [`sciState`](#parameter-linkspropertiesmacsecconfigscistate) | string | Sci mode. |

### Parameter: `links.properties.macSecConfig.cakSecretIdentifier`

Keyvault Secret Identifier URL containing Mac security CAK key.

- Required: Yes
- Type: string

### Parameter: `links.properties.macSecConfig.cipher`

Mac security cipher.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GcmAes128'
    'GcmAes256'
    'GcmAesXpn128'
    'GcmAesXpn256'
  ]
  ```

### Parameter: `links.properties.macSecConfig.cknSecretIdentifier`

Keyvault Secret Identifier URL containing Mac security CKN key.

- Required: Yes
- Type: string

### Parameter: `links.properties.macSecConfig.sciState`

Sci mode.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the ExpressRoute Gateway. |
| `resourceGroupName` | string | The resource group of the ExpressRoute Gateway was deployed into. |
| `resourceId` | string | The resource ID of the ExpressRoute Gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
