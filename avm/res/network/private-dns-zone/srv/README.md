# Private DNS Zone SRV record `[Microsoft.Network/privateDnsZones/SRV]`

This module deploys a Private DNS Zone SRV record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the SRV record. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneName`](#parameter-privatednszonename) | string | The name of the parent Private DNS zone. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-metadata) | object | The metadata attached to the record set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`srvRecords`](#parameter-srvrecords) | array | The list of SRV records in the record set. |
| [`ttl`](#parameter-ttl) | int | The TTL (time-to-live) of the records in the record set. |

### Parameter: `metadata`

The metadata attached to the record set.
- Required: No
- Type: object

### Parameter: `name`

The name of the SRV record.
- Required: Yes
- Type: string

### Parameter: `privateDnsZoneName`

The name of the parent Private DNS zone. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `srvRecords`

The list of SRV records in the record set.
- Required: No
- Type: array

### Parameter: `ttl`

The TTL (time-to-live) of the records in the record set.
- Required: No
- Type: int
- Default: `3600`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed SRV record. |
| `resourceGroupName` | string | The resource group of the deployed SRV record. |
| `resourceId` | string | The resource ID of the deployed SRV record. |

## Cross-referenced modules

_None_
