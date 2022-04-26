# User Assigned Identities

This module deploys Microsoft.ManagedIdentity User Assigned Identities and optionally available children or extensions

## Parameters

| Name              | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                    |
| :---------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`            | `string` | Yes      | Required. Name of the User Assigned Identity.                                                                                                                                                                                                                                                                                                                                                                  |
| `location`        | `string` | No       | Optional. Location for all resources.                                                                                                                                                                                                                                                                                                                                                                          |
| `lock`            | `string` | No       | Optional. Specify the type of lock.                                                                                                                                                                                                                                                                                                                                                                            |
| `roleAssignments` | `array`  | No       | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags`            | `object` | No       | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                                                                                                                |

## Outputs

| Name              | Type   | Description                                                     |
| :---------------- | :----: | :-------------------------------------------------------------- |
| name              | string | The name of the user assigned identity                          |
| resourceId        | string | The resource ID of the user assigned identity                   |
| principalId       | string | The principal ID of the user assigned identity                  |
| resourceGroupName | string | The resource group the user assigned identity was deployed into |

## Examples

### Example 1

Deployment of `1` user assigned identity using the minimum required parameters.

```bicep
module minMSI 'br/public:managed-identity/user-assigned-identity:1.0.1' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-min-msi'
  params: {
    name: 'carml-az-uai-min-01'
    location: 'WestEurope'
  }
}
```

### Example 2

Deployment of `1` user assigned identity with

- `2` tags
- `1` role assignment for `1` identity

```bicep
module genMSI 'br/public:managed-identity/user-assigned-identity:1.0.1' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-gen-msi'
  params: {
    name: 'carml-az-uai-gen-01'
    location: 'WestEurope'
    tags: {
      tag1: 'tag1Value'
      tag2: 'tag2Value'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '222222-2222-2222-2222-2222222222'
        ]
        principalType: 'ServicePrincipal'
      }
    ]
  }
}
```