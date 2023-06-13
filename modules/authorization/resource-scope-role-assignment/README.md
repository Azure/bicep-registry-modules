# Resource scoped role assignment

Create an Azure Authorization Role Assignment at the scope of a Resource E.g. on a Storage Container

## Description

Using this Bicep Module allows for Role Assignments at any Scope within Azure. Pass in any ResourceId to perform the role assignment on that Scope.

[Learn - Steps to assign an Azure role](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-steps)

It is required to generate the unique guid name for the role assignment, ensure you follow your own pattern used for other roleAssignments.

Example pattern to generate the guid().

```bicep
guid(principalId|objectId, roleDefinitionId|roleName, resourceId)
```

## Parameters

| Name               | Type     | Required | Description                                                   |
| :----------------- | :------: | :------: | :------------------------------------------------------------ |
| `resourceId`       | `string` | Yes      | The scope for the role assignment, fully qualified resourceId |
| `name`             | `string` | Yes      | The unique guid name for the role assignment                  |
| `roleDefinitionId` | `string` | Yes      | The role definitionId from your tenant/subscription           |
| `principalId`      | `string` | Yes      | The principal ID                                              |
| `principalType`    | `string` | No       | The principal type of the assigned principal ID               |
| `roleName`         | `string` | No       | The name for the role, used for logging                       |
| `description`      | `string` | No       | The Description of role assignment                            |

## Outputs

| Name       | Type     | Description                                                 |
| :--------- | :------: | :---------------------------------------------------------- |
| `name`     | `string` | The unique name guid used for the roleAssignment            |
| `roleName` | `string` | The name for the role, used for logging                     |
| `id`       | `string` | The roleAssignmentId created on the scope of the resourceId |

## Examples

### Example 1

```bicep
param location string = resourceGroup().location
param saname string = 'sa${uniqueString(resourceGroup().id)}'
param uaiName string = 'storageAccountOperator'
param roleInfoOperator object = {
  roleDefinitionId: '81a9662b-bebf-436f-a333-f67b29880f12'
  roleName: 'Storage Account Key Operator Service Role'
  description: 'Storage account key operator for User assigned identity'
}

resource UAI 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uaiName
  location: location
}

module storageAccount 'br/public:storage/storage-account:1.0.1' = {
  name: saname
  params: {
    location: location
    name: saname
  }
}

// module call with all parameters
module roleAssignmentOperator 'br/public:authorization/resource-scope-role-assignment:1.0.1' = {
  name: take('roleAssignment-storage-accountKeyOperator',64)
  params: {
    name: guid(UAI.properties.principalId, roleInfoOperator.roleDefinitionId, storageAccount.outputs.id)
    principalId: UAI.properties.principalId
    resourceId: storageAccount.outputs.id
    roleDefinitionId: roleInfoOperator.roleDefinitionId
    description: roleInfoOperator.description
    roleName: roleInfoOperator.roleName
    principalType: 'ServicePrincipal'
  }
}

output roleAssignmentOperator string = roleAssignmentOperator.outputs.id
```

```log
Parameters              :
                          Name                   Type                       Value
                          =====================  =========================  ==========
                          location               String                     "eastus"
                          saname                 String                     "sat4jdusq4ilet4"
                          uaiName                String                     "storageAccountOperator"
                          roleInfoOperator       Object                     {"roleDefinitionId":"81a9662b-bebf-436f-a333-f67b29880f12","roleName":"Storage Account Key Operator Service Role","description":"Storage account key operator for User assigned identity"}

Outputs                 :
                          Name                         Type                       Value
                          ===========================  =========================  ==========
                          roleAssignmentOperator       String                     "/subscriptions/fe8c6f31-247d-4941-a62d-fde7a2185aca/resourceGroups/ResourceGroup01/providers/Microsoft.Storage/storageAccounts/sat4jdusq4ilet4/providers/Microsoft.Authorization/roleAssignments/3b71ddea-994f-5ccc-be34-cecd838b1152"
```

### Example 2

```bicep
param location string = resourceGroup().location
param saname string = 'sa${uniqueString(resourceGroup().id)}'
param uaiName string = 'storageAccountOperator'

param roleInfoContributor object = {
  roleDefinitionId: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

resource UAI 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uaiName
  location: location
}

module storageAccount 'br/public:storage/storage-account:1.0.1' = {
  name: saname
  params: {
    location: location
    name: saname
  }
}

// module call with only required parameters
module roleAssignmentContributor 'br/public:authorization/resource-scope-role-assignment:1.0.1' = {
  name: take('roleAssignment-storage-accountContributor',64)
  params: {
    name: guid(UAI.properties.principalId, roleInfoContributor.roleDefinitionId, storageAccount.outputs.id)
    principalId: UAI.properties.principalId
    resourceId: storageAccount.outputs.id
    roleDefinitionId: roleInfoContributor.roleDefinitionId
  }
}

output roleAssignmentContributor string = roleAssignmentContributor.outputs.id
```

```log
Parameters              :
                          Name                   Type                       Value
                          =====================  =========================  ==========
                          location               String                     "eastus"
                          saname                 String                     "sat4jdusq4ilet4"
                          uaiName                String                     "storageAccountOperator"
                          roleInfoContributor    Object                     {"roleDefinitionId":"17d1049b-9a84-46fb-8f53-869881c3d3ab"}

Outputs                 :
                          Name                         Type                       Value
                          ===========================  =========================  ==========
                          roleAssignmentContributor    String                     "/subscriptions/fe8c6f31-247d-4941-a62d-fde7a2185aca/resourceGroups/ResourceGroup01/providers/Microsoft.Storage/storageAccounts/sat4jdusq4ilet4/providers/Microsoft.Authorization/roleAssignments/afd5b488-e47c-5d0c-8389-4f40ef374e4b"
```