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
param eventHubNamespaces array = [
  {
    name: 'evns-${uniqueString(resourceGroup().id)}'
    sku: 'Standard'
    capacity: 1
    maximumThroughputUnits: 0
    zoneRedundant: false
    isAutoInflateEnabled: false
    disableLocalAuth: false
    kafkaEnabled: true
  }
]

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
param eventHubs array = []

@description('Optional. Authorization Rules for the Event Hub Namespace.')
param namespaceAuthorizationRules array = []

@description('Optional. Role assignments for the namespace.')
param namespaceRoleAssignments array = []

@description('Optional. The disaster recovery config for the namespace.')
param disasterRecoveryConfigs array = []

@description('Optional. The Diagnostics Settings config for the namespace.')
param diagnosticSettings array = []

@description('Optional. Authorization Rules for the Event Hub .')
param eventHubAuthorizationRules array = []

@description('Optional. consumer groups for the Event Hub .')
param consumerGroups array = []

@description('Define Private Endpoints that should be created for Azure EventHub Namespace.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure EventHub Namespace should be enabled.')
param privateEndpointsApprovalEnabled bool = false

var varEventHubNamespaces = [for eventHubnamespace in eventHubNamespaces: {
  eventHubNamespaceName: eventHubnamespace.name
  sku: contains(eventHubnamespace, 'sku') ? eventHubnamespace.sku : 'Standard'
  capacity: contains(eventHubnamespace, 'capacity') ? eventHubnamespace.capacity : 1
  zoneRedundant: contains(eventHubnamespace, 'zoneRedundant') ? eventHubnamespace.zoneRedundant : false
  isAutoInflateEnabled: contains(eventHubnamespace, 'isAutoInflateEnabled') ? eventHubnamespace.isAutoInflateEnabled : false
  maximumThroughputUnits: contains(eventHubnamespace, 'maximumThroughputUnits') ? eventHubnamespace.maximumThroughputUnits : 0
  disableLocalAuth: contains(eventHubnamespace, 'disableLocalAuth') ? eventHubnamespace.disableLocalAuth : false
  kafkaEnabled: contains(eventHubnamespace, 'kafkaEnabled') ? eventHubnamespace.kafkaEnabled : true
}]

var varNamespaceAuthorizationRules = [for namespaceAuthorizationRule in namespaceAuthorizationRules: {
  eventHubNamespaceAuthorizationRuleName: namespaceAuthorizationRule.name
  rights: contains(namespaceAuthorizationRule, 'rights') ? namespaceAuthorizationRule.rights : []
  eventHubNamespaceName: namespaceAuthorizationRule.eventHubNamespaceName
}]

var varDisasterRecoveryConfigs = [for disasterRecoveryConfig in disasterRecoveryConfigs: {
  disasterRecoveryConfigname: disasterRecoveryConfig.name
  partnerNamespaceId: contains(disasterRecoveryConfig, 'partnerNamespaceId') ? disasterRecoveryConfig.partnerNamespaceId : ''
  eventHubNamespaceName: disasterRecoveryConfig.eventHubNamespaceName
}]

var varEventHubs = [for eventHub in eventHubs: {
  eventHubName: eventHub.name
  messageRetentionInDays: contains(eventHub, 'messageRetentionInDays') ? eventHub.messageRetentionInDays : 1
  partitionCount: contains(eventHub, 'partitionCount') ? eventHub.partitionCount : 2
  eventHubNamespaceName: eventHub.eventHubNamespaceName
  status: contains(eventHub, 'status') ? eventHub.status : 'Active'
  captureDescriptionDestinationArchiveNameFormat: contains(eventHub, 'captureDescriptionDestinationArchiveNameFormat') ? eventHub.captureDescriptionDestinationArchiveNameFormat : '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
  captureDescriptionDestinationBlobContainer: contains(eventHub, 'captureDescriptionDestinationBlobContainer') ? eventHub.captureDescriptionDestinationBlobContainer : ''
  captureDescriptionDestinationName: contains(eventHub, 'captureDescriptionDestinationName') ? eventHub.captureDescriptionDestinationName : 'EventHubArchive.AzureBlockBlob'
  captureDescriptionDestinationStorageAccountResourceId: contains(eventHub, 'captureDescriptionDestinationStorageAccountResourceId') ? eventHub.captureDescriptionDestinationStorageAccountResourceId : ''
  captureDescriptionEnabled: contains(eventHub, 'captureDescriptionEnabled') ? eventHub.captureDescriptionEnabled : false
  captureDescriptionEncoding: contains(eventHub, 'captureDescriptionEncoding') ? eventHub.captureDescriptionEncoding : 'Avro'
  captureDescriptionIntervalInSeconds: contains(eventHub, 'captureDescriptionIntervalInSeconds') ? eventHub.captureDescriptionIntervalInSeconds : 300
  captureDescriptionSizeLimitInBytes: contains(eventHub, 'captureDescriptionSizeLimitInBytes') ? eventHub.captureDescriptionSizeLimitInBytes : 314572800
  captureDescriptionSkipEmptyArchives: contains(eventHub, 'captureDescriptionSkipEmptyArchives') ? eventHub.captureDescriptionSkipEmptyArchives : false
  roleAssignments: contains(eventHub, 'roleAssignments') ? eventHub.roleAssignments : []
}]

