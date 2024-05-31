# Sender Usernames `[Microsoft.Communication/emailServices/domains/senderUsernames]`

This module deploys an Sender

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
