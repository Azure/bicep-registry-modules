# Compute Galleries Applications `[Microsoft.Compute/galleries/applications]`

This module deploys an Azure Compute Gallery Application.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the application definition. |
| [`supportedOSType`](#parameter-supportedostype) | string | This property allows you to specify the supported type of the OS that application is built for. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryName`](#parameter-galleryname) | string | The name of the parent Azure Compute Gallery. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customActions`](#parameter-customactions) | array | A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application. |
| [`description`](#parameter-description) | string | The description of this gallery Application Definition resource. This property is updatable. |
| [`endOfLifeDate`](#parameter-endoflifedate) | string | The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z. |
| [`eula`](#parameter-eula) | string | The Eula agreement for the gallery Application Definition. Has to be a valid URL. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`privacyStatementUri`](#parameter-privacystatementuri) | string | The privacy statement uri. Has to be a valid URL. |
| [`releaseNoteUri`](#parameter-releasenoteuri) | string | The release note uri. Has to be a valid URL. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `name`

Name of the application definition.

- Required: Yes
- Type: string

### Parameter: `supportedOSType`

This property allows you to specify the supported type of the OS that application is built for.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `galleryName`

The name of the parent Azure Compute Gallery. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `customActions`

A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.

- Required: No
- Type: array

### Parameter: `description`

The description of this gallery Application Definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `endOfLifeDate`

The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.

- Required: No
- Type: string

### Parameter: `eula`

The Eula agreement for the gallery Application Definition. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `privacyStatementUri`

The privacy statement uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Compute Gallery Sharing Admin'`
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

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |

## Notes

### Parameter Usage: `customActions`

Create a list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.

<details>

<summary>Parameter JSON format</summary>

```json
"customActions": {
    "value": [
        {
            "description": "This is a sample custom action",
            "name": "Name of the custom action 1 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                },
                {
                    "defaultValue": "Default Value of Parameter2. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": False,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        },
        {
            "description": "This is another sample custom action",
            "name": "Name of the custom action 2 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customActions: [
    {
        description: "This is a sample custom action"
        name: "Name of the custom action 1 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter 1. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
            {
                defaultValue: "Default Value of Parameter 2. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
    {
        description: "This is another sample custom action"
        name: "Name of the custom action 2 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The paramter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
]
```

</details>
<p>
