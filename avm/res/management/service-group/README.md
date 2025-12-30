# Service Groups `[Microsoft.Management/serviceGroups]`

This module will allow you to create a service group and also associate resource to this service group, if you have permissions upon those resources.

You can reference the module as follows:
```bicep
module serviceGroup 'br/public:avm/res/management/service-group:<version>' = {
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
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Management/serviceGroups` | 2024-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.management_servicegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2024-02-01-preview/serviceGroups)</li></ul> |
| `Microsoft.Relationships/serviceGroupMember` | 2023-09-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.relationships_servicegroupmember.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relationships/2023-09-01-preview/serviceGroupMember)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/management/service-group:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Maximum configuration](#example-2-maximum-configuration)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module serviceGroup 'br/public:avm/res/management/service-group:<version>' = {
  params: {
    name: '<name>'
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
    "name": {
      "value": "<name>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/management/service-group:<version>'

param name = '<name>'
```

</details>
<p>

### Example 2: _Maximum configuration_

This instance deploys the module with the maximum set of parameters supported.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module serviceGroup 'br/public:avm/res/management/service-group:<version>' = {
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    displayName: 'Service Group E2E Test Maximum Configuration'
    parentServiceGroupResourceId: '<parentServiceGroupResourceId>'
    resourceGroupResourceIdsToAssociateToServiceGroup: [
      '<resourceId>'
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        roleDefinitionIdOrName: 'Service Group Reader'
      }
    ]
    subscriptionIdsToAssociateToServiceGroup: [
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
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "displayName": {
      "value": "Service Group E2E Test Maximum Configuration"
    },
    "parentServiceGroupResourceId": {
      "value": "<parentServiceGroupResourceId>"
    },
    "resourceGroupResourceIdsToAssociateToServiceGroup": {
      "value": [
        "<resourceId>"
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "roleDefinitionIdOrName": "Service Group Reader"
        }
      ]
    },
    "subscriptionIdsToAssociateToServiceGroup": {
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
using 'br/public:avm/res/management/service-group:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param displayName = 'Service Group E2E Test Maximum Configuration'
param parentServiceGroupResourceId = '<parentServiceGroupResourceId>'
param resourceGroupResourceIdsToAssociateToServiceGroup = [
  '<resourceId>'
]
param roleAssignments = [
  {
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Service Group Reader'
  }
]
param subscriptionIdsToAssociateToServiceGroup = [
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
module serviceGroup 'br/public:avm/res/management/service-group:<version>' = {
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    displayName: 'Service Group E2E Test WAF Aligned'
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
      "value": "<name>"
    },
    // Non-required parameters
    "displayName": {
      "value": "Service Group E2E Test WAF Aligned"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/management/service-group:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param displayName = 'Service Group E2E Test WAF Aligned'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the service group to create. Must be globally unique. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Display name of the service group to create. If not provided, the name parameter input value will be used. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`parentServiceGroupResourceId`](#parameter-parentservicegroupresourceid) | string | The parent service group resource ID, e.g. "/providers/Microsoft.Management/serviceGroups/<name>", of the service group to create. If not provided, the service group will be created under the root service group, e.g. "/providers/Microsoft.Management/serviceGroups/<TENANT ID>". |
| [`resourceGroupResourceIdsToAssociateToServiceGroup`](#parameter-resourcegroupresourceidstoassociatetoservicegroup) | array | An array of resource group resource IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target resource groups. The relationship name is generated using uniqueString() function with the service group ID and the resource group resource ID as inputs. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`subscriptionIdsToAssociateToServiceGroup`](#parameter-subscriptionidstoassociatetoservicegroup) | array | An array of subscription IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target subscriptions. The relationship name is generated using uniqueString() function with the service group ID and the subscription ID as inputs. |

### Parameter: `name`

Name of the service group to create. Must be globally unique.

- Required: Yes
- Type: string

### Parameter: `displayName`

Display name of the service group to create. If not provided, the name parameter input value will be used.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `parentServiceGroupResourceId`

The parent service group resource ID, e.g. "/providers/Microsoft.Management/serviceGroups/<name>", of the service group to create. If not provided, the service group will be created under the root service group, e.g. "/providers/Microsoft.Management/serviceGroups/<TENANT ID>".

- Required: No
- Type: string

### Parameter: `resourceGroupResourceIdsToAssociateToServiceGroup`

An array of resource group resource IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target resource groups. The relationship name is generated using uniqueString() function with the service group ID and the resource group resource ID as inputs.

- Required: No
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Service Group Administrator'`
  - `'Service Group Contributor'`
  - `'Service Group Reader'`

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

### Parameter: `subscriptionIdsToAssociateToServiceGroup`

An array of subscription IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target subscriptions. The relationship name is generated using uniqueString() function with the service group ID and the subscription ID as inputs.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the service group. |
| `resourceId` | string | The resource ID of the service group. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Notes

This module only supports creating a service group and optionally adding members that are of types: `Subscription` and `Resource Group`. Resource member types, e.g. a storage account or virtual machine, are not supported in this module at this time due to limitations of Bicep. However, the AVM team are planning to add a new shared interface for all resource modules to implement, which will allow you to optionally associate the resource to a service group as part of the resource module itself; you can track the progress of this feature in the issue [2324](https://github.com/Azure/Azure-Verified-Modules/issues/2324).

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
