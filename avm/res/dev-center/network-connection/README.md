# Dev Center Network Connection `[Microsoft.DevCenter/networkConnections]`

This module deploys an Azure Dev Center Network Connection.

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
| `Microsoft.DevCenter/networkConnections` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/networkConnections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/dev-center/network-connection:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkConnection 'br/public:avm/res/dev-center/network-connection:<version>' = {
  name: 'networkConnectionDeployment'
  params: {
    // Required parameters
    name: 'dcncmin001'
    subnetResourceId: '<subnetResourceId>'
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
      "value": "dcncmin001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/network-connection:<version>'

// Required parameters
param name = 'dcncmin001'
param subnetResourceId = '<subnetResourceId>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkConnection 'br/public:avm/res/dev-center/network-connection:<version>' = {
  name: 'networkConnectionDeployment'
  params: {
    // Required parameters
    name: 'dcncmax001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    domainJoinType: 'HybridAzureADJoin'
    domainName: 'contoso.com'
    domainPassword: '<domainPassword>'
    domainUsername: 'admin@contoso.com'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkingResourceGroupName: 'rg-dcncmax-networking'
    organizationUnit: 'OU=Computers,DC=contoso,DC=com'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Network Contributor'
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
      costCenter: '1234'
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
      "value": "dcncmax001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "domainJoinType": {
      "value": "HybridAzureADJoin"
    },
    "domainName": {
      "value": "contoso.com"
    },
    "domainPassword": {
      "value": "<domainPassword>"
    },
    "domainUsername": {
      "value": "admin@contoso.com"
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
    "networkingResourceGroupName": {
      "value": "rg-dcncmax-networking"
    },
    "organizationUnit": {
      "value": "OU=Computers,DC=contoso,DC=com"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Network Contributor"
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
        "costCenter": "1234"
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
using 'br/public:avm/res/dev-center/network-connection:<version>'

// Required parameters
param name = 'dcncmax001'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param domainJoinType = 'HybridAzureADJoin'
param domainName = 'contoso.com'
param domainPassword = '<domainPassword>'
param domainUsername = 'admin@contoso.com'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param networkingResourceGroupName = 'rg-dcncmax-networking'
param organizationUnit = 'OU=Computers,DC=contoso,DC=com'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Network Contributor'
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
  costCenter: '1234'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module networkConnection 'br/public:avm/res/dev-center/network-connection:<version>' = {
  name: 'networkConnectionDeployment'
  params: {
    // Required parameters
    name: 'dcncwaf001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    domainJoinType: 'AzureADJoin'
    networkingResourceGroupName: 'rg-dcncwaf-networking'
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
      "value": "dcncwaf001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "domainJoinType": {
      "value": "AzureADJoin"
    },
    "networkingResourceGroupName": {
      "value": "rg-dcncwaf-networking"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/network-connection:<version>'

// Required parameters
param name = 'dcncwaf001'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param domainJoinType = 'AzureADJoin'
param networkingResourceGroupName = 'rg-dcncwaf-networking'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Dev Center Network Connection. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The subnet to attach Virtual Machines to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | Active Directory domain name. Required if domainJoinType is "HybridAzureADJoin"". |
| [`domainPassword`](#parameter-domainpassword) | securestring | The password for the account used to join the domain. Required if domainJoinType is "HybridAzureADJoin". |
| [`domainUsername`](#parameter-domainusername) | string | The username of an Active Directory account (user or service account) that has permissions to create computer objects in Active Directory. Required format: admin@contoso.com. Required if domainJoinType is "HybridAzureADJoin". |
| [`organizationUnit`](#parameter-organizationunit) | string | Active Directory domain Organization Unit (OU). Required if domainJoinType is "HybridAzureADJoin". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainJoinType`](#parameter-domainjointype) | string | AAD Join type for the network connection. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`networkingResourceGroupName`](#parameter-networkingresourcegroupname) | string | The name for the resource group where NICs will be placed. If not provided, the default name "NI_networkConnectionName_region" (e.g. "NI_myNetworkConnection_eastus") will be used. It cannot be an existing resource group. It will also contain a health check Network Interface (NIC) resource for the network connection. This NIC name will be "nic-CPC-Hth-<randomString>_<date>" (e.g. "nic-CPC-Hth-12345678_2023-10-01"). |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Dev Center Network Connection.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The subnet to attach Virtual Machines to.

- Required: Yes
- Type: string

### Parameter: `domainName`

Active Directory domain name. Required if domainJoinType is "HybridAzureADJoin"".

- Required: No
- Type: string

### Parameter: `domainPassword`

The password for the account used to join the domain. Required if domainJoinType is "HybridAzureADJoin".

- Required: No
- Type: securestring

### Parameter: `domainUsername`

The username of an Active Directory account (user or service account) that has permissions to create computer objects in Active Directory. Required format: admin@contoso.com. Required if domainJoinType is "HybridAzureADJoin".

- Required: No
- Type: string

### Parameter: `organizationUnit`

Active Directory domain Organization Unit (OU). Required if domainJoinType is "HybridAzureADJoin".

- Required: No
- Type: string

### Parameter: `domainJoinType`

AAD Join type for the network connection.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'AzureADJoin'
    'HybridAzureADJoin'
    'None'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `networkingResourceGroupName`

The name for the resource group where NICs will be placed. If not provided, the default name "NI_networkConnectionName_region" (e.g. "NI_myNetworkConnection_eastus") will be used. It cannot be an existing resource group. It will also contain a health check Network Interface (NIC) resource for the network connection. This NIC name will be "nic-CPC-Hth-<randomString>_<date>" (e.g. "nic-CPC-Hth-12345678_2023-10-01").

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
| `name` | string | The name of the deployed network connection. |
| `resourceGroupName` | string | The name of the resource group the network connection was deployed into. |
| `resourceId` | string | The resource ID of the deployed network connection. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