var varEventHubAuthorizationRules = [for eventHubAuthorizationRule in eventHubAuthorizationRules: {
  eventHubAuthorizationRuleName: eventHubAuthorizationRule.name
  rights: contains(eventHubAuthorizationRule, 'rights') ? eventHubAuthorizationRule.rights : []
  eventHubNamespaceName: eventHubAuthorizationRule.eventHubNamespaceName
  eventHubName: eventHubAuthorizationRule.eventHubName
}]

var varConsumerGroups = [for consumerGroup in consumerGroups: {
  consumerGroupName: consumerGroup.name
  eventHubNamespaceName: consumerGroup.eventHubNamespaceName
  eventHubName: consumerGroup.eventHubName
  userMetadata: contains(consumerGroup, 'userMetadata') ? consumerGroup.userMetadata : ''
}]

var varDiagnosticSettings = [for diagnosticSetting in diagnosticSettings: {
  diagnosticSettingName: diagnosticSetting.name
  diagnosticEnableNamespaceName: diagnosticSetting.diagnosticEnablenamespaceName
  diagnosticStorageAccountId: contains(diagnosticSetting, 'diagnosticStorageAccountId') ? diagnosticSetting.diagnosticStorageAccountId : ''
  diagnosticWorkspaceId: contains(diagnosticSetting, 'diagnosticWorkspaceId') ? diagnosticSetting.diagnosticWorkspaceId : ''
  diagnosticEventHubAuthorizationRuleId: contains(diagnosticSetting, 'diagnosticEventHubAuthorizationRuleId') ? diagnosticSetting.diagnosticEventHubAuthorizationRuleId : ''
  diagnosticEventHubName: contains(diagnosticSetting, 'diagnosticEventHubName') ? diagnosticSetting.diagnosticEventHubName : ''
  diagnosticsMetrics: contains(diagnosticSetting, 'diagnosticsMetrics') ? diagnosticSetting.diagnosticsMetrics : []
  diagnosticsLogs: contains(diagnosticSetting, 'diagnosticsLogs') ? diagnosticSetting.diagnosticsLogs : []
}]

var varNamespaceRoleAssignments = [for namespaceRoleAssignment in namespaceRoleAssignments: {
  eventHubNamespaceRoleAssignmentsName: namespaceRoleAssignment.name
  description: contains(namespaceRoleAssignment, 'description') ? namespaceRoleAssignment.description : ''
  principalIds: namespaceRoleAssignment.principalIds
  principalType: contains(namespaceRoleAssignment, 'principalType') ? namespaceRoleAssignment.principalType : ''
  roleDefinitionIdOrName: namespaceRoleAssignment.roleDefinitionIdOrName
  eventHubNamespaceName: namespaceRoleAssignment.eventHubNamespaceName
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

resource cluster 'Microsoft.EventHub/clusters@2021-11-01' = if (clusterName != 'null') {
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
    clusterArmId: (clusterName != 'null') ? cluster.id : null
  }
  tags: tags
}]

module eventHubNamespace_authorizationRules 'modules/authorizationRules.bicep' = [for (varNamespaceAuthorizationRule, index) in varNamespaceAuthorizationRules: {
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
    roleAssignmentsName: varNamespaceRoleAssignment.eventHubNamespaceRoleAssignmentsName
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
    captureDescriptionEncoding: varEventHub.captureDescriptionEncoding
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
    diagnosticEventHubName: varDiagnosticSetting.diagnosticEventHubName
    diagnosticsMetrics: varDiagnosticSetting.diagnosticsMetrics
    diagnosticsLogs: varDiagnosticSetting.diagnosticsLogs
  }
  dependsOn: [
    eventHubNamespace
  ]
}]

module eventHubNamespace_privateEndpoint 'modules/privateEndpoint.bicep' = [for (varPrivateEndpoint, index) in varPrivateEndpoints: {
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
  id: reference(varEventHubNamespace.eventHubNamespaceName, '2021-11-01', 'Full').resourceId
  serviceBusEndpoint: reference(varEventHubNamespace.eventHubNamespaceName, '2021-11-01', 'Full').properties.serviceBusEndpoint
  status: reference(varEventHubNamespace.eventHubNamespaceName, '2021-11-01', 'Full').properties.status
}]
