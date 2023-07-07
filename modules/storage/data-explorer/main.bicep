type kustoTier = 'Basic' | 'Standard'

type kustoSku = 'Dev(No SLA)_Standard_D11_v2' | 'Dev(No SLA)_Standard_E2a_v4' | 'Standard_D11_v2' | 'Standard_D12_v2' | 'Standard_D13_v2' | 'Standard_D14_v2' | 'Standard_D16d_v5' | 'Standard_D32d_v4' | 'Standard_D32d_v5' | 'Standard_DS13_v2+1TB_PS' | 'Standard_DS13_v2+2TB_PS' | 'Standard_DS14_v2+3TB_PS' | 'Standard_DS14_v2+4TB_PS' | 'Standard_E16a_v4' | 'Standard_E16ads_v5' | 'Standard_E16as_v4+3TB_PS' | 'Standard_E16as_v4+4TB_PS' | 'Standard_E16as_v5+3TB_PS' | 'Standard_E16as_v5+4TB_PS' | 'Standard_E16d_v4' | 'Standard_E16d_v5' | 'Standard_E16s_v4+3TB_PS' | 'Standard_E16s_v4+4TB_PS' | 'Standard_E16s_v5+3TB_PS' | 'Standard_E16s_v5+4TB_PS' | 'Standard_E2a_v4' | 'Standard_E2ads_v5' | 'Standard_E2d_v4' | 'Standard_E2d_v5' | 'Standard_E4a_v4' | 'Standard_E4ads_v5' | 'Standard_E4d_v4' | 'Standard_E4d_v5' | 'Standard_E64i_v3' | 'Standard_E80ids_v4' | 'Standard_E8a_v4' | 'Standard_E8ads_v5' | 'Standard_E8as_v4+1TB_PS' | 'Standard_E8as_v4+2TB_PS' | 'Standard_E8as_v5+1TB_PS' | 'Standard_E8as_v5+2TB_PS' | 'Standard_E8d_v4' | 'Standard_E8d_v5' | 'Standard_E8s_v4+1TB_PS' | 'Standard_E8s_v4+2TB_PS' | 'Standard_E8s_v5+1TB_PS' | 'Standard_E8s_v5+2TB_PS' | 'Standard_EC16ads_v5' | 'Standard_EC16as_v5+3TB_PS'

@minValue(0)
@maxValue(36500)
type period = int

@description('Deployment Location')
param location string

@minLength(4)
@maxLength(22)
@description('Name of the Kusto Cluster. Must be unique within Azure.')
param name string = 'kusto${uniqueString(resourceGroup().id, subscription().id)}'

@description('The SKU of the Kusto Cluster.')
param sku kustoSku = 'Dev(No SLA)_Standard_D11_v2'

@description('The tier of the Kusto Cluster.')
param tier kustoTier = 'Basic'

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

@description('Toggle if Private Endpoints manual approval for Kusto Cluster should be enabled.')
param privateEndpointsApprovalEnabled bool = false

@description('Define Private Endpoints that should be created for Kusto Cluster.')
param privateEndpoints array = []

@description('optional. database list of kustoCluster to be created.')
param databases array

@description('optional. data connection for specied database and resource cosmosdb')
param dataCosmosDbConnections array = []

@description('optional. data connection for specied database and resource eventhub.')
param dataEventHubConnections array = []

@description('Optional. The identity type attach to kustoCluster.')
@allowed([
  'None'
  'SystemAssigned'
  'UserAssigned'
])
param identityType string = 'None'

@description('''
Optional. Gets or sets a list of key value pairs that describe the set of User Assigned identities that will be used with this kustoCluster.
The key is the ARM resource identifier of the identity. Only 1 User Assigned identity is permitted here
''')
param userAssignedIdentities object = {}

@description('Enable or disable public network access.')
param publicNetworkAccess string = 'Enabled'

@description('The list of managed private endpoints.')
param managedPrivateEndpoints array = []

@description('list of principalAssignments for database')
param principalAssignments principalAssignmentType[] = []

@description('List of role assignments for kustoCluster.')
param roleAssignments array = []

var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: '${privateEndpoint.name}-${kustoCluster.name}'
  privateLinkServiceId: kustoCluster.id
  groupIds: [
    'cluster'
  ]
  subnetId: privateEndpoint.subnetId
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
}]

var databasesNames = map(databases, db => db.name)

