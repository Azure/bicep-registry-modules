metadata name = 'Healthcare API Workspace IoT Connectors'
metadata description = 'This module deploys a Healthcare API Workspace IoT Connector.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the MedTech service.')
@maxLength(50)
param name string

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. Event Hub name to connect to.')
param eventHubName string

@description('Optional. Consumer group of the event hub to connected to.')
param consumerGroup string = name

@description('Required. Namespace of the Event Hub to connect to.')
param eventHubNamespaceName string

@description('Required. The mapping JSON that determines how incoming device data is normalized.')
param deviceMapping object = {
  templateType: 'CollectionContent'
  template: []
}

@description('Optional. FHIR Destination.')
param fhirdestination object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

// =========== //
// Deployments //
// =========== //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

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
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: iotConnector
}

resource iotConnector_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: iotConnector
}]

module fhir_destination 'fhirdestination/main.bicep' = if (!empty(fhirdestination)) {
  name: '${deployment().name}-FhirDestination'
  params: {
    name: '${uniqueString(workspaceName, iotConnector.name)}-map'
    iotConnectorName: iotConnector.name
    resourceIdentityResolutionType: contains(fhirdestination, 'resourceIdentityResolutionType') ? fhirdestination.resourceIdentityResolutionType : 'Lookup'
    fhirServiceResourceId: fhirdestination.fhirServiceResourceId
    destinationMapping: contains(fhirdestination, 'destinationMapping') ? fhirdestination.destinationMapping : {
      templateType: 'CollectionFhir'
      template: []
    }
    enableDefaultTelemetry: enableReferencedModulesTelemetry
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
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(iotConnector.identity, 'principalId') ? iotConnector.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = iotConnector.location

@description('The name of the medtech workspace.')
output workspaceName string = workspace.name

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
  }[]?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
