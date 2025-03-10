# Azure Maps Account `[Microsoft.Maps/accounts]`

This module deploys an Azure Maps Account.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Maps/accounts` | [2024-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maps/2024-07-01-preview/accounts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/maps/account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/maps/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'mamin001'
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
      "value": "mamin001"
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
using 'br/public:avm/res/maps/account:<version>'

// Required parameters
param name = 'mamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/maps/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'mamax001'
    // Non-required parameters
    corsRules: [
      {
        allowedOrigins: [
          'https://www.bing.com'
          'https://www.microsoft.com'
        ]
      }
      {
        allowedOrigins: [
          'https://www.microsoft.com'
        ]
      }
    ]
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    disableLocalAuth: true
    kind: 'Gen2'
    linkedResources: [
      {
        id: '<id>'
        uniqueName: '<uniqueName>'
      }
    ]
    location: '<location>'
    locations: [
      'eastus'
      'westeurope'
    ]
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        roleDefinitionIdOrName: 'Azure Maps Data Reader'
      }
    ]
    sku: 'G2'
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
      "value": "mamax001"
    },
    // Non-required parameters
    "corsRules": {
      "value": [
        {
          "allowedOrigins": [
            "https://www.bing.com",
            "https://www.microsoft.com"
          ]
        },
        {
          "allowedOrigins": [
            "https://www.microsoft.com"
          ]
        }
      ]
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "disableLocalAuth": {
      "value": true
    },
    "kind": {
      "value": "Gen2"
    },
    "linkedResources": {
      "value": [
        {
          "id": "<id>",
          "uniqueName": "<uniqueName>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "locations": {
      "value": [
        "eastus",
        "westeurope"
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "roleDefinitionIdOrName": "Azure Maps Data Reader"
        }
      ]
    },
    "sku": {
      "value": "G2"
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
using 'br/public:avm/res/maps/account:<version>'

// Required parameters
param name = 'mamax001'
// Non-required parameters
param corsRules = [
  {
    allowedOrigins: [
      'https://www.bing.com'
      'https://www.microsoft.com'
    ]
  }
  {
    allowedOrigins: [
      'https://www.microsoft.com'
    ]
  }
]
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param disableLocalAuth = true
param kind = 'Gen2'
param linkedResources = [
  {
    id: '<id>'
    uniqueName: '<uniqueName>'
  }
]
param location = '<location>'
param locations = [
  'eastus'
  'westeurope'
]
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Azure Maps Data Reader'
  }
]
param sku = 'G2'
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
module account 'br/public:avm/res/maps/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'mawaf001'
    // Non-required parameters
    corsRules: [
      {
        allowedOrigins: [
          'https://www.bing.com'
        ]
      }
      {
        allowedOrigins: [
          'https://www.bing.de'
        ]
      }
    ]
    disableLocalAuth: true
    kind: 'Gen2'
    location: '<location>'
    locations: [
      'eastus'
      'westeurope'
    ]
    sku: 'G2'
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
      "value": "mawaf001"
    },
    // Non-required parameters
    "corsRules": {
      "value": [
        {
          "allowedOrigins": [
            "https://www.bing.com"
          ]
        },
        {
          "allowedOrigins": [
            "https://www.bing.de"
          ]
        }
      ]
    },
    "disableLocalAuth": {
      "value": true
    },
    "kind": {
      "value": "Gen2"
    },
    "location": {
      "value": "<location>"
    },
    "locations": {
      "value": [
        "eastus",
        "westeurope"
      ]
    },
    "sku": {
      "value": "G2"
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
using 'br/public:avm/res/maps/account:<version>'

// Required parameters
param name = 'mawaf001'
// Non-required parameters
param corsRules = [
  {
    allowedOrigins: [
      'https://www.bing.com'
    ]
  }
  {
    allowedOrigins: [
      'https://www.bing.de'
    ]
  }
]
param disableLocalAuth = true
param kind = 'Gen2'
param location = '<location>'
param locations = [
  'eastus'
  'westeurope'
]
param sku = 'G2'
param tags = {
  costCenter: '1234'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsRules`](#parameter-corsrules) | array | Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Allows toggle functionality on Azure Policy to disable Azure Maps local authentication support. This will disable Shared Keys and Shared Access Signature Token authentication from any usage. Default is true. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kind`](#parameter-kind) | string | The kind of the Maps Account. Default is Gen2. |
| [`linkedResources`](#parameter-linkedresources) | array | The array of associated resources to the Maps account. Linked resource in the array cannot individually update, you must update all linked resources in the array together. These resources may be used on operations on the Azure Maps REST API. Access is controlled by the Maps Account Managed Identity(s) permissions to those resource(s). |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`locations`](#parameter-locations) | array | List of additional data processing regions for the Maps Account, which may result in requests being processed in another geography. Some features or results may be restricted to specific regions. By default, Maps REST APIs process requests according to the account location or the geographic scope. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | string | Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | The SKU of the Maps Account. Default is G2. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `corsRules`

Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedOrigins`](#parameter-corsrulesallowedorigins) | array | The allowed origins for the CORS rule. |

### Parameter: `corsRules.allowedOrigins`

The allowed origins for the CORS rule.

- Required: Yes
- Type: array

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `disableLocalAuth`

Allows toggle functionality on Azure Policy to disable Azure Maps local authentication support. This will disable Shared Keys and Shared Access Signature Token authentication from any usage. Default is true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kind`

The kind of the Maps Account. Default is Gen2.

- Required: No
- Type: string
- Default: `'Gen2'`

### Parameter: `linkedResources`

The array of associated resources to the Maps account. Linked resource in the array cannot individually update, you must update all linked resources in the array together. These resources may be used on operations on the Azure Maps REST API. Access is controlled by the Maps Account Managed Identity(s) permissions to those resource(s).

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-linkedresourcesid) | string | ARM resource id in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/accounts/{storageName}'. |
| [`uniqueName`](#parameter-linkedresourcesuniquename) | string | A provided name which uniquely identifies the linked resource. |

### Parameter: `linkedResources.id`

ARM resource id in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/accounts/{storageName}'.

- Required: Yes
- Type: string

### Parameter: `linkedResources.uniqueName`

A provided name which uniquely identifies the linked resource.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `locations`

List of additional data processing regions for the Maps Account, which may result in requests being processed in another geography. Some features or results may be restricted to specific regions. By default, Maps REST APIs process requests according to the account location or the geographic scope.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `requireInfrastructureEncryption`

Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Maps Search and Render Data Reader'`
  - `'Azure Maps Data Reader'`
  - `'Azure Maps Data Contributor'`
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

### Parameter: `sku`

The SKU of the Maps Account. Default is G2.

- Required: No
- Type: string
- Default: `'G2'`
- Allowed:
  ```Bicep
  [
    'G2'
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
| `name` | string | The name of the Maps Account. |
| `resourceGroupName` | string | The name of the resource group the Maps Account was deployed into. |
| `resourceId` | string | The resource ID of the Maps Account. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
