@description('Optional. Name for the Event Hub cluster, Alphanumerics and hyphens characters, Start with letter, End with letter or number.')
// We can not pass default variable value ''. Because it was showing The template resource '' of type 'Microsoft.EventHub/clusters' at line '1' is not valid. The name property cannot be null or empty.
param clusterName string = 'null'

@description('Optional. The quantity of Event Hubs Cluster Capacity Units contained in this cluster.')
param clusterCapacity int = 1

@description('Required. Location for all resources.')
param location string

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
param eventHubNamespaces object = {
  'evns-${uniqueString(location)}': {
    sku: 'Standard'
    capacity:  1
    maximumThroughputUnits: 0
    zoneRedundant: false
    isAutoInflateEnabled: false
    disableLocalAuth: false
    kafkaEnabled: true
  }
}

@description(''' Optional. Name for the eventhub to be created.
Below paramters you can pass while the creating Azure Event Hub.
messageRetentionInDays: (Optional) int, Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Default to 1.
partitionCount: (Optional) int, Number of partitions created for the Event Hub. Default to 2.
eventHubNamespaceName: (Optional) string, Name of the Azure Event Hub Namespace.
status: (Optional) string, Enumerates the possible values for the status of the Event Hub. 'Active','Creating','Deleting','Disabled','ReceiveDisabled','Renaming','Restoring','SendDisabled','Unknown'. Default to 'Active'.
captureDescriptionDestinationName: (Optional) string, Name for capture destination.
captureDescriptionDestinationArchiveNameFormat: (Optional) string,  Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order.
captureDescriptionDestinationBlobContainer: (Optional) string, Blob container Name.
captureDescriptionDestinationStorageAccountResourceId: (Optional) string, Resource ID of the storage account to be used to create the blobs.
captureDescriptionEnabled: (Optional) boolean, A value that indicates whether capture description is enabled.
captureDescriptionEncoding: (Optional) string, Enumerates the possible values for the encoding format of capture description.
captureDescriptionIntervalInSeconds: (Optional) int, The time window allows you to set the frequency with which the capture to Azure Blobs will happen.
captureDescriptionSizeLimitInBytes: (Optional) int, The size window defines the amount of data built up in your Event Hub before an capture operation.
captureDescriptionSkipEmptyArchives: (Optional) boolean,  A value that indicates whether to Skip Empty Archives.
roleAssignments: (Optional) Array, Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.
''')
param eventHubs object = {}

@description('Optional. Authorization Rules for the Event Hub Namespace.')
param namespaceAuthorizationRules object = {}

@description('Optional. Role assignments for the namespace.')
param namespaceRoleAssignments object = {}

@description('Optional. The disaster recovery config for the namespace.')
param disasterRecoveryConfigs object = {}

@description('Optional. The Diagnostics Settings config for the namespace.')
param diagnosticSettings object = {}

@description('Optional. Authorization Rules for the Event Hub .')
param eventHubAuthorizationRules object = {}

@description('Optional. consumer groups for the Event Hub .')
param consumerGroups object = {}

@description('Define Private Endpoints that should be created for Azure Container Registry.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Container Registry should be enabled.')
param privateEndpointsApprovalEnabled bool = false

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
  roleAssignments: contains(eventHub.value, 'roleAssignments') ? eventHub.value.roleAssignments : []
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

var varNamespaceRoleAssignments =  [for namespaceRoleAssignment in items(namespaceRoleAssignments): {
  eventHubNamespaceAuthorizationRuleName: namespaceRoleAssignment.key
  description: contains(namespaceRoleAssignment.value, 'description') ? namespaceRoleAssignment.value.description : ''
  principalIds: namespaceRoleAssignment.value.principalIds
  principalType: contains(namespaceRoleAssignment.value, 'principalType') ? namespaceRoleAssignment.value.principalType: ''
  roleDefinitionIdOrName: namespaceRoleAssignment.value.roleDefinitionIdOrName
  eventHubNamespaceName: namespaceRoleAssignment.value.eventHubNamespaceName
}]

var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: privateEndpoint.name
  eventHubNamespaceName: privateEndpoint.eventHubNamespaceName
  groupIds: [
    'namespace'
  ]
  subnetId: privateEndpoint.subnetId
  customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
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

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = [for varEventHubNamespace in varEventHubNamespaces: {
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

module eventHubNamespace_authorizationRules 'modules/authorizationRules.bicep' = [for (varNamespaceAuthorizationRule, index) in varNamespaceAuthorizationRules:{
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

module eventHubNamespace_disasterRecoveryConfigs 'modules/disasterRecoveryConfigs.bicep' = [for (varDisasterRecoveryConfig, index) in varDisasterRecoveryConfigs: {
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

module eventHubNamespace_roleAssignments 'modules/roleAssignments.bicep' = [for (varNamespaceRoleAssignment, index) in varNamespaceRoleAssignments: {
  name: '${deployment().name}-Namespace-Rbac-${index}'
  params: {
    description: varNamespaceRoleAssignment.description
    principalIds: varNamespaceRoleAssignment.principalIds
    principalType: varNamespaceRoleAssignment.principalType
    roleDefinitionIdOrName: varNamespaceRoleAssignment.roleDefinitionIdOrName
    eventHubNamespaceName: varNamespaceRoleAssignment.eventHubNamespaceName
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHubNamespace_eventHubs 'modules/eventHubs/deploy.bicep' = [for (varEventHub, index) in varEventHubs: {
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
    roleAssignments: varEventHub.roleAssignments
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHub_authorizationRules 'modules/eventHubs/authorizationRules.bicep' = [for (varEventHubAuthorizationRule, index) in varEventHubAuthorizationRules: {
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

module eventHub_consumerGroup 'modules/eventHubs/consumerGroups.bicep' = [for (varConsumerGroup, index) in varConsumerGroups: {
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

module eventHubNamespace_diagnosticSettings 'modules/diagnosticSettings.bicep' = [for (varDiagnosticSetting, index) in varDiagnosticSettings: {
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

module eventHubNamespace_privateEndpoint 'modules/privateEndpoint.bicep'= [for (varPrivateEndpoint, index) in varPrivateEndpoints: {
  name: '${uniqueString(deployment().name)}-eventnamespace-private-endpoints-${index}'
  params: {
    name: varPrivateEndpoint.name
    namespaceName: varPrivateEndpoint.eventHubNamespaceName
    location: location
    groupIds: varPrivateEndpoint.groupIds
    subnetId: varPrivateEndpoint.subnetId
    privateDnsZones: contains(varPrivateEndpoint, 'privateDnsZones') ? varPrivateEndpoint.privateDnsZones : []
    customNetworkInterfaceName: varPrivateEndpoint.customNetworkInterfaceName
    tags: tags
    manualApprovalEnabled: privateEndpointsApprovalEnabled
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
