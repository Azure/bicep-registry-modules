# Cost Management scheduled action

Creates a Cost Management scheduled action to notify recipients when an anomaly is detected or on a recurring schedule.

## Description

Use this module within other Bicep templates to simplify creating and updating scheduled actions.

## Parameters

| Name                   | Type     | Required | Description                                                                                                                                                                                                                                                                                 |
| :--------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                 | `string` | Yes      | Name of the scheduled action used in the resource ID.                                                                                                                                                                                                                                       |
| `kind`                 | `string` | No       | Indicates the kind of scheduled action.                                                                                                                                                                                                                                                     |
| `builtInView`          | `string` | No       | Specifies which built-in view to use. This is a shortcut for the full view ID.                                                                                                                                                                                                              |
| `viewId`               | `string` | No       | Required if kind is "Email" and builtInView is not set. The resource ID of the view to which the scheduled action will send. The view must either be private (tenant level) or owned by the same scope as the scheduled action. Ignored if kind is "InsightAlert" or if builtInView is set. |
| `displayName`          | `string` | No       | The display name to show in the portal when viewing the list of scheduled actions.                                                                                                                                                                                                          |
| `status`               | `string` | No       | The status of the scheduled action.                                                                                                                                                                                                                                                         |
| `notificationEmail`    | `string` | No       | Email address of the person or team responsible for this scheduled action. This email address will be included in emails.                                                                                                                                                                   |
| `emailRecipients`      | `array`  | Yes      | List of email addresses that should receive emails. At least one valid email address is required.                                                                                                                                                                                           |
| `emailSubject`         | `string` | No       | The subject of the email that will be sent to the email recipients.                                                                                                                                                                                                                         |
| `emailMessage`         | `string` | No       | Include a message for recipients to add context about why they are getting the email, what to do, and/or who to contact.                                                                                                                                                                    |
| `emailLanguage`        | `string` | No       | The language that will be used for the email template.                                                                                                                                                                                                                                      |
| `emailRegionalFormat`  | `string` | No       | The regional format that will be used for dates, times, and numbers.                                                                                                                                                                                                                        |
| `includeCsv`           | `bool`   | No       | Indicates whether to include a link to a CSV file with the backing data for the chart. Ignored if kind is "InsightAlert".                                                                                                                                                                   |
| `scheduleFrequency`    | `string` | No       | The frequency at which the scheduled action will run.                                                                                                                                                                                                                                       |
| `scheduleDaysOfWeek`   | `array`  | No       | Required if kind is "Email" and scheduleFrequency is "Weekly". List of days of the week that emails should be delivered. Allowed: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.                                                                                           |
| `scheduleDayOfMonth`   | `int`    | No       | Required if kind is "Email" and scheduleFrequency is "Monthly". The day of the month that emails should be delivered. Note monthly cost is not final until the 3rd of the month. This or scheduleWeeksOfMonth is required if scheduleFrequency is "Monthly".                                |
| `scheduleWeeksOfMonth` | `array`  | No       | List of weeks of the month that emails should be delivered. This or scheduleDayOfMonth is required if scheduleFrequency is "Monthly". Allowed: First, Second, Third, Fourth, Last.                                                                                                          |
| `scheduleStartDate`    | `string` | No       | The first day the schedule should run. Use the time to indicate when you want to receive emails. Must be in the format yyyy-MM-ddTHH:miZ. Default = Today                                                                                                                                   |
| `scheduleEndDate`      | `string` | No       | The last day the schedule should run. Must be in the format yyyy-MM-dd. Default = 1 year from start date.                                                                                                                                                                                   |

## Outputs

| Name              | Type   | Description                          |
| :---------------- | :----: | :----------------------------------- |
| scheduledActionId | string | Resource ID of the scheduled action. |

## Examples

### Example 1

Creates a shared scheduled action for the DailyCosts built-in view.

```bicep
module dailyCostsAlert 'br/public:cost/resourcegroup-scheduled-action:1.0' = {
  name: 'dailyCostsAlert'
  params: {
    name: 'DailyCostsAlert'
    displayName: 'My schedule'
    builtInView: 'DailyCosts'
    emailRecipients: [ 'ema@contoso.com' ]
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
  }
}
```

### Example 2

Creates a private scheduled action for the DailyCosts built-in view with custom start/end dates.

```bicep
module privateAlert 'br/public:cost/resourcegroup-scheduled-action:1.0' = {
  name: 'privateAlert'
  params: {
    name: 'PrivateAlert'
    displayName: 'My private schedule'
    private: true
    builtInView: 'DailyCosts'
    emailRecipients: [ 'priya@contoso.com' ]
    scheduleFrequency: 'Monthly'
    scheduleDayOfMonth: 1
    scheduleStartDate: scheduleStartDate
    scheduleEndDate: scheduleEndDate
  }
}
```