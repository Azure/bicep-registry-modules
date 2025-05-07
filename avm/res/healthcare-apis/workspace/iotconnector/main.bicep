metadata name = 'Healthcare API Workspace IoT Connectors'
metadata description = 'This module deploys a Healthcare API Workspace IoT Connector.'

@minLength(3)
@maxLength(24)
@description('Required. The name of the MedTech service.')
param name string

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. Event Hub name to connect to.')
param eventHubName string

@description('Optional. Consumer group of the event hub to connected to.')
param consumerGroup string = name

@description('Required. Namespace of the Event Hub to connect to.')
param eventHubNamespaceName string

@description('Optional. The mapping JSON that determines how incoming device data is normalized.')
param deviceMapping object = {
  templateType: 'CollectionContent'
  template: []
}

@description('Optional. FHIR Destination.')
param fhirdestination object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the resource.')
param tags object?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// =========== //
// Deployments //
// =========== //
resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' existing = {
  name: workspaceName
}

resource iotConnector 'Microsoft.HealthcareApis/workspaces/iotconnectors@2022-06-01' = {
  name: name
  parent: workspace
  location: location
  tags: tags
  identity: identity
  properties: {
    ingestionEndpointConfiguration: {
      eventHubName: eventHubName
      consumerGroup: consumerGroup
      fullyQualifiedEventHubNamespace: '${eventHubNamespaceName}.servicebus.windows.net'
    }
    deviceMapping: {
      content: deviceMapping
    }
  }
}

resource iotConnector_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: iotConnector
}

resource iotConnector_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: iotConnector
  }
]

module fhir_destination 'fhirdestination/main.bicep' = if (!empty(fhirdestination)) {
  name: '${deployment().name}-FhirDestination'
  params: {
    name: '${uniqueString(workspaceName, iotConnector.name)}-map'
    iotConnectorName: iotConnector.name
    resourceIdentityResolutionType: fhirdestination.?resourceIdentityResolutionType
    fhirServiceResourceId: fhirdestination.fhirServiceResourceId
    destinationMapping: fhirdestination.?destinationMapping
    location: location
    workspaceName: workspaceName
  }
}

@description('The name of the medtech service.')
output name string = iotConnector.name

@description('The resource ID of the medtech service.')
output resourceId string = iotConnector.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = iotConnector.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = iotConnector.location

@description('The name of the medtech workspace.')
output workspaceName string = workspace.name
