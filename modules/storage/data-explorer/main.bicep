type kustoSku = 'Dev(No SLA)_Standard_D11_v2' | 'Dev(No SLA)_Standard_E2a_v4' | 'Standard_D11_v2' | 'Standard_D12_v2' | 'Standard_D13_v2' | 'Standard_D14_v2' | 'Standard_D16d_v5' | 'Standard_D32d_v4' | 'Standard_D32d_v5' | 'Standard_DS13_v2+1TB_PS' | 'Standard_DS13_v2+2TB_PS' | 'Standard_DS14_v2+3TB_PS' | 'Standard_DS14_v2+4TB_PS' | 'Standard_E16a_v4' | 'Standard_E16ads_v5' | 'Standard_E16as_v4+3TB_PS' | 'Standard_E16as_v4+4TB_PS' | 'Standard_E16as_v5+3TB_PS' | 'Standard_E16as_v5+4TB_PS' | 'Standard_E16d_v4' | 'Standard_E16d_v5' | 'Standard_E16s_v4+3TB_PS' | 'Standard_E16s_v4+4TB_PS' | 'Standard_E16s_v5+3TB_PS' | 'Standard_E16s_v5+4TB_PS' | 'Standard_E2a_v4' | 'Standard_E2ads_v5' | 'Standard_E2d_v4' | 'Standard_E2d_v5' | 'Standard_E4a_v4' | 'Standard_E4ads_v5' | 'Standard_E4d_v4' | 'Standard_E4d_v5' | 'Standard_E64i_v3' | 'Standard_E80ids_v4' | 'Standard_E8a_v4' | 'Standard_E8ads_v5' | 'Standard_E8as_v4+1TB_PS' | 'Standard_E8as_v4+2TB_PS' | 'Standard_E8as_v5+1TB_PS' | 'Standard_E8as_v5+2TB_PS' | 'Standard_E8d_v4' | 'Standard_E8d_v5' | 'Standard_E8s_v4+1TB_PS' | 'Standard_E8s_v4+2TB_PS' | 'Standard_E8s_v5+1TB_PS' | 'Standard_E8s_v5+2TB_PS' | 'Standard_EC16ads_v5' | 'Standard_EC16as_v5+3TB_PS'

type kustoTier = 'Basic' | 'Standard'

@minValue(0)
@maxValue(36500)
type period = int

type newOrExisting = 'new' | 'existing' | 'none'

type eventHubSkuName = 'Basic' | 'Standard'

type EventHubSkuConfig = {
  capacity: int
  name: eventHubSkuName
  tier: eventHubSkuName
}

@description('Deployment Location')
param location string

@minLength(4)
@maxLength(22)
@description('Name of the Kusto Cluster. Must be unique within Azure.')
param name string = 'kusto${uniqueString(resourceGroup().id, subscription().id)}'

@description('Name of the Kusto Database. Must be unique within Kusto Cluster.')
param databaseName string = 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'

@description('The SKU of the Kusto Cluster.')
param sku kustoSku = 'Dev(No SLA)_Standard_D11_v2'

@description('The tier of the Kusto Cluster.')
param tier kustoTier = 'Standard'

@minValue(2)
@maxValue(1000)
@description('The number of nodes in the Kusto Cluster.')
param numberOfNodes int = autoScaleMin

@description('The version of the Kusto Cluster.')
param version int = 1

@description('Enable or disable auto scale.')
param enableAutoScale bool = false

@minValue(2)
@maxValue(999)
@description('The minimum number of nodes in the Kusto Cluster.')
param autoScaleMin int = 2

@minValue(3)
@maxValue(1000)
@description('The maximum number of nodes in the Kusto Cluster.')
param autoScaleMax int = 8

@description('The tags of the Kusto Cluster.')
param tags object = {}

@description('The script content of the Kusto Database. Use [loadTextContent(\'script.kql\')] to load the script content from a file.')
param scripts array = []

@description('Continue if there are errors running a script.')
param continueOnErrors bool = false

@description('Enable or disable the use of a Managed Identity with Data Explorer.')
param enableManagedIdentity bool = false

