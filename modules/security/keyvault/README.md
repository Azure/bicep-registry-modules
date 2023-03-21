# Azure Key Vault

Bicep module for simplified deployment of KeyVault; enables VNet integration and offers flexible configuration options.

## Description

Azure Key Vault is a cloud service that provides secure storage of secrets such as keys and passwords. These secrets can be protected by hardware security modules (HSMs) and can only be accessed by authorized users and applications.

The Bicep module allows for the creation of a new Key Vault or the use of an existing one, depending on the value of the newOrExisting parameter. If a new Key Vault is created, it is given a unique name based on the resource group ID and the name parameter. The enableSoftDelete and softDeleteRetentionInDays properties are set to enable soft delete for the Key Vault. The sku property is set to use the standard tier with the A family. The enableRbacAuthorization property is set to enable role-based access control (RBAC) for the Key Vault.

If enableVNet is set to true, the module creates a network access control list (ACL) that allows traffic from the specified subnet. If rbacPolicies are specified, the module creates RBAC role assignments for the Key Vault. If assignRole is set to false, no role assignments are created.

The Bicep module outputs the ID and name of the Key Vault, which can be used by other Bicep templates to reference the Key Vault. This module provides a secure and easy way to store and manage secrets in Azure.

## Parameters

| Name              | Type     | Required | Description                                        |
| :---------------- | :------: | :------: | :------------------------------------------------- |
| `location`        | `string` | Yes      | Deployment Location                                |
| `prefix`          | `string` | No       | Prefix of Cosmos DB Resource Name                  |
| `name`            | `string` | No       | Name of the Key Vault                              |
| `subnetID`        | `string` | No       | Subnet ID for the Key Vault                        |
| `tenantId`        | `string` | No       | The tenant ID where the Key Vault is deployed      |
| `enableVNet`      | `bool`   | No       | Enable VNet Service Endpoints for Key Vault        |
| `rbacPolicies`    | `array`  | No       | List of RBAC policies to assign to the Key Vault   |
| `assignRole`      | `bool`   | No       | Enable role assignment for the Key Vault           |
| `roleAssignments` | `array`  | No       | RBAC Role Assignments to apply to each RBAC policy |

## Outputs

| Name | Type   | Description    |
| :--- | :----: | :------------- |
| id   | string | Key Vault Id   |
| name | string | Key Vault Name |

## Examples

### Example 1

```bicep
param location string = 'eastus'
param name string = 'mykeyvault'

module keyVault 'br/public:security/keyvault:0.0.1' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: name
  }
}
```

### Example 2

```bicep
param roleAssignments array = [
  '4633458b-17de-408a-b874-0445c86b69e6' // rbacSecretsReaderRole
]

module keyVault 'br/public:security/keyvault:0.0.1' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: name
  }
}
```