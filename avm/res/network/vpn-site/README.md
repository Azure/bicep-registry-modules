# VPN Sites `[Microsoft.Network/vpnSites]`

This module deploys a VPN Site.

You can reference the module as follows:
```bicep
module vpnSite 'br/public:avm/res/network/vpn-site:<version>' = {
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
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Network/vpnSites` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_vpnsites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/vpnSites)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/vpn-site:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnSite 'br/public:avm/res/network/vpn-site:<version>' = {
  params: {
    // Required parameters
    name: 'nvsmin'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    ipAddress: '1.2.3.4'
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
      "value": "nvsmin"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "ipAddress": {
      "value": "1.2.3.4"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-site:<version>'

// Required parameters
param name = 'nvsmin'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param addressPrefixes = [
  '10.0.0.0/16'
]
param ipAddress = '1.2.3.4'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnSite 'br/public:avm/res/network/vpn-site:<version>' = {
  params: {
    // Required parameters
    name: 'nvsmax'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    o365Policy: {
      breakOutCategories: {
        allow: true
        default: true
        optimize: true
      }
    }
    roleAssignments: [
      {
        name: '1dcfa9c2-5e95-42d2-bf04-bdecad93abcf'
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
      'hidden-title': 'This is visible in the resource name'
      tagA: 'valueA'
      tagB: 'valueB'
    }
    vpnSiteLinks: [
      {
        name: 'vSite-nvsmax'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
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
      "value": "nvsmax"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "deviceProperties": {
      "value": {
        "linkSpeedInMbps": 0
      }
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
    "o365Policy": {
      "value": {
        "breakOutCategories": {
          "allow": true,
          "default": true,
          "optimize": true
        }
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "1dcfa9c2-5e95-42d2-bf04-bdecad93abcf",
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
        "hidden-title": "This is visible in the resource name",
        "tagA": "valueA",
        "tagB": "valueB"
      }
    },
    "vpnSiteLinks": {
      "value": [
        {
          "name": "vSite-nvsmax",
          "properties": {
            "bgpProperties": {
              "asn": 65010,
              "bgpPeeringAddress": "1.1.1.1"
            },
            "ipAddress": "1.2.3.4",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
        },
        {
          "name": "Link1",
          "properties": {
            "bgpProperties": {
              "asn": 65020,
              "bgpPeeringAddress": "192.168.1.0"
            },
            "ipAddress": "2.2.2.2",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
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
using 'br/public:avm/res/network/vpn-site:<version>'

// Required parameters
param name = 'nvsmax'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param deviceProperties = {
  linkSpeedInMbps: 0
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
o365Policy: {
  breakOutCategories: {
    allow: true
    default: true
    optimize: true
  }
}
param roleAssignments = [
  {
    name: '1dcfa9c2-5e95-42d2-bf04-bdecad93abcf'
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
  'hidden-title': 'This is visible in the resource name'
  tagA: 'valueA'
  tagB: 'valueB'
}
param vpnSiteLinks = [
  {
    name: 'vSite-nvsmax'
    properties: {
      bgpProperties: {
        asn: 65010
        bgpPeeringAddress: '1.1.1.1'
      }
      ipAddress: '1.2.3.4'
      linkProperties: {
        linkProviderName: 'contoso'
        linkSpeedInMbps: 5
      }
    }
  }
  {
    name: 'Link1'
    properties: {
      bgpProperties: {
        asn: 65020
        bgpPeeringAddress: '192.168.1.0'
      }
      ipAddress: '2.2.2.2'
      linkProperties: {
        linkProviderName: 'contoso'
        linkSpeedInMbps: 5
      }
    }
  }
]
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnSite 'br/public:avm/res/network/vpn-site:<version>' = {
  params: {
    // Required parameters
    name: 'nvswaf'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    location: '<location>'
    o365Policy: {
      breakOutCategories: {
        allow: true
        default: true
        optimize: true
      }
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      tagA: 'valueA'
      tagB: 'valueB'
    }
    vpnSiteLinks: [
      {
        name: 'vSite-nvswaf'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
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
      "value": "nvswaf"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "deviceProperties": {
      "value": {
        "linkSpeedInMbps": 0
      }
    },
    "location": {
      "value": "<location>"
    },
    "o365Policy": {
      "value": {
        "breakOutCategories": {
          "allow": true,
          "default": true,
          "optimize": true
        }
      }
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "tagA": "valueA",
        "tagB": "valueB"
      }
    },
    "vpnSiteLinks": {
      "value": [
        {
          "name": "vSite-nvswaf",
          "properties": {
            "bgpProperties": {
              "asn": 65010,
              "bgpPeeringAddress": "1.1.1.1"
            },
            "ipAddress": "1.2.3.4",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
        },
        {
          "name": "Link1",
          "properties": {
            "bgpProperties": {
              "asn": 65020,
              "bgpPeeringAddress": "192.168.1.0"
            },
            "ipAddress": "2.2.2.2",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
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
using 'br/public:avm/res/network/vpn-site:<version>'

// Required parameters
param name = 'nvswaf'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param deviceProperties = {
  linkSpeedInMbps: 0
}
param location = '<location>'
o365Policy: {
  breakOutCategories: {
    allow: true
    default: true
    optimize: true
  }
}
param tags = {
  'hidden-title': 'This is visible in the resource name'
  tagA: 'valueA'
  tagB: 'valueB'
}
param vpnSiteLinks = [
  {
    name: 'vSite-nvswaf'
    properties: {
      bgpProperties: {
        asn: 65010
        bgpPeeringAddress: '1.1.1.1'
      }
      ipAddress: '1.2.3.4'
      linkProperties: {
        linkProviderName: 'contoso'
        linkSpeedInMbps: 5
      }
    }
  }
  {
    name: 'Link1'
    properties: {
      bgpProperties: {
        asn: 65020
        bgpPeeringAddress: '192.168.1.0'
      }
      ipAddress: '2.2.2.2'
      linkProperties: {
        linkProviderName: 'contoso'
        linkSpeedInMbps: 5
      }
    }
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the VPN Site. |
| [`virtualWanResourceId`](#parameter-virtualwanresourceid) | string | Resource ID of the virtual WAN to link to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-addressprefixes) | array | An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured. |
| [`bgpProperties`](#parameter-bgpproperties) | object | BGP settings details. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. Required if no addressPrefixes or VPNSiteLinks are configured. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deviceProperties`](#parameter-deviceproperties) | object | List of properties of the device. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipAddress`](#parameter-ipaddress) | string | The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| [`isSecuritySite`](#parameter-issecuritysite) | bool | IsSecuritySite flag. |
| [`location`](#parameter-location) | string | Location where all resources will be created. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`o365Policy`](#parameter-o365policy) | object | The Office365 breakout policy. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnSiteLinks`](#parameter-vpnsitelinks) | array | List of all VPN site links. |

### Parameter: `name`

Name of the VPN Site.

- Required: Yes
- Type: string

### Parameter: `virtualWanResourceId`

Resource ID of the virtual WAN to link to.

- Required: Yes
- Type: string

### Parameter: `addressPrefixes`

An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured.

- Required: No
- Type: array

### Parameter: `bgpProperties`

BGP settings details. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. Required if no addressPrefixes or VPNSiteLinks are configured.

- Required: No
- Type: object

### Parameter: `deviceProperties`

List of properties of the device.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ipAddress`

The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isSecuritySite`

IsSecuritySite flag.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location where all resources will be created.

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

### Parameter: `o365Policy`

The Office365 breakout policy.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
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

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnSiteLinks`

List of all VPN site links.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VPN site. |
| `resourceGroupName` | string | The resource group the VPN site was deployed into. |
| `resourceId` | string | The resource ID of the VPN site. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Notes

### Parameter Usage `deviceProperties`

<details>

<summary>Parameter JSON format</summary>

```json
"deviceProperties": {
    "value": {
        "deviceModel": "morty",
        "deviceVendor": "contoso",
        "linkSpeedInMbps": 0
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
deviceProperties: {
    deviceModel: 'morty'
    deviceVendor: 'contoso'
    linkSpeedInMbps: 0
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
