# Private DNS Zones `[Microsoft.Network/privateDnsZones]`

This module deploys a Private DNS zone.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
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
    ]
    aaaa: [
      {
        aaaaRecords: [
          {
            ipv6Address: '2001:0db8:85a3:0000:0000:8a2e:0370:7334'
          }
        ]
        name: 'AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334'
        ttl: 3600
      }
    ]
    cname: [
      {
        cnameRecord: {
          cname: 'test'
        }
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
    ]
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    mx: [
      {
        mxRecords: [
          {
            exchange: 'contoso.com'
            preference: 100
          }
        ]
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
    ]
    ptr: [
      {
        name: 'PTR_contoso'
        ptrRecords: [
          {
            ptrdname: 'contoso.com'
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
        ttl: 3600
      }
    ]
    roleAssignments: [
      {
        name: '8001f03c-2ca1-4dab-ab69-4dbaa3635af1'
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
    soa: [
      {
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
        soaRecord: {
          email: 'azureprivatedns-host.microsoft.com'
          expireTime: 2419200
          host: 'azureprivatedns.net'
          minimumTtl: 10
          refreshTime: 3600
          retryTime: 300
          serialNumber: 1
        }
        ttl: 3600
      }
    ]
    srv: [
      {
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
        srvRecords: [
          {
            port: 9332
            priority: 0
            target: 'test.contoso.com'
            weight: 0
          }
        ]
        ttl: 3600
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    txt: [
      {
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
          "name": "AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334",
          "ttl": 3600
        }
      ]
    },
    "cname": {
      "value": [
        {
          "cnameRecord": {
            "cname": "test"
          },
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
          "mxRecords": [
            {
              "exchange": "contoso.com",
              "preference": 100
            }
          ],
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
        }
      ]
    },
    "ptr": {
      "value": [
        {
          "name": "PTR_contoso",
          "ptrRecords": [
            {
              "ptrdname": "contoso.com"
            }
          ],
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
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "8001f03c-2ca1-4dab-ab69-4dbaa3635af1",
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
    "soa": {
      "value": [
        {
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
          "soaRecord": {
            "email": "azureprivatedns-host.microsoft.com",
            "expireTime": 2419200,
            "host": "azureprivatedns.net",
            "minimumTtl": 10,
            "refreshTime": 3600,
            "retryTime": 300,
            "serialNumber": 1
          },
          "ttl": 3600
        }
      ]
    },
    "srv": {
      "value": [
        {
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
          "srvRecords": [
            {
              "port": 9332,
              "priority": 0,
              "target": "test.contoso.com",
              "weight": 0
            }
          ],
          "ttl": 3600
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
          "ttl": 3600,
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
| [`name`](#parameter-aname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aRecords`](#parameter-aarecords) | array | The list of A records in the record set. |
| [`metadata`](#parameter-ametadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-aroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-attl) | int | The TTL of the record. |

### Parameter: `a.name`

The name of the record.

- Required: Yes
- Type: string

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

### Parameter: `a.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `a.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-aroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-aroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-aroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-aroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-aroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-aroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-aroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-aroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `a.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `a.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `a.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `a.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `a.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `a.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `a.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `a.roleAssignments.principalType`

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

### Parameter: `a.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `aaaa`

Array of AAAA records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aaaaname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aaaaRecords`](#parameter-aaaaaaaarecords) | array | The list of AAAA records in the record set. |
| [`metadata`](#parameter-aaaametadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-aaaaroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-aaaattl) | int | The TTL of the record. |

### Parameter: `aaaa.name`

The name of the record.

- Required: Yes
- Type: string

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

### Parameter: `aaaa.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `aaaa.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-aaaaroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-aaaaroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-aaaaroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-aaaaroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-aaaaroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-aaaaroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-aaaaroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-aaaaroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `aaaa.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `aaaa.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `aaaa.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `aaaa.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `aaaa.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `aaaa.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `aaaa.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `aaaa.roleAssignments.principalType`

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

### Parameter: `aaaa.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `cname`

Array of CNAME records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cnamename) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cnameRecord`](#parameter-cnamecnamerecord) | object | The CNAME record in the record set. |
| [`metadata`](#parameter-cnamemetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-cnameroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-cnamettl) | int | The TTL of the record. |

### Parameter: `cname.name`

The name of the record.

- Required: Yes
- Type: string

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

### Parameter: `cname.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `cname.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-cnameroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-cnameroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-cnameroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-cnameroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-cnameroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-cnameroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-cnameroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-cnameroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `cname.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `cname.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `cname.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `cname.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `cname.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `cname.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `cname.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `cname.roleAssignments.principalType`

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

### Parameter: `cname.ttl`

The TTL of the record.

- Required: No
- Type: int

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
| [`name`](#parameter-mxname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-mxmetadata) | object | The metadata of the record. |
| [`mxRecords`](#parameter-mxmxrecords) | array | The list of MX records in the record set. |
| [`roleAssignments`](#parameter-mxroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-mxttl) | int | The TTL of the record. |

### Parameter: `mx.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `mx.metadata`

The metadata of the record.

- Required: No
- Type: object

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

### Parameter: `mx.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-mxroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-mxroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-mxroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-mxroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-mxroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-mxroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-mxroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-mxroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `mx.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `mx.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `mx.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `mx.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `mx.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `mx.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `mx.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `mx.roleAssignments.principalType`

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

### Parameter: `mx.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `ptr`

Array of PTR records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-ptrname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-ptrmetadata) | object | The metadata of the record. |
| [`ptrRecords`](#parameter-ptrptrrecords) | array | The list of PTR records in the record set. |
| [`roleAssignments`](#parameter-ptrroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-ptrttl) | int | The TTL of the record. |

### Parameter: `ptr.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `ptr.metadata`

The metadata of the record.

- Required: No
- Type: object

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

### Parameter: `ptr.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-ptrroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-ptrroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-ptrroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-ptrroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-ptrroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-ptrroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-ptrroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-ptrroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `ptr.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `ptr.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `ptr.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `ptr.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `ptr.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `ptr.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `ptr.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `ptr.roleAssignments.principalType`

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

### Parameter: `ptr.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

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

### Parameter: `soa`

Array of SOA records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-soaname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-soametadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-soaroleassignments) | array | Array of role assignments to create. |
| [`soaRecord`](#parameter-soasoarecord) | object | The SOA record in the record set. |
| [`ttl`](#parameter-soattl) | int | The TTL of the record. |

### Parameter: `soa.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `soa.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `soa.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-soaroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-soaroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-soaroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-soaroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-soaroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-soaroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-soaroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-soaroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `soa.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `soa.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `soa.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `soa.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `soa.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `soa.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `soa.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `soa.roleAssignments.principalType`

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

### Parameter: `soa.ttl`

The TTL of the record.

- Required: No
- Type: int

### Parameter: `srv`

Array of SRV records.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-srvname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-srvmetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-srvroleassignments) | array | Array of role assignments to create. |
| [`srvRecords`](#parameter-srvsrvrecords) | array | The list of SRV records in the record set. |
| [`ttl`](#parameter-srvttl) | int | The TTL of the record. |

### Parameter: `srv.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `srv.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `srv.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-srvroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-srvroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-srvroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-srvroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-srvroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-srvroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-srvroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-srvroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `srv.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `srv.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `srv.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `srv.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `srv.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `srv.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `srv.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `srv.roleAssignments.principalType`

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

### Parameter: `srv.ttl`

The TTL of the record.

- Required: No
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
| [`name`](#parameter-txtname) | string | The name of the record. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-txtmetadata) | object | The metadata of the record. |
| [`roleAssignments`](#parameter-txtroleassignments) | array | Array of role assignments to create. |
| [`ttl`](#parameter-txtttl) | int | The TTL of the record. |
| [`txtRecords`](#parameter-txttxtrecords) | array | The list of TXT records in the record set. |

### Parameter: `txt.name`

The name of the record.

- Required: Yes
- Type: string

### Parameter: `txt.metadata`

The metadata of the record.

- Required: No
- Type: object

### Parameter: `txt.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Private DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-txtroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-txtroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-txtroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-txtroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-txtroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-txtroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-txtroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-txtroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `txt.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `txt.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `txt.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `txt.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `txt.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `txt.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `txt.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `txt.roleAssignments.principalType`

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

### Parameter: `txt.ttl`

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
| [`value`](#parameter-txttxtrecordsvalue) | array | The text value of this TXT record. |

### Parameter: `txt.txtRecords.value`

The text value of this TXT record.

- Required: Yes
- Type: array

### Parameter: `virtualNetworkLinks`

Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'virtualNetworkResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworklinksvirtualnetworkresourceid) | string | The resource ID of the virtual network to link. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-virtualnetworklinkslocation) | string | The Azure Region where the resource lives. |
| [`name`](#parameter-virtualnetworklinksname) | string | The resource name. |
| [`registrationEnabled`](#parameter-virtualnetworklinksregistrationenabled) | bool | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?. |
| [`tags`](#parameter-virtualnetworklinkstags) | object | Resource tags. |

### Parameter: `virtualNetworkLinks.virtualNetworkResourceId`

The resource ID of the virtual network to link.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkLinks.location`

The Azure Region where the resource lives.

- Required: No
- Type: string

### Parameter: `virtualNetworkLinks.name`

The resource name.

- Required: No
- Type: string

### Parameter: `virtualNetworkLinks.registrationEnabled`

Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.

- Required: No
- Type: bool

### Parameter: `virtualNetworkLinks.tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private DNS zone. |
| `resourceGroupName` | string | The resource group the private DNS zone was deployed into. |
| `resourceId` | string | The resource ID of the private DNS zone. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
