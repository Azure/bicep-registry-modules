# DevTest Lab Notification Channels `[Microsoft.DevTestLab/labs/notificationchannels]`

This module deploys a DevTest Lab Notification Channel.

Notification channels are used by the schedule resource type in order to send notifications or events to email addresses and/or webhooks.

You can reference the module as follows:
```bicep
module lab 'br/public:avm/res/dev-test-lab/lab/notificationchannel:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DevTestLab/labs/notificationchannels` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_labs_notificationchannels.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/notificationchannels)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`events`](#parameter-events) | array | The list of event for which this notification is enabled. |
| [`name`](#parameter-name) | string | The name of the notification channel. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailRecipient`](#parameter-emailrecipient) | string | The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty. |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |
| [`webHookUrl`](#parameter-webhookurl) | string | The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of notification. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`notificationLocale`](#parameter-notificationlocale) | string | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `events`

The list of event for which this notification is enabled.

- Required: Yes
- Type: array

### Parameter: `name`

The name of the notification channel.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'autoShutdown'
    'costThreshold'
  ]
  ```

### Parameter: `emailRecipient`

The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.

- Required: No
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `webHookUrl`

The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `description`

Description of notification.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `notificationLocale`

The locale to use when sending a notification (fallback for unsupported languages is EN).

- Required: No
- Type: string
- Default: `'en'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the notification channel. |
| `resourceGroupName` | string | The name of the resource group the notification channel was created in. |
| `resourceId` | string | The resource ID of the notification channel. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