resource kustoCluster 'Microsoft.Kusto/clusters@2022-12-29' = {
  name: name
  location: location
  sku: {
    name: sku
    tier: tier
    capacity: sku == 'Dev(No SLA)_Standard_D11_v2' || sku == 'Dev(No SLA)_Standard_D11_v2' ? 1 : numberOfNodes
  }
  tags: tags
  identity: (identityType == 'UserAssigned') ? {
    type: identityType
    userAssignedIdentities: userAssignedIdentities
  } : {
    type: identityType
  }
  zones: enableZoneRedundant ? [
    '1'
    '2'
    '3'
  ] : null
  properties: {
    publicNetworkAccess: publicNetworkAccess
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
}

resource database 'Microsoft.Kusto/clusters/databases@2022-12-29' = [for database in databases: {
  kind: database.kind
  name: database.name
  location: location
  parent: kustoCluster
  properties: {
    softDeletePeriod: database.unlimitedSoftDelete ? null : 'P${database.softDeletePeriod}D'
    hotCachePeriod: database.unlimitedHotCache ? null : 'P${database.hotCachePeriod}D'
  }
}]

@batchSize(1)
resource script 'Microsoft.Kusto/clusters/databases/scripts@2022-12-29' = [for script in scripts: {
  name: 'db-script-${script.name}-${uniqueString(script.name)}'
  parent: database[indexOf(databasesNames, script.databaseName)]
  properties: {
    scriptContent: contains(script, 'scriptContent') ? script.scriptContent : loadTextContent('script.kql')
    continueOnErrors: continueOnErrors
  }
}]

resource dataCosmosDbConnection 'Microsoft.Kusto/clusters/databases/dataConnections@2022-12-29' = [for dataConnection in dataCosmosDbConnections: {
  dependsOn: [
    database
    script
  ]
  location: location
  name: 'cosmosdb-${dataConnection.name}-${uniqueString(dataConnection.name)}'
  parent: database[indexOf(databasesNames, dataConnection.databaseName)]
  kind: 'CosmosDb'
  properties: {
    cosmosDbAccountResourceId: dataConnection.cosmosDbAccountResourceId
    cosmosDbContainer: dataConnection.cosmosDbContainer
    cosmosDbDatabase: dataConnection.cosmosDbDatabase
    managedIdentityResourceId: dataConnection.managedIdentityResourceId
    tableName: empty(dataConnection.tableName) ? null : dataConnection.tableName
  }
}]

resource dataEventHubConnection 'Microsoft.Kusto/clusters/databases/dataConnections@2022-12-29' = [for dataConnection in dataEventHubConnections: {
  dependsOn: [
    database
    script
  ]
  location: location
  name: 'eventhub-${dataConnection.name}-${uniqueString(dataConnection.name)}'
  parent: database[indexOf(databasesNames, dataConnection.databaseName)]
  kind: 'EventHub'
  properties: {
    consumerGroup: dataConnection.consumerGroup
    eventHubResourceId: dataConnection.eventHubResourceId
    tableName: empty(dataConnection.tableName) ? null : dataConnection.tableName
    compression: dataConnection.compression
  }
}]

module kustoClusterPrivateEndpoint '.bicep/nested_privateEndpoint.bicep' = {
  name: 'ep-${uniqueString(deployment().name, kustoCluster.name, kustoCluster.id)}-kusto-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
    manualApprovalEnabled: privateEndpointsApprovalEnabled
  }
}

@batchSize(1)
resource managedPrivateEndpoint 'Microsoft.Kusto/clusters/managedPrivateEndpoints@2022-12-29' = [for ep in managedPrivateEndpoints: {
  name: '${ep.name}-${kustoCluster.name}-managedPrivateEndpoints'
  dependsOn: [
    kustoClusterPrivateEndpoint
  ]
  parent: kustoCluster
  properties: {
    groupId: ep.groupId
    privateLinkResourceId: ep.privateLinkResourceId
  }
}]

@batchSize(1)
resource principalAssignment 'Microsoft.Kusto/clusters/databases/principalAssignments@2022-12-29' = [for principal in principalAssignments: {
  dependsOn: [
    database
    kustoClusterPrivateEndpoint
    managedPrivateEndpoint
  ]
  name: guid(location, principal.databaseName!, principal.principalType!, principal.principalId!, principal.role!)
  parent: database[indexOf(databasesNames, principal.databaseName)]
  properties: {
    principalId: principal.principalId!
    principalType: principal.principalType!
    role: principal.role!
    tenantId: principal.tenantId
  }
}]

module containerRegistry_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  dependsOn: [
    principalAssignment
  ]
  name: '${uniqueString(deployment().name, kustoCluster.name, location)}-kusto-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    resourceId: kustoCluster.id
  }
}]

//types:
type principalAssignmentType = {
  name: string?
  databaseName: string?
  principalId: string?
  principalType: 'App' | 'Group' | 'User'?
  role: 'Admin' | 'Ingestor' | 'Monitor' | 'User' | 'Viewer'?
  tenantId: string?
}

@description('The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments.')
output id string = kustoCluster.id

@description('Name of the kusto cluster created')

output clusterName string = kustoCluster.name
