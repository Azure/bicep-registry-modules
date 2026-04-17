# Dev Center Project Policy `[Microsoft.DevCenter/devcenters/projectPolicies]`

This module deploys a Dev Center Project Policy.

You can reference the module as follows:
```bicep
module devcenter 'br/public:avm/res/dev-center/devcenter/project-policy:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DevCenter/devcenters/projectPolicies` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devcenter_devcenters_projectpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/projectPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the project policy. |
| [`resourcePolicies`](#parameter-resourcepolicies) | array | Resource policies that are a part of this project policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devcenterName`](#parameter-devcentername) | string | The name of the parent dev center. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`projectsResourceIdOrName`](#parameter-projectsresourceidorname) | array | Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned". |

### Parameter: `name`

The name of the project policy.

- Required: Yes
- Type: string

### Parameter: `resourcePolicies`

Resource policies that are a part of this project policy.

- Required: Yes
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-resourcepoliciesaction) | string | Policy action to be taken on the resources. Defaults to "Allow" if not specified. Cannot be used when the "resources" property is provided. |
| [`filter`](#parameter-resourcepoliciesfilter) | string | When specified, this expression is used to filter the resources. |
| [`resources`](#parameter-resourcepoliciesresources) | string | Explicit resources that are "allowed" as part of a project policy. Must be in the format of a resource ID. Cannot be used when the "resourceType" property is provided. |
| [`resourceType`](#parameter-resourcepoliciesresourcetype) | string | The resource type being restricted or allowed by a project policy. Used with a given "action" to restrict or allow access to a resource type. If not specified for a given policy, the action will be set to "Allow" for the unspecified resource types. For example, if the action is "Deny" for "Images" and "Skus", the project policy will deny access to images and skus, but allow access for remaining resource types like "AttachedNetworks". |

### Parameter: `resourcePolicies.action`

Policy action to be taken on the resources. Defaults to "Allow" if not specified. Cannot be used when the "resources" property is provided.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `resourcePolicies.filter`

When specified, this expression is used to filter the resources.

- Required: No
- Type: string

### Parameter: `resourcePolicies.resources`

Explicit resources that are "allowed" as part of a project policy. Must be in the format of a resource ID. Cannot be used when the "resourceType" property is provided.

- Required: No
- Type: string

### Parameter: `resourcePolicies.resourceType`

The resource type being restricted or allowed by a project policy. Used with a given "action" to restrict or allow access to a resource type. If not specified for a given policy, the action will be set to "Allow" for the unspecified resource types. For example, if the action is "Deny" for "Images" and "Skus", the project policy will deny access to images and skus, but allow access for remaining resource types like "AttachedNetworks".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AttachedNetworks'
    'Images'
    'Skus'
  ]
  ```

### Parameter: `devcenterName`

The name of the parent dev center. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `projectsResourceIdOrName`

Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned".

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Dev Center Project Policy. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Project Policy was created in. |
| `resourceId` | string | The resource ID of the Dev Center Project Policy. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
