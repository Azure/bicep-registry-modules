# Registration Definitions `[Microsoft.ManagedServices/registrationDefinitions]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
> 
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys a `Registration Definition` and a `Registration Assignment` (often referred to as 'Lighthouse' or 'resource delegation') on a subscription or resource group scope.
This type of delegation is very similar to role assignments but here the principal that is assigned a role is in a remote/managing Azure Active Directory tenant.
The templates are run towards the tenant where the Azure resources you want to delegate access to are, providing 'authorizations' (aka. access delegation) to principals in a remote/managing tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ManagedServices/registrationAssignments` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2022-10-01/registrationAssignments) |
| `Microsoft.ManagedServices/registrationDefinitions` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2022-10-01/registrationDefinitions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/managed-services/registration-definition:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Resource group deployment](#example-3-resource-group-deployment)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br/public:avm/res/managed-services/registration-definition:<version>' = {
  name: 'registrationDefinitionDeployment'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<managedByTenantId>'
    name: 'Component Validation - msrdmin Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    metadataLocation: '<metadataLocation>'
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
    "authorizations": {
      "value": [
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<managedByTenantId>"
    },
    "name": {
      "value": "Component Validation - msrdmin Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "metadataLocation": {
      "value": "<metadataLocation>"
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
module registrationDefinition 'br/public:avm/res/managed-services/registration-definition:<version>' = {
  name: 'registrationDefinitionDeployment'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        principalIdDisplayName: 'Lighthouse Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        principalIdDisplayName: 'Managed Services Registration assignment Delete Role'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
      {
        delegatedRoleDefinitionIds: [
          'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        ]
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
      }
    ]
    managedByTenantId: '<managedByTenantId>'
    name: 'Component Validation - msrdmax Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    metadataLocation: '<metadataLocation>'
    registrationId: '<registrationId>'
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
    "authorizations": {
      "value": [
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "principalIdDisplayName": "Lighthouse Contributor",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "principalIdDisplayName": "Managed Services Registration assignment Delete Role",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        },
        {
          "delegatedRoleDefinitionIds": [
            "acdd72a7-3385-48ef-bd42-f606fba81ae7"
          ],
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<managedByTenantId>"
    },
    "name": {
      "value": "Component Validation - msrdmax Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "metadataLocation": {
      "value": "<metadataLocation>"
    },
    "registrationId": {
      "value": "<registrationId>"
    }
  }
}
```

</details>
<p>

### Example 3: _Resource group deployment_

This instance deploys the module on a resource group.


<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br/public:avm/res/managed-services/registration-definition:<version>' = {
  name: 'registrationDefinitionDeployment'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<managedByTenantId>'
    name: 'Component Validation - msrdrg Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    metadataLocation: '<metadataLocation>'
    registrationId: '<registrationId>'
    resourceGroupName: '<resourceGroupName>'
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
    "authorizations": {
      "value": [
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<managedByTenantId>"
    },
    "name": {
      "value": "Component Validation - msrdrg Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "metadataLocation": {
      "value": "<metadataLocation>"
    },
    "registrationId": {
      "value": "<registrationId>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br/public:avm/res/managed-services/registration-definition:<version>' = {
  name: 'registrationDefinitionDeployment'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<managedByTenantId>'
    name: 'Component Validation - msrdwaf Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    metadataLocation: '<metadataLocation>'
    resourceGroupName: '<resourceGroupName>'
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
    "authorizations": {
      "value": [
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "ecadddf6-78c3-4516-afb2-7d30a174ea13",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<managedByTenantId>"
    },
    "name": {
      "value": "Component Validation - msrdwaf Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "metadataLocation": {
      "value": "<metadataLocation>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
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
| [`authorizations`](#parameter-authorizations) | array | Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers. |
| [`managedByTenantId`](#parameter-managedbytenantid) | string | Specify the tenant ID of the tenant which homes the principals you are delegating permissions to. |
| [`name`](#parameter-name) | string | Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>'. |
| [`registrationDescription`](#parameter-registrationdescription) | string | Description of the offer/registration. i.e. 'Managed by <Managing Org Name>'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`metadataLocation`](#parameter-metadatalocation) | string | Location of the deployment metadata. |
| [`registrationId`](#parameter-registrationid) | string | The Id (GUID) of the registration definition. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription. |

### Parameter: `authorizations`

Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-authorizationsprincipalid) | string | The identifier of the Azure Active Directory principal. |
| [`roleDefinitionId`](#parameter-authorizationsroledefinitionid) | string | The identifier of the Azure built-in role that defines the permissions that the Azure Active Directory principal will have on the projected scope. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`delegatedRoleDefinitionIds`](#parameter-authorizationsdelegatedroledefinitionids) | array | The list of role definition ids which define all the permissions that the user in the authorization can assign to other principals. Required if the `roleDefinitionId` refers to the User Access Administrator Role. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalIdDisplayName`](#parameter-authorizationsprincipaliddisplayname) | string | The display name of the Azure Active Directory principal. |

### Parameter: `authorizations.principalId`

The identifier of the Azure Active Directory principal.

- Required: Yes
- Type: string

### Parameter: `authorizations.roleDefinitionId`

The identifier of the Azure built-in role that defines the permissions that the Azure Active Directory principal will have on the projected scope.

- Required: Yes
- Type: string

### Parameter: `authorizations.delegatedRoleDefinitionIds`

The list of role definition ids which define all the permissions that the user in the authorization can assign to other principals. Required if the `roleDefinitionId` refers to the User Access Administrator Role.

- Required: No
- Type: array

### Parameter: `authorizations.principalIdDisplayName`

The display name of the Azure Active Directory principal.

- Required: No
- Type: string

### Parameter: `managedByTenantId`

Specify the tenant ID of the tenant which homes the principals you are delegating permissions to.

- Required: Yes
- Type: string

### Parameter: `name`

Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>'.

- Required: Yes
- Type: string

### Parameter: `registrationDescription`

Description of the offer/registration. i.e. 'Managed by <Managing Org Name>'.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `metadataLocation`

Location of the deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `registrationId`

The Id (GUID) of the registration definition.

- Required: No
- Type: string
- Default: `[if(empty(parameters('resourceGroupName')), guid(parameters('managedByTenantId'), subscription().tenantId, subscription().subscriptionId), guid(parameters('managedByTenantId'), subscription().tenantId, subscription().subscriptionId, parameters('resourceGroupName')))]`

### Parameter: `resourceGroupName`

Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `assignmentResourceId` | string | The registration assignment resource ID. |
| `name` | string | The name of the registration definition. |
| `resourceId` | string | The resource ID of the registration definition. |
| `subscriptionName` | string | The subscription the registration definition was deployed into. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
