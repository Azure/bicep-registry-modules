# Azure Service Health Alerts `[Subscription/ServiceHealthAlerts]`

This module deploys Azure Service Health Alerts to notify you of service issues, planned maintenance, and health advisories that may affect your Azure services.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/actionGroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-01-01/actionGroups) |
| `Microsoft.Insights/activityLogAlerts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/subscription/service-health-alerts:<version>`.

- [Deploying multiple service health alerts.](#example-1-deploying-multiple-service-health-alerts)
- [Using only defaults.](#example-2-using-only-defaults)

### Example 1: _Deploying multiple service health alerts._

This instance deploys the module with the maximum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module serviceHealthAlerts 'br/public:avm/ptn/subscription/service-health-alerts:<version>' = {
  name: 'serviceHealthAlertsDeployment'
  params: {
    enableTelemetry: true
    location: '<location>'
    serviceHealthAlerts: [
      {
        actionGroup: {
          armRoleReceivers: [
            {
              name: 'armRoleReceiverOwner-ashalt'
              roleId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
            }
          ]
          emailReceivers: [
            {
              emailAddress: 'admin@contoso.com'
              name: 'emailReceiver-ashalt'
            }
          ]
          enabled: true
          name: 'actionGroup-ashalt'
        }
        alertDescription: 'Resource Health Unhealthy'
        isEnabled: true
        serviceHealthAlert: 'Resource Health Unhealthy'
      }
    ]
    serviceHealthAlertsResourceGroupName: '<serviceHealthAlertsResourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "serviceHealthAlerts": {
      "value": [
        {
          "actionGroup": {
            "armRoleReceivers": [
              {
                "name": "armRoleReceiverOwner-ashalt",
                "roleId": "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
              }
            ],
            "emailReceivers": [
              {
                "emailAddress": "admin@contoso.com",
                "name": "emailReceiver-ashalt"
              }
            ],
            "enabled": true,
            "name": "actionGroup-ashalt"
          },
          "alertDescription": "Resource Health Unhealthy",
          "isEnabled": true,
          "serviceHealthAlert": "Resource Health Unhealthy"
        }
      ]
    },
    "serviceHealthAlertsResourceGroupName": {
      "value": "<serviceHealthAlertsResourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/subscription/service-health-alerts:<version>'

param enableTelemetry = true
param location = '<location>'
param serviceHealthAlerts = [
  {
    actionGroup: {
      armRoleReceivers: [
        {
          name: 'armRoleReceiverOwner-ashalt'
          roleId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
        }
      ]
      emailReceivers: [
        {
          emailAddress: 'admin@contoso.com'
          name: 'emailReceiver-ashalt'
        }
      ]
      enabled: true
      name: 'actionGroup-ashalt'
    }
    alertDescription: 'Resource Health Unhealthy'
    isEnabled: true
    serviceHealthAlert: 'Resource Health Unhealthy'
  }
]
param serviceHealthAlertsResourceGroupName = '<serviceHealthAlertsResourceGroupName>'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 2: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module serviceHealthAlerts 'br/public:avm/ptn/subscription/service-health-alerts:<version>' = {
  name: 'serviceHealthAlertsDeployment'
  params: {
    enableTelemetry: true
    location: '<location>'
    serviceHealthAlertsResourceGroupName: '<serviceHealthAlertsResourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "serviceHealthAlertsResourceGroupName": {
      "value": "<serviceHealthAlertsResourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/subscription/service-health-alerts:<version>'

param enableTelemetry = true
param location = '<location>'
param serviceHealthAlertsResourceGroupName = '<serviceHealthAlertsResourceGroupName>'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`serviceHealthAlerts`](#parameter-servicehealthalerts) | array | The list of service health alerts to create. If empty or not provided, all service health alerts will be created. |
| [`serviceHealthAlertsResourceGroupName`](#parameter-servicehealthalertsresourcegroupname) | string | The name of the resource group to deploy service health alerts into. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The subscription Id to deploy service health alerts for. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

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

### Parameter: `serviceHealthAlerts`

The list of service health alerts to create. If empty or not provided, all service health alerts will be created.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      alertDescription: 'Alert for Resource Health Unhealthy status.'
      alertName: 'ResourceHealthUnhealthyAlert'
      isEnabled: true
      serviceHealthAlert: 'Resource Health Unhealthy'
    }
    {
      alertDescription: 'Alert for Service Health Advisory incidents.'
      alertName: 'ServiceHealthAdvisoryAlert'
      isEnabled: true
      serviceHealthAlert: 'Service Health Advisory'
    }
    {
      alertDescription: 'Alert for Service Health Incident occurrences.'
      alertName: 'ServiceHealthIncidentAlert'
      isEnabled: true
      serviceHealthAlert: 'Service Health Incident'
    }
    {
      alertDescription: 'Alert for Service Health Maintenance events.'
      alertName: 'ServiceHealthMaintenanceAlert'
      isEnabled: true
      serviceHealthAlert: 'Service Health Maintenance'
    }
    {
      alertDescription: 'Alert for Service Health Security incidents.'
      alertName: 'ServiceHealthSecurityAlert'
      isEnabled: true
      serviceHealthAlert: 'Service Health Security'
    }
  ]
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionGroup`](#parameter-servicehealthalertsactiongroup) | object | The action group to use for the alert. |
| [`alertDescription`](#parameter-servicehealthalertsalertdescription) | string | The description of the service health alert. |
| [`alertName`](#parameter-servicehealthalertsalertname) | string | The name of the service health alert. |
| [`isEnabled`](#parameter-servicehealthalertsisenabled) | bool | Flag to enable or disable the alert. |
| [`serviceHealthAlert`](#parameter-servicehealthalertsservicehealthalert) | string | The service health alerts to enable. |

### Parameter: `serviceHealthAlerts.actionGroup`

The action group to use for the alert.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-servicehealthalertsactiongroupenabled) | bool | Flag to enable or disable the action group. |
| [`name`](#parameter-servicehealthalertsactiongroupname) | string | The name of the action group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`armRoleReceivers`](#parameter-servicehealthalertsactiongrouparmrolereceivers) | array | The list of ARM role receivers for the action group. |
| [`automationRunbookReceivers`](#parameter-servicehealthalertsactiongroupautomationrunbookreceivers) | array | The list of automation runbook receivers for the action group. |
| [`azureAppPushReceivers`](#parameter-servicehealthalertsactiongroupazureapppushreceivers) | array | The list of Azure App Push receivers for the action group. |
| [`azureFunctionReceivers`](#parameter-servicehealthalertsactiongroupazurefunctionreceivers) | array | The list of Azure function receivers for the action group. |
| [`emailReceivers`](#parameter-servicehealthalertsactiongroupemailreceivers) | array | The list of email receivers for the action group. |
| [`eventHubReceivers`](#parameter-servicehealthalertsactiongroupeventhubreceivers) | array | The list of event hub receivers for the action group. |
| [`groupShortName`](#parameter-servicehealthalertsactiongroupgroupshortname) | string | The short name of the action group. Max length is 12 characters. |
| [`incidentReceivers`](#parameter-servicehealthalertsactiongroupincidentreceivers) | array | The list of incident receivers for the action group. |
| [`itsmReceivers`](#parameter-servicehealthalertsactiongroupitsmreceivers) | array | The list of ITSM receivers for the action group. |
| [`logicAppReceivers`](#parameter-servicehealthalertsactiongrouplogicappreceivers) | array | The list of logic app receivers for the action group. |
| [`smsReceivers`](#parameter-servicehealthalertsactiongroupsmsreceivers) | array | The list of SMS receivers for the action group. |
| [`voiceReceivers`](#parameter-servicehealthalertsactiongroupvoicereceivers) | array | The list of voice receivers for the action group. |
| [`webhookReceivers`](#parameter-servicehealthalertsactiongroupwebhookreceivers) | array | The list of webhook receivers for the action group. |

### Parameter: `serviceHealthAlerts.actionGroup.enabled`

Flag to enable or disable the action group.

- Required: Yes
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.name`

The name of the action group.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.armRoleReceivers`

The list of ARM role receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-servicehealthalertsactiongrouparmrolereceiversname) | string | The name of the ARM role receiver. |
| [`roleId`](#parameter-servicehealthalertsactiongrouparmrolereceiversroleid) | string | The role ID of the ARM role receiver. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongrouparmrolereceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.armRoleReceivers.name`

The name of the ARM role receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.armRoleReceivers.roleId`

The role ID of the ARM role receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.armRoleReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers`

The list of automation runbook receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountId`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversautomationaccountid) | string | The resource Id of the automation runbook account. |
| [`isGlobalRunbook`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversisglobalrunbook) | bool | Flag to indicate if the runbook is global. |
| [`runbookName`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversrunbookname) | string | The name of the runbook. |
| [`serviceUri`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversserviceuri) | string | The URI where webhooks should be sent. |
| [`webhookResourceId`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiverswebhookresourceid) | string | The resource Id of the webhook. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentity`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversmanagedidentity) | string | The principal id of the managed identity. |
| [`name`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversname) | string | The name of the webhook. |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongroupautomationrunbookreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.automationAccountId`

The resource Id of the automation runbook account.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.isGlobalRunbook`

Flag to indicate if the runbook is global.

- Required: Yes
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.runbookName`

The name of the runbook.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.serviceUri`

The URI where webhooks should be sent.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.webhookResourceId`

The resource Id of the webhook.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.managedIdentity`

The principal id of the managed identity.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.name`

The name of the webhook.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.automationRunbookReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.azureAppPushReceivers`

The list of Azure App Push receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailAddress`](#parameter-servicehealthalertsactiongroupazureapppushreceiversemailaddress) | string | The email address registered for the Azure mobile app. |
| [`name`](#parameter-servicehealthalertsactiongroupazureapppushreceiversname) | string | The name of the Azure mobile app push receiver. |

### Parameter: `serviceHealthAlerts.actionGroup.azureAppPushReceivers.emailAddress`

The email address registered for the Azure mobile app.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureAppPushReceivers.name`

The name of the Azure mobile app push receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers`

The list of Azure function receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`functionAppResourceId`](#parameter-servicehealthalertsactiongroupazurefunctionreceiversfunctionappresourceid) | string | TThe resource Id of the function App. |
| [`functionName`](#parameter-servicehealthalertsactiongroupazurefunctionreceiversfunctionname) | string | The name of the Azure function in the function App. |
| [`httpTriggerUrl`](#parameter-servicehealthalertsactiongroupazurefunctionreceivershttptriggerurl) | string | The http trigger url where http request sent to. |
| [`name`](#parameter-servicehealthalertsactiongroupazurefunctionreceiversname) | string | The name of the Azure function receiver. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentity`](#parameter-servicehealthalertsactiongroupazurefunctionreceiversmanagedidentity) | string | The principal id of the managed identity. |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongroupazurefunctionreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.functionAppResourceId`

TThe resource Id of the function App.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.functionName`

The name of the Azure function in the function App.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.httpTriggerUrl`

The http trigger url where http request sent to.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.name`

The name of the Azure function receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.managedIdentity`

The principal id of the managed identity.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.azureFunctionReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.emailReceivers`

The list of email receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailAddress`](#parameter-servicehealthalertsactiongroupemailreceiversemailaddress) | string | The email address of the email receiver. |
| [`name`](#parameter-servicehealthalertsactiongroupemailreceiversname) | string | The name of the email receiver. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongroupemailreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.emailReceivers.emailAddress`

The email address of the email receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.emailReceivers.name`

The name of the email receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.emailReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers`

The list of event hub receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-servicehealthalertsactiongroupeventhubreceiverseventhubname) | string | The name of the specific Event Hub queue. |
| [`eventHubNameSpace`](#parameter-servicehealthalertsactiongroupeventhubreceiverseventhubnamespace) | string | The Event Hub namespace. |
| [`name`](#parameter-servicehealthalertsactiongroupeventhubreceiversname) | string | The name of the Event Hub receiver. |
| [`subscriptionId`](#parameter-servicehealthalertsactiongroupeventhubreceiverssubscriptionid) | string | The Id for the subscription containing this event hub. |
| [`tenantId`](#parameter-servicehealthalertsactiongroupeventhubreceiverstenantid) | string | The tenant Id for the subscription containing this event hub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentity`](#parameter-servicehealthalertsactiongroupeventhubreceiversmanagedidentity) | string | The principal id of the managed identity. |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongroupeventhubreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.eventHubName`

The name of the specific Event Hub queue.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.eventHubNameSpace`

The Event Hub namespace.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.name`

The name of the Event Hub receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.subscriptionId`

The Id for the subscription containing this event hub.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.tenantId`

The tenant Id for the subscription containing this event hub.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.managedIdentity`

The principal id of the managed identity.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.eventHubReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.groupShortName`

The short name of the action group. Max length is 12 characters.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers`

The list of incident receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connection`](#parameter-servicehealthalertsactiongroupincidentreceiversconnection) | object | The connection details for the incident management service. |
| [`incidentManagementService`](#parameter-servicehealthalertsactiongroupincidentreceiversincidentmanagementservice) | string | The incident management service type. |
| [`mappings`](#parameter-servicehealthalertsactiongroupincidentreceiversmappings) | object | The list of Field mappings for the incident service. |
| [`name`](#parameter-servicehealthalertsactiongroupincidentreceiversname) | string | The name of the incident receiver. |

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.connection`

The connection details for the incident management service.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-servicehealthalertsactiongroupincidentreceiversconnectionid) | string | GUID value representing the connection ID for the incident management service. |
| [`name`](#parameter-servicehealthalertsactiongroupincidentreceiversconnectionname) | string | The name of the connection. |

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.connection.id`

GUID value representing the connection ID for the incident management service.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.connection.name`

The name of the connection.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.incidentManagementService`

The incident management service type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Icm'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.mappings`

The list of Field mappings for the incident service.

- Required: Yes
- Type: object

### Parameter: `serviceHealthAlerts.actionGroup.incidentReceivers.name`

The name of the incident receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers`

The list of ITSM receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionId`](#parameter-servicehealthalertsactiongroupitsmreceiversconnectionid) | string | Unique identification of ITSM connection. |
| [`name`](#parameter-servicehealthalertsactiongroupitsmreceiversname) | string | The name of the ITSM connection. |
| [`region`](#parameter-servicehealthalertsactiongroupitsmreceiversregion) | string | Region in which workspace resides. Supported values:'centralindia','japaneast','southeastasia','australiasoutheast','uksouth','westcentralus','canadacentral','eastus','westeurope'. |
| [`ticketConfiguration`](#parameter-servicehealthalertsactiongroupitsmreceiversticketconfiguration) | string | JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well. |
| [`workspaceId`](#parameter-servicehealthalertsactiongroupitsmreceiversworkspaceid) | string | Log analytics workspace Id. |

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers.connectionId`

Unique identification of ITSM connection.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers.name`

The name of the ITSM connection.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers.region`

Region in which workspace resides. Supported values:'centralindia','japaneast','southeastasia','australiasoutheast','uksouth','westcentralus','canadacentral','eastus','westeurope'.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers.ticketConfiguration`

JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.itsmReceivers.workspaceId`

Log analytics workspace Id.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers`

The list of logic app receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`callbackUrl`](#parameter-servicehealthalertsactiongrouplogicappreceiverscallbackurl) | string | The callback url where http request sent to. |
| [`name`](#parameter-servicehealthalertsactiongrouplogicappreceiversname) | string | The name of the logic app receiver. |
| [`resourceId`](#parameter-servicehealthalertsactiongrouplogicappreceiversresourceid) | string | The resource Id of the logic app. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentity`](#parameter-servicehealthalertsactiongrouplogicappreceiversmanagedidentity) | string | The principal id of the managed identity. |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongrouplogicappreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers.callbackUrl`

The callback url where http request sent to.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers.name`

The name of the logic app receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers.resourceId`

The resource Id of the logic app.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers.managedIdentity`

The principal id of the managed identity.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.logicAppReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.smsReceivers`

The list of SMS receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`countryCode`](#parameter-servicehealthalertsactiongroupsmsreceiverscountrycode) | string | The country code of the SMS receiver. |
| [`name`](#parameter-servicehealthalertsactiongroupsmsreceiversname) | string | The name of the SMS receiver. |
| [`phoneNumber`](#parameter-servicehealthalertsactiongroupsmsreceiversphonenumber) | string | The phone number of the SMS receiver. |

### Parameter: `serviceHealthAlerts.actionGroup.smsReceivers.countryCode`

The country code of the SMS receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.smsReceivers.name`

The name of the SMS receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.smsReceivers.phoneNumber`

The phone number of the SMS receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.voiceReceivers`

The list of voice receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`countryCode`](#parameter-servicehealthalertsactiongroupvoicereceiverscountrycode) | string | The country code of the voice receiver. |
| [`name`](#parameter-servicehealthalertsactiongroupvoicereceiversname) | string | The name of the voice receiver. |
| [`phoneNumber`](#parameter-servicehealthalertsactiongroupvoicereceiversphonenumber) | string | The phone number of the voice receiver. |

### Parameter: `serviceHealthAlerts.actionGroup.voiceReceivers.countryCode`

The country code of the voice receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.voiceReceivers.name`

The name of the voice receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.voiceReceivers.phoneNumber`

The phone number of the voice receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers`

The list of webhook receivers for the action group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-servicehealthalertsactiongroupwebhookreceiversname) | string | The name of the webhook receiver. |
| [`serviceUri`](#parameter-servicehealthalertsactiongroupwebhookreceiversserviceuri) | string | The URI where webhooks should be sent. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifierUri`](#parameter-servicehealthalertsactiongroupwebhookreceiversidentifieruri) | string | The identifier uri for aad auth. |
| [`managedIdentity`](#parameter-servicehealthalertsactiongroupwebhookreceiversmanagedidentity) | string | The principal id of the managed identity. |
| [`objectId`](#parameter-servicehealthalertsactiongroupwebhookreceiversobjectid) | string | The webhook app object Id for aad auth. |
| [`tenantId`](#parameter-servicehealthalertsactiongroupwebhookreceiverstenantid) | string | The tenant Id. |
| [`useAadAuth`](#parameter-servicehealthalertsactiongroupwebhookreceiversuseaadauth) | bool | Flag to use Entra ID autentication. |
| [`useCommonAlertSchema`](#parameter-servicehealthalertsactiongroupwebhookreceiversusecommonalertschema) | bool | Flag to use common alert schema. |

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.name`

The name of the webhook receiver.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.serviceUri`

The URI where webhooks should be sent.

- Required: Yes
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.identifierUri`

The identifier uri for aad auth.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.managedIdentity`

The principal id of the managed identity.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.objectId`

The webhook app object Id for aad auth.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.tenantId`

The tenant Id.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.useAadAuth`

Flag to use Entra ID autentication.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.actionGroup.webhookReceivers.useCommonAlertSchema`

Flag to use common alert schema.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.alertDescription`

The description of the service health alert.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.alertName`

The name of the service health alert.

- Required: No
- Type: string

### Parameter: `serviceHealthAlerts.isEnabled`

Flag to enable or disable the alert.

- Required: No
- Type: bool

### Parameter: `serviceHealthAlerts.serviceHealthAlert`

The service health alerts to enable.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Resource Health Unhealthy'
    'Service Health Advisory'
    'Service Health Incident'
    'Service Health Maintenance'
    'Service Health Security'
  ]
  ```

### Parameter: `serviceHealthAlertsResourceGroupName`

The name of the resource group to deploy service health alerts into.

- Required: No
- Type: string
- Default: `[format('rg-asha-{0}', parameters('subscriptionId'))]`

### Parameter: `subscriptionId`

The subscription Id to deploy service health alerts for.

- Required: No
- Type: string
- Default: `[subscription().subscriptionId]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `actionGroupResourceIds` | array | The resource IDs of the created action groups. |
| `alertsResourceIds` | array | The resource IDs of the created alerts. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/insights/action-group:0.7.0` | Remote reference |
| `br/public:avm/res/insights/activity-log-alert:0.4.0` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
