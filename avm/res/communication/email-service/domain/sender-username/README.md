# Sender Usernames `[Microsoft.Communication/emailServices/domains/senderUsernames]`

This module deploys an Sender

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Communication/emailServices/domains/senderUsernames` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Communication/emailServices/domains/senderUsernames) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the sender username resource to create. |
| [`username`](#parameter-username) | string | A sender username to be used when sending emails. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | The name of the parent domain. Required if the template is used in a standalone deployment. |
| [`emailServiceName`](#parameter-emailservicename) | string | The name of the parent email service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name for the senderUsername. |

### Parameter: `name`

Name of the sender username resource to create.

- Required: Yes
- Type: string

### Parameter: `username`

A sender username to be used when sending emails.

- Required: Yes
- Type: string

### Parameter: `domainName`

The name of the parent domain. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `emailServiceName`

The name of the parent email service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `displayName`

The display name for the senderUsername.

- Required: No
- Type: string
- Default: `[parameters('username')]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the sender username. |
| `resourceGroupName` | string | The name of the resource group the sender username was created in. |
| `resourceId` | string | The resource ID of the sender username. |
