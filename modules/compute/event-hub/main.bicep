@description('Optional. Name for the Event Hub cluster, Alphanumerics and hyphens characters, Start with letter, End with letter or number.')
// We can not pass default variable value ''. Because it was showing The template resource '' of type 'Microsoft.EventHub/clusters' at line '1' is not valid. The name property cannot be null or empty.
param clusterName string = 'null'

@description('Optional. The quantity of Event Hubs Cluster Capacity Units contained in this cluster.')
param clusterCapacity int = 1

@description('Required. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. The list of the event hub namespaces with its configurations to be created.')
param namespaces namespacesType[] = [
  {
    name: 'evhns001'
    sku: 'Standard'
    capacity: 1
    disableLocalAuth: false
    kafkaEnabled: true
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    zoneRedundant: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
]

@description('Optional. Authorization Rules for the Event Hub Namespace.')
param namespaceAuthorizationRules authorizationRulesType[] = []

@description('Optional. Role assignments for the namespace.')
param namespaceRoleAssignments namespaceRoleAssignmentsType[] = []

@description('Optional. The disaster recovery config for the namespace.')
param namespaceDisasterRecoveryConfigs namespaceDisasterRecoveryConfigsType[] = []

@description('Optional. The Diagnostics Settings config for the namespace.')
param namespaceDiagnosticSettings namespaceDiagnosticSettingsType[] = []

@description('Optional. Name for the eventhub with its all configurations to be created.')
param eventHubs eventHubsType[] = []

@description('Optional. Authorization Rules for the Event Hub .')
param eventHubAuthorizationRules authorizationRulesType[] = []

@description('Optional. consumer groups for the Event Hub .')
param eventHubConsumerGroups eventHubConsumerGroupsType[] = []

@description('Private Endpoints that should be created for Azure EventHub Namespaces.')
param namespacePrivateEndpoints privateEndpointType[] = []

resource cluster 'Microsoft.EventHub/clusters@2022-10-01-preview' = if (clusterName != 'null') {
  name: clusterName
  location: location
  tags: tags
  sku: {
    name: 'Dedicated'
    capacity: clusterCapacity
  }
}

resource evhns 'Microsoft.EventHub/namespaces@2022-10-01-preview' = [for ns in namespaces: {
  name: ns.name
  location: location
  sku: {
    name: ns.?sku ?? 'Standard'
    capacity: ns.?capacity ?? 1
  }
  properties: {
    disableLocalAuth: ns.?disableLocalAuth ?? false
    kafkaEnabled: ns.?kafkaEnabled ?? true
    isAutoInflateEnabled: ns.?isAutoInflateEnabled ?? false
    maximumThroughputUnits: ns.?maximumThroughputUnits ?? 0
    zoneRedundant: ns.?zoneRedundant ?? false
    clusterArmId: (clusterName != 'null') ? cluster.id : null
    minimumTlsVersion: ns.?minimumTlsVersion ?? '1.2'
    publicNetworkAccess: ns.?publicNetworkAccess ?? 'Enabled'
  }
  tags: tags
}]

module evhns_authorizationRules 'modules/authorizationRule.bicep' = [for (rule, index) in namespaceAuthorizationRules: {
  name: '${uniqueString(deployment().name, location)}-evhns-authrule-${index}'
  params: {
    name: rule.name
    rights: rule.rights
    namespaceName: rule.namespaceName
  }
  dependsOn: [
    evhns
  ]
}]

module evhns_roleAssignments 'modules/roleAssignment.bicep' = [for (role, index) in namespaceRoleAssignments: {
  name: '${deployment().name}-evhns-role-${index}'
  params: {
    roleName: role.?name ?? ''
    description: role.?description ?? ''
    principalIds: role.principalIds
    principalType: role.?principalType ?? ''
    roleDefinitionIdOrName: role.roleDefinitionIdOrName
    namespaceName: role.namespaceName
  }
  dependsOn: [
    evhns
  ]
}]

module evhns_disasterRecoveryConfigs 'modules/disasterRecoveryConfig.bicep' = [for (drConfig, index) in namespaceDisasterRecoveryConfigs: {
  name: '${uniqueString(deployment().name, location)}-evhns-drconfig-${index}'
  params: {
    name: drConfig.name
    partnerNamespaceId: drConfig.partnerNamespaceId
    namespaceName: drConfig.namespaceName
  }
  dependsOn: [
    evhns
  ]
}]

module evh 'modules/eventHub/eventHub.bicep' = [for (evh, index) in eventHubs: {
  name: '${uniqueString(deployment().name, location)}-evh-${index}'
  params: {
    namespaceName: evh.namespaceName
    name: evh.name
    messageRetentionInDays: evh.?messageRetentionInDays ?? 1
    partitionCount: evh.?partitionCount ?? 2
    status: evh.?status ?? 'Active'
    captureDescriptionEnabled: evh.?captureDescriptionEnabled ?? false
    captureDescriptionEncoding: evh.?captureDescriptionEncoding ?? 'Avro'
    captureDescriptionIntervalInSeconds: evh.?captureDescriptionIntervalInSeconds ?? 300
    captureDescriptionSizeLimitInBytes: evh.?captureDescriptionSizeLimitInBytes ?? 314572800
    captureDescriptionSkipEmptyArchives: evh.?captureDescriptionSkipEmptyArchives ?? false
    captureDescriptionDestinationName: evh.?captureDescriptionDestinationName ?? 'EventHubArchive.AzureBlockBlob'
    captureDescriptionDestinationArchiveNameFormat: evh.?captureDescriptionDestinationArchiveNameFormat ?? '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
    captureDescriptionDestinationBlobContainer: evh.?captureDescriptionDestinationBlobContainer ?? ''
    captureDescriptionDestinationStorageAccountResourceId: evh.?captureDescriptionDestinationStorageAccountResourceId ?? ''
    captureDescriptionDestinationdataLakeAccountName: evh.?captureDescriptionDestinationdataLakeAccountName ?? ''
    captureDescriptionDestinationdataLakeFolderPath: evh.?captureDescriptionDestinationdataLakeFolderPath ?? ''
    captureDescriptionDestinationdataLakeSubscriptionId: evh.?captureDescriptionDestinationdataLakeSubscriptionId ?? ''
    roleAssignments: evh.?roleAssignments ?? []
  }
  dependsOn: [
    evhns
  ]
}]

module evh_authorizationRules 'modules/eventHub/authorizationRule.bicep' = [for (rule, index) in eventHubAuthorizationRules: {
  name: '${uniqueString(deployment().name, location)}-evh-authrule-${index}'
  params: {
    namespaceName: rule.namespaceName
    eventHubName: rule.eventHubName
    name: rule.name
    rights: rule.rights
  }
  dependsOn: [
    evh
  ]
}]

module evh_consumerGroups 'modules/eventHub/consumerGroup.bicep' = [for (cg, index) in eventHubConsumerGroups: {
  name: '${deployment().name}-evh-cg-${index}'
  params: {
    namespaceName: cg.namespaceName
    eventHubName: cg.eventHubName
    name: cg.name
    userMetadata: cg.?userMetadata ?? ''
  }
  dependsOn: [
    evh
  ]
}]

module evhns_diagnosticSettings 'modules/diagnosticSetting.bicep' = [for (ds, index) in namespaceDiagnosticSettings: {
  name: '${deployment().name}-evhns-diagnosticSettings-${index}'
  params: {
    namespaceName: ds.namespaceName
    name: ds.name
    storageAccountId: ds.?storageAccountId ?? ''
    workspaceId: ds.?workspaceId ?? ''
    eventHubAuthorizationRuleId: ds.?eventHubAuthorizationRuleId ?? ''
    eventHubName: ds.?eventHubName ?? ''
    metricsSettings: ds.?metricsSettings ?? []
    logsSettings: ds.?logsSettings ?? []
  }
  dependsOn: [
    evhns
  ]
}]

module evhns_privateEndpoints 'modules/privateEndpoint.bicep' = [for (pep, index) in namespacePrivateEndpoints: {
  name: '${uniqueString(deployment().name)}-evhns-pep-${index}'
  params: {
    name: pep.name
    namespaceName: pep.namespaceName
    location: location
    groupIds: pep.?groupIds ?? [ 'namespace' ]
    subnetId: pep.subnetId
    privateDnsZoneId: pep.?privateDnsZoneId ?? ''
    tags: tags
    manualApprovalEnabled: pep.?manualApprovalEnabled ?? false
  }
  dependsOn: [
    evhns
  ]
}]

// output
@description('Azure Event Hub namespace names.')
output eventHubNamespaceNames array = [for ns in namespaces: ns.name]

@description('Azure Event Hub namespace resource Ids.')
output eventHubNamespaceResourceIds array = [for ns in namespaces: resourceId('Microsoft.EventHub/namespaces', ns.name)]

// user defined type
type namespacesType = {
  @description('Name of the Event Hub Namespace.')
  name: string
  @description('SKU of the Event Hub Namespace. Possible values are "Basic" or "Standard" or "Premium')
  sku: ('Basic' | 'Standard' | 'Premium')?// Default 'Standard'
  @description('Event Hubs throughput units for Basic or Standard tiers where value should be 0 to 20 units. For Premium tier, value should be 0 to 10 premium units.')
  capacity: int?// Default 1
  @description('Enabling this property creates a Standard Event Hubs Namespace in regions supported availability zones.')
  zoneRedundant: bool?// Default false
  @description('Whether to enable AutoInflate or not.')
  isAutoInflateEnabled: bool?// Default false
  @description('Upper limit of throughput units when AutoInflate is enabled.')
  maximumThroughputUnits: int?// Default 0
  @description('Whether to enable Kafka or not.')
  kafkaEnabled: bool?// Default 'true'
  @description('Whethere tp disable SAS authentication or not.')
  disableLocalAuth: bool?// Default false
  @description('Whether to enable public network access or not.')
  publicNetworkAccess: ('Enabled' | 'Disabled' | 'SecuredByPerimeter')?// Default 'Enabled'
  @description('Set the minimum TLS version for the Event Hub Namespace.')
  minimumTlsVersion: ('1.0' | '1.1' | '1.2')?// Default '1.2'

}

type authorizationRulesType = {
  @description('Name of the namespace authorization rule.')
  name: string
  @description('The rights associated with the rule.')
  rights: string[]
  @description('The eventhub namespace name.')
  namespaceName: string
  @description('The eventhub name. Optional if the authorization rule is for namespace and not for an eventhub.')
  eventHubName: string?
}

type namespaceRoleAssignmentsType = {
  @description('Name of the namespace role assignment.')
  name: string?
  @description('The description of the role assignment.')
  description: string?
  @description('The principal ids associated with the role assignment.')
  principalIds: string[]
  @description('The principal type associated with the role assignment.')
  principalType: ('Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User')?
  @description('The role definition id or name associated with the role assignment.')
  roleDefinitionIdOrName: string
  @description('The eventhub namespace name.')
  namespaceName: string
}

type eventHubRoleAssignmentsType = {
  @description('Name of the namespace role assignment.')
  name: string?
  @description('The description of the role assignment.')
  description: string?
  @description('The principal ids associated with the role assignment.')
  principalIds: string[]
  @description('The principal type associated with the role assignment.')
  principalType: ('Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User')?
  @description('The role definition id or name associated with the role assignment.')
  roleDefinitionIdOrName: string
}

type namespaceDisasterRecoveryConfigsType = {
  @description('Name of the namespace disaster recovery config.')
  name: string
  @description('The resource id of the secondary partner namespace, which is part of GEO DR pairing.')
  partnerNamespaceId: string
  @description('The eventhub namespace name.')
  namespaceName: string
}

type eventHubsType = {
  @description('Name of the Event Hub.')
  name: string
  @description('The eventhub namespace name.')
  namespaceName: string
  @description('Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.')
  partitionCount: int?// Default 2
  @description('Number of days to retain the events for this Event Hub, value should be 1 to 7 days.')
  messageRetentionInDays: int?// Default 1
  @description('A value that indicates whether capture description is enabled.')
  captureDescriptionEnabled: bool?// Default false
  @description('TEnumerates the possible values for the encoding format of capture description.')
  captureDescriptionEncoding: ('Avro' | 'Parquet')?// Default 'Avro'
  @description('The time window allows you to set the frequency with which the capture to Azure Blobs will happen, value should between 60 to 900 seconds.')
  captureDescriptionIntervalInSeconds: int?
  @description('The size window defines the amount of data built up in your Event Hub before an capture operation, value should be between 10485760 to 524288000 bytes.')
  captureDescriptionSizeLimitInBytes: int?
  @description('A value that indicates whether to Skip Empty Archives')
  captureDescriptionSkipEmptyArchives: bool?
  @description('The eventhub capture destination name.')
  captureDescriptionDestinationName: ('EventHubArchive.AzureBlockBlob' | 'EventHubArchive.AzureDataLake')?// Default 'EventHubArchive.AzureBlockBlob'
  @description('Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}.')
  captureDescriptionDestinationArchiveNameFormat: string?
  @description('The eventhub capture description destination blob container name.')
  captureDescriptionDestinationBlobContainer: string?
  @description('TSubscription Id of Azure Data Lake Store')
  captureDescriptionDestinationStorageAccountResourceId: string?
  @description('The Azure Data Lake Store name for the captured events')
  captureDescriptionDestinationdataLakeAccountName: string?
  @description('The destination folder path for the captured events')
  captureDescriptionDestinationdataLakeFolderPath: string?
  @description('Subscription Id of Azure Data Lake Store')
  captureDescriptionDestinationdataLakeSubscriptionId: string?
  @description('The role assignements scoped to event hub.')
  roleAssignments: eventHubRoleAssignmentsType[]?
  @description('The possible values for the status of the Event Hub..')
  status: ('Active' | 'Disabled' | 'SendDisabled')?// Default 'Active'
}

type eventHubConsumerGroupsType = {
  @description('Name of the Event Hub Consumer Group.')
  name: string
  @description('The eventhub namespace name.')
  namespaceName: string
  @description('The eventhub name.')
  eventHubName: string
  @description('The user metadata.')
  userMetadata: string?
}

type namespaceDiagnosticSettingsType = {
  @description('Name of the namespace diagnostic setting.')
  name: string
  @description('The eventhub namespace name.')
  namespaceName: string
  @description('The log analytics workspace id.')
  workspaceId: string?
  @description('The storage account id.')
  storageAccountId: string?
  @description('The eventhub name.')
  eventHubName: string?
  @description('The eventhub authorization rule id.')
  eventHubAuthorizationRuleId: string?
  @description('The list of metic settings.')
  metricsSettings: metricSettingsType[]
  @description('The list of logs settings.')
  logsSettings: logSettingsType[]
}

type metricSettingsType = {
  @description('A value indicating whether this category is enabled.')
  enabled: bool
  @description('The category of the metrics.')
  category: ('AllMetrics')
  @description('The time grain of the metric in ISO8601 format.')
  timeGrain: string?
  @description('The retention policy of the metric.')
  retentionPolicy: retentionPolicyType?
}

type retentionPolicyType = {
  @description('The retention period of the metric.')
  days: int
  @description('The retention policy enabled flag.')
  enabled: bool
}

type logSettingsType = {
  @description('A value indicating whether this log is enabled.')
  enabled: bool
  @description('The category of the logs.')
  category: string?
  @description('The category group of the logs.')
  categoryGroup: ('allLogs' | 'audit')?
  @description('The retention policy of the logs.')
  retentionPolicy: retentionPolicyType?
}

type privateEndpointType = {
  @description('The name of the private endpoint.')
  name: string
  @description('The eventhub namespace name.')
  namespaceName: string
  @description('The subnet that the private endpoint should be created in.')
  subnetId: string
  @description('The subresource name of the target Azure resource that private endpoint will connect to.')
  groupIds: array?// Default ['namespace']
  @description('The ID of the private DNS zone in which private endpoint will register its private IP address.')
  privateDnsZoneId: string?
  @description('When set to true, users will need to manually approve the private endpoint connection request.')
  manualApprovalEnabled: bool?// Default false
  @description('Tags for the resource.')
  tags: { *: string }?
}
