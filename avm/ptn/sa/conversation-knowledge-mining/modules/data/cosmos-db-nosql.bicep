// ============================================================================
// Module: Cosmos DB
// Description: AVM wrapper for Azure Cosmos DB (NoSQL) with WAF alignment
// AVM Module: avm/res/document-db/database-account:0.19.0
// WAF: https://learn.microsoft.com/azure/well-architected/service-guides/cosmos-db
// ============================================================================

@description('Solution name suffix used to derive the resource name.')
param solutionName string

@description('Name of the Cosmos DB account.')
param name string = 'cosmos-${solutionName}'

@description('Azure region for the resource.')
param location string

@description('Tags to apply to the resource.')
param tags object = {}

@description('Database name.')
param databaseName string = 'db_conversation_history'

@description('Container definitions.')
param containers array = [
  {
    name: 'conversations'
    partitionKeyPath: '/userId'
  }
]

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// --- WAF: Monitoring ---
@description('Diagnostic settings for monitoring.')
param diagnosticSettings array = []

// --- WAF: Private Networking ---
@description('Public network access setting.')
param publicNetworkAccess string = 'Enabled'

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

// --- WAF: Redundancy ---
@description('Enable zone redundancy.')
param zoneRedundant bool = false

@description('Enable automatic failover.')
param enableAutomaticFailover bool = false

@description('Optional. HA paired region for multi-region failover when redundancy is enabled.')
param haLocation string = ''

@description('Optional. Managed identities for the resource.')
param managedIdentities object = { systemAssigned: true }

// ============================================================================
// AVM Module Deployment
// ============================================================================
module cosmosAccount 'br/public:avm/res/document-db/database-account:0.19.0' = {
  name: take('avm.res.document-db.database-account.${name}', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    capabilitiesToAdd: zoneRedundant ? [] : ['EnableServerless']
    sqlDatabases: [
      {
        name: databaseName
        containers: [for container in containers: {
          name: container.name
          paths: [container.partitionKeyPath]
          kind: 'Hash'
          version: 2
        }]
      }
    ]
    sqlRoleAssignments: []
    diagnosticSettings: !empty(diagnosticSettings) ? diagnosticSettings : []
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: publicNetworkAccess
    }
    privateEndpoints: privateEndpoints
    zoneRedundant: zoneRedundant
    enableAutomaticFailover: enableAutomaticFailover
    managedIdentities: managedIdentities
    failoverLocations: zoneRedundant
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: location
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: haLocation
          }
        ]
      : [
          {
            locationName: location
            failoverPriority: 0
            isZoneRedundant: false
          }
        ]
  }
}

// ============================================================================
// Outputs
// ============================================================================
@description('Resource ID of the Cosmos DB account.')
output resourceId string = cosmosAccount.outputs.resourceId

@description('Name of the Cosmos DB account.')
output name string = cosmosAccount.outputs.name

@description('Endpoint of the Cosmos DB account.')
output endpoint string = 'https://${name}.documents.azure.com:443/'

@description('Database name.')
output databaseName string = databaseName

@description('Container name (first container).')
output containerName string = containers[0].name
