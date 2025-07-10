# Azure NetApp Files `[Microsoft.NetApp/netAppAccounts]`

This module deploys an Azure NetApp Files Account and the associated resource types such as backups, capacity pools and volumes.

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
| `Microsoft.NetApp/netAppAccounts` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts) |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupPolicies) |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults/backups) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/capacityPools/volumes) |
| `Microsoft.NetApp/netAppAccounts/snapshotPolicies` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/snapshotPolicies) |

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
    backupPolicies: [
      {
        name: 'myBackupPolicy'
      }
    ]
    backupVault: {
      backups: [
        {
          capacityPoolName: 'cp-001'
          label: 'myLabel'
          name: 'myBackup01'
          volumeName: 'vol-001'
        }
      ]
      name: 'myVault'
    }
    capacityPools: [
      {
        name: 'cp-001'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 1
        volumes: [
          {
            dataProtection: {
              backup: {
                backupPolicyName: 'myBackupPolicy'
                backupVaultName: 'myVault'
                policyEnforced: false
              }
              snapshot: {
                snapshotPolicyName: 'mySnapshotPolicy'
              }
            }
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicy: {
              rules: [
                {
                  allowedClients: '0.0.0.0/0'
                  kerberos5iReadOnly: false
                  kerberos5iReadWrite: false
                  kerberos5pReadOnly: false
                  kerberos5pReadWrite: false
                  kerberos5ReadOnly: false
                  kerberos5ReadWrite: false
                  nfsv3: false
                  nfsv41: true
                  ruleIndex: 1
                  unixReadOnly: false
                  unixReadWrite: true
                }
              ]
            }
            name: 'vol-001'
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
            zone: 1
          }
          {
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicy: {
              rules: [
                {
                  allowedClients: '0.0.0.0/0'
                  kerberos5iReadOnly: false
                  kerberos5iReadWrite: false
                  kerberos5pReadOnly: false
                  kerberos5pReadWrite: false
                  kerberos5ReadOnly: false
                  kerberos5ReadWrite: false
                  nfsv3: false
                  nfsv41: true
                  ruleIndex: 1
                  unixReadOnly: false
                  unixReadWrite: false
                }
              ]
            }
            kerberosEnabled: false
            name: 'vol-002'
            networkFeatures: 'Standard'
            protocolTypes: [
              'NFSv4.1'
            ]
            smbContinuouslyAvailable: false
            smbEncryption: false
            smbNonBrowsable: 'Disabled'
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
            zone: 1
          }
        ]
      }
      {
        name: 'cp-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 1
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
    snapshotPolicies: [
      {
        dailySchedule: {
          hour: 0
          minute: 0
          snapshotsToKeep: 1
        }
        name: 'mySnapshotPolicy'
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
    "backupPolicies": {
      "value": [
        {
          "name": "myBackupPolicy"
        }
      ]
    },
    "backupVault": {
      "value": {
        "backups": [
          {
            "capacityPoolName": "cp-001",
            "label": "myLabel",
            "name": "myBackup01",
            "volumeName": "vol-001"
          }
        ],
        "name": "myVault"
      }
    },
    "capacityPools": {
      "value": [
        {
          "name": "cp-001",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 1,
          "volumes": [
            {
              "dataProtection": {
                "backup": {
                  "backupPolicyName": "myBackupPolicy",
                  "backupVaultName": "myVault",
                  "policyEnforced": false
                },
                "snapshot": {
                  "snapshotPolicyName": "mySnapshotPolicy"
                }
              },
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicy": {
                "rules": [
                  {
                    "allowedClients": "0.0.0.0/0",
                    "kerberos5iReadOnly": false,
                    "kerberos5iReadWrite": false,
                    "kerberos5pReadOnly": false,
                    "kerberos5pReadWrite": false,
                    "kerberos5ReadOnly": false,
                    "kerberos5ReadWrite": false,
                    "nfsv3": false,
                    "nfsv41": true,
                    "ruleIndex": 1,
                    "unixReadOnly": false,
                    "unixReadWrite": true
                  }
                ]
              },
              "name": "vol-001",
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
              "zone": 1
            },
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicy": {
                "rules": [
                  {
                    "allowedClients": "0.0.0.0/0",
                    "kerberos5iReadOnly": false,
                    "kerberos5iReadWrite": false,
                    "kerberos5pReadOnly": false,
                    "kerberos5pReadWrite": false,
                    "kerberos5ReadOnly": false,
                    "kerberos5ReadWrite": false,
                    "nfsv3": false,
                    "nfsv41": true,
                    "ruleIndex": 1,
                    "unixReadOnly": false,
                    "unixReadWrite": false
                  }
                ]
              },
              "kerberosEnabled": false,
              "name": "vol-002",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv4.1"
              ],
              "smbContinuouslyAvailable": false,
              "smbEncryption": false,
              "smbNonBrowsable": "Disabled",
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400,
              "zone": 1
            }
          ]
        },
        {
          "name": "cp-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 1,
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
    "snapshotPolicies": {
      "value": [
        {
          "dailySchedule": {
            "hour": 0,
            "minute": 0,
            "snapshotsToKeep": 1
          },
          "name": "mySnapshotPolicy"
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
param backupPolicies = [
  {
    name: 'myBackupPolicy'
  }
]
param backupVault = {
  backups: [
    {
      capacityPoolName: 'cp-001'
      label: 'myLabel'
      name: 'myBackup01'
      volumeName: 'vol-001'
    }
  ]
  name: 'myVault'
}
param capacityPools = [
  {
    name: 'cp-001'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 1
    volumes: [
      {
        dataProtection: {
          backup: {
            backupPolicyName: 'myBackupPolicy'
            backupVaultName: 'myVault'
            policyEnforced: false
          }
          snapshot: {
            snapshotPolicyName: 'mySnapshotPolicy'
          }
        }
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicy: {
          rules: [
            {
              allowedClients: '0.0.0.0/0'
              kerberos5iReadOnly: false
              kerberos5iReadWrite: false
              kerberos5pReadOnly: false
              kerberos5pReadWrite: false
              kerberos5ReadOnly: false
              kerberos5ReadWrite: false
              nfsv3: false
              nfsv41: true
              ruleIndex: 1
              unixReadOnly: false
              unixReadWrite: true
            }
          ]
        }
        name: 'vol-001'
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
        zone: 1
      }
      {
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicy: {
          rules: [
            {
              allowedClients: '0.0.0.0/0'
              kerberos5iReadOnly: false
              kerberos5iReadWrite: false
              kerberos5pReadOnly: false
              kerberos5pReadWrite: false
              kerberos5ReadOnly: false
              kerberos5ReadWrite: false
              nfsv3: false
              nfsv41: true
              ruleIndex: 1
              unixReadOnly: false
              unixReadWrite: false
            }
          ]
        }
        kerberosEnabled: false
        name: 'vol-002'
        networkFeatures: 'Standard'
        protocolTypes: [
          'NFSv4.1'
        ]
        smbContinuouslyAvailable: false
        smbEncryption: false
        smbNonBrowsable: 'Disabled'
        subnetResourceId: '<subnetResourceId>'
        usageThreshold: 107374182400
        zone: 1
      }
    ]
  }
  {
    name: 'cp-002'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceLevel: 'Premium'
    size: 1
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
param snapshotPolicies = [
  {
    dailySchedule: {
      hour: 0
      minute: 0
      snapshotsToKeep: 1
    }
    name: 'mySnapshotPolicy'
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
        size: 1
        volumes: [
          {
            encryptionKeySource: '<encryptionKeySource>'
            exportPolicy: {
              rules: [
                {
                  allowedClients: '0.0.0.0/0'
                  kerberos5iReadOnly: false
                  kerberos5iReadWrite: false
                  kerberos5pReadOnly: false
                  kerberos5pReadWrite: false
                  kerberos5ReadOnly: false
                  kerberos5ReadWrite: false
                  nfsv3: true
                  nfsv41: false
                  ruleIndex: 1
                  unixReadOnly: false
                  unixReadWrite: true
                }
              ]
            }
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
            zone: 1
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
            zone: 1
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
        size: 1
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
          "size": 1,
          "volumes": [
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "exportPolicy": {
                "rules": [
                  {
                    "allowedClients": "0.0.0.0/0",
                    "kerberos5iReadOnly": false,
                    "kerberos5iReadWrite": false,
                    "kerberos5pReadOnly": false,
                    "kerberos5pReadWrite": false,
                    "kerberos5ReadOnly": false,
                    "kerberos5ReadWrite": false,
                    "nfsv3": true,
                    "nfsv41": false,
                    "ruleIndex": 1,
                    "unixReadOnly": false,
                    "unixReadWrite": true
                  }
                ]
              },
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
              "usageThreshold": 107374182400,
              "zone": 1
            },
            {
              "encryptionKeySource": "<encryptionKeySource>",
              "name": "nanaanfs3-vol-002",
              "networkFeatures": "Standard",
              "protocolTypes": [
                "NFSv3"
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400,
              "zone": 1
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
          "size": 1,
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
    size: 1
    volumes: [
      {
        encryptionKeySource: '<encryptionKeySource>'
        exportPolicy: {
          rules: [
            {
              allowedClients: '0.0.0.0/0'
              kerberos5iReadOnly: false
              kerberos5iReadWrite: false
              kerberos5pReadOnly: false
              kerberos5pReadWrite: false
              kerberos5ReadOnly: false
              kerberos5ReadWrite: false
              nfsv3: true
              nfsv41: false
              ruleIndex: 1
              unixReadOnly: false
              unixReadWrite: true
            }
          ]
        }
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
        zone: 1
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
        zone: 1
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
    size: 1
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
| [`allowLocalNfsUsersWithLdap`](#parameter-allowlocalnfsuserswithldap) | bool | If enabled, NFS client local users can also (in addition to LDAP users) access the NFS volumes. |
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

### Parameter: `allowLocalNfsUsersWithLdap`

If enabled, NFS client local users can also (in addition to LDAP users) access the NFS volumes.

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
| [`dailyBackupsToKeep`](#parameter-backuppoliciesdailybackupstokeep) | int | The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`enabled`](#parameter-backuppoliciesenabled) | bool | Indicates whether the backup policy is enabled. |
| [`location`](#parameter-backuppolicieslocation) | string | The location of the backup policy. |
| [`monthlyBackupsToKeep`](#parameter-backuppoliciesmonthlybackupstokeep) | int | The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`name`](#parameter-backuppoliciesname) | string | The name of the backup policy. |
| [`weeklyBackupsToKeep`](#parameter-backuppoliciesweeklybackupstokeep) | int | The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |

### Parameter: `backupPolicies.dailyBackupsToKeep`

The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- MinValue: 2
- MaxValue: 1019

### Parameter: `backupPolicies.enabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool

### Parameter: `backupPolicies.location`

The location of the backup policy.

- Required: No
- Type: string

### Parameter: `backupPolicies.monthlyBackupsToKeep`

The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1019

### Parameter: `backupPolicies.name`

The name of the backup policy.

- Required: No
- Type: string

### Parameter: `backupPolicies.weeklyBackupsToKeep`

The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1019

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
| [`capacityPoolName`](#parameter-backupvaultbackupscapacitypoolname) | string | The name of the capacity pool containing the volume. |
| [`volumeName`](#parameter-backupvaultbackupsvolumename) | string | The name of the volume to backup. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`label`](#parameter-backupvaultbackupslabel) | string | Label for backup. |
| [`name`](#parameter-backupvaultbackupsname) | string | The name of the backup. |
| [`snapshotName`](#parameter-backupvaultbackupssnapshotname) | string | The name of the snapshot. |

### Parameter: `backupVault.backups.capacityPoolName`

The name of the capacity pool containing the volume.

- Required: Yes
- Type: string

### Parameter: `backupVault.backups.volumeName`

The name of the volume to backup.

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
| [`size`](#parameter-capacitypoolssize) | int | Provisioned size of the pool in Tebibytes (TiB). |

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
| [`volumes`](#parameter-capacitypoolsvolumes) | array | List of volumes to create in the capacity pool. |

### Parameter: `capacityPools.name`

The name of the capacity pool.

- Required: Yes
- Type: string

### Parameter: `capacityPools.size`

Provisioned size of the pool in Tebibytes (TiB).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 2048

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

List of volumes to create in the capacity pool.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-capacitypoolsvolumesname) | string | The name of the pool volume. |
| [`subnetResourceId`](#parameter-capacitypoolsvolumessubnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-capacitypoolsvolumesusagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |
| [`zone`](#parameter-capacitypoolsvolumeszone) | int | The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-capacitypoolsvolumescoolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolAccessRetrievalPolicy`](#parameter-capacitypoolsvolumescoolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-capacitypoolsvolumescoolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-capacitypoolsvolumescreationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`dataProtection`](#parameter-capacitypoolsvolumesdataprotection) | object | DataProtection type volumes include an object containing details of the replication. |
| [`encryptionKeySource`](#parameter-capacitypoolsvolumesencryptionkeysource) | string | The source of the encryption key. |
| [`exportPolicy`](#parameter-capacitypoolsvolumesexportpolicy) | object | Export policy rules. |
| [`kerberosEnabled`](#parameter-capacitypoolsvolumeskerberosenabled) | bool | Define if a volume is KerberosEnabled. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-capacitypoolsvolumeskeyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-capacitypoolsvolumeslocation) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-capacitypoolsvolumesnetworkfeatures) | string | Network feature for the volume. |
| [`protocolTypes`](#parameter-capacitypoolsvolumesprotocoltypes) | array | Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`. |
| [`roleAssignments`](#parameter-capacitypoolsvolumesroleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-capacitypoolsvolumesservicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`smbContinuouslyAvailable`](#parameter-capacitypoolsvolumessmbcontinuouslyavailable) | bool | Enables continuously available share property for SMB volume. Only applicable for SMB volume. |
| [`smbEncryption`](#parameter-capacitypoolsvolumessmbencryption) | bool | Enables SMB encryption. Only applicable for SMB/DualProtocol volume. |
| [`smbNonBrowsable`](#parameter-capacitypoolsvolumessmbnonbrowsable) | string | Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume. |
| [`throughputMibps`](#parameter-capacitypoolsvolumesthroughputmibps) | int | The throughput in MiBps for the NetApp account. |
| [`volumeType`](#parameter-capacitypoolsvolumesvolumetype) | string | The type of the volume. DataProtection volumes are used for replication. |

### Parameter: `capacityPools.volumes.name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `capacityPools.volumes.zone`

The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.

- Required: Yes
- Type: int

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

### Parameter: `capacityPools.volumes.dataProtection`

DataProtection type volumes include an object containing details of the replication.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backup`](#parameter-capacitypoolsvolumesdataprotectionbackup) | object | Backup properties. |
| [`replication`](#parameter-capacitypoolsvolumesdataprotectionreplication) | object | Replication properties. |
| [`snapshot`](#parameter-capacitypoolsvolumesdataprotectionsnapshot) | object | Snapshot properties. |

### Parameter: `capacityPools.volumes.dataProtection.backup`

Backup properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-capacitypoolsvolumesdataprotectionbackupbackuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultName`](#parameter-capacitypoolsvolumesdataprotectionbackupbackupvaultname) | string | The name of the Backup Vault. |
| [`policyEnforced`](#parameter-capacitypoolsvolumesdataprotectionbackuppolicyenforced) | bool | Enable to enforce the policy. |

### Parameter: `capacityPools.volumes.dataProtection.backup.backupPolicyName`

The name of the backup policy to link.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.backup.backupVaultName`

The name of the Backup Vault.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.backup.policyEnforced`

Enable to enforce the policy.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.dataProtection.replication`

Replication properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpointType`](#parameter-capacitypoolsvolumesdataprotectionreplicationendpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`remotePath`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotepath) | object | The full path to a volume that is to be migrated into ANF. Required for Migration volumes. |
| [`remoteVolumeRegion`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotevolumeregion) | string | The remote region for the other end of the Volume Replication.Required for Data Protection volumes. |
| [`remoteVolumeResourceId`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotevolumeresourceid) | string | The resource ID of the remote volume. Required for Data Protection volumes. |
| [`replicationSchedule`](#parameter-capacitypoolsvolumesdataprotectionreplicationreplicationschedule) | string | The replication schedule for the volume (to only be set on the destination (dst)). |

### Parameter: `capacityPools.volumes.dataProtection.replication.endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'dst'
    'src'
  ]
  ```

### Parameter: `capacityPools.volumes.dataProtection.replication.remotePath`

The full path to a volume that is to be migrated into ANF. Required for Migration volumes.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalHostName`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotepathexternalhostname) | string | The Path to a ONTAP Host. |
| [`serverName`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotepathservername) | string | The name of a server on the ONTAP Host. |
| [`volumeName`](#parameter-capacitypoolsvolumesdataprotectionreplicationremotepathvolumename) | string | The name of a volume on the server. |

### Parameter: `capacityPools.volumes.dataProtection.replication.remotePath.externalHostName`

The Path to a ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.replication.remotePath.serverName`

The name of a server on the ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.replication.remotePath.volumeName`

The name of a volume on the server.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.replication.remoteVolumeRegion`

The remote region for the other end of the Volume Replication.Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.replication.remoteVolumeResourceId`

The resource ID of the remote volume. Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.dataProtection.replication.replicationSchedule`

The replication schedule for the volume (to only be set on the destination (dst)).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '_10minutely'
    'daily'
    'hourly'
  ]
  ```

### Parameter: `capacityPools.volumes.dataProtection.snapshot`

Snapshot properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapshotPolicyName`](#parameter-capacitypoolsvolumesdataprotectionsnapshotsnapshotpolicyname) | string | The name of the snapshot policy to link. |

### Parameter: `capacityPools.volumes.dataProtection.snapshot.snapshotPolicyName`

The name of the snapshot policy to link.

- Required: Yes
- Type: string

### Parameter: `capacityPools.volumes.encryptionKeySource`

The source of the encryption key.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.exportPolicy`

Export policy rules.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-capacitypoolsvolumesexportpolicyrules) | array | The Export policy rules. |

### Parameter: `capacityPools.volumes.exportPolicy.rules`

The Export policy rules.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kerberos5iReadOnly`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5ireadonly) | bool | Kerberos5i Read only access. |
| [`kerberos5iReadWrite`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5ireadwrite) | bool | Kerberos5i Read and write access. |
| [`kerberos5pReadOnly`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5preadonly) | bool | Kerberos5p Read only access. |
| [`kerberos5pReadWrite`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5preadwrite) | bool | Kerberos5p Read and write access. |
| [`kerberos5ReadOnly`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5readonly) | bool | Kerberos5 Read only access. |
| [`kerberos5ReadWrite`](#parameter-capacitypoolsvolumesexportpolicyruleskerberos5readwrite) | bool | Kerberos5 Read and write access. |
| [`nfsv3`](#parameter-capacitypoolsvolumesexportpolicyrulesnfsv3) | bool | Allows NFSv3 protocol. Enable only for NFSv3 type volumes. |
| [`nfsv41`](#parameter-capacitypoolsvolumesexportpolicyrulesnfsv41) | bool | Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes. |
| [`ruleIndex`](#parameter-capacitypoolsvolumesexportpolicyrulesruleindex) | int | Order index. |
| [`unixReadOnly`](#parameter-capacitypoolsvolumesexportpolicyrulesunixreadonly) | bool | Read only access. |
| [`unixReadWrite`](#parameter-capacitypoolsvolumesexportpolicyrulesunixreadwrite) | bool | Read and write access. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedClients`](#parameter-capacitypoolsvolumesexportpolicyrulesallowedclients) | string | Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names. |
| [`chownMode`](#parameter-capacitypoolsvolumesexportpolicyruleschownmode) | string | This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own. |
| [`cifs`](#parameter-capacitypoolsvolumesexportpolicyrulescifs) | bool | Allows CIFS protocol. |
| [`hasRootAccess`](#parameter-capacitypoolsvolumesexportpolicyruleshasrootaccess) | bool | Has root access to volume. |

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5iReadOnly`

Kerberos5i Read only access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5iReadWrite`

Kerberos5i Read and write access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5pReadOnly`

Kerberos5p Read only access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5pReadWrite`

Kerberos5p Read and write access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5ReadOnly`

Kerberos5 Read only access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.kerberos5ReadWrite`

Kerberos5 Read and write access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.nfsv3`

Allows NFSv3 protocol. Enable only for NFSv3 type volumes.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.nfsv41`

Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.ruleIndex`

Order index.

- Required: Yes
- Type: int

### Parameter: `capacityPools.volumes.exportPolicy.rules.unixReadOnly`

Read only access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.unixReadWrite`

Read and write access.

- Required: Yes
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.allowedClients`

Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names.

- Required: No
- Type: string

### Parameter: `capacityPools.volumes.exportPolicy.rules.chownMode`

This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Restricted'
    'Unrestricted'
  ]
  ```

### Parameter: `capacityPools.volumes.exportPolicy.rules.cifs`

Allows CIFS protocol.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.exportPolicy.rules.hasRootAccess`

Has root access to volume.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.kerberosEnabled`

Define if a volume is KerberosEnabled.

- Required: No
- Type: bool

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

### Parameter: `capacityPools.volumes.protocolTypes`

Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'CIFS'
    'NFSv3'
    'NFSv4.1'
  ]
  ```

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

### Parameter: `capacityPools.volumes.smbContinuouslyAvailable`

Enables continuously available share property for SMB volume. Only applicable for SMB volume.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.smbEncryption`

Enables SMB encryption. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: bool

### Parameter: `capacityPools.volumes.smbNonBrowsable`

Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `capacityPools.volumes.throughputMibps`

The throughput in MiBps for the NetApp account.

- Required: No
- Type: int

### Parameter: `capacityPools.volumes.volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hour`](#parameter-snapshotpoliciesdailyschedulehour) | int | The daily snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesdailyscheduleminute) | int | The daily snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesdailyschedulesnapshotstokeep) | int | Daily snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-snapshotpoliciesdailyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `snapshotPolicies.dailySchedule.hour`

The daily snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `snapshotPolicies.dailySchedule.minute`

The daily snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `snapshotPolicies.dailySchedule.snapshotsToKeep`

Daily snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `snapshotPolicies.dailySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.hourlySchedule`

Hourly schedule for the snapshot policy.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-snapshotpolicieshourlyscheduleminute) | int | The hourly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpolicieshourlyschedulesnapshotstokeep) | int | Hourly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-snapshotpolicieshourlyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `snapshotPolicies.hourlySchedule.minute`

The hourly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `snapshotPolicies.hourlySchedule.snapshotsToKeep`

Hourly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `snapshotPolicies.hourlySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`daysOfMonth`](#parameter-snapshotpoliciesmonthlyscheduledaysofmonth) | string | Indicates which days of the month snapshot should be taken. A comma delimited string. E.g., '10,11,12'. |
| [`hour`](#parameter-snapshotpoliciesmonthlyschedulehour) | int | The monthly snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesmonthlyscheduleminute) | int | The monthly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesmonthlyschedulesnapshotstokeep) | int | Monthly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-snapshotpoliciesmonthlyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `snapshotPolicies.monthlySchedule.daysOfMonth`

Indicates which days of the month snapshot should be taken. A comma delimited string. E.g., '10,11,12'.

- Required: Yes
- Type: string

### Parameter: `snapshotPolicies.monthlySchedule.hour`

The monthly snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `snapshotPolicies.monthlySchedule.minute`

The monthly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `snapshotPolicies.monthlySchedule.snapshotsToKeep`

Monthly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `snapshotPolicies.monthlySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `snapshotPolicies.weeklySchedule`

Weekly schedule for the snapshot policy.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`day`](#parameter-snapshotpoliciesweeklyscheduleday) | string | The weekly snapshot day. |
| [`hour`](#parameter-snapshotpoliciesweeklyschedulehour) | int | The weekly snapshot hour. |
| [`minute`](#parameter-snapshotpoliciesweeklyscheduleminute) | int | The weekly snapshot minute. |
| [`snapshotsToKeep`](#parameter-snapshotpoliciesweeklyschedulesnapshotstokeep) | int | Weekly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-snapshotpoliciesweeklyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `snapshotPolicies.weeklySchedule.day`

The weekly snapshot day.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Friday'
    'Monday'
    'Saturday'
    'Sunday'
    'Thursday'
    'Tuesday'
    'Wednesday'
  ]
  ```

### Parameter: `snapshotPolicies.weeklySchedule.hour`

The weekly snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `snapshotPolicies.weeklySchedule.minute`

The weekly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `snapshotPolicies.weeklySchedule.snapshotsToKeep`

Weekly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `snapshotPolicies.weeklySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `capacityPoolResourceIds` | array | The resource IDs of the created capacity pools & their volumes. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the NetApp account. |
| `resourceGroupName` | string | The name of the Resource Group the NetApp account was created in. |
| `resourceId` | string | The Resource ID of the NetApp account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
