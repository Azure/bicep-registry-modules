@description('Optional. Name for the Event Hub cluster, Alphanumerics and hyphens characters, Start with letter, End with letter or number.')
param clusterName string = 'null'

@description('Optional. The quantity of Event Hubs Cluster Capacity Units contained in this cluster.')
param clusterCapacity int = 1

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('''Optional. The name of the event hub namespace to be created.
Below paramters you can pass while creating the Azure Event Hub namespace.
sku: (Optional) Possible values are "Basic" or "Standard" or "Premium". Detault to 'Standard'.
capacity: (Optional) int, The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units.The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units. Default to 1.
zoneRedundant: (Optional) bool, Enabling this property creates a Standard Event Hubs Namespace in regions supported availability zones. Default to false.
isAutoInflateEnabled: (Optional) bool,  Value that indicates whether AutoInflate is enabled for eventhub namespace. Only available for "Standard" sku. Default to false.
maximumThroughputUnits: (Optional) int, Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. ( '0' if AutoInflateEnabled = true)
disableLocalAuth: (Optional) bool, This property disables SAS authentication for the Event Hubs namespace. Default to false.
kafkaEnabled: (Optional) bool, Value that indicates whether Kafka is enabled for eventhub namespace. Default to true.
''')
param eventHubNamespaces object = {}

@description(''' Optional. Name for the eventhub to be created.
Below paramters you can pass while the creating Azure Event Hub
messageRetentionInDays: (Optional) int, Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Default to 1.
partitionCount: (Optional) int, Number of partitions created for the Event Hub. Default to 2
eventHubNamespaceName: (Optional) string, Name of the Azure Event Hub Namespace
status: (Optional) string, Enumerates the possible values for the status of the Event Hub. 'Active','Creating','Deleting','Disabled','ReceiveDisabled','Renaming','Restoring','SendDisabled','Unknown'. Default to 'Active'
''')
param eventHubs object = {}

@description('Optional. Authorization Rules for the Event Hub Namespace.')
param namespaceAuthorizationRules object = {}

@description('Optional. Authorization Rules for the Event Hub .')
param eventHubAuthorizationRules object = {}

@description('Optional. consumer groups for the Event Hub .')
param consumerGroups object = {}

@description('Optional. The disaster recovery config for the namespace.')
param disasterRecoveryConfigs object = {}

@description('Optional. The Diagnostics Settings config for the namespace.')
param diagnosticSettings object = {}

var varEventHubNamespaces = [for eventHubnamespace in items(eventHubNamespaces): {
  eventHubNamespaceName: eventHubnamespace.key
  sku: contains(eventHubnamespace.value, 'sku')? eventHubnamespace.value.sku : 'Standard'
  capacity: contains(eventHubnamespace.value, 'capacity') ? eventHubnamespace.value.capacity: 1
  zoneRedundant: contains(eventHubnamespace.value, 'zoneRedundant') ? eventHubnamespace.value.zoneRedundant : false
  isAutoInflateEnabled: contains(eventHubnamespace.value, 'isAutoInflateEnabled') ? eventHubnamespace.value.isAutoInflateEnabled: false
  maximumThroughputUnits: contains(eventHubnamespace.value, 'maximumThroughputUnits') ? eventHubnamespace.value.maximumThroughputUnits: 0
  disableLocalAuth: contains(eventHubnamespace.value, 'disableLocalAuth') ? eventHubnamespace.value.disableLocalAuth: false
  kafkaEnabled: contains(eventHubnamespace.value, 'kafkaEnabled') ? eventHubnamespace.value.kafkaEnabled: true
}]

var varNamespaceAuthorizationRules =  [for namespaceAuthorizationRule in items(namespaceAuthorizationRules): {
  eventHubNamespaceAuthorizationRuleName: namespaceAuthorizationRule.key
  rights: contains(namespaceAuthorizationRule.value, 'rights') ? namespaceAuthorizationRule.value.rights : []
  eventHubNamespaceName: namespaceAuthorizationRule.value.eventHubNamespaceName
}]

var varDisasterRecoveryConfigs =  [for disasterRecoveryConfig in items(disasterRecoveryConfigs): {
  disasterRecoveryConfigname: disasterRecoveryConfig.key
  partnerNamespaceId: contains(disasterRecoveryConfig.value, 'partnerNamespaceId') ? disasterRecoveryConfig.value.partnerNamespaceId : ''
  eventHubNamespaceName: disasterRecoveryConfig.value.eventHubNamespaceName
}]

