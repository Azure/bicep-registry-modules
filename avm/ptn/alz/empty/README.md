# avm/ptn/alz/empty `[Alz/Empty]`

Azure Landing Zones - Bicep - Empty

Please review the [Usage examples](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty#Usage-examples) section in the module's README, but please ensure for the `max` example you review the entire [directory](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty/tests/e2e/max) to see the supplementary files that are required for the example.

Also please ensure you review the [Notes section of the module's README](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty#Notes) for important information about the module as well as features that exist outside of parameter inputs.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-01-01/policyAssignments) |
| `Microsoft.Authorization/policyDefinitions` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-01-01/policyDefinitions) |
| `Microsoft.Authorization/policySetDefinitions` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-01-01/policySetDefinitions) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleDefinitions` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-05-01-preview/roleDefinitions) |
| `Microsoft.Management/managementGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups) |
| `Microsoft.Management/managementGroups/subscriptions` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2023-04-01/managementGroups/subscriptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/alz/empty:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using all parameters possible](#example-2-using-all-parameters-possible)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module empty 'br/public:avm/ptn/alz/empty:<version>' = {
  name: 'emptyDeployment'
  params: {
    managementGroupName: 'mg-test-alzempmin'
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
    "managementGroupName": {
      "value": "mg-test-alzempmin"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/empty:<version>'

param managementGroupName = 'mg-test-alzempmin'
```

</details>
<p>

### Example 2: _Using all parameters possible_

This instance deploys the module with the maximum set of parameters possible.


<details>

<summary>via Bicep module</summary>

```bicep
module empty 'br/public:avm/ptn/alz/empty:<version>' = {
  name: 'emptyDeployment'
  params: {
    // Required parameters
    managementGroupName: 'mg-test-alzempmax'
    // Non-required parameters
    createOrUpdateManagementGroup: true
    managementGroupCustomPolicyDefinitions: '<managementGroupCustomPolicyDefinitions>'
    managementGroupCustomPolicySetDefinitions: '<managementGroupCustomPolicySetDefinitions>'
    managementGroupCustomRoleDefinitions: '<managementGroupCustomRoleDefinitions>'
    managementGroupDisplayName: 'AVM ALZ PTN Empty Max Test'
    managementGroupPolicyAssignments: [
      {
        definitionVersion: '1.*.*'
        displayName: 'Allowed virtual machine size SKUs'
        enforcementMode: 'Default'
        identity: 'None'
        name: 'allowed-vm-skus-root'
        parameters: {
          listOfAllowedSKUs: {
            value: [
              'Standard_D2_v5'
              'Standard_E8_v5'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
      }
      {
        additionalManagementGroupsIDsToAssignRbacTo: [
          '<name>'
        ]
        displayName: 'Configure Azure Activity logs to stream to specified Log Analytics workspace'
        enforcementMode: 'Default'
        identity: 'SystemAssigned'
        name: 'diag-activity-log-lz'
        parameters: {
          logAnalytics: {
            value: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landing-zones/providers/Microsoft.OperationalInsights/workspaces/la-landing-zones'
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
        roleDefinitionIds: [
          '/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
          '/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
        ]
      }
      {
        displayName: 'Tag checking'
        enforcementMode: 'Default'
        identity: 'None'
        name: 'tags-policy'
        parameters: {
          effect: {
            value: 'Audit'
          }
          tagName: {
            value: 'costCenter'
          }
        }
        policyDefinitionId: '/providers/Microsoft.Management/managementGroups/mg-test-alzempmax/providers/Microsoft.Authorization/policySetDefinitions/custom-tags-policy-set-definition-1'
      }
    ]
    managementGroupRoleAssignments: '<managementGroupRoleAssignments>'
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
    "managementGroupName": {
      "value": "mg-test-alzempmax"
    },
    // Non-required parameters
    "createOrUpdateManagementGroup": {
      "value": true
    },
    "managementGroupCustomPolicyDefinitions": {
      "value": "<managementGroupCustomPolicyDefinitions>"
    },
    "managementGroupCustomPolicySetDefinitions": {
      "value": "<managementGroupCustomPolicySetDefinitions>"
    },
    "managementGroupCustomRoleDefinitions": {
      "value": "<managementGroupCustomRoleDefinitions>"
    },
    "managementGroupDisplayName": {
      "value": "AVM ALZ PTN Empty Max Test"
    },
    "managementGroupPolicyAssignments": {
      "value": [
        {
          "definitionVersion": "1.*.*",
          "displayName": "Allowed virtual machine size SKUs",
          "enforcementMode": "Default",
          "identity": "None",
          "name": "allowed-vm-skus-root",
          "parameters": {
            "listOfAllowedSKUs": {
              "value": [
                "Standard_D2_v5",
                "Standard_E8_v5"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
        },
        {
          "additionalManagementGroupsIDsToAssignRbacTo": [
            "<name>"
          ],
          "displayName": "Configure Azure Activity logs to stream to specified Log Analytics workspace",
          "enforcementMode": "Default",
          "identity": "SystemAssigned",
          "name": "diag-activity-log-lz",
          "parameters": {
            "logAnalytics": {
              "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landing-zones/providers/Microsoft.OperationalInsights/workspaces/la-landing-zones"
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
            "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ]
        },
        {
          "displayName": "Tag checking",
          "enforcementMode": "Default",
          "identity": "None",
          "name": "tags-policy",
          "parameters": {
            "effect": {
              "value": "Audit"
            },
            "tagName": {
              "value": "costCenter"
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/mg-test-alzempmax/providers/Microsoft.Authorization/policySetDefinitions/custom-tags-policy-set-definition-1"
        }
      ]
    },
    "managementGroupRoleAssignments": {
      "value": "<managementGroupRoleAssignments>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/empty:<version>'

// Required parameters
param managementGroupName = 'mg-test-alzempmax'
// Non-required parameters
param createOrUpdateManagementGroup = true
param managementGroupCustomPolicyDefinitions = '<managementGroupCustomPolicyDefinitions>'
param managementGroupCustomPolicySetDefinitions = '<managementGroupCustomPolicySetDefinitions>'
param managementGroupCustomRoleDefinitions = '<managementGroupCustomRoleDefinitions>'
param managementGroupDisplayName = 'AVM ALZ PTN Empty Max Test'
param managementGroupPolicyAssignments = [
  {
    definitionVersion: '1.*.*'
    displayName: 'Allowed virtual machine size SKUs'
    enforcementMode: 'Default'
    identity: 'None'
    name: 'allowed-vm-skus-root'
    parameters: {
      listOfAllowedSKUs: {
        value: [
          'Standard_D2_v5'
          'Standard_E8_v5'
        ]
      }
    }
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
  }
  {
    additionalManagementGroupsIDsToAssignRbacTo: [
      '<name>'
    ]
    displayName: 'Configure Azure Activity logs to stream to specified Log Analytics workspace'
    enforcementMode: 'Default'
    identity: 'SystemAssigned'
    name: 'diag-activity-log-lz'
    parameters: {
      logAnalytics: {
        value: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landing-zones/providers/Microsoft.OperationalInsights/workspaces/la-landing-zones'
      }
    }
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
      '/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
    ]
  }
  {
    displayName: 'Tag checking'
    enforcementMode: 'Default'
    identity: 'None'
    name: 'tags-policy'
    parameters: {
      effect: {
        value: 'Audit'
      }
      tagName: {
        value: 'costCenter'
      }
    }
    policyDefinitionId: '/providers/Microsoft.Management/managementGroups/mg-test-alzempmax/providers/Microsoft.Authorization/policySetDefinitions/custom-tags-policy-set-definition-1'
  }
]
param managementGroupRoleAssignments = '<managementGroupRoleAssignments>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroupName`](#parameter-managementgroupname) | string | The name of the management group to create or update. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createOrUpdateManagementGroup`](#parameter-createorupdatemanagementgroup) | bool | Boolean to create or update the management group. If set to false, the module will only check if the management group exists and do a GET on it before it continues to deploy resources to it. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location to deploy resources to. |
| [`managementGroupCustomPolicyDefinitions`](#parameter-managementgroupcustompolicydefinitions) | array | Array of custom policy definitions to create on the management group. |
| [`managementGroupCustomPolicySetDefinitions`](#parameter-managementgroupcustompolicysetdefinitions) | array | Array of custom policy set definitions (initiatives) to create on the management group. |
| [`managementGroupCustomRoleDefinitions`](#parameter-managementgroupcustomroledefinitions) | array | Array of custom role definitions to create on the management group. |
| [`managementGroupDisplayName`](#parameter-managementgroupdisplayname) | string | The display name of the management group to create or update. If not specified, the management group name will be used. |
| [`managementGroupParentId`](#parameter-managementgroupparentid) | string | The parent ID of the management group to create or update. If not specified, the management group will be created at the root level of the tenant. Just provide the management group ID, not the full resource ID. |
| [`managementGroupPolicyAssignments`](#parameter-managementgrouppolicyassignments) | array | Array of policy assignments to create on the management group. |
| [`managementGroupRoleAssignments`](#parameter-managementgrouproleassignments) | array | Array of custom role assignments to create on the management group. |
| [`subscriptionsToPlaceInManagementGroup`](#parameter-subscriptionstoplaceinmanagementgroup) | array | An array of subscriptions to place in the management group. If not specified, no subscriptions will be placed in the management group. |
| [`waitForConsistencyCounterBeforeCustomPolicyDefinitions`](#parameter-waitforconsistencycounterbeforecustompolicydefinitions) | int | An integer that specifies the number of blank ARM deployments prior to the custom policy definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |
| [`waitForConsistencyCounterBeforeCustomPolicySetDefinitions`](#parameter-waitforconsistencycounterbeforecustompolicysetdefinitions) | int | An integer that specifies the number of blank ARM deployments prior to the custom policy set definitions (initiatives) are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |
| [`waitForConsistencyCounterBeforeCustomRoleDefinitions`](#parameter-waitforconsistencycounterbeforecustomroledefinitions) | int | An integer that specifies the number of blank ARM deployments prior to the custom role definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |
| [`waitForConsistencyCounterBeforePolicyAssignments`](#parameter-waitforconsistencycounterbeforepolicyassignments) | int | An integer that specifies the number of blank ARM deployments prior to the policy assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |
| [`waitForConsistencyCounterBeforeRoleAssignments`](#parameter-waitforconsistencycounterbeforeroleassignments) | int | An integer that specifies the number of blank ARM deployments prior to the role assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |
| [`waitForConsistencyCounterBeforeSubPlacement`](#parameter-waitforconsistencycounterbeforesubplacement) | int | An integer that specifies the number of blank ARM deployments prior to the subscription management group associations are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages. |

### Parameter: `managementGroupName`

The name of the management group to create or update.

- Required: Yes
- Type: string

### Parameter: `createOrUpdateManagementGroup`

Boolean to create or update the management group. If set to false, the module will only check if the management group exists and do a GET on it before it continues to deploy resources to it.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location to deploy resources to.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupCustomPolicyDefinitions`

Array of custom policy definitions to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managementgroupcustompolicydefinitionsname) | string | Specifies the name of the policy definition. Maximum length is 128 characters for management group scope. |
| [`properties`](#parameter-managementgroupcustompolicydefinitionsproperties) | object | The properties of the policy definition. |

### Parameter: `managementGroupCustomPolicyDefinitions.name`

Specifies the name of the policy definition. Maximum length is 128 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `managementGroupCustomPolicyDefinitions.properties`

The properties of the policy definition.

- Required: Yes
- Type: object

### Parameter: `managementGroupCustomPolicySetDefinitions`

Array of custom policy set definitions (initiatives) to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managementgroupcustompolicysetdefinitionsname) | string | Specifies the name of the policy set definition. Maximum length is 128 characters for management group scope. |
| [`properties`](#parameter-managementgroupcustompolicysetdefinitionsproperties) | object | The properties of the policy set definition. |

### Parameter: `managementGroupCustomPolicySetDefinitions.name`

Specifies the name of the policy set definition. Maximum length is 128 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `managementGroupCustomPolicySetDefinitions.properties`

The properties of the policy set definition.

- Required: Yes
- Type: object

### Parameter: `managementGroupCustomRoleDefinitions`

Array of custom role definitions to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managementgroupcustomroledefinitionsname) | string | The name of the custom role definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-managementgroupcustomroledefinitionsactions) | array | The permission actions of the custom role definition. |
| [`assignableScopes`](#parameter-managementgroupcustomroledefinitionsassignablescopes) | array | The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used. |
| [`dataActions`](#parameter-managementgroupcustomroledefinitionsdataactions) | array | The permission data actions of the custom role definition. |
| [`description`](#parameter-managementgroupcustomroledefinitionsdescription) | string | The description of the custom role definition. |
| [`notActions`](#parameter-managementgroupcustomroledefinitionsnotactions) | array | The permission not actions of the custom role definition. |
| [`notDataActions`](#parameter-managementgroupcustomroledefinitionsnotdataactions) | array | The permission not data actions of the custom role definition. |
| [`roleName`](#parameter-managementgroupcustomroledefinitionsrolename) | string | The display name of the custom role definition. If not specified, the name will be used. |

### Parameter: `managementGroupCustomRoleDefinitions.name`

The name of the custom role definition.

- Required: Yes
- Type: string

### Parameter: `managementGroupCustomRoleDefinitions.actions`

The permission actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `managementGroupCustomRoleDefinitions.assignableScopes`

The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used.

- Required: No
- Type: array

### Parameter: `managementGroupCustomRoleDefinitions.dataActions`

The permission data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `managementGroupCustomRoleDefinitions.description`

The description of the custom role definition.

- Required: No
- Type: string

### Parameter: `managementGroupCustomRoleDefinitions.notActions`

The permission not actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `managementGroupCustomRoleDefinitions.notDataActions`

The permission not data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `managementGroupCustomRoleDefinitions.roleName`

The display name of the custom role definition. If not specified, the name will be used.

- Required: No
- Type: string

### Parameter: `managementGroupDisplayName`

The display name of the management group to create or update. If not specified, the management group name will be used.

- Required: No
- Type: string

### Parameter: `managementGroupParentId`

The parent ID of the management group to create or update. If not specified, the management group will be created at the root level of the tenant. Just provide the management group ID, not the full resource ID.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments`

Array of policy assignments to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enforcementMode`](#parameter-managementgrouppolicyassignmentsenforcementmode) | string | The policy assignment enforcement mode. Possible values are `Default` and `DoNotEnforce`. Recommended value is `Default`. |
| [`identity`](#parameter-managementgrouppolicyassignmentsidentity) | string | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning `Modify` or `DeployIfNotExists` policy definitions. |
| [`name`](#parameter-managementgrouppolicyassignmentsname) | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope. |
| [`policyDefinitionId`](#parameter-managementgrouppolicyassignmentspolicydefinitionid) | string | Specifies the Resource ID of the policy definition or policy set definition being assigned. Example `/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3` or `/providers/Microsoft.Management/managementGroups/<management-group-name>/providers/Microsoft.Authorization/policyDefinitions/<policy-definition/set-name`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalManagementGroupsIDsToAssignRbacTo`](#parameter-managementgrouppolicyassignmentsadditionalmanagementgroupsidstoassignrbacto) | array | An array of additional management group IDs to assign RBAC to for the policy assignment if it has an identity. |
| [`additionalResourceGroupResourceIDsToAssignRbacTo`](#parameter-managementgrouppolicyassignmentsadditionalresourcegroupresourceidstoassignrbacto) | array | An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments. |
| [`additionalSubscriptionIDsToAssignRbacTo`](#parameter-managementgrouppolicyassignmentsadditionalsubscriptionidstoassignrbacto) | array | An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments. |
| [`definitionVersion`](#parameter-managementgrouppolicyassignmentsdefinitionversion) | string | The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview. |
| [`description`](#parameter-managementgrouppolicyassignmentsdescription) | string | The description of the policy assignment. |
| [`displayName`](#parameter-managementgrouppolicyassignmentsdisplayname) | string | The display name of the policy assignment. Maximum length is 128 characters. |
| [`location`](#parameter-managementgrouppolicyassignmentslocation) | string | The location of the policy assignment. Only required when utilizing managed identity, as sets location of system assigned managed identity, if created. |
| [`metadata`](#parameter-managementgrouppolicyassignmentsmetadata) | object | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`nonComplianceMessages`](#parameter-managementgrouppolicyassignmentsnoncompliancemessages) | array | The messages that describe why a resource is non-compliant with the policy. |
| [`notScopes`](#parameter-managementgrouppolicyassignmentsnotscopes) | array | The policy excluded scopes. |
| [`overrides`](#parameter-managementgrouppolicyassignmentsoverrides) | array | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| [`parameters`](#parameter-managementgrouppolicyassignmentsparameters) | object | Parameters for the policy assignment if needed. |
| [`resourceSelectors`](#parameter-managementgrouppolicyassignmentsresourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| [`roleDefinitionIds`](#parameter-managementgrouppolicyassignmentsroledefinitionids) | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| [`userAssignedIdentityId`](#parameter-managementgrouppolicyassignmentsuserassignedidentityid) | string | The Resource ID for the user assigned identity to assign to the policy assignment. |

### Parameter: `managementGroupPolicyAssignments.enforcementMode`

The policy assignment enforcement mode. Possible values are `Default` and `DoNotEnforce`. Recommended value is `Default`.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'DoNotEnforce'
  ]
  ```

### Parameter: `managementGroupPolicyAssignments.identity`

The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning `Modify` or `DeployIfNotExists` policy definitions.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `managementGroupPolicyAssignments.name`

Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `managementGroupPolicyAssignments.policyDefinitionId`

Specifies the Resource ID of the policy definition or policy set definition being assigned. Example `/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3` or `/providers/Microsoft.Management/managementGroups/<management-group-name>/providers/Microsoft.Authorization/policyDefinitions/<policy-definition/set-name`.

- Required: Yes
- Type: string

### Parameter: `managementGroupPolicyAssignments.additionalManagementGroupsIDsToAssignRbacTo`

An array of additional management group IDs to assign RBAC to for the policy assignment if it has an identity.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.additionalResourceGroupResourceIDsToAssignRbacTo`

An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.additionalSubscriptionIDsToAssignRbacTo`

An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.definitionVersion`

The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.description`

The description of the policy assignment.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.displayName`

The display name of the policy assignment. Maximum length is 128 characters.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.location`

The location of the policy assignment. Only required when utilizing managed identity, as sets location of system assigned managed identity, if created.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.metadata`

The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.

- Required: No
- Type: object

### Parameter: `managementGroupPolicyAssignments.nonComplianceMessages`

The messages that describe why a resource is non-compliant with the policy.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`message`](#parameter-managementgrouppolicyassignmentsnoncompliancemessagesmessage) | string | A message that describes why a resource is non-compliant with the policy. This is shown in "deny" error messages and on resources non-compliant compliance results. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`policyDefinitionReferenceId`](#parameter-managementgrouppolicyassignmentsnoncompliancemessagespolicydefinitionreferenceid) | string | The policy definition reference ID within a policy set definition the message is intended for. This is only applicable if the policy assignment assigns a policy set definition. If this is not provided the message applies to all policies assigned by this policy assignment. |

### Parameter: `managementGroupPolicyAssignments.nonComplianceMessages.message`

A message that describes why a resource is non-compliant with the policy. This is shown in "deny" error messages and on resources non-compliant compliance results.

- Required: Yes
- Type: string

### Parameter: `managementGroupPolicyAssignments.nonComplianceMessages.policyDefinitionReferenceId`

The policy definition reference ID within a policy set definition the message is intended for. This is only applicable if the policy assignment assigns a policy set definition. If this is not provided the message applies to all policies assigned by this policy assignment.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.notScopes`

The policy excluded scopes.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.overrides`

The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-managementgrouppolicyassignmentsoverrideskind) | string | The override kind. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`selectors`](#parameter-managementgrouppolicyassignmentsoverridesselectors) | array | The selector type. |
| [`value`](#parameter-managementgrouppolicyassignmentsoverridesvalue) | string | The value to override the policy property. |

### Parameter: `managementGroupPolicyAssignments.overrides.kind`

The override kind.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'definitionVersion'
    'policyEffect'
  ]
  ```

### Parameter: `managementGroupPolicyAssignments.overrides.selectors`

The selector type.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-managementgrouppolicyassignmentsoverridesselectorskind) | string | The selector kind. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`in`](#parameter-managementgrouppolicyassignmentsoverridesselectorsin) | array | The list of values to filter in. |
| [`notIn`](#parameter-managementgrouppolicyassignmentsoverridesselectorsnotin) | array | The list of values to filter out. |

### Parameter: `managementGroupPolicyAssignments.overrides.selectors.kind`

The selector kind.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'policyDefinitionReferenceId'
    'resourceLocation'
    'resourceType'
    'resourceWithoutLocation'
  ]
  ```

### Parameter: `managementGroupPolicyAssignments.overrides.selectors.in`

The list of values to filter in.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.overrides.selectors.notIn`

The list of values to filter out.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.overrides.value`

The value to override the policy property.

- Required: No
- Type: string

### Parameter: `managementGroupPolicyAssignments.parameters`

Parameters for the policy assignment if needed.

- Required: No
- Type: object

### Parameter: `managementGroupPolicyAssignments.resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-managementgrouppolicyassignmentsresourceselectorskind) | string | The selector kind. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`in`](#parameter-managementgrouppolicyassignmentsresourceselectorsin) | array | The list of values to filter in. |
| [`notIn`](#parameter-managementgrouppolicyassignmentsresourceselectorsnotin) | array | The list of values to filter out. |

### Parameter: `managementGroupPolicyAssignments.resourceSelectors.kind`

The selector kind.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'policyDefinitionReferenceId'
    'resourceLocation'
    'resourceType'
    'resourceWithoutLocation'
  ]
  ```

### Parameter: `managementGroupPolicyAssignments.resourceSelectors.in`

The list of values to filter in.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.resourceSelectors.notIn`

The list of values to filter out.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.roleDefinitionIds`

The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.

- Required: No
- Type: array

### Parameter: `managementGroupPolicyAssignments.userAssignedIdentityId`

The Resource ID for the user assigned identity to assign to the policy assignment.

- Required: No
- Type: string

### Parameter: `managementGroupRoleAssignments`

Array of custom role assignments to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-managementgrouproleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-managementgrouproleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-managementgrouproleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-managementgrouproleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-managementgrouproleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-managementgrouproleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-managementgrouproleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-managementgrouproleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `managementGroupRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `managementGroupRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `managementGroupRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `managementGroupRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `managementGroupRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `managementGroupRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `managementGroupRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `managementGroupRoleAssignments.principalType`

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

### Parameter: `subscriptionsToPlaceInManagementGroup`

An array of subscriptions to place in the management group. If not specified, no subscriptions will be placed in the management group.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `waitForConsistencyCounterBeforeCustomPolicyDefinitions`

An integer that specifies the number of blank ARM deployments prior to the custom policy definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `5`

### Parameter: `waitForConsistencyCounterBeforeCustomPolicySetDefinitions`

An integer that specifies the number of blank ARM deployments prior to the custom policy set definitions (initiatives) are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `5`

### Parameter: `waitForConsistencyCounterBeforeCustomRoleDefinitions`

An integer that specifies the number of blank ARM deployments prior to the custom role definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `5`

### Parameter: `waitForConsistencyCounterBeforePolicyAssignments`

An integer that specifies the number of blank ARM deployments prior to the policy assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `10`

### Parameter: `waitForConsistencyCounterBeforeRoleAssignments`

An integer that specifies the number of blank ARM deployments prior to the role assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `5`

### Parameter: `waitForConsistencyCounterBeforeSubPlacement`

An integer that specifies the number of blank ARM deployments prior to the subscription management group associations are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.

- Required: No
- Type: int
- Default: `5`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `managementGroupCustomRoleDefinitionIds` | array | The custom role definitions created on the management group. |
| `managementGroupId` | string | The ID of the management group. |
| `managementGroupParentId` | string | The parent management group ID of the management group. |
| `managementGroupResourceId` | string | The resource ID of the management group. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/policy-assignment:0.4.0` | Remote reference |
| `br/public:avm/ptn/authorization/role-assignment:0.2.2` | Remote reference |
| `br/public:avm/ptn/authorization/role-definition:0.1.1` | Remote reference |
| `br/public:avm/res/management/management-group:0.1.2` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Notes

For Custom Policy Set Definitions, the property of `properties.policyDefinitions.policyDefinitionId` for each child policy definition in a policy set definition must be provided. If you are trying to provide the ID of a policy definition that you are also creating in this module, or it exists at the same management group scope, you can use the following input syntax to ensure the correct resource ID for the policy definition is used:

```bicep
{customPolicyDefinitionScopeId}/providers/Microsoft.Authorization/policyDefinitions/<policy-definition-name>
```

The `{customPolicyDefinitionScopeId}` is replaced by resource ID of the management group that this module is creating or deploying to. This will ensure that the correct resource ID is used for the policy definition without you having to hardcode the management group ID in the policy set definitions.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
