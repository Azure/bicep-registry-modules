# Disk Encryption Sets `[Microsoft.Compute/diskEncryptionSets]`

This module deploys a Disk Encryption Set. The module will attempt to set permissions on the provided Key Vault for any used user-assigned identity.

You can reference the module as follows:
```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Compute/diskEncryptionSets` | 2025-01-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_diskencryptionsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2025-01-02/diskEncryptionSets)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2025-05-01/vaults/accessPolicies)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/disk-encryption-set:<version>`.

- [Using managed HSM Customer-Managed-Keys with User-Assigned identity](#example-1-using-managed-hsm-customer-managed-keys-with-user-assigned-identity)
- [Using only defaults](#example-2-using-only-defaults)
- [Using Key Vault with the Access Policy permission model](#example-3-using-key-vault-with-the-access-policy-permission-model)
- [Using Key Vault with the Role Based Access Control (RBAC) permission model](#example-4-using-key-vault-with-the-role-based-access-control-rbac-permission-model)
- [Using large parameter set](#example-5-using-large-parameter-set)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using managed HSM Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-hsm-uami]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
The test is skipped because running the HSM scenario requires a persistent Managed HSM instance to be available and configured at all times, which would incur significant costs for contributors.
```

<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdeshsmu001'
    // Non-required parameters
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
    "name": {
      "value": "cdeshsmu001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": true,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "keyVersion": "<keyVersion>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdeshsmu001'
// Non-required parameters
param customerManagedKey = {
  autoRotationEnabled: true
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  keyVersion: '<keyVersion>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters. Note: The default configuration uses a system-assigned identity, which must be granted the necessary permissions on the Key Vault key after deployment.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdesmin001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    enableKeyPermissions: true
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
    "name": {
      "value": "cdesmin001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "enableKeyPermissions": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdesmin001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param enableKeyPermissions = true
```

</details>
<p>

### Example 3: _Using Key Vault with the Access Policy permission model_

This instance uses a Key Vault with the Access Policy permission model. The option to add the permissions on the key via the module is enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/key-access-policies]


<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdesap001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    enableKeyPermissions: true
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
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
    "name": {
      "value": "cdesap001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "enableKeyPermissions": {
      "value": true
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdesap001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param enableKeyPermissions = true
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
```

</details>
<p>

### Example 4: _Using Key Vault with the Role Based Access Control (RBAC) permission model_

This instance uses a Key Vault with the Role Based Access Control (RBAC) permission model. The option to add the permissions on the key via the module is enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/key-rbac]


<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdesrbac001'
    // Non-required parameters
    customerManagedKey: {
      autoRotationEnabled: false
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    enableKeyPermissions: true
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
    "name": {
      "value": "cdesrbac001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": false,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "enableKeyPermissions": {
      "value": true
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdesrbac001'
// Non-required parameters
param customerManagedKey = {
  autoRotationEnabled: false
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param enableKeyPermissions = true
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 5: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdesmax001'
    // Non-required parameters
    customerManagedKey: {
      autoRotationEnabled: false
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    enableKeyPermissions: true
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: 'c331c327-6458-473a-9398-95b382c6f04f'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "name": {
      "value": "cdesmax001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": false,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "enableKeyPermissions": {
      "value": true
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c331c327-6458-473a-9398-95b382c6f04f",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdesmax001'
// Non-required parameters
param customerManagedKey = {
  autoRotationEnabled: false
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param enableKeyPermissions = true
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    name: 'c331c327-6458-473a-9398-95b382c6f04f'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module diskEncryptionSet 'br/public:avm/res/compute/disk-encryption-set:<version>' = {
  params: {
    // Required parameters
    name: 'cdeswaf001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
    "name": {
      "value": "cdeswaf001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/compute/disk-encryption-set:<version>'

// Required parameters
param name = 'cdeswaf001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the disk encryption set that is being created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`enableKeyPermissions`](#parameter-enablekeypermissions) | bool | Assign permissions to the Key Vault Key. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionType`](#parameter-encryptiontype) | string | The type of key used to encrypt the data of the disk. For security reasons, it is recommended to set encryptionType to EncryptionAtRestWithPlatformAndCustomerKeys. |
| [`federatedClientId`](#parameter-federatedclientid) | string | Multi-tenant application client ID to access key vault in a different tenant. Setting the value to "None" will clear the property. |
| [`location`](#parameter-location) | string | Resource location. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the disk encryption resource. |

### Parameter: `name`

The name of the disk encryption set that is being created.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `enableKeyPermissions`

Assign permissions to the Key Vault Key.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionType`

The type of key used to encrypt the data of the disk. For security reasons, it is recommended to set encryptionType to EncryptionAtRestWithPlatformAndCustomerKeys.

- Required: No
- Type: string
- Default: `'EncryptionAtRestWithPlatformAndCustomerKeys'`
- Allowed:
  ```Bicep
  [
    'ConfidentialVmEncryptedWithCustomerKey'
    'EncryptionAtRestWithCustomerKey'
    'EncryptionAtRestWithPlatformAndCustomerKeys'
  ]
  ```

### Parameter: `federatedClientId`

Multi-tenant application client ID to access key vault in a different tenant. Setting the value to "None" will clear the property.

- Required: No
- Type: string
- Default: `'None'`

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Data Operator for Managed Disks'`
  - `'Disk Backup Reader'`
  - `'Disk Pool Operator'`
  - `'Disk Restore Operator'`
  - `'Disk Snapshot Contributor'`
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

Tags of the disk encryption resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `identities` | object | The idenities of the disk encryption set. |
| `keyVaultName` | string | The name of the key vault with the disk encryption key. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the disk encryption set. |
| `resourceGroupName` | string | The resource group the disk encryption set was deployed into. |
| `resourceId` | string | The resource ID of the disk encryption set. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
