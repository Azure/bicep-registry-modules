targetScope = 'subscription'

metadata name = 'Azure Service Health Alerts'
metadata description = 'This module deploys Azure Service Health Alerts to notify you of service issues, planned maintenance, and health advisories that may affect your Azure services.'

@description('Optional. Location for all Resources.')
param location string = deployment().location

@description('Optional. Tags of the resource.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. The name of the resource group to deploy service health alerts into.')
param serviceHealthAlertsResourceGroupName string = 'rg-asha-${subscriptionId}'

@description('Optional. The list of service health alerts to create. If empty or not provided, all service health alerts will be created.')
param serviceHealthAlerts serviceHealthAlertType[] = [
  {
    serviceHealthAlert: 'Resource Health Unhealthy'
    alertName: 'ResourceHealthUnhealthyAlert'
    alertDescription: 'Alert for Resource Health Unhealthy status.'
    isEnabled: true
  }
  {
    serviceHealthAlert: 'Service Health Advisory'
    alertName: 'ServiceHealthAdvisoryAlert'
    alertDescription: 'Alert for Service Health Advisory incidents.'
    isEnabled: true
  }
  {
    serviceHealthAlert: 'Service Health Incident'
    alertName: 'ServiceHealthIncidentAlert'
    alertDescription: 'Alert for Service Health Incident occurrences.'
    isEnabled: true
  }
  {
    serviceHealthAlert: 'Service Health Maintenance'
    alertName: 'ServiceHealthMaintenanceAlert'
    alertDescription: 'Alert for Service Health Maintenance events.'
    isEnabled: true
  }
  {
    serviceHealthAlert: 'Service Health Security'
    alertName: 'ServiceHealthSecurityAlert'
    alertDescription: 'Alert for Service Health Security incidents.'
    isEnabled: true
  }
]

@description('Optional. The subscription Id to deploy service health alerts for.')
param subscriptionId string = subscription().subscriptionId

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Variables      //
// ============== //

var serviceHealthAlertsMap = [
  {
    serviceHealthAlert: 'Resource Health Unhealthy'
    alertName: 'ResourceHealthUnhealthyAlert'
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ResourceHealth'
        }
        {
          anyOf: [
            {
              field: 'properties.cause'
              equals: 'PlatformInitiated'
            }
            {
              field: 'properties.cause'
              equals: 'UserInitiated'
            }
          ]
        }
        {
          anyOf: [
            {
              field: 'properties.currentHealthStatus'
              equals: 'Degraded'
            }
            {
              field: 'properties.currentHealthStatus'
              equals: 'Unavailable'
            }
          ]
        }
      ]
    }
  }
  {
    serviceHealthAlert: 'Service Health Advisory'
    alertName: 'ServiceHealthAdvisoryAlert'
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'ActionRequired'
        }
      ]
    }
  }
  {
    serviceHealthAlert: 'Service Health Incident'
    alertName: 'ServiceHealthIncidentAlert'
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Incident'
        }
      ]
    }
  }
  {
    serviceHealthAlert: 'Service Health Maintenance'
    alertName: 'ServiceHealthMaintenanceAlert'
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Maintenance'
        }
      ]
    }
  }
  {
    serviceHealthAlert: 'Service Health Security'
    alertName: 'ServiceHealthSecurityAlert'
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Security'
        }
      ]
    }
  }
]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.subscription-svchealthalerts.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'string'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module alertsResourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  scope: subscription(subscriptionId)
  params: {
    name: serviceHealthAlertsResourceGroupName
    location: location
    tags: tags
    lock: lock
    enableTelemetry: enableTelemetry
  }
}

module createServiceHealthAlerts 'br/public:avm/res/insights/activity-log-alert:0.4.0' = [
  for (alert, i) in serviceHealthAlerts: if (!empty(serviceHealthAlerts)) {
    scope: resourceGroup(subscriptionId, serviceHealthAlertsResourceGroupName)
    dependsOn: [
      alertsResourceGroup
    ]
    params: {
      name: alert.?serviceHealthAlert ?? serviceHealthAlertsMap[i].alertName
      conditions: filter(serviceHealthAlertsMap, alertMap => alertMap.serviceHealthAlert == alert.?serviceHealthAlert)[0].condition.allOf
      alertDescription: alert.?alertDescription ?? serviceHealthAlertsMap[i].serviceHealthAlert
      actions: !empty(alert.?actionGroup)
        ? [
            createActionGroups[i].outputs.resourceId
          ]
        : null
      enabled: alert.?isEnabled ?? true
      location: 'Global'
      tags: tags
      lock: lock
      enableTelemetry: enableTelemetry
    }
  }
]

