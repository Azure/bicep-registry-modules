# CDN Profiles Security Policy `[Microsoft.Cdn/profiles/securityPolicies]`

This module deploys a CDN Profile Security Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/securityPolicies` | [2024-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/securityPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associations`](#parameter-associations) | array | Waf associations (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies?pivots=deployment-language-bicep#securitypolicywebapplicationfirewallassociation for details). |
| [`name`](#parameter-name) | string | The resource name. |
| [`wafPolicyResourceId`](#parameter-wafpolicyresourceid) | string | Resource ID of WAF Policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |

### Parameter: `associations`

Waf associations (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies?pivots=deployment-language-bicep#securitypolicywebapplicationfirewallassociation for details).

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domains`](#parameter-associationsdomains) | array | List of domain resource id to associate with this resource. |
| [`patternsToMatch`](#parameter-associationspatternstomatch) | array | List of patterns to match with this association. |

### Parameter: `associations.domains`

List of domain resource id to associate with this resource.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-associationsdomainsid) | string | ResourceID to domain that will be associated. |

### Parameter: `associations.domains.id`

ResourceID to domain that will be associated.

- Required: Yes
- Type: string

### Parameter: `associations.patternsToMatch`

List of patterns to match with this association.

- Required: Yes
- Type: array

### Parameter: `name`

The resource name.

- Required: Yes
- Type: string

### Parameter: `wafPolicyResourceId`

Resource ID of WAF Policy.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the parent CDN profile. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secrect. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secrect. |
