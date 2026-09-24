# Private Link Services `[Microsoft.Network/privateLinkServices]`

This module deploys a Private Link Service.

You can reference the module as follows:
```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Network/privateLinkServices` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatelinkservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateLinkServices)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/private-link-service:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  params: {
    // Required parameters
    ipConfigurations: [
      {
        name: 'nplsmin01'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nplsmin001'
    // Non-required parameters
    loadBalancerFrontendIpConfigurationResourceIds: [
      '<loadBalancerFrontendIpConfigurationResourceId>'
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
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmin01",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nplsmin001"
    },
    // Non-required parameters
    "loadBalancerFrontendIpConfigurationResourceIds": {
      "value": [
        "<loadBalancerFrontendIpConfigurationResourceId>"
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
using 'br/public:avm/res/network/private-link-service:<version>'

// Required parameters
param ipConfigurations = [
  {
    name: 'nplsmin01'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nplsmin001'
// Non-required parameters
param loadBalancerFrontendIpConfigurationResourceIds = [
  '<loadBalancerFrontendIpConfigurationResourceId>'
]
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  params: {
    // Required parameters
    ipConfigurations: [
      {
        name: 'nplsmax01'
        primary: true
        privateIPAllocationMethod: 'Dynamic'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nplsmax001'
    // Non-required parameters
    accessMode: 'Default'
    autoApprovalSubscriptionIds: [
      '*'
    ]
    enableProxyProtocol: true
    fqdns: [
      'nplsmax.plsfqdn01.azure.privatelinkservice'
      'nplsmax.plsfqdn02.azure.privatelinkservice'
    ]
    loadBalancerFrontendIpConfigurationResourceIds: [
      '<loadBalancerFrontendIpConfigurationResourceId>'
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'fec82bb5-8552-4c4b-a3f6-65bdae54d7f4'
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
    visibilitySubscriptionIds: [
      '<subscriptionId>'
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
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmax01",
          "primary": true,
          "privateIPAllocationMethod": "Dynamic",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nplsmax001"
    },
    // Non-required parameters
    "accessMode": {
      "value": "Default"
    },
    "autoApprovalSubscriptionIds": {
      "value": [
        "*"
      ]
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplsmax.plsfqdn01.azure.privatelinkservice",
        "nplsmax.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "loadBalancerFrontendIpConfigurationResourceIds": {
      "value": [
        "<loadBalancerFrontendIpConfigurationResourceId>"
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
          "name": "fec82bb5-8552-4c4b-a3f6-65bdae54d7f4",
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
    "visibilitySubscriptionIds": {
      "value": [
        "<subscriptionId>"
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
using 'br/public:avm/res/network/private-link-service:<version>'

// Required parameters
param ipConfigurations = [
  {
    name: 'nplsmax01'
    primary: true
    privateIPAllocationMethod: 'Dynamic'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nplsmax001'
// Non-required parameters
param accessMode = 'Default'
param autoApprovalSubscriptionIds = [
  '*'
]
param enableProxyProtocol = true
param fqdns = [
  'nplsmax.plsfqdn01.azure.privatelinkservice'
  'nplsmax.plsfqdn02.azure.privatelinkservice'
]
param loadBalancerFrontendIpConfigurationResourceIds = [
  '<loadBalancerFrontendIpConfigurationResourceId>'
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: 'fec82bb5-8552-4c4b-a3f6-65bdae54d7f4'
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
param visibilitySubscriptionIds = [
  '<subscriptionId>'
]
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  params: {
    // Required parameters
    ipConfigurations: [
      {
        name: 'nplswaf01'
        primary: true
        privateIPAllocationMethod: 'Dynamic'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nplswaf001'
    // Non-required parameters
    autoApprovalSubscriptionIds: [
      '*'
    ]
    enableProxyProtocol: true
    fqdns: [
      'nplswaf.plsfqdn01.azure.privatelinkservice'
      'nplswaf.plsfqdn02.azure.privatelinkservice'
    ]
    loadBalancerFrontendIpConfigurationResourceIds: [
      '<loadBalancerFrontendIpConfigurationResourceId>'
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    visibilitySubscriptionIds: [
      '<subscriptionId>'
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
    "ipConfigurations": {
      "value": [
        {
          "name": "nplswaf01",
          "primary": true,
          "privateIPAllocationMethod": "Dynamic",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nplswaf001"
    },
    // Non-required parameters
    "autoApprovalSubscriptionIds": {
      "value": [
        "*"
      ]
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplswaf.plsfqdn01.azure.privatelinkservice",
        "nplswaf.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "loadBalancerFrontendIpConfigurationResourceIds": {
      "value": [
        "<loadBalancerFrontendIpConfigurationResourceId>"
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "visibilitySubscriptionIds": {
      "value": [
        "<subscriptionId>"
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
using 'br/public:avm/res/network/private-link-service:<version>'

// Required parameters
param ipConfigurations = [
  {
    name: 'nplswaf01'
    primary: true
    privateIPAllocationMethod: 'Dynamic'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nplswaf001'
// Non-required parameters
param autoApprovalSubscriptionIds = [
  '*'
]
param enableProxyProtocol = true
param fqdns = [
  'nplswaf.plsfqdn01.azure.privatelinkservice'
  'nplswaf.plsfqdn02.azure.privatelinkservice'
]
param loadBalancerFrontendIpConfigurationResourceIds = [
  '<loadBalancerFrontendIpConfigurationResourceId>'
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param visibilitySubscriptionIds = [
  '<subscriptionId>'
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | An array of private link service IP configurations. At least one IP configuration is required on the private link service. |
| [`name`](#parameter-name) | string | The name of the private link service to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-accessmode) | string | The access mode of the private link service. Defaults to "Default" when not specified. |
| [`autoApprovalSubscriptionIds`](#parameter-autoapprovalsubscriptionids) | array | The list of subscription IDs allowed to automatically approve a connection to the private link service. Use `*` to auto-approve all subscriptions. |
| [`destinationIPAddress`](#parameter-destinationipaddress) | string | Privately routable destination IP for Private Link Service Direct Connect mode, used when consumers need direct IP routing instead of load-balancer forwarding (e.g. databases, legacy applications, on-premises endpoints). Mutually exclusive with `loadBalancerFrontendIpConfigurations`. |
| [`enableProxyProtocol`](#parameter-enableproxyprotocol) | bool | Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedLocation`](#parameter-extendedlocation) | object | The extended location of the load balancer. |
| [`fqdns`](#parameter-fqdns) | array | The list of Fqdn. |
| [`loadBalancerFrontendIpConfigurationResourceIds`](#parameter-loadbalancerfrontendipconfigurationresourceids) | array | Resource IDs of the Standard Load Balancer frontend IP configurations that the Private Link service is tied to. All traffic destined for the service reaches the load balancer frontend, where SLB rules direct it to backend pools. Mutually exclusive with `destinationIPAddress`. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags to be applied on all resources/resource groups in this deployment. |
| [`visibilitySubscriptionIds`](#parameter-visibilitysubscriptionids) | array | The list of subscription IDs the private link service is visible to. Service providers can limit exposure to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions by using `*`. |

### Parameter: `ipConfigurations`

An array of private link service IP configurations. At least one IP configuration is required on the private link service.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-ipconfigurationsname) | string | The name of the private link service IP configuration. |
| [`subnetResourceId`](#parameter-ipconfigurationssubnetresourceid) | string | The resource ID of the subnet to attach the IP configuration to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`primary`](#parameter-ipconfigurationsprimary) | bool | Whether the IP configuration is primary or not. |
| [`privateIPAddress`](#parameter-ipconfigurationsprivateipaddress) | string | The private IP address of the IP configuration. |
| [`privateIPAddressVersion`](#parameter-ipconfigurationsprivateipaddressversion) | string | Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4. |
| [`privateIPAllocationMethod`](#parameter-ipconfigurationsprivateipallocationmethod) | string | The private IP address allocation method. |

### Parameter: `ipConfigurations.name`

The name of the private link service IP configuration.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.subnetResourceId`

The resource ID of the subnet to attach the IP configuration to.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.primary`

Whether the IP configuration is primary or not.

- Required: No
- Type: bool

### Parameter: `ipConfigurations.privateIPAddress`

The private IP address of the IP configuration.

- Required: No
- Type: string

### Parameter: `ipConfigurations.privateIPAddressVersion`

Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `ipConfigurations.privateIPAllocationMethod`

The private IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `name`

The name of the private link service to create.

- Required: Yes
- Type: string

### Parameter: `accessMode`

The access mode of the private link service. Defaults to "Default" when not specified.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'Restricted'
  ]
  ```

### Parameter: `autoApprovalSubscriptionIds`

The list of subscription IDs allowed to automatically approve a connection to the private link service. Use `*` to auto-approve all subscriptions.

- Required: No
- Type: array

### Parameter: `destinationIPAddress`

Privately routable destination IP for Private Link Service Direct Connect mode, used when consumers need direct IP routing instead of load-balancer forwarding (e.g. databases, legacy applications, on-premises endpoints). Mutually exclusive with `loadBalancerFrontendIpConfigurations`.

- Required: No
- Type: string

### Parameter: `enableProxyProtocol`

Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedLocation`

The extended location of the load balancer.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-extendedlocationname) | string | The name of the extended location. |
| [`type`](#parameter-extendedlocationtype) | string | The type of the extended location. |

### Parameter: `extendedLocation.name`

The name of the extended location.

- Required: Yes
- Type: string

### Parameter: `extendedLocation.type`

The type of the extended location.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'EdgeZone'
  ]
  ```

### Parameter: `fqdns`

The list of Fqdn.

- Required: No
- Type: array

### Parameter: `loadBalancerFrontendIpConfigurationResourceIds`

Resource IDs of the Standard Load Balancer frontend IP configurations that the Private Link service is tied to. All traffic destined for the service reaches the load balancer frontend, where SLB rules direct it to backend pools. Mutually exclusive with `destinationIPAddress`.

- Required: No
- Type: array

### Parameter: `location`

Location for all Resources.

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

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
  - `'Private DNS Zone Contributor'`
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

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `visibilitySubscriptionIds`

The list of subscription IDs the private link service is visible to. Service providers can limit exposure to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions by using `*`.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private link service. |
| `resourceGroupName` | string | The resource group the private link service was deployed into. |
| `resourceId` | string | The resource ID of the private link service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
