<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/compute/availability-set](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/compute/availability-set).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Availability Set

This module deploys Microsoft.Compute Availability Sets and optionally available children or extensions

## Details

{{ Add detailed information about the module. }}

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

| Name                | Type     | Description                                               |
| :------------------ | :------: | :-------------------------------------------------------- |
| `name`              | `string` | The name of the availability set                          |
| `resourceId`        | `string` | The resource ID of the availability set                   |
| `resourceGroupName` | `string` | The resource group the availability set was deployed into |

## Examples

### Example 1

Example invocation with the minimum required parameters.

```bicep
module minavs 'br/public:compute/availability-set:1.0.2' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-minavs'
  params: {
    name: 'carml-az-avs-min-01'
  }
}
```

### Example 2

Example invocation with several properties including tags & role assignments.

```bicep
module genavs 'br/public:compute/availability-set:1.0.2' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-genavs'
  params: {
    name: 'carml-az-avs-gen-01'
    proximityPlacementGroupId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.Compute/proximityPlacementGroups/adp-carml-az-ppg-x-001'
    availabilitySetSku: 'aligned'
    availabilitySetUpdateDomain: 2
    availabilitySetFaultDomain: 2
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
    location: 'WestEurope'
  }
}
```
