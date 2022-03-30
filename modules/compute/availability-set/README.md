# Availability Set

This template deploys Microsoft.Compute Availability Sets and optionally available children or extensions

## Parameters

| Name                          | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                    |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                        | `string` | Yes      | Required. The name of the availability set that is being created.                                                                                                                                                                                                                                                                                                                                              |
| `availabilitySetFaultDomain`  | `int`    | No       | Optional. The number of fault domains to use.                                                                                                                                                                                                                                                                                                                                                                  |
| `availabilitySetUpdateDomain` | `int`    | No       | Optional. The number of update domains to use.                                                                                                                                                                                                                                                                                                                                                                 |
| `availabilitySetSku`          | `string` | No       | Optional. Sku of the availability set. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks.                                                                                                                                                                                                                                                          |
| `proximityPlacementGroupId`   | `string` | No       | Optional. Resource ID of a proximity placement group.                                                                                                                                                                                                                                                                                                                                                          |
| `location`                    | `string` | No       | Optional. Resource location.                                                                                                                                                                                                                                                                                                                                                                                   |
| `lock`                        | `string` | No       | Optional. Specify the type of lock.                                                                                                                                                                                                                                                                                                                                                                            |
| `roleAssignments`             | `array`  | No       | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags`                        | `object` | No       | Optional. Tags of the availability set resource.                                                                                                                                                                                                                                                                                                                                                               |

## Outputs

| Name              | Type   | Description                                               |
| :---------------- | :----: | :-------------------------------------------------------- |
| name              | string | The name of the availability set                          |
| resourceId        | string | The resource ID of the availability set                   |
| resourceGroupName | string | The resource group the availability set was deployed into |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```