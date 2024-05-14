# Private DNS Zones `[Microsoft.Network/privateDnsZones]`

This module deploys a Private DNS zone.

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
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/private-dns-zone:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:<version>' = {
  name: 'privateDnsZoneDeployment'
  params: {
    // Required parameters
    name: 'npdzmin001.com'
    // Non-required parameters
    location: 'global'
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
      "value": "npdzmin001.com"
    },
    // Non-required parameters
    "location": {
      "value": "global"
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
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:<version>' = {
  name: 'privateDnsZoneDeployment'
  params: {
    // Required parameters
    name: 'npdzmax001.com'
    // Non-required parameters
    a: [
      {
        aRecords: [
          {
            ipv4Address: '10.240.4.4'
          }
        ]
        base: {
          name: 'A_10.240.4.4'
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
          ttl: 3600
        }
      }
    ]
    aaaa: [
      {
        aaaaRecords: [
          {
            ipv6Address: '2001:0db8:85a3:0000:0000:8a2e:0370:7334'
          }
        ]
        base: {
          name: 'AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334'
          ttl: 3600
        }
      }
    ]
    cname: [
      {
        base: {
          name: 'CNAME_test'
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
          ttl: 3600
        }
        cnameRecord: {
          cname: 'test'
        }
      }
    ]
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    mx: [
      {
        base: {
          name: 'MX_contoso'
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
          ttl: 3600
        }
        mxRecords: [
          {
            exchange: 'contoso.com'
            preference: 100
          }
        ]
      }
    ]
    ptr: [
      {
        base: {
          name: 'PTR_contoso'
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
          ttl: 3600
        }
        ptrRecords: [
          {
            ptrdname: 'contoso.com'
          }
        ]
      }
    ]
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
    soa: [
      {
        base: {
          name: '@'
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
          ttl: 3600
        }
        soaRecord: {
          email: 'azureprivatedns-host.microsoft.com'
          expireTime: 2419200
          host: 'azureprivatedns.net'
          minimumTtl: 10
          refreshTime: 3600
          retryTime: 300
          serialNumber: 1
        }
      }
    ]
    srv: [
      {
        base: {
          name: 'SRV_contoso'
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
          ttl: 3600
        }
        srvRecords: [
          {
            port: 9332
            priority: 0
            target: 'test.contoso.com'
            weight: 0
          }
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    txt: [
      {
        base: {
          name: 'TXT_test'
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
          ttl: 3600
        }
        txtRecords: [
          {
            value: [
              'test'
            ]
          }
        ]
      }
    ]
    virtualNetworkLinks: [
      {
        registrationEnabled: true
        virtualNetworkResourceId: '<virtualNetworkResourceId>'
      }
    ]
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
      "value": "npdzmax001.com"
    },
    // Non-required parameters
    "a": {
      "value": [
        {
          "aRecords": [
            {
              "ipv4Address": "10.240.4.4"
            }
          ],
          "base": {
            "name": "A_10.240.4.4",
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
            ],
            "ttl": 3600
          }
        }
      ]
    },
    "aaaa": {
      "value": [
        {
          "aaaaRecords": [
            {
              "ipv6Address": "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
            }
          ],
          "base": {
            "name": "AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334",
            "ttl": 3600
          }
        }
      ]
    },
    "cname": {
      "value": [
        {
          "base": {
            "name": "CNAME_test",
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
            ],
            "ttl": 3600
          },
          "cnameRecord": {
            "cname": "test"
          }
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "mx": {
      "value": [
        {
          "base": {
            "name": "MX_contoso",
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
            ],
            "ttl": 3600
          },
          "mxRecords": [
            {
              "exchange": "contoso.com",
              "preference": 100
            }
          ]
        }
      ]
    },
    "ptr": {
      "value": [
        {
          "base": {
            "name": "PTR_contoso",
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
            ],
            "ttl": 3600
          },
          "ptrRecords": [
            {
              "ptrdname": "contoso.com"
            }
          ]
        }
      ]
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
    "soa": {
      "value": [
        {
          "base": {
            "name": "@",
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
            ],
            "ttl": 3600
          },
          "soaRecord": {
            "email": "azureprivatedns-host.microsoft.com",
            "expireTime": 2419200,
            "host": "azureprivatedns.net",
            "minimumTtl": 10,
            "refreshTime": 3600,
            "retryTime": 300,
            "serialNumber": 1
          }
        }
      ]
    },
    "srv": {
      "value": [
        {
          "base": {
            "name": "SRV_contoso",
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
            ],
            "ttl": 3600
          },
          "srvRecords": [
            {
              "port": 9332,
              "priority": 0,
              "target": "test.contoso.com",
              "weight": 0
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "txt": {
      "value": [
        {
          "base": {
            "name": "TXT_test",
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
            ],
            "ttl": 3600
          },
          "txtRecords": [
            {
              "value": [
                "test"
              ]
            }
          ]
        }
      ]
    },
    "virtualNetworkLinks": {
      "value": [
        {
          "registrationEnabled": true,
          "virtualNetworkResourceId": "<virtualNetworkResourceId>"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:<version>' = {
  name: 'privateDnsZoneDeployment'
  params: {
    // Required parameters
    name: 'npdzwaf001.com'
    // Non-required parameters
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "npdzwaf001.com"
    },
    // Non-required parameters
    "location": {
      "value": "global"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Private DNS zone name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`a`](#parameter-a) | array | Array of A records. |
| [`aaaa`](#parameter-aaaa) | array | Array of AAAA records. |
| [`cname`](#parameter-cname) | array | Array of CNAME records. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the PrivateDNSZone. Should be global. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`mx`](#parameter-mx) | array | Array of MX records. |
| [`ptr`](#parameter-ptr) | array | Array of PTR records. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`soa`](#parameter-soa) | array | Array of SOA records. |
| [`srv`](#parameter-srv) | array | Array of SRV records. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`txt`](#parameter-txt) | array | Array of TXT records. |
| [`virtualNetworkLinks`](#parameter-virtualnetworklinks) | array | Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'virtualNetworkResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet. |

### Parameter: `name`

Private DNS zone name.

- Required: Yes
- Type: string

### Parameter: `a`

Array of A records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-abase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aRecords`](#parameter-aarecords) | array | The list of A records in the record set. |

### Parameter: `a.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-abasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-abasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-abaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-abasettl) | int | The TTL of the record. |

### Parameter: `a.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `a.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `a.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-abaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-abaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-abaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-abaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-abaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-abaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-abaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `a.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `a.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `a.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `a.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `a.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `a.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `a.base.roleAssignments.principalType`

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

### Parameter: `a.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `a.aRecords`

The list of A records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipv4Address`](#parameter-aarecordsipv4address) | string | The IPv4 address of this A record. |

### Parameter: `a.aRecords.ipv4Address`

The IPv4 address of this A record.

- Required: Yes
- Type: string

### Parameter: `aaaa`

Array of AAAA records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-aaaabase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aaaaRecords`](#parameter-aaaaaaaarecords) | array | The list of AAAA records in the record set. |

### Parameter: `aaaa.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aaaabasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-aaaabasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-aaaabaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-aaaabasettl) | int | The TTL of the record. |

### Parameter: `aaaa.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `aaaa.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `aaaa.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-aaaabaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-aaaabaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-aaaabaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-aaaabaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-aaaabaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-aaaabaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-aaaabaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `aaaa.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `aaaa.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `aaaa.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `aaaa.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `aaaa.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `aaaa.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `aaaa.base.roleAssignments.principalType`

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

### Parameter: `aaaa.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `aaaa.aaaaRecords`

The list of AAAA records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipv6Address`](#parameter-aaaaaaaarecordsipv6address) | string | The IPv6 address of this AAAA record. |

### Parameter: `aaaa.aaaaRecords.ipv6Address`

The IPv6 address of this AAAA record.

- Required: Yes
- Type: string

### Parameter: `cname`

Array of CNAME records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-cnamebase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cnameRecord`](#parameter-cnamecnamerecord) | object | The CNAME record in the record set. |

### Parameter: `cname.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cnamebasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-cnamebasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-cnamebaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-cnamebasettl) | int | The TTL of the record. |

### Parameter: `cname.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `cname.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `cname.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-cnamebaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-cnamebaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-cnamebaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-cnamebaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-cnamebaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-cnamebaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-cnamebaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `cname.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `cname.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `cname.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `cname.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `cname.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `cname.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `cname.base.roleAssignments.principalType`

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

### Parameter: `cname.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `cname.cnameRecord`

The CNAME record in the record set.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cname`](#parameter-cnamecnamerecordcname) | string | The canonical name of the CNAME record. |

### Parameter: `cname.cnameRecord.cname`

The canonical name of the CNAME record.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the PrivateDNSZone. Should be global.

- Required: No
- Type: string
- Default: `'global'`

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

### Parameter: `mx`

Array of MX records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-mxbase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mxRecords`](#parameter-mxmxrecords) | array | The list of MX records in the record set. |

### Parameter: `mx.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-mxbasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-mxbasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-mxbaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-mxbasettl) | int | The TTL of the record. |

### Parameter: `mx.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `mx.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `mx.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-mxbaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-mxbaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-mxbaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-mxbaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-mxbaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-mxbaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-mxbaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `mx.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `mx.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `mx.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `mx.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `mx.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `mx.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `mx.base.roleAssignments.principalType`

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

### Parameter: `mx.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `mx.mxRecords`

The list of MX records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exchange`](#parameter-mxmxrecordsexchange) | string | The domain name of the mail host for this MX record. |
| [`preference`](#parameter-mxmxrecordspreference) | int | The preference value for this MX record. |

### Parameter: `mx.mxRecords.exchange`

The domain name of the mail host for this MX record.

- Required: Yes
- Type: string

### Parameter: `mx.mxRecords.preference`

The preference value for this MX record.

- Required: Yes
- Type: int

### Parameter: `ptr`

Array of PTR records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-ptrbase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ptrRecords`](#parameter-ptrptrrecords) | array | The list of PTR records in the record set. |

### Parameter: `ptr.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-ptrbasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-ptrbasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-ptrbaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-ptrbasettl) | int | The TTL of the record. |

### Parameter: `ptr.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `ptr.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `ptr.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-ptrbaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-ptrbaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-ptrbaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-ptrbaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-ptrbaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-ptrbaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-ptrbaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `ptr.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `ptr.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `ptr.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `ptr.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `ptr.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `ptr.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `ptr.base.roleAssignments.principalType`

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

### Parameter: `ptr.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `ptr.ptrRecords`

The list of PTR records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ptrdname`](#parameter-ptrptrrecordsptrdname) | string | The PTR target domain name for this PTR record. |

### Parameter: `ptr.ptrRecords.ptrdname`

The PTR target domain name for this PTR record.

- Required: Yes
- Type: string

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

### Parameter: `soa`

Array of SOA records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-soabase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`soaRecord`](#parameter-soasoarecord) | object | The SOA record in the record set. |

### Parameter: `soa.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-soabasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-soabasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-soabaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-soabasettl) | int | The TTL of the record. |

### Parameter: `soa.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `soa.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `soa.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-soabaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-soabaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-soabaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-soabaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-soabaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-soabaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-soabaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `soa.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `soa.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `soa.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `soa.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `soa.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `soa.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `soa.base.roleAssignments.principalType`

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

### Parameter: `soa.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `soa.soaRecord`

The SOA record in the record set.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`email`](#parameter-soasoarecordemail) | string | The email contact for this SOA record. |
| [`expireTime`](#parameter-soasoarecordexpiretime) | int | The expire time for this SOA record. |
| [`host`](#parameter-soasoarecordhost) | string | The domain name of the authoritative name server for this SOA record. |
| [`minimumTtl`](#parameter-soasoarecordminimumttl) | int | The minimum value for this SOA record. By convention this is used to determine the negative caching duration. |
| [`refreshTime`](#parameter-soasoarecordrefreshtime) | int | The refresh value for this SOA record. |
| [`retryTime`](#parameter-soasoarecordretrytime) | int | The retry time for this SOA record. |
| [`serialNumber`](#parameter-soasoarecordserialnumber) | int | The serial number for this SOA record. |

### Parameter: `soa.soaRecord.email`

The email contact for this SOA record.

- Required: Yes
- Type: string

### Parameter: `soa.soaRecord.expireTime`

The expire time for this SOA record.

- Required: Yes
- Type: int

### Parameter: `soa.soaRecord.host`

The domain name of the authoritative name server for this SOA record.

- Required: Yes
- Type: string

### Parameter: `soa.soaRecord.minimumTtl`

The minimum value for this SOA record. By convention this is used to determine the negative caching duration.

- Required: Yes
- Type: int

### Parameter: `soa.soaRecord.refreshTime`

The refresh value for this SOA record.

- Required: Yes
- Type: int

### Parameter: `soa.soaRecord.retryTime`

The retry time for this SOA record.

- Required: Yes
- Type: int

### Parameter: `soa.soaRecord.serialNumber`

The serial number for this SOA record.

- Required: Yes
- Type: int

### Parameter: `srv`

Array of SRV records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-srvbase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`srvRecords`](#parameter-srvsrvrecords) | array | The list of SRV records in the record set. |

### Parameter: `srv.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-srvbasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-srvbasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-srvbaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-srvbasettl) | int | The TTL of the record. |

### Parameter: `srv.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `srv.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `srv.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-srvbaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-srvbaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-srvbaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-srvbaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-srvbaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-srvbaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-srvbaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `srv.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `srv.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `srv.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `srv.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `srv.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `srv.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `srv.base.roleAssignments.principalType`

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

### Parameter: `srv.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `srv.srvRecords`

The list of SRV records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-srvsrvrecordsport) | int | The port value for this SRV record. |
| [`priority`](#parameter-srvsrvrecordspriority) | int | The priority value for this SRV record. |
| [`target`](#parameter-srvsrvrecordstarget) | string | The target domain name for this SRV record. |
| [`weight`](#parameter-srvsrvrecordsweight) | int | The weight value for this SRV record. |

### Parameter: `srv.srvRecords.port`

The port value for this SRV record.

- Required: Yes
- Type: int

### Parameter: `srv.srvRecords.priority`

The priority value for this SRV record.

- Required: Yes
- Type: int

### Parameter: `srv.srvRecords.target`

The target domain name for this SRV record.

- Required: Yes
- Type: string

### Parameter: `srv.srvRecords.weight`

The weight value for this SRV record.

- Required: Yes
- Type: int

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `txt`

Array of TXT records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`base`](#parameter-txtbase) | object | The base properties of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`txtRecords`](#parameter-txttxtrecords) | array | The list of TXT records in the record set. |

### Parameter: `txt.base`

The base properties of the record.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-txtbasename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-txtbasemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-txtbaseroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-txtbasettl) | int | The TTL of the record. |

### Parameter: `txt.base.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `txt.base.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `txt.base.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-txtbaseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-txtbaseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-txtbaseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-txtbaseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-txtbaseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-txtbaseroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-txtbaseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `txt.base.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `txt.base.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `txt.base.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `txt.base.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `txt.base.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `txt.base.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `txt.base.roleAssignments.principalType`

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

### Parameter: `txt.base.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `txt.txtRecords`

The list of TXT records in the record set.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

### Parameter: `virtualNetworkLinks`

Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'virtualNetworkResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet.

- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private DNS zone. |
| `resourceGroupName` | string | The resource group the private DNS zone was deployed into. |
| `resourceId` | string | The resource ID of the private DNS zone. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
