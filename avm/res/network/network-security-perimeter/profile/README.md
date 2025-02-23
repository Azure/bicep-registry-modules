# Network Security Perimeter Profile `[Microsoft.Network/networkSecurityPerimeters/profiles]`

This module deploys a Network Security Perimeter Profile.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkSecurityPerimeters/profiles` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-08-01-preview/networkSecurityPerimeters/profiles) |
| `Microsoft.Network/networkSecurityPerimeters/profiles/accessRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-08-01-preview/networkSecurityPerimeters/profiles/accessRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the network security perimeter profile. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkPerimeterName`](#parameter-networkperimetername) | string | The name of the parent network perimeter. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessRules`](#parameter-accessrules) | array | Static Members to create for the network group. Contains virtual networks to add to the network group. |

### Parameter: `name`

The name of the network security perimeter profile.

- Required: Yes
- Type: string

### Parameter: `networkPerimeterName`

The name of the parent network perimeter. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `accessRules`

Static Members to create for the network group. Contains virtual networks to add to the network group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`direction`](#parameter-accessrulesdirection) | string | The type for an access rule. |
| [`name`](#parameter-accessrulesname) | string | The name of the access rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-accessrulesaddressprefixes) | array | Inbound address prefixes (IPv4/IPv6).s. |
| [`emailAddresses`](#parameter-accessrulesemailaddresses) | array | Outbound rules email address format. |
| [`fullyQualifiedDomainNames`](#parameter-accessrulesfullyqualifieddomainnames) | array | Outbound rules fully qualified domain name format. |
| [`phoneNumbers`](#parameter-accessrulesphonenumbers) | array | Outbound rules phone number format. |
| [`serviceTags`](#parameter-accessrulesservicetags) | array | Inbound rules service tag names. |
| [`subscriptions`](#parameter-accessrulessubscriptions) | array | List of subscription ids. |

### Parameter: `accessRules.direction`

The type for an access rule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `accessRules.name`

The name of the access rule.

- Required: Yes
- Type: string

### Parameter: `accessRules.addressPrefixes`

Inbound address prefixes (IPv4/IPv6).s.

- Required: No
- Type: array

### Parameter: `accessRules.emailAddresses`

Outbound rules email address format.

- Required: No
- Type: array

### Parameter: `accessRules.fullyQualifiedDomainNames`

Outbound rules fully qualified domain name format.

- Required: No
- Type: array

### Parameter: `accessRules.phoneNumbers`

Outbound rules phone number format.

- Required: No
- Type: array

### Parameter: `accessRules.serviceTags`

Inbound rules service tag names.

- Required: No
- Type: array

### Parameter: `accessRules.subscriptions`

List of subscription ids.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-accessrulessubscriptionsid) | string | The subscription id. |

### Parameter: `accessRules.subscriptions.id`

The subscription id.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed profile. |
| `resourceGroupName` | string | The resource group the network security perimeter was deployed into. |
| `resourceId` | string | The resource ID of the deployed profile. |
