# Azure NetApp Files `[Microsoft.NetApp/netAppAccounts]`

This module deploys an Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts) |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupPolicies) |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults/backups) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools/volumes) |
| `Microsoft.NetApp/netAppAccounts/snapshotPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/snapshotPolicies) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/net-app/net-app-account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Using nfs31 parameter set](#example-3-using-nfs31-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account:<version>' = {
  name: 'netAppAccountDeployment'
  params: {
    // Required parameters
    name: 'nanaamin001'
    // Non-required parameters
    location: '<location>'
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
      "value": "nanaamin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/net-app/net-app-account:<version>'

// Required parameters
param name = 'nanaamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account:<version>' = {
  name: 'netAppAccountDeployment'
  params: {
    // Required parameters
    name: 'nanaamax001'
    // Non-required parameters
    capacityPools: [
      {
        name: 'nanaamax-cp-001'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaamax-vol-001'
            networkFeatures: 'Standard'
            protocolTypes: [
              'NFSv4.1'
            ]
            roleAssignments: [
              {
                principalId: '<principalId>'
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'Reader'
              }
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
            zones: [
              1
            ]
          }
          {
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaamax-vol-002'
            networkFeatures: 'Standard'
            protocolTypes: [
              'NFSv4.1'
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
            zones: [
              1
            ]
          }
        ]
      }
      {
        name: 'nanaamax-cp-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: '18051111-2a33-4f8e-8b24-441aac1e6562'
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
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
      "value": "nanaamax001"
    },
    // Non-required parameters
    "capacityPools": {
      "value": [
        {
          "name": "nanaamax-cp-001",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": [
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": false,
                  "nfsv41": true,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaamax-vol-001",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv4.1"
              ],
              "roleAssignments": [
                {
                  "principalId": "<principalId>",
                  "principalType": "ServicePrincipal",
                  "roleDefinitionIdOrName": "Reader"
                }
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400,
              "zones": [
                1
              ]
            },
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": false,
                  "nfsv41": true,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaamax-vol-002",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv4.1"
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400,
              "zones": [
                1
              ]
            }
          ]
        },
        {
          "name": "nanaamax-cp-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": []
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "18051111-2a33-4f8e-8b24-441aac1e6562",
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
        "Contact": "test.user@testcompany.com",
        "CostCenter": "7890",
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "PurchaseOrder": "1234",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
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
using 'br/public:avm/res/net-app/net-app-account:<version>'

// Required parameters
param name = 'nanaamax001'
// Non-required parameters
param capacityPools = [
  {
    name: 'nanaamax-cp-001'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 4398046511104
    volumes: [
      {
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicyRules: [
          {
            allowedClients: '0.0.0.0/0'
            nfsv3: false
            nfsv41: true
            ruleIndex: 1
            unixReadOnly: false
            unixReadWrite: true
          }
        ]
        name: 'nanaamax-vol-001'
        networkFeatures: 'Standard'
        protocolTypes: [
          'NFSv4.1'
        ]
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
        usageThreshold: 107374182400
        zones: [
          1
        ]
      }
      {
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicyRules: [
          {
            allowedClients: '0.0.0.0/0'
            nfsv3: false
            nfsv41: true
            ruleIndex: 1
            unixReadOnly: false
            unixReadWrite: true
          }
        ]
        name: 'nanaamax-vol-002'
        networkFeatures: 'Standard'
        protocolTypes: [
          'NFSv4.1'
        ]
        subnetResourceId: '<subnetResourceId>'
        usageThreshold: 107374182400
        zones: [
          1
        ]
      }
    ]
  }
  {
    name: 'nanaamax-cp-002'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 4398046511104
    volumes: []
  }
]
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    name: '18051111-2a33-4f8e-8b24-441aac1e6562'
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
  Contact: 'test.user@testcompany.com'
  CostCenter: '7890'
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  PurchaseOrder: '1234'
  Role: 'DeploymentValidation'
  ServiceName: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _Using nfs31 parameter set_

This instance deploys the module with nfs31.


<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account:<version>' = {
  name: 'netAppAccountDeployment'
  params: {
    // Required parameters
    name: 'nanaanfs3001'
    // Non-required parameters
    capacityPools: [
      {
        name: 'nanaanfs3-cp-001'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: true
                nfsv41: false
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaanfs3-vol-001'
            networkFeatures: 'Standard'
            protocolTypes: [
              'NFSv3'
            ]
            roleAssignments: [
              {
                principalId: '<principalId>'
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'Reader'
              }
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
          {
            encryptionKeySource: '<encryptionKeySource>'
            name: 'nanaanfs3-vol-002'
            networkFeatures: 'Standard'
            protocolTypes: [
              'NFSv3'
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
        ]
      }
      {
        name: 'nanaanfs3-cp-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
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
    tags: {
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
      "value": "nanaanfs3001"
    },
    // Non-required parameters
    "capacityPools": {
      "value": [
        {
          "name": "nanaanfs3-cp-001",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": [
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": true,
                  "nfsv41": false,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaanfs3-vol-001",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv3"
              ],
              "roleAssignments": [
                {
                  "principalId": "<principalId>",
                  "principalType": "ServicePrincipal",
                  "roleDefinitionIdOrName": "Reader"
                }
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            },
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "name": "nanaanfs3-vol-002",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv3"
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            }
          ]
        },
        {
          "name": "nanaanfs3-cp-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": []
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
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
    },
    "tags": {
      "value": {
        "Contact": "test.user@testcompany.com",
        "CostCenter": "7890",
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "PurchaseOrder": "1234",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
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
using 'br/public:avm/res/net-app/net-app-account:<version>'

// Required parameters
param name = 'nanaanfs3001'
// Non-required parameters
param capacityPools = [
  {
    name: 'nanaanfs3-cp-001'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 4398046511104
    volumes: [
      {
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicyRules: [
          {
            allowedClients: '0.0.0.0/0'
            nfsv3: true
            nfsv41: false
            ruleIndex: 1
            unixReadOnly: false
            unixReadWrite: true
          }
        ]
        name: 'nanaanfs3-vol-001'
        networkFeatures: 'Standard'
        protocolTypes: [
          'NFSv3'
        ]
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
        usageThreshold: 107374182400
      }
      {
        encryptionKeySource: '<encryptionKeySource>'
        name: 'nanaanfs3-vol-002'
        networkFeatures: 'Standard'
        protocolTypes: [
          'NFSv3'
        ]
        subnetResourceId: '<subnetResourceId>'
        usageThreshold: 107374182400
      }
    ]
  }
  {
    name: 'nanaanfs3-cp-002'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 4398046511104
    volumes: []
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
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
param tags = {
  Contact: 'test.user@testcompany.com'
  CostCenter: '7890'
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  PurchaseOrder: '1234'
  Role: 'DeploymentValidation'
  ServiceName: 'DeploymentValidation'
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account:<version>' = {
  name: 'netAppAccountDeployment'
  params: {
    // Required parameters
    name: 'nanaawaf001'
    // Non-required parameters
    location: '<location>'
    tags: {
      service: 'netapp'
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
      "value": "nanaawaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "service": "netapp"
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
using 'br/public:avm/res/net-app/net-app-account:<version>'

// Required parameters
param name = 'nanaawaf001'
// Non-required parameters
param location = '<location>'
param tags = {
  service: 'netapp'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the NetApp account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adName`](#parameter-adname) | string | Name of the active directory host as part of Kerberos Realm used for Kerberos authentication. |
| [`aesEncryption`](#parameter-aesencryption) | bool | Enable AES encryption on the SMB Server. |
| [`backupPolicies`](#parameter-backuppolicies) | array | The backup policies to create. |
| [`backupVault`](#parameter-backupvault) | object | The netapp backup vault to create & configure. |
| [`capacityPools`](#parameter-capacitypools) | array | Capacity pools to create. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`dnsServers`](#parameter-dnsservers) | string | Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed. |
| [`domainJoinOU`](#parameter-domainjoinou) | string | Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. 'OU=SecondLevel,OU=FirstLevel'). |
| [`domainJoinPassword`](#parameter-domainjoinpassword) | securestring | Required if domainName is specified. Password of the user specified in domainJoinUser parameter. |
| [`domainJoinUser`](#parameter-domainjoinuser) | string | Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain. |
| [`domainName`](#parameter-domainname) | string | Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com'). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptDCConnections`](#parameter-encryptdcconnections) | bool | Specifies whether encryption should be used for communication between SMB server and domain controller (DC). SMB3 only. |
| [`kdcIP`](#parameter-kdcip) | string | Kerberos Key Distribution Center (KDC) as part of Kerberos Realm used for Kerberos authentication. |
| [`ldapOverTLS`](#parameter-ldapovertls) | bool | Specifies whether to use TLS when NFS (with/without Kerberos) and SMB volumes communicate with an LDAP server. A server root CA certificate must be uploaded if enabled (serverRootCACertificate). |
| [`ldapSigning`](#parameter-ldapsigning) | bool | Specifies whether or not the LDAP traffic needs to be signed. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serverRootCACertificate`](#parameter-serverrootcacertificate) | string | A server Root certificate is required of ldapOverTLS is enabled. |
| [`smbServerNamePrefix`](#parameter-smbservernameprefix) | string | Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes. |
| [`snapshotPolicies`](#parameter-snapshotpolicies) | array | The snapshot policies to create. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `name`

The name of the NetApp account.

- Required: Yes
- Type: string

### Parameter: `adName`

Name of the active directory host as part of Kerberos Realm used for Kerberos authentication.

- Required: No
- Type: string
- Default: `''`

### Parameter: `aesEncryption`

Enable AES encryption on the SMB Server.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `backupPolicies`

The backup policies to create.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyBackupsToKeep`](#parameter-backuppoliciesdailybackupstokeep) | int | The daily backups to keep. |
| [`enabled`](#parameter-backuppoliciesenabled) | bool | Indicates whether the backup policy is enabled. |
| [`location`](#parameter-backuppolicieslocation) | string | The location of the backup policy. |
| [`monthlyBackupsToKeep`](#parameter-backuppoliciesmonthlybackupstokeep) | int | The monthly backups to keep. |
| [`name`](#parameter-backuppoliciesname) | string | The name of the backup policy. |
| [`weeklyBackupsToKeep`](#parameter-backuppoliciesweeklybackupstokeep) | int | The weekly backups to keep. |

### Parameter: `backupPolicies.dailyBackupsToKeep`

The daily backups to keep.

- Required: No
- Type: int

### Parameter: `backupPolicies.enabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool

### Parameter: `backupPolicies.location`

The location of the backup policy.

- Required: No
- Type: string

### Parameter: `backupPolicies.monthlyBackupsToKeep`

The monthly backups to keep.

- Required: No
- Type: int

### Parameter: `backupPolicies.name`

The name of the backup policy.

- Required: No
- Type: string

### Parameter: `backupPolicies.weeklyBackupsToKeep`

The weekly backups to keep.

- Required: No
- Type: int

### Parameter: `backupVault`

The netapp backup vault to create & configure.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backups`](#parameter-backupvaultbackups) | array | The list of backups to create. |
| [`location`](#parameter-backupvaultlocation) | string | Location of the backup vault. |
| [`name`](#parameter-backupvaultname) | string | The name of the backup vault. |

### Parameter: `backupVault.backups`

The list of backups to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`volumeResourceId`](#parameter-backupvaultbackupsvolumeresourceid) | string | ResourceId used to identify the Volume. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`label`](#parameter-backupvaultbackupslabel) | string | Label for backup. |
| [`name`](#parameter-backupvaultbackupsname) | string | The name of the backup. |
| [`snapshotName`](#parameter-backupvaultbackupssnapshotname) | string | The name of the snapshot. |
| [`useExistingSnapshot`](#parameter-backupvaultbackupsuseexistingsnapshot) | bool | Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups. |

### Parameter: `backupVault.backups.volumeResourceId`

ResourceId used to identify the Volume.

- Required: Yes
- Type: string

### Parameter: `backupVault.backups.label`

Label for backup.

- Required: No
- Type: string

### Parameter: `backupVault.backups.name`

The name of the backup.

- Required: No
- Type: string

### Parameter: `backupVault.backups.snapshotName`

The name of the snapshot.

- Required: No
- Type: string

### Parameter: `backupVault.backups.useExistingSnapshot`

Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups.

- Required: No
- Type: bool

### Parameter: `backupVault.location`

Location of the backup vault.

- Required: No
- Type: string

### Parameter: `backupVault.name`

The name of the backup vault.

- Required: No
- Type: string

### Parameter: `capacityPools`

Capacity pools to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-capacitypoolsname) | string | The name of the capacity pool. |
| [`size`](#parameter-capacitypoolssize) | int | Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-capacitypoolscoolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`encryptionType`](#parameter-capacitypoolsencryptiontype) | string | Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool. |
| [`location`](#parameter-capacitypoolslocation) | string | Location of the pool volume. |
| [`qosType`](#parameter-capacitypoolsqostype) | string | The qos type of the pool. |
| [`roleAssignments`](#parameter-capacitypoolsroleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-capacitypoolsservicelevel) | string | The pool service level. |
| [`tags`](#parameter-capacitypoolstags) | object | Tags for the capcity pool. |
| [`volumes`](#parameter-capacitypoolsvolumes) | array | List of volumnes to create in the capacity pool. |

### Parameter: `capacityPools.name`

The name of the capacity pool.

- Required: Yes
- Type: string

### Parameter: `capacityPools.size`

Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104).

- Required: Yes
- Type: int

### Parameter: `capacityPools.coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: No
- Type: bool

### Parameter: `capacityPools.encryptionType`

Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Double'
    'Single'
  ]
  ```

### Parameter: `capacityPools.location`

Location of the pool volume.

- Required: No
- Type: string

### Parameter: `capacityPools.qosType`

The qos type of the pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Auto'
    'Manual'
  ]
  ```

### Parameter: `capacityPools.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-capacitypoolsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-capacitypoolsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-capacitypoolsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-capacitypoolsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-capacitypoolsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-capacitypoolsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-capacitypoolsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-capacitypoolsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `capacityPools.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `capacityPools.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `capacityPools.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `capacityPools.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `capacityPools.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `capacityPools.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `capacityPools.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `capacityPools.roleAssignments.principalType`

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

### Parameter: `capacityPools.serviceLevel`

The pool service level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardZRS'
    'Ultra'
  ]
  ```

### Parameter: `capacityPools.tags`

Tags for the capcity pool.

- Required: No
- Type: object

### Parameter: `capacityPools.volumes`

List of volumnes to create in the capacity pool.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-capacitypoolsvolumesname) | string | The name of the pool volume. |
| [`replicationSchedule`](#parameter-capacitypoolsvolumesreplicationschedule) | string | The replication schedule for the volume. |
| [`subnetResourceId`](#parameter-capacitypoolsvolumessubnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-capacitypoolsvolumesusagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-capacitypoolsvolumesbackuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultResourceId`](#parameter-capacitypoolsvolumesbackupvaultresourceid) | string | The resource Id of the Backup Vault. |
| [`coolAccess`](#parameter-capacitypoolsvolumescoolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolAccessRetrievalPolicy`](#parameter-capacitypoolsvolumescoolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-capacitypoolsvolumescoolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-capacitypoolsvolumescreationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`encryptionKeySource`](#parameter-capacitypoolsvolumesencryptionkeysource) | string | The source of the encryption key. |
| [`endpointType`](#parameter-capacitypoolsvolumesendpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication (src/dst). |
| [`exportPolicyRules`](#parameter-capacitypoolsvolumesexportpolicyrules) | array | Export policy rules. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-capacitypoolsvolumeskeyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-capacitypoolsvolumeslocation) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-capacitypoolsvolumesnetworkfeatures) | string | Network feature for the volume. |
| [`policyEnforced`](#parameter-capacitypoolsvolumespolicyenforced) | bool | If Backup policy is enforced. |
| [`protocolTypes`](#parameter-capacitypoolsvolumesprotocoltypes) | array | Set of protocol types. |
| [`remoteVolumeRegion`](#parameter-capacitypoolsvolumesremotevolumeregion) | string | The remote region for the other end of the Volume Replication. |
| [`remoteVolumeResourceId`](#parameter-capacitypoolsvolumesremotevolumeresourceid) | string | The resource ID of the remote volume. |
| [`replicationEnabled`](#parameter-capacitypoolsvolumesreplicationenabled) | bool | Boolean to enable replication. |
| [`roleAssignments`](#parameter-capacitypoolsvolumesroleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-capacitypoolsvolumesservicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`snapshotPolicyName`](#parameter-capacitypoolsvolumessnapshotpolicyname) | string | The name of the snapshot policy to link. |
| [`volumeType`](#parameter-capacitypoolsvolumesvolumetype) | string | The type of the volume. DataProtection volumes are used for replication. |
| [`zones`](#parameter-capacitypoolsvolumeszones) | array | Zone where the volume will be placed. |

### Parameter: `capacityPools.volumes.name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.replicationSchedule`

The replication schedule for the volume.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `capacityPools.volumes.backupPolicyName`

The name of the backup policy to link.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.backupVaultResourceId`

The resource Id of the Backup Vault.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.coolAccessRetrievalPolicy`

Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.coolnessPeriod`

Specifies the number of days after which data that is not accessed by clients will be tiered.

- Required: No
- Type: int

### Parameter: `capacityPools.volumes.creationToken`

A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.encryptionKeySource`

The source of the encryption key.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.exportPolicyRules`

Export policy rules.

- Required: No
- Type: array

### Parameter: `capacityPools.volumes.keyVaultPrivateEndpointResourceId`

The resource ID of the key vault private endpoint.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.location`

Location of the pool volume.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.networkFeatures`

Network feature for the volume.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Basic_Standard'
    'Standard'
    'Standard_Basic'
  ]
  ```

### Parameter: `capacityPools.volumes.policyEnforced`

If Backup policy is enforced.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.protocolTypes`

Set of protocol types.

- Required: No
- Type: array

### Parameter: `capacityPools.volumes.remoteVolumeRegion`

The remote region for the other end of the Volume Replication.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.remoteVolumeResourceId`

The resource ID of the remote volume.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.replicationEnabled`

Boolean to enable replication.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-capacitypoolsvolumesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-capacitypoolsvolumesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-capacitypoolsvolumesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-capacitypoolsvolumesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-capacitypoolsvolumesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-capacitypoolsvolumesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-capacitypoolsvolumesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-capacitypoolsvolumesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `capacityPools.volumes.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `capacityPools.volumes.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.roleAssignments.principalType`

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

### Parameter: `capacityPools.volumes.serviceLevel`

The pool service level. Must match the one of the parent capacity pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardZRS'
    'Ultra'
  ]
  ```

### Parameter: `capacityPools.volumes.snapshotPolicyName`

The name of the snapshot policy to link.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.zones`

Zone where the volume will be placed.

- Required: No
- Type: array

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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `dnsServers`

Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.

- Required: No
- Type: string
- Default: `''`

### Parameter: `domainJoinOU`

Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. 'OU=SecondLevel,OU=FirstLevel').

- Required: No
- Type: string
- Default: `''`

### Parameter: `domainJoinPassword`

Required if domainName is specified. Password of the user specified in domainJoinUser parameter.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `domainJoinUser`

Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.

- Required: No
- Type: string
- Default: `''`

### Parameter: `domainName`

Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com').

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptDCConnections`

Specifies whether encryption should be used for communication between SMB server and domain controller (DC). SMB3 only.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kdcIP`

Kerberos Key Distribution Center (KDC) as part of Kerberos Realm used for Kerberos authentication.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ldapOverTLS`

Specifies whether to use TLS when NFS (with/without Kerberos) and SMB volumes communicate with an LDAP server. A server root CA certificate must be uploaded if enabled (serverRootCACertificate).

- Required: No
- Type: bool
- Default: `False`

### Parameter: `ldapSigning`

Specifies whether or not the LDAP traffic needs to be signed.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

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

### Parameter: `serverRootCACertificate`

A server Root certificate is required of ldapOverTLS is enabled.

- Required: No
- Type: string
- Default: `''`

### Parameter: `smbServerNamePrefix`

Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes.

- Required: No
- Type: string
- Default: `''`

### Parameter: `snapshotPolicies`

The snapshot policies to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-snapshotpoliciesname) | string | The name of the snapshot policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailySchedule`](#parameter-snapshotpoliciesdailyschedule) | object | Daily schedule for the snapshot policy. |
| [`hourlySchedule`](#parameter-snapshotpolicieshourlyschedule) | object | Hourly schedule for the snapshot policy. |
| [`location`](#parameter-snapshotpolicieslocation) | string | Location of the snapshot policy. |
| [`monthlySchedule`](#parameter-snapshotpoliciesmonthlyschedule) | object | Monthly schedule for the snapshot policy. |
| [`weeklySchedule`](#parameter-snapshotpoliciesweeklyschedule) | object | Weekly schedule for the snapshot policy. |

### Parameter: `snapshotPolicies.name`

The name of the snapshot policy.

- Required: Yes
- Type: string

### Parameter: `snapshotPolicies.dailySchedule`

Daily schedule for the snapshot policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hour`](#parameter-snapshotpoliciesdailyschedulehour) | int | The daily snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesdailyscheduleminute) | int | The daily snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesdailyschedulesnapshotstokeep) | int | Daily snapshot count to keep. |
| [`usedBytes`](#parameter-snapshotpoliciesdailyscheduleusedbytes) | int | Daily snapshot used bytes. |

### Parameter: `snapshotPolicies.dailySchedule.hour`

The daily snapshot hour.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.dailySchedule.minute`

The daily snapshot minute.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.dailySchedule.snapshotsToKeep`

Daily snapshot count to keep.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.dailySchedule.usedBytes`

Daily snapshot used bytes.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.hourlySchedule`

Hourly schedule for the snapshot policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-snapshotpolicieshourlyscheduleminute) | int | The hourly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpolicieshourlyschedulesnapshotstokeep) | int | Hourly snapshot count to keep. |
| [`usedBytes`](#parameter-snapshotpolicieshourlyscheduleusedbytes) | int | Hourly snapshot used bytes. |

### Parameter: `snapshotPolicies.hourlySchedule.minute`

The hourly snapshot minute.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.hourlySchedule.snapshotsToKeep`

Hourly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.hourlySchedule.usedBytes`

Hourly snapshot used bytes.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.location`

Location of the snapshot policy.

- Required: No
- Type: string

### Parameter: `snapshotPolicies.monthlySchedule`

Monthly schedule for the snapshot policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`daysOfMonth`](#parameter-snapshotpoliciesmonthlyscheduledaysofmonth) | string | The monthly snapshot day. |
| [`hour`](#parameter-snapshotpoliciesmonthlyschedulehour) | int | The monthly snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesmonthlyscheduleminute) | int | The monthly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesmonthlyschedulesnapshotstokeep) | int | Monthly snapshot count to keep. |
| [`usedBytes`](#parameter-snapshotpoliciesmonthlyscheduleusedbytes) | int | Monthly snapshot used bytes. |

### Parameter: `snapshotPolicies.monthlySchedule.daysOfMonth`

The monthly snapshot day.

- Required: No
- Type: string

### Parameter: `snapshotPolicies.monthlySchedule.hour`

The monthly snapshot hour.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.monthlySchedule.minute`

The monthly snapshot minute.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.monthlySchedule.snapshotsToKeep`

Monthly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.monthlySchedule.usedBytes`

Monthly snapshot used bytes.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.weeklySchedule`

Weekly schedule for the snapshot policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`day`](#parameter-snapshotpoliciesweeklyscheduleday) | string | The weekly snapshot day. |
| [`hour`](#parameter-snapshotpoliciesweeklyschedulehour) | int | The weekly snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesweeklyscheduleminute) | int | The weekly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesweeklyschedulesnapshotstokeep) | int | Weekly snapshot count to keep. |
| [`usedBytes`](#parameter-snapshotpoliciesweeklyscheduleusedbytes) | int | Weekly snapshot used bytes. |

### Parameter: `snapshotPolicies.weeklySchedule.day`

The weekly snapshot day.

- Required: No
- Type: string

### Parameter: `snapshotPolicies.weeklySchedule.hour`

The weekly snapshot hour.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.weeklySchedule.minute`

The weekly snapshot minute.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.weeklySchedule.snapshotsToKeep`

Weekly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.weeklySchedule.usedBytes`

Weekly snapshot used bytes.

- Required: No
- Type: int

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the NetApp account. |
| `resourceGroupName` | string | The name of the Resource Group the NetApp account was created in. |
| `resourceId` | string | The Resource ID of the NetApp account. |
| `volumeResourceId` | string | The resource IDs of the volume created in the capacity pool. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
