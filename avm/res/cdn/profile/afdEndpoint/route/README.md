# CDN Profiles AFD Endpoint Route `[Microsoft.Cdn/profiles/afdEndpoints/routes]`

This module deploys a CDN Profile AFD Endpoint route.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/afdEndpoints/routes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`afdEndpointName`](#parameter-afdendpointname) | string | The name of the AFD endpoint. |
| [`name`](#parameter-name) | string | The name of the route. |
| [`originGroupName`](#parameter-origingroupname) | string | The name of the origin group. The origin group must be defined in the profile originGroups. |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cacheConfiguration`](#parameter-cacheconfiguration) | object | The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object. |
| [`customDomainNames`](#parameter-customdomainnames) | array | The names of the custom domains. The custom domains must be defined in the profile customDomains array. |
| [`enabledState`](#parameter-enabledstate) | string | Whether this route is enabled. |
| [`forwardingProtocol`](#parameter-forwardingprotocol) | string | The protocol this rule will use when forwarding traffic to backends. |
| [`httpsRedirect`](#parameter-httpsredirect) | string | Whether to automatically redirect HTTP traffic to HTTPS traffic. |
| [`linkToDefaultDomain`](#parameter-linktodefaultdomain) | string | Whether this route will be linked to the default endpoint domain. |
| [`originPath`](#parameter-originpath) | string | A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath. |
| [`patternsToMatch`](#parameter-patternstomatch) | array | The route patterns of the rule. |
| [`ruleSets`](#parameter-rulesets) | array | The rule sets of the rule. The rule sets must be defined in the profile ruleSets. |
| [`supportedProtocols`](#parameter-supportedprotocols) | array | The supported protocols of the rule. |

### Parameter: `afdEndpointName`

The name of the AFD endpoint.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the route.

- Required: Yes
- Type: string

### Parameter: `originGroupName`

The name of the origin group. The origin group must be defined in the profile originGroups.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the parent CDN profile.

- Required: Yes
- Type: string

### Parameter: `cacheConfiguration`

The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object.

- Required: No
- Type: object

### Parameter: `customDomainNames`

The names of the custom domains. The custom domains must be defined in the profile customDomains array.

- Required: No
- Type: array

### Parameter: `enabledState`

Whether this route is enabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `forwardingProtocol`

The protocol this rule will use when forwarding traffic to backends.

- Required: No
- Type: string
- Default: `'MatchRequest'`
- Allowed:
  ```Bicep
  [
    'HttpOnly'
    'HttpsOnly'
    'MatchRequest'
  ]
  ```

### Parameter: `httpsRedirect`

Whether to automatically redirect HTTP traffic to HTTPS traffic.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `linkToDefaultDomain`

Whether this route will be linked to the default endpoint domain.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `originPath`

A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath.

- Required: No
- Type: string

### Parameter: `patternsToMatch`

The route patterns of the rule.

- Required: No
- Type: array

### Parameter: `ruleSets`

The rule sets of the rule. The rule sets must be defined in the profile ruleSets.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `supportedProtocols`

The supported protocols of the rule.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Http'
    'Https'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the route. |
| `resourceGroupName` | string | The name of the resource group the route was created in. |
| `resourceId` | string | The ID of the route. |
