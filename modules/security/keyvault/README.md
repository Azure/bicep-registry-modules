# Azure Key Vault

Bicep module for simplified deployment of KeyVault; enables VNet integration and offers flexible configuration options.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name            | Type     | Required | Description                                                                                                                                   |
| :-------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`      | `string` | Yes      | Deployment Location                                                                                                                           |
| `name`          | `string` | No       | Name of the Key Vault                                                                                                                         |
| `subnetID`      | `string` | No       | Subnet ID for the Key Vault                                                                                                                   |
| `tenantId`      | `string` | No       | The tenant ID where the Key Vault is deployed                                                                                                 |
| `enableVNet`    | `bool`   | No       | Enable VNet Service Endpoints for Key Vault                                                                                                   |
| `rbacPolicies`  | `array`  | No       | List of RBAC policies to assign to the Key Vault                                                                                              |
| `newOrExisting` | `string` | No       | Specifies whether to create a new Key Vault or use an existing one. Use "new" to create a new Key Vault or "existing" to use an existing one. |
| `assignRole`    | `bool`   | No       | Enable role assignment for the Key Vault                                                                                                      |

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
```