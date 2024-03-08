<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/key-vault/vault](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Azure Key Vault

Bicep module for simplified deployment of KeyVault; enables VNet integration and offers flexible configuration options.

## Details

Azure Key Vault is a cloud service that provides secure storage of secrets such as keys and passwords. These secrets can be protected by hardware security modules (HSMs) and can only be accessed by authorized users and applications.

The Bicep module allows for the creation of a new Key Vault or the use of an existing one, depending on the value of the newOrExisting parameter. If a new Key Vault is created, it is given a unique name based on the resource group ID and the name parameter. The enableSoftDelete and softDeleteRetentionInDays properties are set to enable soft delete for the Key Vault. The sku property is set to use the standard tier with the A family. The enableRbacAuthorization property is set to enable role-based access control (RBAC) for the Key Vault.

If enableVNet is set to true, the module creates a network access control list (ACL) that allows traffic from the specified subnet. If rbacPolicies are specified, the module creates RBAC role assignments for the Key Vault. If assignRole is set to false, no role assignments are created.

The Bicep module outputs the ID and name of the Key Vault, which can be used by other Bicep templates to reference the Key Vault. This module provides a secure and easy way to store and manage secrets in Azure.

## Parameters

| Name                        | Type           | Required | Description                                                                                               |
| :-------------------------- | :------------: | :------: | :-------------------------------------------------------------------------------------------------------- |
| `location`                  | `string`       | Yes      | Deployment Location                                                                                       |
| `prefix`                    | `string`       | No       | Prefix of Azure Key Vault Resource Name                                                                   |
| `name`                      | `string`       | No       | Name of the Key Vault                                                                                     |
| `tenantId`                  | `string`       | No       | The tenant ID where the Key Vault is deployed                                                             |
| `enableVNet`                | `bool`         | No       | Deploy Key Vault into existing Virtual Network. Enabling this setting also requires subnetID              |
| `subnetID`                  | `string`       | No       | Subnet ID for the Key Vault                                                                               |
| `rbacPolicies`              | `array`        | No       | List of RBAC policies to assign to the Key Vault                                                          |
| `roleAssignments`           | `array`        | No       | RBAC Role Assignments to apply to each RBAC policy                                                        |
| `newOrExisting`             | `string`       | No       | Whether to create a new Key Vault or use an existing one.                                                 |
| `secretName`                | `string`       | No       | Name of Secret to add to Key Vault. Required when provided a secretValue.                                 |
| `secretValue`               | `securestring` | No       | Value of Secret to add to Key Vault. The secretName parameter must also be provided when adding a secret. |
| `enableSoftDelete`          | `bool`         | No       | Specifies whether soft delete should be enabled for the Key Vault.                                        |
| `softDeleteRetentionInDays` | `int`          | No       | The number of days to retain deleted data in the Key Vault.                                               |
| `skuName`                   | `string`       | No       | The SKU name of the Key Vault.                                                                            |
| `skuFamily`                 | `string`       | No       | The SKU family of the Key Vault.                                                                          |

## Outputs

| Name                   | Type     | Description             |
| :--------------------- | :------: | :---------------------- |
| `id`                   | `string` | Key Vault Id            |
| `name`                 | `string` | Key Vault Name          |
| `secretId`             | `string` | Key Vault Seceret Id    |
| `secretName`           | `string` | Key Vault Secert Name   |
| `secretUri`            | `string` | Secret URI              |
| `secretUriWithVersion` | `string` | Secret URI with version |

## Examples

### Example 1

```bicep
param location string = 'eastus'
param name string = 'mykeyvault'

module keyVault 'br/public:security/keyvault:1.0.2' = {
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

module keyVault 'br/public:security/keyvault:1.0.2' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: name
  }
}
```

### Example 3

This example deploys a Virtual Network with the specified parameters and a subnet with the desired address space.

```bicep
param location string

module vnet 'br/public:network/virtual-network:1.0.1' = {
  name: 'vnet'
  params: {
    location: location
    name: 'az-vnet-kv-01'
    addressPrefixes: [ '10.0.0.0/16' ]
    subnets: [
      {
        name: 'az-subnet-kv-01'
        addressPrefix: '10.0.0.0/24'
        serviceEndpoints: [{ service: 'Microsoft.KeyVault' }]
      }
    ]
  }
}

module keyVaultModule 'br/public:security/keyvault:1.0.2' = {
  name: 'keyVault-in-vnet'
  params: {
    location: location
    subnetID: vnet.outputs.subnetResourceIds[0]
  }
}
```

### Example 4

This example is a module deployment that adds a secret to an existing Key Vault.

```bicep
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name
param keyVaultName string
param storageSecretName string

@secure()
param storageAccountSecret string

module secretsBatch 'br/public:security/keyvault:1.0.2' = {
  name: 'secrets-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    keyVaultName: keyVaultName
    newOrExisting: 'existing'
    secretName: storageSecretName
    secretValue: storageAccountSecret
  }
}
```