@description('Enable or disable streaming ingest.')
param enableStreamingIngest bool = false

@description('Enable or disable purge.')
param enablePurge bool = false

@description('Enable or disable disk encryption.')
param enableDiskEncryption bool = false

@description('Enable or disable double encryption.')
param enableDoubleEncryption bool = false

@description('Enable or disable public access from all Tenants.')
param trustAllTenants bool = false

@description('The list of trusted external tenants.')
param trustedExternalTenants array = []

@description('Enable or disable auto stop.')
param enableAutoStop bool = true

@description('Enable or disable zone redundant.')
param enableZoneRedundant bool = false

@allowed([ 'ReadWrite', 'ReadOnlyFollowing' ])
@description('The kind of the Kusto Database.')
param databaseKind string = 'ReadWrite'

@description('Enable or disable soft delete.')
param unlimitedSoftDelete bool = false

@description('The soft delete period of the Kusto Database.')
param softDeletePeriod period = 30

@description('Enable or disable unlimited hot cache.')
param unlimitedHotCache bool = false

@description('The hot cache period of the Kusto Database.')
param hotCachePeriod period = 30

@description('Enable or disable the Event Hub connector.')
param enableEventHubConnector bool = newOrExistingEventHub != 'none'

@description('Name of Event Hub\'s namespace')
param eventHubNamespaceName string = 'eventHub${uniqueString(resourceGroup().id)}'

@description('Name of Event Hub')
param eventHubName string = 'kustoHub'

@description('Enable or disable the Cosmos DB connector.')
param enableCosmosDBConnector bool = false

@description('Name of Cosmos DB account')
param cosmosDDAccountName string = 'cosmosdb${uniqueString(resourceGroup().id)}'

@description('Name of Cosmos DB database')
param cosmosDBDatabaseName string = 'mydb'

@description('Name of Cosmos DB container')
param cosmosDBContainerName string = 'mycontainer'

@description('Create a new Event Hub namespace or use an existing one. If none, the Event Hub connector will be disabled.')
param newOrExistingEventHub newOrExisting = 'none'

@description('EventHub Sku Configuration Properties.')
param eventHubSku {
  capacity: int
  name: eventHubSkuName
  tier: eventHubSkuName
} = {
  capacity: 1
  name: 'Standard'
  tier: 'Standard'
}

@description('EventHub Properties.')
param eventHubProperties {
  messageRetentionInDays: int
  partitionCount: int
} = {
  messageRetentionInDays: 2
  partitionCount: 2
}

@description('Create a new Cosmos DB account or use an existing one. If none, the Cosmos DB connector will be disabled.')
param newOrExistingCosmosDB newOrExisting = 'none'

//  Role list:  https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
var eventHubDataReceiver = 'a638d3c7-ab3a-418d-83e6-5f17a39d4fde'
var cosmosDataReader = '00000000-0000-0000-0000-000000000001'