var varEventHubs =  [for eventHub in items(eventHubs): {
  eventHubName: eventHub.key
  messageRetentionInDays: contains(eventHub.value, 'messageRetentionInDays') ? eventHub.value.messageRetentionInDays : 1
  partitionCount: contains(eventHub.value, 'partitionCount') ? eventHub.value.partitionCount : 2
  eventHubNamespaceName: eventHub.value.eventHubNamespaceName
  status: contains(eventHub.value, 'status') ? eventHub.value.status : 'Active'
  captureDescriptionDestinationArchiveNameFormat: contains(eventHub.value, 'captureDescriptionDestinationArchiveNameFormat') ? eventHub.value.captureDescriptionDestinationArchiveNameFormat : '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
  captureDescriptionDestinationBlobContainer: contains(eventHub.value, 'captureDescriptionDestinationBlobContainer') ? eventHub.value.captureDescriptionDestinationBlobContainer : ''
  captureDescriptionDestinationName: contains(eventHub.value, 'captureDescriptionDestinationName') ? eventHub.value.captureDescriptionDestinationName : 'EventHubArchive.AzureBlockBlob'
  captureDescriptionDestinationStorageAccountResourceId: contains(eventHub.value, 'captureDescriptionDestinationStorageAccountResourceId') ? eventHub.value.captureDescriptionDestinationStorageAccountResourceId : ''
  captureDescriptionEnabled: contains(eventHub.value, 'captureDescriptionEnabled') ? eventHub.value.captureDescriptionEnabled : false
  captureDescriptionEncoding: contains(eventHub.value, 'captureDescriptionEncoding') ? eventHub.value.captureDescriptionEncoding : 'Avro'
  captureDescriptionIntervalInSeconds: contains(eventHub.value, 'captureDescriptionIntervalInSeconds') ? eventHub.value.captureDescriptionIntervalInSeconds : 300
  captureDescriptionSizeLimitInBytes: contains(eventHub.value, 'captureDescriptionSizeLimitInBytes') ? eventHub.value.captureDescriptionSizeLimitInBytes : 314572800
  captureDescriptionSkipEmptyArchives: contains(eventHub.value, 'captureDescriptionSkipEmptyArchives') ? eventHub.value.captureDescriptionSkipEmptyArchives : false
}]

var varEventHubAuthorizationRules =  [for eventHubAuthorizationRule in items(eventHubAuthorizationRules): {
  eventHubAuthorizationRuleName: eventHubAuthorizationRule.key
  rights: contains(eventHubAuthorizationRule.value, 'rights') ? eventHubAuthorizationRule.value.rights : []
  eventHubNamespaceName: eventHubAuthorizationRule.value.eventHubNamespaceName
  eventHubName: eventHubAuthorizationRule.value.eventHubName
}]

var varConsumerGroups =  [for consumerGroup in items(consumerGroups): {
  consumerGroupName: consumerGroup.key
  eventHubNamespaceName: consumerGroup.value.eventHubNamespaceName
  eventHubName: consumerGroup.value.eventHubName
  userMetadata: contains(consumerGroup.value, 'userMetadata') ? consumerGroup.value.userMetadata : ''
}]

var varDiagnosticSettings = [for diagnosticSetting in items(diagnosticSettings): {
  diagnosticSettingName: diagnosticSetting.key
  diagnosticEnableNamespaceName: diagnosticSetting.value.diagnosticEnablenamespaceName
  diagnosticStorageAccountId: contains(diagnosticSetting.value, 'diagnosticStorageAccountId') ? diagnosticSetting.value.diagnosticStorageAccountId : ''
  diagnosticWorkspaceId: contains(diagnosticSetting.value, 'diagnosticWorkspaceId') ? diagnosticSetting.value.diagnosticWorkspaceId : ''
  diagnosticEventHubAuthorizationRuleId: contains(diagnosticSetting.value, 'diagnosticEventHubAuthorizationRuleId') ? diagnosticSetting.value.diagnosticEventHubAuthorizationRuleId : ''
  diagnosticEventHubName: contains(diagnosticSetting.value, 'diagnosticEventHubName') ? diagnosticSetting.value.diagnosticEventHubName : ''
  diagnosticsMetrics: contains(diagnosticSetting.value, 'diagnosticsMetrics') ? diagnosticSetting.value.diagnosticsMetrics : []
  diagnosticsLogs: contains(diagnosticSetting.value, 'diagnosticsLogs') ? diagnosticSetting.value.diagnosticsLogs : []
}]

