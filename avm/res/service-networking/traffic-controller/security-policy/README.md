# Application Gateway for Containers Security Policy `[Microsoft.ServiceNetworking/trafficControllers/securityPolicies]`

This module deploys an Application Gateway for Containers Security Policy

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ServiceNetworking/trafficControllers/securityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.servicenetworking_trafficcontrollers_securitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceNetworking/2025-01-01/trafficControllers/securityPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the security policy to create. |
| [`wafPolicyResourceId`](#parameter-wafpolicyresourceid) | string | The resource ID of the WAF Policy to associate with the security policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`trafficControllerName`](#parameter-trafficcontrollername) | string | The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

Name of the security policy to create.

- Required: Yes
- Type: string

### Parameter: `wafPolicyResourceId`

The resource ID of the WAF Policy to associate with the security policy.

- Required: Yes
- Type: string

### Parameter: `trafficControllerName`

The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security policy. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the security policy. |