resource kustoCluster 'Microsoft.Kusto/clusters@2022-12-29' = {
  name: name
  location: location
  sku: {
    name: sku
    tier: tier
    capacity: numberOfNodes
  }
  tags: tags
  identity: enableManagedIdentity ? {
    type: 'systemAssigned'
  } : null
  zones: enableZoneRedundant ? [
    '1'
    '2'
    '3'
  ] : null
  properties: {
    optimizedAutoscale: enableAutoScale ? {
      isEnabled: enableAutoScale
      minimum: autoScaleMin
      maximum: autoScaleMax
      version: version
    } : null
    enableStreamingIngest: enableStreamingIngest
    enablePurge: enablePurge
    enableDiskEncryption: enableDiskEncryption
    enableDoubleEncryption: enableDoubleEncryption
    trustedExternalTenants: trustAllTenants ? [
      {
        value: '*'
      }
    ] : trustedExternalTenants
    enableAutoStop: enableAutoStop
  }
  resource database 'databases' = {
    parent: kustoCluster
    name: databaseName
    location: location
    kind: databaseKind
    properties: {
      softDeletePeriod: unlimitedSoftDelete ? null : 'P${softDeletePeriod}D'
      hotCachePeriod: unlimitedHotCache ? null : 'P${hotCachePeriod}D'
    }

    resource kustoScript 'scripts' = [for script in scripts: {
      name: 'db-script-${uniqueString(script)}'
      properties: {
        scriptContent: script
        continueOnErrors: continueOnErrors
      }
    }]

    resource eventConnection 'dataConnections' = if (enableEventHubConnector) {
      name: 'eventConnection'
      location: location
      dependsOn: [
        kustoScript
        clusterEventHubAuthorization
      ]
      kind: 'EventHub'
      properties: {
        compression: 'None'
        consumerGroup: eventHubNamespace::eventHub::kustoConsumerGroup.name
        dataFormat: 'MULTIJSON'
        eventHubResourceId: eventHubNamespace::eventHub.id
        eventSystemProperties: [
          'x-opt-enqueued-time'
        ]
        managedIdentityResourceId: kustoCluster.id
        mappingRuleName: 'DirectJson'
        tableName: 'RawEvents'
      }
    }

    resource nosqlConnection 'dataConnections' = {
      name: 'nosqlConnection'
      location: location
      dependsOn: [
        kustoScript
        cosmosDbAccount::clusterCosmosDbAuthorization
      ]
      kind: 'CosmosDb'
      properties: {
        tableName: 'TestTable'
        mappingRuleName: 'DocumentMapping'
        managedIdentityResourceId: kustoCluster.id
        cosmosDbAccountResourceId: cosmosDbAccount.id
        cosmosDbDatabase: cosmosDBDatabaseName
        cosmosDbContainer: cosmosDBContainerName
      }
    }
  }
}

resource newEventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = if (enableEventHubConnector && newOrExistingEventHub == 'new') {
  name: eventHubNamespaceName
  location: location
  sku: eventHubSku
  properties: {}

  resource newEventHub 'eventhubs' = {
    name: eventHubName
    properties: eventHubProperties

    resource newKustoConsumerGroup 'consumergroups' = {
      name: 'kustoConsumerGroup'
      properties: {}
    }
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = if (enableEventHubConnector) {
  name: eventHubNamespaceName

  resource eventHub 'eventhubs' existing = {
    name: eventHubName

    resource kustoConsumerGroup 'consumergroups' = {
      name: 'kustoConsumerGroup'
    }
  }
}

resource clusterEventHubAuthorization 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableEventHubConnector) {
  name: guid(resourceGroup().id, eventHubName, eventHubDataReceiver, name)
  scope: eventHubNamespace::eventHub
  dependsOn: [
    newEventHubNamespace
  ]
  properties: {
    description: 'Give "Azure Event Hubs Data Receiver" to the cluster'
    principalId: kustoCluster.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', eventHubDataReceiver)
  }
}

resource newCosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = if (enableCosmosDBConnector && newOrExistingCosmosDB == 'new') {
  name: cosmosDDAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    databaseAccountOfferType: 'Standard'
  }

  resource cosmosDbDatabase 'sqlDatabases' = {
    name: cosmosDBDatabaseName
    properties: {
      resource: {
        id: cosmosDBDatabaseName
      }
    }

    resource cosmosDbContainer 'containers' = {
      name: cosmosDBContainerName
      properties: {
        options: {
          throughput: 400
        }
        resource: {
          id: cosmosDBContainerName
          partitionKey: {
            kind: 'Hash'
            paths: [
              '/part'
            ]
          }
        }
      }
    }
  }
}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = if (enableCosmosDBConnector) {
  name: cosmosDDAccountName

  resource clusterCosmosDbAuthorization 'sqlRoleAssignments' = if (enableCosmosDBConnector) {
    name: guid(kustoCluster.id, cosmosDDAccountName)

    properties: {
      principalId: kustoCluster.identity.principalId
      roleDefinitionId: resourceId('Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', cosmosDDAccountName, cosmosDataReader)
      scope: resourceId('Microsoft.DocumentDB/databaseAccounts', cosmosDDAccountName)
    }
  }
}

@description('The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments.')
output id string = kustoCluster.id