resource cluster 'Microsoft.EventHub/clusters@2021-11-01' = if (clusterName != 'null' )  {
  name: clusterName
  location: location
  tags: tags
  sku: {
    name: 'Dedicated'
    capacity: clusterCapacity
  }
  properties: {}
  dependsOn: [
    resourceGroup()
  ]
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = [for varEventHubNamespace in varEventHubNamespaces: if (!empty(eventHubNamespaces)) {
  name: varEventHubNamespace.eventHubNamespaceName
  location: location
  sku: {
    name: varEventHubNamespace.sku
    tier: varEventHubNamespace.sku
    capacity: varEventHubNamespace.capacity
  }
  properties: {
    disableLocalAuth: varEventHubNamespace.disableLocalAuth
    kafkaEnabled: varEventHubNamespace.kafkaEnabled
    isAutoInflateEnabled: varEventHubNamespace.isAutoInflateEnabled
    maximumThroughputUnits: ((varEventHubNamespace.isAutoInflateEnabled) ? varEventHubNamespace.maximumThroughputUnits : 0)
    zoneRedundant: varEventHubNamespace.zoneRedundant
    clusterArmId: (clusterName != 'null') ? cluster.id: null
  }
  tags: tags
}]

module eventHubNamespace_authorizationRules 'modules/authorizationRules.bicep' = [for (varNamespaceAuthorizationRule, index) in varNamespaceAuthorizationRules: if (!empty(namespaceAuthorizationRules)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-AuthRule-${index}'
  params: {
    namespaceName: varNamespaceAuthorizationRule.eventHubNamespaceName
    name: varNamespaceAuthorizationRule.eventHubNamespaceAuthorizationRuleName
    rights: varNamespaceAuthorizationRule.rights
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHubNamespace_disasterRecoveryConfigs 'modules/disasterRecoveryConfigs.bicep' = [for (varDisasterRecoveryConfig, index) in varDisasterRecoveryConfigs: if (!empty(disasterRecoveryConfigs)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-DisRecConfig-${index}'
  params: {
    namespaceName: varDisasterRecoveryConfig.eventHubNamespaceName
    name: varDisasterRecoveryConfig.disasterRecoveryConfigname
    partnerNamespaceId: varDisasterRecoveryConfig.partnerNamespaceId
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHubNamespace_eventHubs 'modules/eventHubs/deploy.bicep' = [for (varEventHub, index) in varEventHubs: if (!empty(eventHubs)){
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-EventHub-${index}'
  params: {
    namespaceName: varEventHub.eventHubNamespaceName
    name: varEventHub.eventHubName
    messageRetentionInDays: varEventHub.messageRetentionInDays
    partitionCount: varEventHub.partitionCount
    status: varEventHub.status
    captureDescriptionEnabled: varEventHub.captureDescriptionEnabled
    captureDescriptionDestinationArchiveNameFormat: varEventHub.captureDescriptionDestinationArchiveNameFormat
    captureDescriptionDestinationBlobContainer: varEventHub.captureDescriptionDestinationBlobContainer
    captureDescriptionDestinationName: varEventHub.captureDescriptionDestinationName
    captureDescriptionDestinationStorageAccountResourceId: varEventHub.captureDescriptionDestinationStorageAccountResourceId
    captureDescriptionEncoding:  varEventHub.captureDescriptionEncoding
    captureDescriptionIntervalInSeconds: varEventHub.captureDescriptionIntervalInSeconds
    captureDescriptionSizeLimitInBytes: varEventHub.captureDescriptionSizeLimitInBytes
    captureDescriptionSkipEmptyArchives: varEventHub.captureDescriptionSkipEmptyArchives
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHub_authorizationRules 'modules/eventHubs/authorizationRules.bicep' = [for (varEventHubAuthorizationRule, index) in varEventHubAuthorizationRules: if (!empty(eventHubAuthorizationRules)) {
  name: '${uniqueString(deployment().name, location)}-Evhub-AuthRule-${index}'
  params: {
    namespaceName: varEventHubAuthorizationRule.eventHubNamespaceName
    eventHubName: varEventHubAuthorizationRule.eventHubName
    name: varEventHubAuthorizationRule.eventHubAuthorizationRuleName
    rights: varEventHubAuthorizationRule.rights
  }
  dependsOn: [
    eventHubNamespace_eventHubs
  ]
}]

module eventHub_consumerGroup 'modules/eventHubs/consumerGroups.bicep' = [for (varConsumerGroup, index) in varConsumerGroups: if (!empty(consumerGroups)) {
  name: '${deployment().name}-ConsumerGroup-${index}'
  params: {
    namespaceName: varConsumerGroup.eventHubNamespaceName
    eventHubName: varConsumerGroup.eventHubName
    name: varConsumerGroup.consumerGroupName
    userMetadata: varConsumerGroup.userMetadata
  }
  dependsOn: [
    eventHubNamespace_eventHubs
  ]
}]

module eventHubNamespace_diagnosticSettings 'modules/diagnosticSettings.bicep' = [for (varDiagnosticSetting, index) in varDiagnosticSettings: if (!empty(diagnosticSettings)) {
  name: '${deployment().name}-diagnosticSettings-${index}'
  params: {
    namespaceName: varDiagnosticSetting.diagnosticEnableNamespaceName
    name: varDiagnosticSetting.diagnosticSettingName
    diagnosticStorageAccountId: varDiagnosticSetting.diagnosticStorageAccountId
    diagnosticWorkspaceId: varDiagnosticSetting.diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: varDiagnosticSetting.diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName:varDiagnosticSetting.diagnosticEventHubName
    diagnosticsMetrics: varDiagnosticSetting.diagnosticsMetrics
    diagnosticsLogs: varDiagnosticSetting.diagnosticsLogs
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

@description('The resource group the Azure Event Hub was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('Azure Event Hub namespace details.')
output eventHubNamespaceDetails array = [for varEventHubNamespace in varEventHubNamespaces: {
  id: reference(varEventHubNamespace.eventHubNamespaceName,'2021-11-01','Full').resourceId
  serviceBusEndpoint: reference(varEventHubNamespace.eventHubNamespaceName,'2021-11-01','Full').properties.serviceBusEndpoint
  status: reference(varEventHubNamespace.eventHubNamespaceName,'2021-11-01','Full').properties.status
}]
