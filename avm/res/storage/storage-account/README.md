# Storage Accounts `[Microsoft.Storage/storageAccounts]`

This module deploys a Storage Account.

You can reference the module as follows:
```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
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
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/storage/storage-account:<version>`.

- [Deploying as a Blob Storage](#example-1-deploying-as-a-blob-storage)
- [Deploying as a Block Blob Storage](#example-2-deploying-as-a-block-blob-storage)
- [Using only changefeed configuration](#example-3-using-only-changefeed-configuration)
- [Using managed HSM Customer-Managed-Keys with User-Assigned identity](#example-4-using-managed-hsm-customer-managed-keys-with-user-assigned-identity)
- [Using Customer-Managed-Keys with System-Assigned identity](#example-5-using-customer-managed-keys-with-system-assigned-identity)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-6-using-customer-managed-keys-with-user-assigned-identity)
- [Using only defaults](#example-7-using-only-defaults)
- [Using extended zones](#example-8-using-extended-zones)
- [With immutability policy](#example-9-with-immutability-policy)
- [Deploying with a key vault reference to save secrets](#example-10-deploying-with-a-key-vault-reference-to-save-secrets)
- [Using large parameter set](#example-11-using-large-parameter-set)
- [Deploying with a NFS File Share](#example-12-deploying-with-a-nfs-file-share)
- [Using object replication](#example-13-using-object-replication)
- [Using premium file shares](#example-14-using-premium-file-shares)
- [Deploying as Storage Account version 1](#example-15-deploying-as-storage-account-version-1)
- [WAF-aligned](#example-16-waf-aligned)

### Example 1: _Deploying as a Blob Storage_

This instance deploys the module as a Blob Storage account.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/blob]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssablob001'
    // Non-required parameters
    kind: 'BlobStorage'
    skuName: 'Standard_LRS'
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
      "value": "ssablob001"
    },
    // Non-required parameters
    "kind": {
      "value": "BlobStorage"
    },
    "skuName": {
      "value": "Standard_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssablob001'
// Non-required parameters
param kind = 'BlobStorage'
param skuName = 'Standard_LRS'
```

</details>
<p>

### Example 2: _Deploying as a Block Blob Storage_

This instance deploys the module as a Premium Block Blob Storage account.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/block]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssablock001'
    // Non-required parameters
    kind: 'BlockBlobStorage'
    skuName: 'Premium_LRS'
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
      "value": "ssablock001"
    },
    // Non-required parameters
    "kind": {
      "value": "BlockBlobStorage"
    },
    "skuName": {
      "value": "Premium_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssablock001'
// Non-required parameters
param kind = 'BlockBlobStorage'
param skuName = 'Premium_LRS'
```

</details>
<p>

### Example 3: _Using only changefeed configuration_

This instance deploys the module with the minimum set of required parameters for the changefeed configuration.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/changefeed]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssachf001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      changeFeedEnabled: true
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
      "value": "ssachf001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "changeFeedEnabled": true
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssachf001'
// Non-required parameters
param allowBlobPublicAccess = false
param blobServices = {
  changeFeedEnabled: true
}
```

</details>
<p>

### Example 4: _Using managed HSM Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-hsm-uami]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
The test is skipped because running the HSM scenario requires a persistent Managed HSM instance to be available and configured at all times, which would incur significant costs for contributors.
```

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssauhsmu001'
    // Non-required parameters
    blobServices: {
      containers: [
        {
          name: 'container'
          publicAccess: 'None'
        }
      ]
    }
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
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
      "value": "ssauhsmu001"
    },
    // Non-required parameters
    "blobServices": {
      "value": {
        "containers": [
          {
            "name": "container",
            "publicAccess": "None"
          }
        ]
      }
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssauhsmu001'
// Non-required parameters
param blobServices = {
  containers: [
    {
      name: 'container'
      publicAccess: 'None'
    }
  ]
}
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 5: _Using Customer-Managed-Keys with System-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-sami]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    blobServices: {
      containers: [
        {
          name: 'container'
          publicAccess: 'None'
        }
      ]
    }
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    managedIdentities: {
      systemAssigned: true
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
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
      "value": "<name>"
    },
    // Non-required parameters
    "blobServices": {
      "value": {
        "containers": [
          {
            "name": "container",
            "publicAccess": "None"
          }
        ]
      }
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param blobServices = {
  containers: [
    {
      name: 'container'
      publicAccess: 'None'
    }
  ]
}
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param managedIdentities = {
  systemAssigned: true
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'blob'
    subnetResourceId: '<subnetResourceId>'
  }
]
```

</details>
<p>

### Example 6: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-uami]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssauacr001'
    // Non-required parameters
    blobServices: {
      containers: [
        {
          name: 'container'
          publicAccess: 'None'
        }
      ]
    }
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
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
      "value": "ssauacr001"
    },
    // Non-required parameters
    "blobServices": {
      "value": {
        "containers": [
          {
            "name": "container",
            "publicAccess": "None"
          }
        ]
      }
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny"
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssauacr001'
// Non-required parameters
param blobServices = {
  containers: [
    {
      name: 'container'
      publicAccess: 'None'
    }
  ]
}
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'blob'
    subnetResourceId: '<subnetResourceId>'
  }
]
```

</details>
<p>

### Example 7: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'stamin001'
    // Non-required parameters
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
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
      "value": "stamin001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'stamin001'
// Non-required parameters
param allowBlobPublicAccess = false
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}
```

</details>
<p>

### Example 8: _Using extended zones_

This instance deploys the module within an Azure Extended Zone.

> Note: To run a deployment with an extended location, the subscription must be registered for the feature. For example:
> ```pwsh
> az provider register --namespace 'Microsoft.EdgeZones'
> az edge-zones extended-zone register --extended-zone-name 'losangeles'
> ```
> Please refer to the [documentation](https://learn.microsoft.com/en-us/azure/extended-zones/request-access) for more information.


You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/extended-location]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssaexzn001'
    // Non-required parameters
    allowBlobPublicAccess: false
    extendedLocationZone: '<extendedLocationZone>'
    kind: 'StorageV2'
    location: '<location>'
    skuName: 'Premium_LRS'
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
      "value": "ssaexzn001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "extendedLocationZone": {
      "value": "<extendedLocationZone>"
    },
    "kind": {
      "value": "StorageV2"
    },
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "Premium_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssaexzn001'
// Non-required parameters
param allowBlobPublicAccess = false
param extendedLocationZone = '<extendedLocationZone>'
param kind = 'StorageV2'
param location = '<location>'
param skuName = 'Premium_LRS'
```

</details>
<p>

### Example 9: _With immutability policy_

This instance deploys the module with the immutability policy enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/immutability]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssaim001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      containers: [
        {
          immutabilityPolicy: {
            allowProtectedAppendWrites: false
          }
          immutableStorageWithVersioningEnabled: true
          metadata: {
            testKey: 'testValue'
          }
          name: 'archivecontainer'
          publicAccess: 'None'
        }
      ]
      isVersioningEnabled: true
    }
    immutableStorageWithVersioning: {
      enabled: true
      immutabilityPolicy: {
        allowProtectedAppendWrites: true
        immutabilityPeriodSinceCreationInDays: 7
        state: 'Unlocked'
      }
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
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
      "value": "ssaim001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "containers": [
          {
            "immutabilityPolicy": {
              "allowProtectedAppendWrites": false
            },
            "immutableStorageWithVersioningEnabled": true,
            "metadata": {
              "testKey": "testValue"
            },
            "name": "archivecontainer",
            "publicAccess": "None"
          }
        ],
        "isVersioningEnabled": true
      }
    },
    "immutableStorageWithVersioning": {
      "value": {
        "enabled": true,
        "immutabilityPolicy": {
          "allowProtectedAppendWrites": true,
          "immutabilityPeriodSinceCreationInDays": 7,
          "state": "Unlocked"
        }
      }
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssaim001'
// Non-required parameters
param allowBlobPublicAccess = false
param blobServices = {
  containers: [
    {
      immutabilityPolicy: {
        allowProtectedAppendWrites: false
      }
      immutableStorageWithVersioningEnabled: true
      metadata: {
        testKey: 'testValue'
      }
      name: 'archivecontainer'
      publicAccess: 'None'
    }
  ]
  isVersioningEnabled: true
}
param immutableStorageWithVersioning = {
  enabled: true
  immutabilityPolicy: {
    allowProtectedAppendWrites: true
    immutabilityPeriodSinceCreationInDays: 7
    state: 'Unlocked'
  }
}
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}
```

</details>
<p>

### Example 10: _Deploying with a key vault reference to save secrets_

This instance deploys the module saving all its secrets in a key vault.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/kvSecrets]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'kvref'
    // Non-required parameters
    secretsExportConfiguration: {
      accessKey1Name: 'custom-key1-name'
      accessKey2Name: 'custom-key2-name'
      connectionString1Name: 'custom-connectionString1-name'
      connectionString2Name: 'custom-connectionString2-name'
      keyVaultResourceId: '<keyVaultResourceId>'
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
      "value": "kvref"
    },
    // Non-required parameters
    "secretsExportConfiguration": {
      "value": {
        "accessKey1Name": "custom-key1-name",
        "accessKey2Name": "custom-key2-name",
        "connectionString1Name": "custom-connectionString1-name",
        "connectionString2Name": "custom-connectionString2-name",
        "keyVaultResourceId": "<keyVaultResourceId>"
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'kvref'
// Non-required parameters
param secretsExportConfiguration = {
  accessKey1Name: 'custom-key1-name'
  accessKey2Name: 'custom-key2-name'
  connectionString1Name: 'custom-connectionString1-name'
  connectionString2Name: 'custom-connectionString2-name'
  keyVaultResourceId: '<keyVaultResourceId>'
}
```

</details>
<p>

### Example 11: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssamax001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      automaticSnapshotPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 10
      containerDeleteRetentionPolicyEnabled: true
      containers: [
        {
          enableNfsV3AllSquash: true
          enableNfsV3RootSquash: true
          name: 'avdscripts'
          publicAccess: 'None'
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
        {
          metadata: {
            testKey: 'testValue'
          }
          name: 'archivecontainer'
          publicAccess: 'None'
        }
      ]
      corsRules: [
        {
          allowedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          allowedMethods: [
            'GET'
            'PUT'
          ]
          allowedOrigins: [
            'http://*.contoso.com'
            'http://www.fabrikam.com'
          ]
          exposedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          maxAgeInSeconds: 200
        }
      ]
      deleteRetentionPolicyDays: 9
      deleteRetentionPolicyEnabled: true
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      isVersioningEnabled: false
      lastAccessTimeTrackingPolicyEnabled: true
      versionDeletePolicyDays: 3
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableHierarchicalNamespace: true
    enableNfsV3: true
    enableSftp: true
    fileServices: {
      corsRules: [
        {
          allowedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          allowedMethods: [
            'GET'
            'PUT'
          ]
          allowedOrigins: [
            'http://*.contoso.com'
            'http://www.fabrikam.com'
          ]
          exposedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          maxAgeInSeconds: 200
        }
      ]
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      shares: [
        {
          accessTier: 'Hot'
          name: 'avdprofiles'
          roleAssignments: [
            {
              name: 'cff1213b-7877-4425-b67c-bb1de8950dfb'
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
          shareQuota: 5120
        }
        {
          name: 'avdprofiles2'
          shareQuota: 102400
        }
      ]
    }
    largeFileSharesState: 'Enabled'
    localUsers: [
      {
        hasSharedKey: false
        hasSshKey: true
        hasSshPassword: false
        homeDirectory: 'avdscripts'
        name: 'testuser'
        permissionScopes: [
          {
            permissions: 'r'
            resourceName: 'avdscripts'
            service: 'blob'
          }
        ]
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
      notes: 'This is a custom lock note.'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managementPolicyRules: [
      {
        definition: {
          actions: {
            baseBlob: {
              delete: {
                daysAfterModificationGreaterThan: 30
              }
              tierToCool: {
                daysAfterLastAccessTimeGreaterThan: 5
              }
            }
          }
          filters: {
            blobIndexMatch: [
              {
                name: 'BlobIndex'
                op: '=='
                value: '1'
              }
            ]
            blobTypes: [
              'blockBlob'
            ]
            prefixMatch: [
              'sample-container/log'
            ]
          }
        }
        enabled: true
        name: 'FirstRule'
        type: 'Lifecycle'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
      resourceAccessRules: [
        {
          resourceId: '<resourceId>'
          tenantId: '<tenantId>'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: '<id>'
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'table'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'queue'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'file'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'web'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'dfs'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    queueServices: {
      corsRules: [
        {
          allowedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          allowedMethods: [
            'GET'
            'PUT'
          ]
          allowedOrigins: [
            'http://*.contoso.com'
            'http://www.fabrikam.com'
          ]
          exposedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          maxAgeInSeconds: 200
        }
      ]
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
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
        {
          metadata: {}
          name: 'queue2'
        }
      ]
    }
    requireInfrastructureEncryption: true
    roleAssignments: [
      {
        name: '30b99723-a3d8-4e31-8872-b80c960d62bd'
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
    sasExpirationPeriod: '180.00:00:00'
    skuName: 'Standard_LRS'
    tableServices: {
      corsRules: [
        {
          allowedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          allowedMethods: [
            'GET'
            'PUT'
          ]
          allowedOrigins: [
            'http://*.contoso.com'
            'http://www.fabrikam.com'
          ]
          exposedHeaders: [
            'x-ms-meta-data'
            'x-ms-meta-source-path'
            'x-ms-meta-target-path'
          ]
          maxAgeInSeconds: 200
        }
      ]
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      tables: [
        {
          name: 'table1'
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
        {
          name: 'table2'
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
      ]
    }
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
      "value": "ssamax001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "automaticSnapshotPolicyEnabled": true,
        "containerDeleteRetentionPolicyDays": 10,
        "containerDeleteRetentionPolicyEnabled": true,
        "containers": [
          {
            "enableNfsV3AllSquash": true,
            "enableNfsV3RootSquash": true,
            "name": "avdscripts",
            "publicAccess": "None",
            "roleAssignments": [
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
          },
          {
            "metadata": {
              "testKey": "testValue"
            },
            "name": "archivecontainer",
            "publicAccess": "None"
          }
        ],
        "corsRules": [
          {
            "allowedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "allowedMethods": [
              "GET",
              "PUT"
            ],
            "allowedOrigins": [
              "http://*.contoso.com",
              "http://www.fabrikam.com"
            ],
            "exposedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "maxAgeInSeconds": 200
          }
        ],
        "deleteRetentionPolicyDays": 9,
        "deleteRetentionPolicyEnabled": true,
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "isVersioningEnabled": false,
        "lastAccessTimeTrackingPolicyEnabled": true,
        "versionDeletePolicyDays": 3
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableHierarchicalNamespace": {
      "value": true
    },
    "enableNfsV3": {
      "value": true
    },
    "enableSftp": {
      "value": true
    },
    "fileServices": {
      "value": {
        "corsRules": [
          {
            "allowedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "allowedMethods": [
              "GET",
              "PUT"
            ],
            "allowedOrigins": [
              "http://*.contoso.com",
              "http://www.fabrikam.com"
            ],
            "exposedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "maxAgeInSeconds": 200
          }
        ],
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "shares": [
          {
            "accessTier": "Hot",
            "name": "avdprofiles",
            "roleAssignments": [
              {
                "name": "cff1213b-7877-4425-b67c-bb1de8950dfb",
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
            ],
            "shareQuota": 5120
          },
          {
            "name": "avdprofiles2",
            "shareQuota": 102400
          }
        ]
      }
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "localUsers": {
      "value": [
        {
          "hasSharedKey": false,
          "hasSshKey": true,
          "hasSshPassword": false,
          "homeDirectory": "avdscripts",
          "name": "testuser",
          "permissionScopes": [
            {
              "permissions": "r",
              "resourceName": "avdscripts",
              "service": "blob"
            }
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName",
        "notes": "This is a custom lock note."
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
    "managementPolicyRules": {
      "value": [
        {
          "definition": {
            "actions": {
              "baseBlob": {
                "delete": {
                  "daysAfterModificationGreaterThan": 30
                },
                "tierToCool": {
                  "daysAfterLastAccessTimeGreaterThan": 5
                }
              }
            },
            "filters": {
              "blobIndexMatch": [
                {
                  "name": "BlobIndex",
                  "op": "==",
                  "value": "1"
                }
              ],
              "blobTypes": [
                "blockBlob"
              ],
              "prefixMatch": [
                "sample-container/log"
              ]
            }
          },
          "enabled": true,
          "name": "FirstRule",
          "type": "Lifecycle"
        }
      ]
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "value": "1.1.1.1"
          }
        ],
        "resourceAccessRules": [
          {
            "resourceId": "<resourceId>",
            "tenantId": "<tenantId>"
          }
        ],
        "virtualNetworkRules": [
          {
            "action": "Allow",
            "id": "<id>"
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "table",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "queue",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "file",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "web",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "dfs",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "queueServices": {
      "value": {
        "corsRules": [
          {
            "allowedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "allowedMethods": [
              "GET",
              "PUT"
            ],
            "allowedOrigins": [
              "http://*.contoso.com",
              "http://www.fabrikam.com"
            ],
            "exposedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "maxAgeInSeconds": 200
          }
        ],
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1",
            "roleAssignments": [
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
          },
          {
            "metadata": {},
            "name": "queue2"
          }
        ]
      }
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "name": "30b99723-a3d8-4e31-8872-b80c960d62bd",
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
    "sasExpirationPeriod": {
      "value": "180.00:00:00"
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "tableServices": {
      "value": {
        "corsRules": [
          {
            "allowedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "allowedMethods": [
              "GET",
              "PUT"
            ],
            "allowedOrigins": [
              "http://*.contoso.com",
              "http://www.fabrikam.com"
            ],
            "exposedHeaders": [
              "x-ms-meta-data",
              "x-ms-meta-source-path",
              "x-ms-meta-target-path"
            ],
            "maxAgeInSeconds": 200
          }
        ],
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "tables": [
          {
            "name": "table1",
            "roleAssignments": [
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
          },
          {
            "name": "table2",
            "roleAssignments": [
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
        ]
      }
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssamax001'
// Non-required parameters
param allowBlobPublicAccess = false
param blobServices = {
  automaticSnapshotPolicyEnabled: true
  containerDeleteRetentionPolicyDays: 10
  containerDeleteRetentionPolicyEnabled: true
  containers: [
    {
      enableNfsV3AllSquash: true
      enableNfsV3RootSquash: true
      name: 'avdscripts'
      publicAccess: 'None'
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
    {
      metadata: {
        testKey: 'testValue'
      }
      name: 'archivecontainer'
      publicAccess: 'None'
    }
  ]
  corsRules: [
    {
      allowedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      allowedMethods: [
        'GET'
        'PUT'
      ]
      allowedOrigins: [
        'http://*.contoso.com'
        'http://www.fabrikam.com'
      ]
      exposedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      maxAgeInSeconds: 200
    }
  ]
  deleteRetentionPolicyDays: 9
  deleteRetentionPolicyEnabled: true
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  isVersioningEnabled: false
  lastAccessTimeTrackingPolicyEnabled: true
  versionDeletePolicyDays: 3
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param enableHierarchicalNamespace = true
enableNfsV3: true
param enableSftp = true
param fileServices = {
  corsRules: [
    {
      allowedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      allowedMethods: [
        'GET'
        'PUT'
      ]
      allowedOrigins: [
        'http://*.contoso.com'
        'http://www.fabrikam.com'
      ]
      exposedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      maxAgeInSeconds: 200
    }
  ]
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  shares: [
    {
      accessTier: 'Hot'
      name: 'avdprofiles'
      roleAssignments: [
        {
          name: 'cff1213b-7877-4425-b67c-bb1de8950dfb'
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
      shareQuota: 5120
    }
    {
      name: 'avdprofiles2'
      shareQuota: 102400
    }
  ]
}
param largeFileSharesState = 'Enabled'
param localUsers = [
  {
    hasSharedKey: false
    hasSshKey: true
    hasSshPassword: false
    homeDirectory: 'avdscripts'
    name: 'testuser'
    permissionScopes: [
      {
        permissions: 'r'
        resourceName: 'avdscripts'
        service: 'blob'
      }
    ]
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
  notes: 'This is a custom lock note.'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managementPolicyRules = [
  {
    definition: {
      actions: {
        baseBlob: {
          delete: {
            daysAfterModificationGreaterThan: 30
          }
          tierToCool: {
            daysAfterLastAccessTimeGreaterThan: 5
          }
        }
      }
      filters: {
        blobIndexMatch: [
          {
            name: 'BlobIndex'
            op: '=='
            value: '1'
          }
        ]
        blobTypes: [
          'blockBlob'
        ]
        prefixMatch: [
          'sample-container/log'
        ]
      }
    }
    enabled: true
    name: 'FirstRule'
    type: 'Lifecycle'
  }
]
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: [
    {
      action: 'Allow'
      value: '1.1.1.1'
    }
  ]
  resourceAccessRules: [
    {
      resourceId: '<resourceId>'
      tenantId: '<tenantId>'
    }
  ]
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: '<id>'
    }
  ]
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'blob'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'blob'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'table'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'queue'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'file'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'web'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'dfs'
    subnetResourceId: '<subnetResourceId>'
  }
]
param queueServices = {
  corsRules: [
    {
      allowedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      allowedMethods: [
        'GET'
        'PUT'
      ]
      allowedOrigins: [
        'http://*.contoso.com'
        'http://www.fabrikam.com'
      ]
      exposedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      maxAgeInSeconds: 200
    }
  ]
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  queues: [
    {
      metadata: {
        key1: 'value1'
        key2: 'value2'
      }
      name: 'queue1'
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
    {
      metadata: {}
      name: 'queue2'
    }
  ]
}
param requireInfrastructureEncryption = true
param roleAssignments = [
  {
    name: '30b99723-a3d8-4e31-8872-b80c960d62bd'
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
param sasExpirationPeriod = '180.00:00:00'
param skuName = 'Standard_LRS'
param tableServices = {
  corsRules: [
    {
      allowedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      allowedMethods: [
        'GET'
        'PUT'
      ]
      allowedOrigins: [
        'http://*.contoso.com'
        'http://www.fabrikam.com'
      ]
      exposedHeaders: [
        'x-ms-meta-data'
        'x-ms-meta-source-path'
        'x-ms-meta-target-path'
      ]
      maxAgeInSeconds: 200
    }
  ]
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  tables: [
    {
      name: 'table1'
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
    {
      name: 'table2'
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
  ]
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 12: _Deploying with a NFS File Share_

This instance deploys the module with a NFS File Share.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/nfs]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssanfs001'
    // Non-required parameters
    fileServices: {
      shares: [
        {
          enabledProtocols: 'NFS'
          name: 'nfsfileshare'
        }
      ]
    }
    kind: 'FileStorage'
    skuName: 'Premium_LRS'
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
      "value": "ssanfs001"
    },
    // Non-required parameters
    "fileServices": {
      "value": {
        "shares": [
          {
            "enabledProtocols": "NFS",
            "name": "nfsfileshare"
          }
        ]
      }
    },
    "kind": {
      "value": "FileStorage"
    },
    "skuName": {
      "value": "Premium_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssanfs001'
// Non-required parameters
param fileServices = {
  shares: [
    {
      enabledProtocols: 'NFS'
      name: 'nfsfileshare'
    }
  ]
}
param kind = 'FileStorage'
param skuName = 'Premium_LRS'
```

</details>
<p>

### Example 13: _Using object replication_

This instance deploys the module with Object Replication features to async replicate blobs from one account to another.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/object-replication]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssaobre001'
    // Non-required parameters
    blobServices: {
      changeFeedEnabled: true
      containers: [
        {
          name: 'container01'
        }
      ]
      isVersioningEnabled: true
    }
    objectReplicationPolicies: [
      {
        destinationStorageAccountResourceId: '<destinationStorageAccountResourceId>'
        rules: [
          {
            containerName: 'container01'
            filters: {
              minCreationTime: '2025-01-01T00:00:00Z'
              prefixMatch: [
                'documents/'
                'images/'
              ]
            }
          }
        ]
      }
    ]
    skuName: 'Standard_LRS'
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
      "value": "ssaobre001"
    },
    // Non-required parameters
    "blobServices": {
      "value": {
        "changeFeedEnabled": true,
        "containers": [
          {
            "name": "container01"
          }
        ],
        "isVersioningEnabled": true
      }
    },
    "objectReplicationPolicies": {
      "value": [
        {
          "destinationStorageAccountResourceId": "<destinationStorageAccountResourceId>",
          "rules": [
            {
              "containerName": "container01",
              "filters": {
                "minCreationTime": "2025-01-01T00:00:00Z",
                "prefixMatch": [
                  "documents/",
                  "images/"
                ]
              }
            }
          ]
        }
      ]
    },
    "skuName": {
      "value": "Standard_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssaobre001'
// Non-required parameters
param blobServices = {
  changeFeedEnabled: true
  containers: [
    {
      name: 'container01'
    }
  ]
  isVersioningEnabled: true
}
param objectReplicationPolicies = [
  {
    destinationStorageAccountResourceId: '<destinationStorageAccountResourceId>'
    rules: [
      {
        containerName: 'container01'
        filters: {
          minCreationTime: '2025-01-01T00:00:00Z'
          prefixMatch: [
            'documents/'
            'images/'
          ]
        }
      }
    ]
  }
]
param skuName = 'Standard_LRS'
```

</details>
<p>

### Example 14: _Using premium file shares_

This instance deploys the module with File Services with PremiumV2 SKU and a file share.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/premium-file-share]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssapfs001'
    // Non-required parameters
    allowBlobPublicAccess: false
    fileServices: {
      shares: [
        {
          name: 'fileshare01'
          provisionedBandwidthMibps: 200
          provisionedIops: 5000
        }
        {
          name: 'fileshare02'
        }
      ]
    }
    kind: 'FileStorage'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    skuName: 'PremiumV2_LRS'
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
      "value": "ssapfs001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "fileServices": {
      "value": {
        "shares": [
          {
            "name": "fileshare01",
            "provisionedBandwidthMibps": 200,
            "provisionedIops": 5000
          },
          {
            "name": "fileshare02"
          }
        ]
      }
    },
    "kind": {
      "value": "FileStorage"
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny"
      }
    },
    "skuName": {
      "value": "PremiumV2_LRS"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssapfs001'
// Non-required parameters
param allowBlobPublicAccess = false
param fileServices = {
  shares: [
    {
      name: 'fileshare01'
      provisionedBandwidthMibps: 200
      provisionedIops: 5000
    }
    {
      name: 'fileshare02'
    }
  ]
}
param kind = 'FileStorage'
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}
param skuName = 'PremiumV2_LRS'
```

</details>
<p>

### Example 15: _Deploying as Storage Account version 1_

This instance deploys the module as Storage Account version 1.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/v1]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssav1001'
    // Non-required parameters
    kind: 'Storage'
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
      "value": "ssav1001"
    },
    // Non-required parameters
    "kind": {
      "value": "Storage"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssav1001'
// Non-required parameters
param kind = 'Storage'
```

</details>
<p>

### Example 16: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:<version>' = {
  params: {
    // Required parameters
    name: 'ssawaf001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      automaticSnapshotPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 10
      containerDeleteRetentionPolicyEnabled: true
      containers: [
        {
          name: 'avdscripts'
          publicAccess: 'None'
        }
        {
          immutabilityPolicy: {
            allowProtectedAppendWrites: false
            allowProtectedAppendWritesAll: true
            immutabilityPeriodSinceCreationInDays: 7
          }
          metadata: {
            testKey: 'testValue'
          }
          name: 'archivecontainer'
          publicAccess: 'None'
        }
      ]
      deleteRetentionPolicyDays: 9
      deleteRetentionPolicyEnabled: true
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      isVersioningEnabled: true
      lastAccessTimeTrackingPolicyEnabled: true
      versionDeletePolicyDays: 3
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    fileServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      shares: [
        {
          accessTier: 'Hot'
          name: 'avdprofiles'
          shareQuota: 5120
        }
        {
          name: 'avdprofiles2'
          shareQuota: 102400
        }
      ]
    }
    largeFileSharesState: 'Enabled'
    localUsers: [
      {
        hasSharedKey: false
        hasSshKey: true
        hasSshPassword: false
        homeDirectory: 'avdscripts'
        name: 'testuser'
        permissionScopes: [
          {
            permissions: 'r'
            resourceName: 'avdscripts'
            service: 'blob'
          }
        ]
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managementPolicyRules: [
      {
        definition: {
          actions: {
            baseBlob: {
              delete: {
                daysAfterModificationGreaterThan: 30
              }
              tierToCool: {
                daysAfterLastAccessTimeGreaterThan: 5
              }
            }
          }
          filters: {
            blobIndexMatch: [
              {
                name: 'BlobIndex'
                op: '=='
                value: '1'
              }
            ]
            blobTypes: [
              'blockBlob'
            ]
            prefixMatch: [
              'sample-container/log'
            ]
          }
        }
        enabled: true
        name: 'FirstRule'
        type: 'Lifecycle'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: '<id>'
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    queueServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
        }
        {
          metadata: {}
          name: 'queue2'
        }
      ]
    }
    requireInfrastructureEncryption: true
    sasExpirationPeriod: '180.00:00:00'
    skuName: 'Standard_ZRS'
    tableServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      tables: [
        {
          name: 'table1'
        }
        {
          name: 'table2'
        }
      ]
    }
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
      "value": "ssawaf001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "automaticSnapshotPolicyEnabled": true,
        "containerDeleteRetentionPolicyDays": 10,
        "containerDeleteRetentionPolicyEnabled": true,
        "containers": [
          {
            "name": "avdscripts",
            "publicAccess": "None"
          },
          {
            "immutabilityPolicy": {
              "allowProtectedAppendWrites": false,
              "allowProtectedAppendWritesAll": true,
              "immutabilityPeriodSinceCreationInDays": 7
            },
            "metadata": {
              "testKey": "testValue"
            },
            "name": "archivecontainer",
            "publicAccess": "None"
          }
        ],
        "deleteRetentionPolicyDays": 9,
        "deleteRetentionPolicyEnabled": true,
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "isVersioningEnabled": true,
        "lastAccessTimeTrackingPolicyEnabled": true,
        "versionDeletePolicyDays": 3
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "fileServices": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "shares": [
          {
            "accessTier": "Hot",
            "name": "avdprofiles",
            "shareQuota": 5120
          },
          {
            "name": "avdprofiles2",
            "shareQuota": 102400
          }
        ]
      }
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "localUsers": {
      "value": [
        {
          "hasSharedKey": false,
          "hasSshKey": true,
          "hasSshPassword": false,
          "homeDirectory": "avdscripts",
          "name": "testuser",
          "permissionScopes": [
            {
              "permissions": "r",
              "resourceName": "avdscripts",
              "service": "blob"
            }
          ]
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managementPolicyRules": {
      "value": [
        {
          "definition": {
            "actions": {
              "baseBlob": {
                "delete": {
                  "daysAfterModificationGreaterThan": 30
                },
                "tierToCool": {
                  "daysAfterLastAccessTimeGreaterThan": 5
                }
              }
            },
            "filters": {
              "blobIndexMatch": [
                {
                  "name": "BlobIndex",
                  "op": "==",
                  "value": "1"
                }
              ],
              "blobTypes": [
                "blockBlob"
              ],
              "prefixMatch": [
                "sample-container/log"
              ]
            }
          },
          "enabled": true,
          "name": "FirstRule",
          "type": "Lifecycle"
        }
      ]
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "value": "1.1.1.1"
          }
        ],
        "virtualNetworkRules": [
          {
            "action": "Allow",
            "id": "<id>"
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "queueServices": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1"
          },
          {
            "metadata": {},
            "name": "queue2"
          }
        ]
      }
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "sasExpirationPeriod": {
      "value": "180.00:00:00"
    },
    "skuName": {
      "value": "Standard_ZRS"
    },
    "tableServices": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "tables": [
          {
            "name": "table1"
          },
          {
            "name": "table2"
          }
        ]
      }
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
using 'br/public:avm/res/storage/storage-account:<version>'

// Required parameters
param name = 'ssawaf001'
// Non-required parameters
param allowBlobPublicAccess = false
param blobServices = {
  automaticSnapshotPolicyEnabled: true
  containerDeleteRetentionPolicyDays: 10
  containerDeleteRetentionPolicyEnabled: true
  containers: [
    {
      name: 'avdscripts'
      publicAccess: 'None'
    }
    {
      immutabilityPolicy: {
        allowProtectedAppendWrites: false
        allowProtectedAppendWritesAll: true
        immutabilityPeriodSinceCreationInDays: 7
      }
      metadata: {
        testKey: 'testValue'
      }
      name: 'archivecontainer'
      publicAccess: 'None'
    }
  ]
  deleteRetentionPolicyDays: 9
  deleteRetentionPolicyEnabled: true
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  isVersioningEnabled: true
  lastAccessTimeTrackingPolicyEnabled: true
  versionDeletePolicyDays: 3
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param fileServices = {
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  shares: [
    {
      accessTier: 'Hot'
      name: 'avdprofiles'
      shareQuota: 5120
    }
    {
      name: 'avdprofiles2'
      shareQuota: 102400
    }
  ]
}
param largeFileSharesState = 'Enabled'
param localUsers = [
  {
    hasSharedKey: false
    hasSshKey: true
    hasSshPassword: false
    homeDirectory: 'avdscripts'
    name: 'testuser'
    permissionScopes: [
      {
        permissions: 'r'
        resourceName: 'avdscripts'
        service: 'blob'
      }
    ]
  }
]
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managementPolicyRules = [
  {
    definition: {
      actions: {
        baseBlob: {
          delete: {
            daysAfterModificationGreaterThan: 30
          }
          tierToCool: {
            daysAfterLastAccessTimeGreaterThan: 5
          }
        }
      }
      filters: {
        blobIndexMatch: [
          {
            name: 'BlobIndex'
            op: '=='
            value: '1'
          }
        ]
        blobTypes: [
          'blockBlob'
        ]
        prefixMatch: [
          'sample-container/log'
        ]
      }
    }
    enabled: true
    name: 'FirstRule'
    type: 'Lifecycle'
  }
]
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: [
    {
      action: 'Allow'
      value: '1.1.1.1'
    }
  ]
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: '<id>'
    }
  ]
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'blob'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param queueServices = {
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  queues: [
    {
      metadata: {
        key1: 'value1'
        key2: 'value2'
      }
      name: 'queue1'
    }
    {
      metadata: {}
      name: 'queue2'
    }
  ]
}
param requireInfrastructureEncryption = true
param sasExpirationPeriod = '180.00:00:00'
param skuName = 'Standard_ZRS'
param tableServices = {
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  tables: [
    {
      name: 'table1'
    }
    {
      name: 'table2'
    }
  ]
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Storage Account. Must be lower-case. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessTier`](#parameter-accesstier) | string | Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type. |
| [`enableHierarchicalNamespace`](#parameter-enablehierarchicalnamespace) | bool | If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBlobPublicAccess`](#parameter-allowblobpublicaccess) | bool | Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false. |
| [`allowCrossTenantReplication`](#parameter-allowcrosstenantreplication) | bool | Allow or disallow cross AAD tenant object replication. |
| [`allowedCopyScope`](#parameter-allowedcopyscope) | string | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. |
| [`allowSharedKeyAccess`](#parameter-allowsharedkeyaccess) | bool | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true. |
| [`azureFilesIdentityBasedAuthentication`](#parameter-azurefilesidentitybasedauthentication) | object | Provides the identity based authentication settings for Azure Files. |
| [`blobServices`](#parameter-blobservices) | object | Blob service and containers to deploy. |
| [`customDomainName`](#parameter-customdomainname) | string | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| [`customDomainUseSubDomainName`](#parameter-customdomainusesubdomainname) | bool | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`defaultToOAuthAuthentication`](#parameter-defaulttooauthauthentication) | bool | A boolean flag which indicates whether the default authentication is OAuth or not. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsEndpointType`](#parameter-dnsendpointtype) | string | Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier. |
| [`enableNfsV3`](#parameter-enablenfsv3) | bool | If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`enableSftp`](#parameter-enablesftp) | bool | If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedLocationZone`](#parameter-extendedlocationzone) | string | Extended Zone location (ex 'losangeles'). When supplied, the storage account will be created in the specified zone under the parent location. The extended zone must be available in the supplied parent location. |
| [`fileServices`](#parameter-fileservices) | object | File service and shares to deploy. |
| [`immutableStorageWithVersioning`](#parameter-immutablestoragewithversioning) | object | The property is immutable and can only be set to true at the account creation time. When set to true, it enables object level immutability for all the new containers in the account by default. Cannot be enabled for ADLS Gen2 storage accounts. |
| [`isLocalUserEnabled`](#parameter-islocaluserenabled) | bool | Enables local users feature, if set to true. |
| [`keyType`](#parameter-keytype) | string | The keyType to use with Queue & Table services. |
| [`kind`](#parameter-kind) | string | Type of Storage Account to create. |
| [`largeFileSharesState`](#parameter-largefilesharesstate) | string | Allow large file shares if set to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares). |
| [`localUsers`](#parameter-localusers) | array | Local users to deploy for SFTP authentication. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managementPolicyRules`](#parameter-managementpolicyrules) | array | The Storage Account ManagementPolicies Rules. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | Set the minimum TLS version on request to storage. The TLS versions 1.0 and 1.1 are deprecated and not supported anymore. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`objectReplicationPolicies`](#parameter-objectreplicationpolicies) | array | Object replication policies for the storage account. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`queueServices`](#parameter-queueservices) | object | Queue service and queues to create. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sasExpirationAction`](#parameter-sasexpirationaction) | string | The SAS expiration action. Allowed values are Block and Log. |
| [`sasExpirationPeriod`](#parameter-sasexpirationperiod) | string | The SAS expiration period. DD.HH:MM:SS. |
| [`secretsExportConfiguration`](#parameter-secretsexportconfiguration) | object | Key vault reference and secret settings for the module's secrets export. |
| [`skuName`](#parameter-skuname) | string | Storage Account Sku Name - note: certain V2 SKUs require the use of: kind = FileStorage. |
| [`supportsHttpsTrafficOnly`](#parameter-supportshttpstrafficonly) | bool | Allows HTTPS traffic only to storage service if sets to true. |
| [`tableServices`](#parameter-tableservices) | object | Table service and tables to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Storage Account. Must be lower-case.

- Required: Yes
- Type: string

### Parameter: `accessTier`

Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.

- Required: No
- Type: string
- Default: `'Hot'`
- Allowed:
  ```Bicep
  [
    'Cold'
    'Cool'
    'Hot'
    'Premium'
  ]
  ```

### Parameter: `enableHierarchicalNamespace`

If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true.

- Required: No
- Type: bool

### Parameter: `allowBlobPublicAccess`

Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowCrossTenantReplication`

Allow or disallow cross AAD tenant object replication.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowedCopyScope`

Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AAD'
    'PrivateLink'
  ]
  ```

### Parameter: `allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `azureFilesIdentityBasedAuthentication`

Provides the identity based authentication settings for Azure Files.

- Required: No
- Type: object

### Parameter: `blobServices`

Blob service and containers to deploy.

- Required: No
- Type: object
- Default: `[if(not(equals(parameters('kind'), 'FileStorage')), createObject('containerDeleteRetentionPolicyEnabled', true(), 'containerDeleteRetentionPolicyDays', 7, 'deleteRetentionPolicyEnabled', true(), 'deleteRetentionPolicyDays', 6), createObject())]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automaticSnapshotPolicyEnabled`](#parameter-blobservicesautomaticsnapshotpolicyenabled) | bool | Automatic Snapshot is enabled if set to true. |
| [`changeFeedEnabled`](#parameter-blobserviceschangefeedenabled) | bool | The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service. |
| [`changeFeedRetentionInDays`](#parameter-blobserviceschangefeedretentionindays) | int | Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. If left blank, it indicates an infinite retention of the change feed. |
| [`containerDeleteRetentionPolicyAllowPermanentDelete`](#parameter-blobservicescontainerdeleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`containerDeleteRetentionPolicyDays`](#parameter-blobservicescontainerdeleteretentionpolicydays) | int | Indicates the number of days that the deleted item should be retained. |
| [`containerDeleteRetentionPolicyEnabled`](#parameter-blobservicescontainerdeleteretentionpolicyenabled) | bool | The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled. |
| [`containers`](#parameter-blobservicescontainers) | array | Blob containers to create. |
| [`corsRules`](#parameter-blobservicescorsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`defaultServiceVersion`](#parameter-blobservicesdefaultserviceversion) | string | Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions. |
| [`deleteRetentionPolicyAllowPermanentDelete`](#parameter-blobservicesdeleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`deleteRetentionPolicyDays`](#parameter-blobservicesdeleteretentionpolicydays) | int | Indicates the number of days that the deleted blob should be retained. |
| [`deleteRetentionPolicyEnabled`](#parameter-blobservicesdeleteretentionpolicyenabled) | bool | The blob service properties for blob soft delete. |
| [`diagnosticSettings`](#parameter-blobservicesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`isVersioningEnabled`](#parameter-blobservicesisversioningenabled) | bool | Use versioning to automatically maintain previous versions of your blobs. Cannot be enabled for ADLS Gen2 storage accounts. |
| [`lastAccessTimeTrackingPolicyEnabled`](#parameter-blobserviceslastaccesstimetrackingpolicyenabled) | bool | The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled. |
| [`restorePolicyDays`](#parameter-blobservicesrestorepolicydays) | int | How long this blob can be restored. It should be less than DeleteRetentionPolicy days. |
| [`restorePolicyEnabled`](#parameter-blobservicesrestorepolicyenabled) | bool | The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. |
| [`versionDeletePolicyDays`](#parameter-blobservicesversiondeletepolicydays) | int | Number of days to keep a version before deleting. If set, a lifecycle management policy will be created to handle deleting previous versions. |

### Parameter: `blobServices.automaticSnapshotPolicyEnabled`

Automatic Snapshot is enabled if set to true.

- Required: No
- Type: bool

### Parameter: `blobServices.changeFeedEnabled`

The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service.

- Required: No
- Type: bool

### Parameter: `blobServices.changeFeedRetentionInDays`

Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. If left blank, it indicates an infinite retention of the change feed.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 146000

### Parameter: `blobServices.containerDeleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.

- Required: No
- Type: bool

### Parameter: `blobServices.containerDeleteRetentionPolicyDays`

Indicates the number of days that the deleted item should be retained.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 365

### Parameter: `blobServices.containerDeleteRetentionPolicyEnabled`

The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled.

- Required: No
- Type: bool

### Parameter: `blobServices.containers`

Blob containers to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-blobservicescontainersname) | string | The name of the Storage Container to deploy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultEncryptionScope`](#parameter-blobservicescontainersdefaultencryptionscope) | string | Default the container to use specified encryption scope for all writes. |
| [`denyEncryptionScopeOverride`](#parameter-blobservicescontainersdenyencryptionscopeoverride) | bool | Block override of encryption scope from the container default. |
| [`enableNfsV3AllSquash`](#parameter-blobservicescontainersenablenfsv3allsquash) | bool | Enable NFSv3 all squash on blob container. |
| [`enableNfsV3RootSquash`](#parameter-blobservicescontainersenablenfsv3rootsquash) | bool | Enable NFSv3 root squash on blob container. |
| [`immutabilityPolicy`](#parameter-blobservicescontainersimmutabilitypolicy) | object | Configure immutability policy. |
| [`immutableStorageWithVersioningEnabled`](#parameter-blobservicescontainersimmutablestoragewithversioningenabled) | bool | This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process. |
| [`metadata`](#parameter-blobservicescontainersmetadata) | object | A name-value pair to associate with the container as metadata. |
| [`publicAccess`](#parameter-blobservicescontainerspublicaccess) | string | Specifies whether data in the container may be accessed publicly and the level of access. |
| [`roleAssignments`](#parameter-blobservicescontainersroleassignments) | array | Array of role assignments to create. |

### Parameter: `blobServices.containers.name`

The name of the Storage Container to deploy.

- Required: Yes
- Type: string

### Parameter: `blobServices.containers.defaultEncryptionScope`

Default the container to use specified encryption scope for all writes.

- Required: No
- Type: string

### Parameter: `blobServices.containers.denyEncryptionScopeOverride`

Block override of encryption scope from the container default.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.enableNfsV3AllSquash`

Enable NFSv3 all squash on blob container.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.enableNfsV3RootSquash`

Enable NFSv3 root squash on blob container.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.immutabilityPolicy`

Configure immutability policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowProtectedAppendWrites`](#parameter-blobservicescontainersimmutabilitypolicyallowprotectedappendwrites) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. Defaults to false. |
| [`allowProtectedAppendWritesAll`](#parameter-blobservicescontainersimmutabilitypolicyallowprotectedappendwritesall) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive. Defaults to false. |
| [`immutabilityPeriodSinceCreationInDays`](#parameter-blobservicescontainersimmutabilitypolicyimmutabilityperiodsincecreationindays) | int | The immutability period for the blobs in the container since the policy creation, in days. |

### Parameter: `blobServices.containers.immutabilityPolicy.allowProtectedAppendWrites`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. Defaults to false.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.immutabilityPolicy.allowProtectedAppendWritesAll`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive. Defaults to false.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.immutabilityPolicy.immutabilityPeriodSinceCreationInDays`

The immutability period for the blobs in the container since the policy creation, in days.

- Required: No
- Type: int

### Parameter: `blobServices.containers.immutableStorageWithVersioningEnabled`

This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.

- Required: No
- Type: bool

### Parameter: `blobServices.containers.metadata`

A name-value pair to associate with the container as metadata.

- Required: No
- Type: object

### Parameter: `blobServices.containers.publicAccess`

Specifies whether data in the container may be accessed publicly and the level of access.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Blob'
    'Container'
    'None'
  ]
  ```

### Parameter: `blobServices.containers.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-blobservicescontainersroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-blobservicescontainersroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-blobservicescontainersroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-blobservicescontainersroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-blobservicescontainersroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-blobservicescontainersroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-blobservicescontainersroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-blobservicescontainersroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `blobServices.containers.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `blobServices.containers.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `blobServices.containers.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `blobServices.containers.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `blobServices.containers.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `blobServices.containers.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `blobServices.containers.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `blobServices.containers.roleAssignments.principalType`

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

### Parameter: `blobServices.corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedHeaders`](#parameter-blobservicescorsrulesallowedheaders) | array | A list of headers allowed to be part of the cross-origin request. |
| [`allowedMethods`](#parameter-blobservicescorsrulesallowedmethods) | array | A list of HTTP methods that are allowed to be executed by the origin. |
| [`allowedOrigins`](#parameter-blobservicescorsrulesallowedorigins) | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains. |
| [`exposedHeaders`](#parameter-blobservicescorsrulesexposedheaders) | array | A list of response headers to expose to CORS clients. |
| [`maxAgeInSeconds`](#parameter-blobservicescorsrulesmaxageinseconds) | int | The number of seconds that the client/browser should cache a preflight response. |

### Parameter: `blobServices.corsRules.allowedHeaders`

A list of headers allowed to be part of the cross-origin request.

- Required: Yes
- Type: array

### Parameter: `blobServices.corsRules.allowedMethods`

A list of HTTP methods that are allowed to be executed by the origin.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'CONNECT'
    'DELETE'
    'GET'
    'HEAD'
    'MERGE'
    'OPTIONS'
    'PATCH'
    'POST'
    'PUT'
    'TRACE'
  ]
  ```

### Parameter: `blobServices.corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array

### Parameter: `blobServices.corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array

### Parameter: `blobServices.corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int

### Parameter: `blobServices.defaultServiceVersion`

Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions.

- Required: No
- Type: string

### Parameter: `blobServices.deleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.

- Required: No
- Type: bool

### Parameter: `blobServices.deleteRetentionPolicyDays`

Indicates the number of days that the deleted blob should be retained.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 365

### Parameter: `blobServices.deleteRetentionPolicyEnabled`

The blob service properties for blob soft delete.

- Required: No
- Type: bool

### Parameter: `blobServices.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-blobservicesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-blobservicesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-blobservicesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-blobservicesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-blobservicesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-blobservicesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-blobservicesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-blobservicesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-blobservicesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `blobServices.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `blobServices.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-blobservicesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-blobservicesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-blobservicesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `blobServices.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `blobServices.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-blobservicesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-blobservicesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `blobServices.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `blobServices.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `blobServices.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `blobServices.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `blobServices.isVersioningEnabled`

Use versioning to automatically maintain previous versions of your blobs. Cannot be enabled for ADLS Gen2 storage accounts.

- Required: No
- Type: bool

### Parameter: `blobServices.lastAccessTimeTrackingPolicyEnabled`

The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled.

- Required: No
- Type: bool

### Parameter: `blobServices.restorePolicyDays`

How long this blob can be restored. It should be less than DeleteRetentionPolicy days.

- Required: No
- Type: int
- MinValue: 1

### Parameter: `blobServices.restorePolicyEnabled`

The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled.

- Required: No
- Type: bool

### Parameter: `blobServices.versionDeletePolicyDays`

Number of days to keep a version before deleting. If set, a lifecycle management policy will be created to handle deleting previous versions.

- Required: No
- Type: int

### Parameter: `customDomainName`

Sets the custom domain name assigned to the storage account. Name is the CNAME source.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customDomainUseSubDomainName`

Indicates whether indirect CName validation is enabled. This should only be set on updates.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `defaultToOAuthAuthentication`

A boolean flag which indicates whether the default authentication is OAuth or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `dnsEndpointType`

Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDnsZone'
    'Standard'
  ]
  ```

### Parameter: `enableNfsV3`

If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableSftp`

If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedLocationZone`

Extended Zone location (ex 'losangeles'). When supplied, the storage account will be created in the specified zone under the parent location. The extended zone must be available in the supplied parent location.

- Required: No
- Type: string

### Parameter: `fileServices`

File service and shares to deploy.

- Required: No
- Type: object
- Default: `{}`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsRules`](#parameter-fileservicescorsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`diagnosticSettings`](#parameter-fileservicesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`protocolSettings`](#parameter-fileservicesprotocolsettings) | object | Protocol settings for file service. |
| [`shareDeleteRetentionPolicy`](#parameter-fileservicessharedeleteretentionpolicy) | object | The service properties for soft delete. |
| [`shares`](#parameter-fileservicesshares) | array | File shares to create. |

### Parameter: `fileServices.corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedHeaders`](#parameter-fileservicescorsrulesallowedheaders) | array | A list of headers allowed to be part of the cross-origin request. |
| [`allowedMethods`](#parameter-fileservicescorsrulesallowedmethods) | array | A list of HTTP methods that are allowed to be executed by the origin. |
| [`allowedOrigins`](#parameter-fileservicescorsrulesallowedorigins) | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains. |
| [`exposedHeaders`](#parameter-fileservicescorsrulesexposedheaders) | array | A list of response headers to expose to CORS clients. |
| [`maxAgeInSeconds`](#parameter-fileservicescorsrulesmaxageinseconds) | int | The number of seconds that the client/browser should cache a preflight response. |

### Parameter: `fileServices.corsRules.allowedHeaders`

A list of headers allowed to be part of the cross-origin request.

- Required: Yes
- Type: array

### Parameter: `fileServices.corsRules.allowedMethods`

A list of HTTP methods that are allowed to be executed by the origin.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'CONNECT'
    'DELETE'
    'GET'
    'HEAD'
    'MERGE'
    'OPTIONS'
    'PATCH'
    'POST'
    'PUT'
    'TRACE'
  ]
  ```

### Parameter: `fileServices.corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array

### Parameter: `fileServices.corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array

### Parameter: `fileServices.corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int

### Parameter: `fileServices.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-fileservicesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-fileservicesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-fileservicesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-fileservicesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-fileservicesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-fileservicesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-fileservicesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-fileservicesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-fileservicesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `fileServices.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `fileServices.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-fileservicesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-fileservicesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-fileservicesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `fileServices.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `fileServices.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-fileservicesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-fileservicesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `fileServices.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `fileServices.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `fileServices.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `fileServices.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `fileServices.protocolSettings`

Protocol settings for file service.

- Required: No
- Type: object

### Parameter: `fileServices.shareDeleteRetentionPolicy`

The service properties for soft delete.

- Required: No
- Type: object

### Parameter: `fileServices.shares`

File shares to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-fileservicessharesname) | string | The name of the file share. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessTier`](#parameter-fileservicessharesaccesstier) | string | Access tier for specific share. Required if the Storage Account kind is set to FileStorage (should be set to "Premium"). GpV2 account can choose between TransactionOptimized (default), Hot, and Cool. |
| [`enabledProtocols`](#parameter-fileservicessharesenabledprotocols) | string | The authentication protocol that is used for the file share. Can only be specified when creating a share. |
| [`provisionedBandwidthMibps`](#parameter-fileservicessharesprovisionedbandwidthmibps) | int | The provisioned bandwidth of the share, in mebibytes per second. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 10340. |
| [`provisionedIops`](#parameter-fileservicessharesprovisionediops) | int | The provisioned IOPS of the share. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 102400. |
| [`roleAssignments`](#parameter-fileservicessharesroleassignments) | array | Array of role assignments to create. |
| [`rootSquash`](#parameter-fileservicessharesrootsquash) | string | Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares. |
| [`shareQuota`](#parameter-fileservicessharessharequota) | int | The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB). |

### Parameter: `fileServices.shares.name`

The name of the file share.

- Required: Yes
- Type: string

### Parameter: `fileServices.shares.accessTier`

Access tier for specific share. Required if the Storage Account kind is set to FileStorage (should be set to "Premium"). GpV2 account can choose between TransactionOptimized (default), Hot, and Cool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Cool'
    'Hot'
    'Premium'
    'TransactionOptimized'
  ]
  ```

### Parameter: `fileServices.shares.enabledProtocols`

The authentication protocol that is used for the file share. Can only be specified when creating a share.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `fileServices.shares.provisionedBandwidthMibps`

The provisioned bandwidth of the share, in mebibytes per second. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 10340.

- Required: No
- Type: int
- MaxValue: 10340

### Parameter: `fileServices.shares.provisionedIops`

The provisioned IOPS of the share. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 102400.

- Required: No
- Type: int
- MaxValue: 102400

### Parameter: `fileServices.shares.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-fileservicessharesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-fileservicessharesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-fileservicessharesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-fileservicessharesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-fileservicessharesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-fileservicessharesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-fileservicessharesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-fileservicessharesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `fileServices.shares.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `fileServices.shares.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `fileServices.shares.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `fileServices.shares.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `fileServices.shares.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `fileServices.shares.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `fileServices.shares.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `fileServices.shares.roleAssignments.principalType`

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

### Parameter: `fileServices.shares.rootSquash`

Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllSquash'
    'NoRootSquash'
    'RootSquash'
  ]
  ```

### Parameter: `fileServices.shares.shareQuota`

The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB).

- Required: No
- Type: int

### Parameter: `immutableStorageWithVersioning`

The property is immutable and can only be set to true at the account creation time. When set to true, it enables object level immutability for all the new containers in the account by default. Cannot be enabled for ADLS Gen2 storage accounts.

- Required: No
- Type: object

### Parameter: `isLocalUserEnabled`

Enables local users feature, if set to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `keyType`

The keyType to use with Queue & Table services.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Account'
    'Service'
  ]
  ```

### Parameter: `kind`

Type of Storage Account to create.

- Required: No
- Type: string
- Default: `'StorageV2'`
- Allowed:
  ```Bicep
  [
    'BlobStorage'
    'BlockBlobStorage'
    'FileStorage'
    'Storage'
    'StorageV2'
  ]
  ```

### Parameter: `largeFileSharesState`

Allow large file shares if set to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `localUsers`

Local users to deploy for SFTP authentication.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hasSshKey`](#parameter-localusershassshkey) | bool | Indicates whether SSH key exists. Set it to false to remove existing SSH key. |
| [`hasSshPassword`](#parameter-localusershassshpassword) | bool | Indicates whether SSH password exists. Set it to false to remove existing SSH password. |
| [`name`](#parameter-localusersname) | string | The name of the local user used for SFTP Authentication. |
| [`permissionScopes`](#parameter-localuserspermissionscopes) | array | The permission scopes of the local user. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hasSharedKey`](#parameter-localusershassharedkey) | bool | Indicates whether shared key exists. Set it to false to remove existing shared key. |
| [`homeDirectory`](#parameter-localusershomedirectory) | string | The local user home directory. |
| [`sshAuthorizedKeys`](#parameter-localuserssshauthorizedkeys) | array | The local user SSH authorized keys for SFTP. |

### Parameter: `localUsers.hasSshKey`

Indicates whether SSH key exists. Set it to false to remove existing SSH key.

- Required: Yes
- Type: bool

### Parameter: `localUsers.hasSshPassword`

Indicates whether SSH password exists. Set it to false to remove existing SSH password.

- Required: Yes
- Type: bool

### Parameter: `localUsers.name`

The name of the local user used for SFTP Authentication.

- Required: Yes
- Type: string

### Parameter: `localUsers.permissionScopes`

The permission scopes of the local user.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`permissions`](#parameter-localuserspermissionscopespermissions) | string | The permissions for the local user. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c). |
| [`resourceName`](#parameter-localuserspermissionscopesresourcename) | string | The name of resource, normally the container name or the file share name, used by the local user. |
| [`service`](#parameter-localuserspermissionscopesservice) | string | The service used by the local user, e.g. blob, file. |

### Parameter: `localUsers.permissionScopes.permissions`

The permissions for the local user. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c).

- Required: Yes
- Type: string

### Parameter: `localUsers.permissionScopes.resourceName`

The name of resource, normally the container name or the file share name, used by the local user.

- Required: Yes
- Type: string

### Parameter: `localUsers.permissionScopes.service`

The service used by the local user, e.g. blob, file.

- Required: Yes
- Type: string

### Parameter: `localUsers.hasSharedKey`

Indicates whether shared key exists. Set it to false to remove existing shared key.

- Required: No
- Type: bool

### Parameter: `localUsers.homeDirectory`

The local user home directory.

- Required: No
- Type: string

### Parameter: `localUsers.sshAuthorizedKeys`

The local user SSH authorized keys for SFTP.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-localuserssshauthorizedkeyskey) | securestring | SSH public key base64 encoded. The format should be: '{keyType} {keyData}', e.g. ssh-rsa AAAABBBB. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-localuserssshauthorizedkeysdescription) | string | Description used to store the function/usage of the key. |

### Parameter: `localUsers.sshAuthorizedKeys.key`

SSH public key base64 encoded. The format should be: '{keyType} {keyData}', e.g. ssh-rsa AAAABBBB.

- Required: Yes
- Type: securestring

### Parameter: `localUsers.sshAuthorizedKeys.description`

Description used to store the function/usage of the key.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

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

### Parameter: `managementPolicyRules`

The Storage Account ManagementPolicies Rules.

- Required: No
- Type: array

### Parameter: `minimumTlsVersion`

Set the minimum TLS version on request to storage. The TLS versions 1.0 and 1.1 are deprecated and not supported anymore.

- Required: No
- Type: string
- Default: `'TLS1_2'`
- Allowed:
  ```Bicep
  [
    'TLS1_2'
  ]
  ```

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bypass`](#parameter-networkaclsbypass) | string | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging,Metrics,AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics. |
| [`defaultAction`](#parameter-networkaclsdefaultaction) | string | Specifies the default action of allow or deny when no other rules match. |
| [`ipRules`](#parameter-networkaclsiprules) | array | Sets the IP ACL rules. |
| [`resourceAccessRules`](#parameter-networkaclsresourceaccessrules) | array | Sets the resource access rules. Array entries must consist of "tenantId" and "resourceId" fields only. |
| [`virtualNetworkRules`](#parameter-networkaclsvirtualnetworkrules) | array | Sets the virtual network rules. |

### Parameter: `networkAcls.bypass`

Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging,Metrics,AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureServices'
    'AzureServices, Logging'
    'AzureServices, Logging, Metrics'
    'AzureServices, Metrics'
    'Logging'
    'Logging, Metrics'
    'Metrics'
    'None'
  ]
  ```

### Parameter: `networkAcls.defaultAction`

Specifies the default action of allow or deny when no other rules match.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkAcls.ipRules`

Sets the IP ACL rules.

- Required: No
- Type: array

### Parameter: `networkAcls.resourceAccessRules`

Sets the resource access rules. Array entries must consist of "tenantId" and "resourceId" fields only.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-networkaclsresourceaccessrulesresourceid) | string | The resource ID of the target service. Can also contain a wildcard, if multiple services e.g. in a resource group should be included. |
| [`tenantId`](#parameter-networkaclsresourceaccessrulestenantid) | string | The ID of the tenant in which the resource resides in. |

### Parameter: `networkAcls.resourceAccessRules.resourceId`

The resource ID of the target service. Can also contain a wildcard, if multiple services e.g. in a resource group should be included.

- Required: Yes
- Type: string

### Parameter: `networkAcls.resourceAccessRules.tenantId`

The ID of the tenant in which the resource resides in.

- Required: Yes
- Type: string

### Parameter: `networkAcls.virtualNetworkRules`

Sets the virtual network rules.

- Required: No
- Type: array

### Parameter: `objectReplicationPolicies`

Object replication policies for the storage account.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationStorageAccountResourceId`](#parameter-objectreplicationpoliciesdestinationstorageaccountresourceid) | string | The resource ID of the destination storage account. |
| [`rules`](#parameter-objectreplicationpoliciesrules) | array | The storage account object replication rules. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableMetrics`](#parameter-objectreplicationpoliciesenablemetrics) | bool | Indicates whether metrics are enabled for the object replication policy. |
| [`name`](#parameter-objectreplicationpoliciesname) | string | The name of the object replication policy. If not provided, a GUID will be generated. |

### Parameter: `objectReplicationPolicies.destinationStorageAccountResourceId`

The resource ID of the destination storage account.

- Required: Yes
- Type: string

### Parameter: `objectReplicationPolicies.rules`

The storage account object replication rules.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerName`](#parameter-objectreplicationpoliciesrulescontainername) | string | The name of the source container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationContainerName`](#parameter-objectreplicationpoliciesrulesdestinationcontainername) | string | The name of the destination container. If not provided, the same name as the source container will be used. |
| [`filters`](#parameter-objectreplicationpoliciesrulesfilters) | object | The filters for the object replication policy rule. |
| [`ruleId`](#parameter-objectreplicationpoliciesrulesruleid) | string | The ID of the rule. Auto-generated on destination account. Required for source account. |

### Parameter: `objectReplicationPolicies.rules.containerName`

The name of the source container.

- Required: Yes
- Type: string

### Parameter: `objectReplicationPolicies.rules.destinationContainerName`

The name of the destination container. If not provided, the same name as the source container will be used.

- Required: No
- Type: string

### Parameter: `objectReplicationPolicies.rules.filters`

The filters for the object replication policy rule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minCreationTime`](#parameter-objectreplicationpoliciesrulesfiltersmincreationtime) | string | The minimum creation time to match for the replication policy rule. |
| [`prefixMatch`](#parameter-objectreplicationpoliciesrulesfiltersprefixmatch) | array | The prefix to match for the replication policy rule. |

### Parameter: `objectReplicationPolicies.rules.filters.minCreationTime`

The minimum creation time to match for the replication policy rule.

- Required: No
- Type: string

### Parameter: `objectReplicationPolicies.rules.filters.prefixMatch`

The prefix to match for the replication policy rule.

- Required: No
- Type: array

### Parameter: `objectReplicationPolicies.rules.ruleId`

The ID of the rule. Auto-generated on destination account. Required for source account.

- Required: No
- Type: string

### Parameter: `objectReplicationPolicies.enableMetrics`

Indicates whether metrics are enabled for the object replication policy.

- Required: No
- Type: bool

### Parameter: `objectReplicationPolicies.name`

The name of the object replication policy. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints. |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

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

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

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

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'SecuredByPerimeter'
  ]
  ```

### Parameter: `queueServices`

Queue service and queues to create.

- Required: No
- Type: object
- Default: `{}`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsRules`](#parameter-queueservicescorsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`diagnosticSettings`](#parameter-queueservicesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`queues`](#parameter-queueservicesqueues) | array | Queues to create. |

### Parameter: `queueServices.corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedHeaders`](#parameter-queueservicescorsrulesallowedheaders) | array | A list of headers allowed to be part of the cross-origin request. |
| [`allowedMethods`](#parameter-queueservicescorsrulesallowedmethods) | array | A list of HTTP methods that are allowed to be executed by the origin. |
| [`allowedOrigins`](#parameter-queueservicescorsrulesallowedorigins) | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains. |
| [`exposedHeaders`](#parameter-queueservicescorsrulesexposedheaders) | array | A list of response headers to expose to CORS clients. |
| [`maxAgeInSeconds`](#parameter-queueservicescorsrulesmaxageinseconds) | int | The number of seconds that the client/browser should cache a preflight response. |

### Parameter: `queueServices.corsRules.allowedHeaders`

A list of headers allowed to be part of the cross-origin request.

- Required: Yes
- Type: array

### Parameter: `queueServices.corsRules.allowedMethods`

A list of HTTP methods that are allowed to be executed by the origin.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'CONNECT'
    'DELETE'
    'GET'
    'HEAD'
    'MERGE'
    'OPTIONS'
    'PATCH'
    'POST'
    'PUT'
    'TRACE'
  ]
  ```

### Parameter: `queueServices.corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array

### Parameter: `queueServices.corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array

### Parameter: `queueServices.corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int

### Parameter: `queueServices.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-queueservicesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-queueservicesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-queueservicesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-queueservicesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-queueservicesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-queueservicesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-queueservicesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-queueservicesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-queueservicesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `queueServices.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `queueServices.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-queueservicesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-queueservicesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-queueservicesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `queueServices.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `queueServices.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-queueservicesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-queueservicesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `queueServices.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `queueServices.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `queueServices.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `queueServices.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `queueServices.queues`

Queues to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-queueservicesqueuesname) | string | The name of the queue. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-queueservicesqueuesmetadata) | object | Metadata to set on the queue. |
| [`roleAssignments`](#parameter-queueservicesqueuesroleassignments) | array | Array of role assignments to create. |

### Parameter: `queueServices.queues.name`

The name of the queue.

- Required: Yes
- Type: string

### Parameter: `queueServices.queues.metadata`

Metadata to set on the queue.

- Required: No
- Type: object

### Parameter: `queueServices.queues.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-queueservicesqueuesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-queueservicesqueuesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-queueservicesqueuesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-queueservicesqueuesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-queueservicesqueuesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-queueservicesqueuesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-queueservicesqueuesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-queueservicesqueuesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `queueServices.queues.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `queueServices.queues.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `queueServices.queues.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `queueServices.queues.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `queueServices.queues.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `queueServices.queues.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `queueServices.queues.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `queueServices.queues.roleAssignments.principalType`

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

### Parameter: `requireInfrastructureEncryption`

A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Reader and Data Access'`
  - `'Role Based Access Control Administrator'`
  - `'Storage Account Backup Contributor'`
  - `'Storage Account Contributor'`
  - `'Storage Account Key Operator Service Role'`
  - `'Storage Blob Data Contributor'`
  - `'Storage Blob Data Owner'`
  - `'Storage Blob Data Reader'`
  - `'Storage Blob Delegator'`
  - `'Storage File Data Privileged Contributor'`
  - `'Storage File Data Privileged Reader'`
  - `'Storage File Data SMB Share Contributor'`
  - `'Storage File Data SMB Share Elevated Contributor'`
  - `'Storage File Data SMB Share Reader'`
  - `'Storage Queue Data Contributor'`
  - `'Storage Queue Data Message Processor'`
  - `'Storage Queue Data Message Sender'`
  - `'Storage Queue Data Reader'`
  - `'Storage Table Data Contributor'`
  - `'Storage Table Data Reader'`
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

### Parameter: `sasExpirationAction`

The SAS expiration action. Allowed values are Block and Log.

- Required: No
- Type: string
- Default: `'Log'`
- Allowed:
  ```Bicep
  [
    'Block'
    'Log'
  ]
  ```

### Parameter: `sasExpirationPeriod`

The SAS expiration period. DD.HH:MM:SS.

- Required: No
- Type: string
- Default: `''`

### Parameter: `secretsExportConfiguration`

Key vault reference and secret settings for the module's secrets export.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultResourceId`](#parameter-secretsexportconfigurationkeyvaultresourceid) | string | The key vault name where to store the keys and connection strings generated by the modules. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKey1Name`](#parameter-secretsexportconfigurationaccesskey1name) | string | The accessKey1 secret name to create. |
| [`accessKey2Name`](#parameter-secretsexportconfigurationaccesskey2name) | string | The accessKey2 secret name to create. |
| [`connectionString1Name`](#parameter-secretsexportconfigurationconnectionstring1name) | string | The connectionString1 secret name to create. |
| [`connectionString2Name`](#parameter-secretsexportconfigurationconnectionstring2name) | string | The connectionString2 secret name to create. |

### Parameter: `secretsExportConfiguration.keyVaultResourceId`

The key vault name where to store the keys and connection strings generated by the modules.

- Required: Yes
- Type: string

### Parameter: `secretsExportConfiguration.accessKey1Name`

The accessKey1 secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.accessKey2Name`

The accessKey2 secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.connectionString1Name`

The connectionString1 secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.connectionString2Name`

The connectionString2 secret name to create.

- Required: No
- Type: string

### Parameter: `skuName`

Storage Account Sku Name - note: certain V2 SKUs require the use of: kind = FileStorage.

- Required: No
- Type: string
- Default: `'Standard_GRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'PremiumV2_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
    'StandardV2_GRS'
    'StandardV2_GZRS'
    'StandardV2_LRS'
    'StandardV2_ZRS'
  ]
  ```

### Parameter: `supportsHttpsTrafficOnly`

Allows HTTPS traffic only to storage service if sets to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tableServices`

Table service and tables to create.

- Required: No
- Type: object
- Default: `{}`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsRules`](#parameter-tableservicescorsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`diagnosticSettings`](#parameter-tableservicesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`tables`](#parameter-tableservicestables) | array | Tables to create. |

### Parameter: `tableServices.corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedHeaders`](#parameter-tableservicescorsrulesallowedheaders) | array | A list of headers allowed to be part of the cross-origin request. |
| [`allowedMethods`](#parameter-tableservicescorsrulesallowedmethods) | array | A list of HTTP methods that are allowed to be executed by the origin. |
| [`allowedOrigins`](#parameter-tableservicescorsrulesallowedorigins) | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains. |
| [`exposedHeaders`](#parameter-tableservicescorsrulesexposedheaders) | array | A list of response headers to expose to CORS clients. |
| [`maxAgeInSeconds`](#parameter-tableservicescorsrulesmaxageinseconds) | int | The number of seconds that the client/browser should cache a preflight response. |

### Parameter: `tableServices.corsRules.allowedHeaders`

A list of headers allowed to be part of the cross-origin request.

- Required: Yes
- Type: array

### Parameter: `tableServices.corsRules.allowedMethods`

A list of HTTP methods that are allowed to be executed by the origin.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'CONNECT'
    'DELETE'
    'GET'
    'HEAD'
    'MERGE'
    'OPTIONS'
    'PATCH'
    'POST'
    'PUT'
    'TRACE'
  ]
  ```

### Parameter: `tableServices.corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array

### Parameter: `tableServices.corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array

### Parameter: `tableServices.corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int

### Parameter: `tableServices.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-tableservicesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-tableservicesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-tableservicesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-tableservicesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-tableservicesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-tableservicesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-tableservicesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-tableservicesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-tableservicesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `tableServices.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `tableServices.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-tableservicesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-tableservicesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-tableservicesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `tableServices.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `tableServices.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-tableservicesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-tableservicesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `tableServices.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `tableServices.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `tableServices.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `tableServices.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `tableServices.tables`

Tables to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-tableservicestablesname) | string | The name of the table. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleAssignments`](#parameter-tableservicestablesroleassignments) | array | Array of role assignments to create. |

### Parameter: `tableServices.tables.name`

The name of the table.

- Required: Yes
- Type: string

### Parameter: `tableServices.tables.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Reader and Data Access'`
  - `'Role Based Access Control Administrator'`
  - `'Storage Account Backup Contributor'`
  - `'Storage Account Contributor'`
  - `'Storage Account Key Operator Service Role'`
  - `'Storage Blob Data Contributor'`
  - `'Storage Blob Data Owner'`
  - `'Storage Blob Data Reader'`
  - `'Storage Blob Delegator'`
  - `'Storage File Data Privileged Contributor'`
  - `'Storage File Data Privileged Reader'`
  - `'Storage File Data SMB Share Contributor'`
  - `'Storage File Data SMB Share Elevated Contributor'`
  - `'Storage File Data SMB Share Reader'`
  - `'Storage Queue Data Contributor'`
  - `'Storage Queue Data Message Processor'`
  - `'Storage Queue Data Message Sender'`
  - `'Storage Queue Data Reader'`
  - `'Storage Table Data Contributor'`
  - `'Storage Table Data Reader'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-tableservicestablesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-tableservicestablesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-tableservicestablesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-tableservicestablesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-tableservicestablesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-tableservicestablesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-tableservicestablesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-tableservicestablesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `tableServices.tables.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `tableServices.tables.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `tableServices.tables.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `tableServices.tables.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `tableServices.tables.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `tableServices.tables.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `tableServices.tables.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `tableServices.tables.roleAssignments.principalType`

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

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `exportedSecrets` |  | A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret's name. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed storage account. |
| `primaryAccessKey` | securestring | The primary access key of the storage account. |
| `primaryBlobEndpoint` | string | The primary blob endpoint reference if blob services are deployed. |
| `primaryConnectionString` | securestring | The primary connection string of the storage account. |
| `privateEndpoints` | array | The private endpoints of the Storage Account. |
| `resourceGroupName` | string | The resource group of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `secondaryAccessKey` | securestring | The secondary access key of the storage account. |
| `secondaryConnectionString` | securestring | The secondary connection string of the storage account. |
| `serviceEndpoints` | object | All service endpoints of the deployed storage account, Note Standard_LRS and Standard_ZRS accounts only have a blob service endpoint. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