module createActionGroups 'br/public:avm/res/insights/action-group:0.7.0' = [
  for alert in serviceHealthAlerts: if (!empty(alert.?actionGroup)) {
    scope: resourceGroup(subscriptionId, serviceHealthAlertsResourceGroupName)
    dependsOn: [
      alertsResourceGroup
    ]
    params: {
      name: alert.?actionGroup.?name ?? '${alert.?alertName}-action-group'
      groupShortName: alert.?actionGroup.?groupShortName ?? take(alert.?alertName ?? 'servicehealth', 12)
      location: 'Global'
      lock: lock
      tags: tags
      enableTelemetry: enableTelemetry
      enabled: alert.?actionGroup.?enabled ?? true
      azureFunctionReceivers: alert.?actionGroup.?azureFunctionReceivers ?? []
      voiceReceivers: alert.?actionGroup.?voiceReceivers ?? []
      webhookReceivers: alert.?actionGroup.?webhookReceivers ?? []
      armRoleReceivers: alert.?actionGroup.?armRoleReceivers ?? []
      automationRunbookReceivers: alert.?actionGroup.?automationRunbookReceivers ?? []
      azureAppPushReceivers: alert.?actionGroup.?azureAppPushReceivers ?? []
      emailReceivers: alert.?actionGroup.?emailReceivers ?? []
      eventHubReceivers: alert.?actionGroup.?eventHubReceivers ?? []
      itsmReceivers: alert.?actionGroup.?itsmReceivers ?? []
      logicAppReceivers: alert.?actionGroup.?logicAppReceivers ?? []
      smsReceivers: alert.?actionGroup.?smsReceivers ?? []
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource IDs of the created alerts.')
output alertsResourceIds array = [
  for (alert, i) in serviceHealthAlerts: {
    alertResourceId: createServiceHealthAlerts[i].outputs.resourceId
  }
]

@description('The resource IDs of the created action groups.')
output actionGroupResourceIds array = [
  for (actionGroup, i) in serviceHealthAlerts: (!empty(actionGroup.?actionGroup))
    ? {
        actionGroupResourceId: createActionGroups[i].outputs.resourceId
      }
    : null
]

// ================ //
// Definitions      //
// ================ //

type serviceHealthAlertType = {
  @description('Optional. The service health alerts to enable.')
  serviceHealthAlert:
    | 'Resource Health Unhealthy'
    | 'Service Health Advisory'
    | 'Service Health Incident'
    | 'Service Health Maintenance'
    | 'Service Health Security'?

  @description('Optional. The name of the service health alert.')
  alertName: string?

  @description('Optional. The description of the service health alert.')
  alertDescription: string?

  @description('Optional. Flag to enable or disable the alert.')
  isEnabled: bool?

  @description('Optional. The action group to use for the alert.')
  actionGroup: actionGroupType?
}

type actionGroupType = {
  @description('Required. The name of the action group.')
  name: string

  @description('Optional. The short name of the action group. Max length is 12 characters.')
  groupShortName: string?

  @description('Required. Flag to enable or disable the action group.')
  enabled: bool

  @description('Optional. The list of email receivers for the action group.')
  emailReceivers: emailReceiversType[]?

  @description('Optional. The list of event hub receivers for the action group.')
  eventHubReceivers: eventHubReceiversType[]?

  @description('Optional. The list of SMS receivers for the action group.')
  smsReceivers: smsReceiversType[]?

  @description('Optional. The list of webhook receivers for the action group.')
  webhookReceivers: webhookReceiversType[]?

  @description('Optional. The list of ITSM receivers for the action group.')
  itsmReceivers: itsmReceiversType[]?

  @description('Optional. The list of Azure App Push receivers for the action group.')
  azureAppPushReceivers: azureAppPushReceiversType[]?

  @description('Optional. The list of automation runbook receivers for the action group.')
  automationRunbookReceivers: automationRunbookReceiversType[]?

  @description('Optional. The list of voice receivers for the action group.')
  voiceReceivers: voiceReceiverType[]?

  @description('Optional. The list of logic app receivers for the action group.')
  logicAppReceivers: logicAppReceiversType[]?

  @description('Optional. The list of ARM role receivers for the action group.')
  armRoleReceivers: armRoleReceiversType[]?

  @description('Optional. The list of Azure function receivers for the action group.')
  azureFunctionReceivers: azureFunctionReceiversType[]?

  @description('Optional. The list of incident receivers for the action group.')
  incidentReceivers: incidentReceiverType[]?
}

type incidentReceiverType = {
  @description('Required. The name of the incident receiver.')
  name: string

  @description('Required. The incident management service type.')
  incidentManagementService: 'Icm'

  @description('Required. The connection details for the incident management service.')
  connection: incidentReceiverConnectionType

  @description('Required. The list of Field mappings for the incident service.')
  mappings: object
}

type incidentReceiverConnectionType = {
  @description('Required. GUID value representing the connection ID for the incident management service.')
  id: string

  @description('Required. The name of the connection.')
  name: string
}

type armRoleReceiversType = {
  @description('Required. The name of the ARM role receiver.')
  name: string

  @description('Required. The role ID of the ARM role receiver.')
  roleId: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?
}

type automationRunbookReceiversType = {
  @description('Required. The resource Id of the automation runbook account.')
  automationAccountId: string

  @description('Required. Flag to indicate if the runbook is global.')
  isGlobalRunbook: bool

  @description('Optional. The principal id of the managed identity.')
  managedIdentity: 'SystemAssigned' | 'None'?

  @description('Optional. The name of the webhook.')
  name: string?

  @description('Required. The name of the runbook.')
  runbookName: string

  @description('Required. The URI where webhooks should be sent.')
  serviceUri: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?

  @description('Required. The resource Id of the webhook.')
  webhookResourceId: string
}

type azureAppPushReceiversType = {
  @description('Required. The email address registered for the Azure mobile app.')
  emailAddress: string

  @description('Required. The name of the Azure mobile app push receiver.')
  name: string
}

type eventHubReceiversType = {
  @description('Required. The name of the specific Event Hub queue.')
  eventHubName: string

  @description('Required. The Event Hub namespace.')
  eventHubNameSpace: string

  @description('Optional. The principal id of the managed identity.')
  managedIdentity: 'SystemAssigned' | 'None'?

  @description('Required. The name of the Event Hub receiver.')
  name: string

  @description('Required. The Id for the subscription containing this event hub.')
  subscriptionId: string

  @description('Required. The tenant Id for the subscription containing this event hub.')
  tenantId: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?
}

type itsmReceiversType = {
  @description('Required. Unique identification of ITSM connection.')
  connectionId: string

  @description('Required. The name of the ITSM connection.')
  name: string

  @description('Required. Region in which workspace resides. Supported values:\'centralindia\',\'japaneast\',\'southeastasia\',\'australiasoutheast\',\'uksouth\',\'westcentralus\',\'canadacentral\',\'eastus\',\'westeurope\'.')
  region: string

  @description('Required. JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.')
  ticketConfiguration: string

  @description('Required. Log analytics workspace Id.')
  workspaceId: string
}

type logicAppReceiversType = {
  @description('Required. The callback url where http request sent to.')
  callbackUrl: string

  @description('Optional. The principal id of the managed identity.')
  managedIdentity: 'SystemAssigned' | 'None'?

  @description('Required. The name of the logic app receiver.')
  name: string

  @description('Required. The resource Id of the logic app.')
  resourceId: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?
}

type smsReceiversType = {
  @description('Required. The country code of the SMS receiver.')
  countryCode: string

  @description('Required. The phone number of the SMS receiver.')
  phoneNumber: string

  @description('Required. The name of the SMS receiver.')
  name: string
}

type voiceReceiverType = {
  @description('Required. The country code of the voice receiver.')
  countryCode: string

  @description('Required. The phone number of the voice receiver.')
  phoneNumber: string

  @description('Required. The name of the voice receiver.')
  name: string
}

type webhookReceiversType = {
  @description('Optional. The identifier uri for aad auth.')
  identifierUri: string?

  @description('Optional. The principal id of the managed identity.')
  managedIdentity: 'SystemAssigned' | 'None'?

  @description('Required. The name of the webhook receiver.')
  name: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?

  @description('Optional. The webhook app object Id for aad auth.')
  objectId: string?

  @description('Required. The URI where webhooks should be sent.')
  serviceUri: string

  @description('Optional. The tenant Id.')
  tenantId: string?

  @description('Optional. Flag to use Entra ID autentication.')
  useAadAuth: bool?
}

type emailReceiversType = {
  @description('Required. The email address of the email receiver.')
  emailAddress: string

  @description('Required. The name of the email receiver.')
  name: string

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?
}

type azureFunctionReceiversType = {
  @description('Required. The name of the Azure function in the function App.')
  functionName: string

  @description('Required. TThe resource Id of the function App.')
  functionAppResourceId: string

  @description('Optional. The principal id of the managed identity.')
  managedIdentity: 'SystemAssigned' | 'None'?

  @description('Optional. Flag to use common alert schema.')
  useCommonAlertSchema: bool?

  @description('Required. The http trigger url where http request sent to.')
  httpTriggerUrl: string

  @description('Required. The name of the Azure function receiver.')
  name: string
}
