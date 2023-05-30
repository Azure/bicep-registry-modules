# Cost Management scheduled action for subscriptions

Creates a scheduled action to notify recipients about the latest costs or when an anomaly is detected.

## Description

Scheduled actions allow you to configure email alerts on a daily, weekly, or monthly basis. Scheduled actions are configured based on a Cost Management view, which can be opened and edited in Cost analysis in the Azure portal. Email alerts include a picture of the selected view and optionally a link to a CSV file with the summarized cost data. To learn more about scheduled alerts, see [Subscribe to scheduled alerts](https://learn.microsoft.com/azure/cost-management-billing/costs/save-share-views#subscribe-to-scheduled-alerts).

You can also use scheduled actions to configure anomaly detection alerts for subscriptions. To learn more about Cost Management anomaly detection, see [Identify anomalies and unexpected changes in cost](https://learn.microsoft.com/azure/cost-management-billing/understand/analyze-unexpected-charges).

## Parameters

| Name                   | Type     | Required | Description                                                                                                                                                                                                                                                                                 |
| :--------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                 | `string` | Yes      | Name of the scheduled action used in the resource ID.                                                                                                                                                                                                                                       |
| `kind`                 | `string` | No       | Indicates the kind of scheduled action. Default: Email.                                                                                                                                                                                                                                     |
| `private`              | `bool`   | No       | Indicates whether the scheduled action is private and only editable by the current user. If false, the scheduled action will be shared with other users in the same scope. Ignored if kind is "InsightAlert". Default: false.                                                               |
| `builtInView`          | `string` | No       | Specifies which built-in view to use. This is a shortcut for the full view ID.                                                                                                                                                                                                              |
| `viewId`               | `string` | No       | Required if kind is "Email" and builtInView is not set. The resource ID of the view to which the scheduled action will send. The view must either be private (tenant level) or owned by the same scope as the scheduled action. Ignored if kind is "InsightAlert" or if builtInView is set. |
| `displayName`          | `string` | No       | The display name to show in the portal when viewing the list of scheduled actions. Default: (scheduled action name).                                                                                                                                                                        |
| `status`               | `string` | No       | The status of the scheduled action. Default: Enabled.                                                                                                                                                                                                                                       |
| `notificationEmail`    | `string` | Yes      | Email address of the person or team responsible for this scheduled action. This email address will be included in emails. Default: (email address of user deploying the template).                                                                                                          |
| `emailRecipients`      | `array`  | Yes      | List of email addresses that should receive emails. At least one valid email address is required.                                                                                                                                                                                           |
| `emailSubject`         | `string` | No       | The subject of the email that will be sent to the email recipients. Default: (view name).                                                                                                                                                                                                   |
| `emailMessage`         | `string` | No       | Include a message for recipients to add context about why they are getting the email, what to do, and/or who to contact. Default: "" (no message).                                                                                                                                          |
| `emailLanguage`        | `string` | No       | The language that will be used for the email template. Default: en.                                                                                                                                                                                                                         |
| `emailRegionalFormat`  | `string` | No       | The regional format that will be used for dates, times, and numbers. Default: en-us.                                                                                                                                                                                                        |
| `includeCsv`           | `bool`   | No       | Indicates whether to include a link to a CSV file with the backing data for the chart. Ignored if kind is "InsightAlert". Default: false.                                                                                                                                                   |
| `scheduleFrequency`    | `string` | No       | The frequency at which the scheduled action will run. Default: Daily for "Email" and Weekly for "InsightAlert".                                                                                                                                                                             |
| `scheduleDaysOfWeek`   | `array`  | No       | Required if kind is "Email" and scheduleFrequency is "Weekly". List of days of the week that emails should be delivered. Allowed: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. Default: Monday.                                                                          |
| `scheduleDayOfMonth`   | `int`    | No       | Required if kind is "Email" and scheduleFrequency is "Monthly". The day of the month that emails should be delivered. Note monthly cost is not final until the 3rd of the month. This or scheduleWeeksOfMonth is required if scheduleFrequency is "Monthly". Default: 0 (not set).          |
| `scheduleWeeksOfMonth` | `array`  | No       | List of weeks of the month that emails should be delivered. This or scheduleDayOfMonth is required if scheduleFrequency is "Monthly". Allowed: First, Second, Third, Fourth, Last. Default [] (not set).)                                                                                   |
| `scheduleStartDate`    | `string` | No       | The first day the schedule should run. Use the time to indicate when you want to receive emails. Must be in the format yyyy-MM-ddTHH:miZ. Default = Now.                                                                                                                                    |
| `scheduleEndDate`      | `string` | No       | The last day the schedule should run. Must be in the format yyyy-MM-dd. Default = 1 year from start date.                                                                                                                                                                                   |

## Outputs

| Name              | Type   | Description                          |
| :---------------- | :----: | :----------------------------------- |
| scheduledActionId | string | Resource ID of the scheduled action. |

## Examples

### Example 1

Creates a shared scheduled action for the DailyCosts built-in view.

```bicep
module dailyCostsAlert 'br/public:cost/subscription-scheduled-action:1.0.1' = {
  name: 'dailyCostsAlert'
  params: {
    name: 'DailyCostsAlert'
    displayName: 'My schedule'
    builtInView: 'DailyCosts'
    emailRecipients: [ 'ema@contoso.com' ]
    notificationEmail: 'ema@contoso.com'
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
  }
}
```

### Example 2

Creates a private scheduled action for the DailyCosts built-in view with custom start/end dates.

```bicep
module privateAlert 'br/public:cost/subscription-scheduled-action:1.0.1' = {
  name: 'privateAlert'
  params: {
    name: 'PrivateAlert'
    displayName: 'My private schedule'
    private: true
    builtInView: 'DailyCosts'
    emailRecipients: [ 'priya@contoso.com' ]
    notificationEmail: 'priya@contoso.com'
    scheduleFrequency: 'Monthly'
    scheduleDayOfMonth: 1
    scheduleStartDate: scheduleStartDate
    scheduleEndDate: scheduleEndDate
  }
}
```

### Example 3

Creates an anomaly alert.

```bicep
module anomalyAlert 'br/public:cost/subscription-scheduled-action:1.0.1' = {
  name: 'anomalyAlert'
  params: {
    name: 'AnomalyAlert'
    kind: 'InsightAlert'
    displayName: 'My anomaly check'
    emailRecipients: [ 'ana@contoso.com' ]
    notificationEmail: 'ana@contoso.com'
  }
}
```