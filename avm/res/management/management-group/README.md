# Management Groups `[Microsoft.Management/managementGroups]`

This template will prepare the management group structure based on the provided parameter.

This module has some known **limitations**:
- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Management/managementGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/management.management-group:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managementGroup 'br:bicep/modules/management.management-group:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-mmgmin'
  params: {
    // Required parameters
    name: 'mmgmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "mmgmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module managementGroup 'br:bicep/modules/management.management-group:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-mmgmax'
  params: {
    // Required parameters
    name: 'mmgmax001'
    // Non-required parameters
    displayName: 'Test MG'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    parentId: '<parentId>'
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
      "value": "mmgmax001"
    },
    // Non-required parameters
    "displayName": {
      "value": "Test MG"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "parentId": {
      "value": "<parentId>"
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
module managementGroup 'br:bicep/modules/management.management-group:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-mmgwaf'
  params: {
    // Required parameters
    name: 'mmgwaf001'
    // Non-required parameters
    displayName: 'Test MG'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    parentId: '<parentId>'
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
      "value": "mmgwaf001"
    },
    // Non-required parameters
    "displayName": {
      "value": "Test MG"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "parentId": {
      "value": "<parentId>"
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
| [`name`](#parameter-name) | string | The group ID of the Management group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The friendly name of the management group. If no value is passed then this field will be set to the group ID. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`parentId`](#parameter-parentid) | string | The management group parent ID. Defaults to current scope. |

### Parameter: `name`

The group ID of the Management group.

- Required: Yes
- Type: string

### Parameter: `displayName`

The friendly name of the management group. If no value is passed then this field will be set to the group ID.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `parentId`

The management group parent ID. Defaults to current scope.

- Required: No
- Type: string
- Default: `[last(split(managementGroup().id, '/'))]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the management group. |
| `resourceId` | string | The resource ID of the management group. |

## Cross-referenced modules

_None_

## Notes

### Considerations

This template is using a **Tenant level deployment**, meaning the user/principal deploying it needs to have the [proper access](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access)

If owner access is excessive, the following rights roles will grant enough rights:

- **Automation Job Operator** at **tenant** level (scope '/')
- **Management Group Contributor** at the top management group that needs to be managed

Consider using the following script:

```powershell
$PrincipalID = "<The object ID of the identity here>"
$TopMGID = "<The group ID of the management group here>"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/" -RoleDefinitionName "Automation Job Operator"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/providers/Microsoft.Management/managementGroups/$TopMGID" -RoleDefinitionName "Management Group Contributor"
```
