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

<summary>via JSON Parameter file</summary>

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
              '1'
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
              '1'
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

<summary>via JSON Parameter file</summary>

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
                "1"
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
                "1"
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
            zones: [
              '1'
            ]
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
            zones: [
              '1'
            ]
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

<summary>via JSON Parameter file</summary>

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
              "usageThreshold": 107374182400,
              "zones": [
                "1"
              ]
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
              "zones": [
                "1"
              ]
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

<summary>via JSON Parameter file</summary>

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

### Parameter: `capacityPools`

Capacity pools to create.

- Required: No
- Type: array
- Default: `[]`

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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
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

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
