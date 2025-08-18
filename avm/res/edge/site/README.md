# Microsoft Edge Site `[Microsoft.Edge/sites]`

This module deploys a Microsoft Edge Site at subscription or resource group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Edge/sites` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.edge_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Edge/2025-06-01/sites)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/edge/site:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using subscription scope deployment](#example-2-using-subscription-scope-deployment)
- [Using Well-Architected Framework aligned parameters](#example-3-using-well-architected-framework-aligned-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    displayName: 'Test Edge Site'
    location: '<location>'
    name: 'esmin001'
    siteAddress: {
      country: 'US'
    }
    // Non-required parameters
    resourceGroupName: '<resourceGroupName>'
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
    "displayName": {
      "value": "Test Edge Site"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "esmin001"
    },
    "siteAddress": {
      "value": {
        "country": "US"
      }
    },
    // Non-required parameters
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/edge/site:<version>'

// Required parameters
param displayName = 'Test Edge Site'
param location = '<location>'
param name = 'esmin001'
param siteAddress = {
  country: 'US'
}
// Non-required parameters
param resourceGroupName = '<resourceGroupName>'
```

</details>
<p>

### Example 2: _Using subscription scope deployment_

This instance deploys the module at subscription scope without requiring a resource group.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    displayName: 'Subscription-Scoped Edge Site'
    location: '<location>'
    name: 'essub001'
    siteAddress: {
      country: 'US'
    }
    // Non-required parameters
    deploymentScope: 'subscription'
    siteDescription: 'Edge site deployed at subscription scope'
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
    "displayName": {
      "value": "Subscription-Scoped Edge Site"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "essub001"
    },
    "siteAddress": {
      "value": {
        "country": "US"
      }
    },
    // Non-required parameters
    "deploymentScope": {
      "value": "subscription"
    },
    "siteDescription": {
      "value": "Edge site deployed at subscription scope"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/edge/site:<version>'

// Required parameters
param displayName = 'Subscription-Scoped Edge Site'
param location = '<location>'
param name = 'essub001'
param siteAddress = {
  country: 'US'
}
// Non-required parameters
param deploymentScope = 'subscription'
param siteDescription = 'Edge site deployed at subscription scope'
```

</details>
<p>

### Example 3: _Using Well-Architected Framework aligned parameters_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    displayName: 'Production Edge Site'
    location: '<location>'
    name: 'eswaf001'
    siteAddress: {
      city: 'New York'
      country: 'US'
      postalCode: '10001'
      stateOrProvince: 'New York'
      streetAddress1: '350 Fifth Avenue'
      streetAddress2: 'Floor 34'
    }
    // Non-required parameters
    labels: {
      businessUnit: 'IT'
      costCenter: 'CC-1234'
      environment: 'production'
      project: 'EdgeDeployment'
    }
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    resourceGroupName: '<resourceGroupName>'
    siteDescription: 'Production edge site for region deployment'
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
    "displayName": {
      "value": "Production Edge Site"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "eswaf001"
    },
    "siteAddress": {
      "value": {
        "city": "New York",
        "country": "US",
        "postalCode": "10001",
        "stateOrProvince": "New York",
        "streetAddress1": "350 Fifth Avenue",
        "streetAddress2": "Floor 34"
      }
    },
    // Non-required parameters
    "labels": {
      "value": {
        "businessUnit": "IT",
        "costCenter": "CC-1234",
        "environment": "production",
        "project": "EdgeDeployment"
      }
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "siteDescription": {
      "value": "Production edge site for region deployment"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/edge/site:<version>'

// Required parameters
param displayName = 'Production Edge Site'
param location = '<location>'
param name = 'eswaf001'
param siteAddress = {
  city: 'New York'
  country: 'US'
  postalCode: '10001'
  stateOrProvince: 'New York'
  streetAddress1: '350 Fifth Avenue'
  streetAddress2: 'Floor 34'
}
// Non-required parameters
param labels = {
  businessUnit: 'IT'
  costCenter: 'CC-1234'
  environment: 'production'
  project: 'EdgeDeployment'
}
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param resourceGroupName = '<resourceGroupName>'
param siteDescription = 'Production edge site for region deployment'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the site. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`siteAddress`](#parameter-siteaddress) | object | The physical address configuration of the site. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the resource group. Required if deploymentScope is "resourceGroup". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentScope`](#parameter-deploymentscope) | string | The scope at which to deploy the module. Valid values are "subscription" or "resourceGroup". |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`labels`](#parameter-labels) | object | Labels for the site. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`siteDescription`](#parameter-sitedescription) | string | The description of the site. |

### Parameter: `displayName`

The display name of the site.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `siteAddress`

The physical address configuration of the site.

- Required: Yes
- Type: object

### Parameter: `resourceGroupName`

Name of the resource group. Required if deploymentScope is "resourceGroup".

- Required: No
- Type: string

### Parameter: `deploymentScope`

The scope at which to deploy the module. Valid values are "subscription" or "resourceGroup".

- Required: No
- Type: string
- Default: `'resourceGroup'`
- Allowed:
  ```Bicep
  [
    'resourceGroup'
    'subscription'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `labels`

Labels for the site.

- Required: No
- Type: object

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

### Parameter: `siteDescription`

The description of the site.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceId` | string | The resource ID of the site. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
