@description('Required. Name of the Cosmos DB Account.')
param name string

@description('Required. Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Required. Managed Identity princpial to assign data plane roles for the Cosmos DB Account.')
param dataAccessIdentityPrincipalId string

@description('Optional. The resource ID of an existing Log Analytics workspace to associate with AI Foundry for monitoring.')
param logAnalyticsWorkspaceResourceId string?

@description('Required. Indicates whether the single-region account is zone redundant. This property is ignored for multi-region accounts.')
param zoneRedundant bool

@description('Optional. The secondary location for the Cosmos DB Account for failover and multiple writes.')
param secondaryLocation string?

import { resourcePrivateNetworkingType } from 'customTypes.bicep'
@description('Optional. Values to establish private networking for the Cosmos DB resource.')
param privateNetworking resourcePrivateNetworkingType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module privateDnsZone 'privateDnsZone.bicep' = if (privateNetworking != null && empty(privateNetworking.?privateDnsZoneResourceId)) {
  name: take('${name}-documents-pdns-deployment', 64)
  params: {
    name: 'privatelink.documents.azure.com'
    virtualNetworkResourceId: privateNetworking.?virtualNetworkResourceId ?? ''
    tags: tags
  }
}

var privateDnsZoneResourceId = privateNetworking != null
  ? (empty(privateNetworking.?privateDnsZoneResourceId)
      ? privateDnsZone.outputs.resourceId ?? ''
      : privateNetworking.?privateDnsZoneResourceId ?? '')
  : ''

resource sqlContributorRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-11-15' existing = {
  name: '${name}/00000000-0000-0000-0000-000000000002'
}

var databaseName = 'cmsadb'
var batchContainerName = 'cmsabatch'
var fileContainerName = 'cmsafile'
var logContainerName = 'cmsalog'

module cosmosAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('${name}-account-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [privateDnsZone] // required due to optional flags that could change dependency
  params: {
    name: name
    enableAnalyticalStorage: true
    location: location
    minimumTlsVersion: 'Tls12'
    defaultConsistencyLevel: 'Session'
    networkRestrictions: {
      networkAclBypass: 'AzureServices'
      publicNetworkAccess: privateNetworking != null ? 'Disabled' : 'Enabled'
      ipRules: []
      virtualNetworkRules: []
    }
    zoneRedundant: zoneRedundant
    automaticFailover: !empty(secondaryLocation)
    failoverLocations: !empty(secondaryLocation)
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: zoneRedundant
            locationName: location
          }
          {
            failoverPriority: 0
            isZoneRedundant: zoneRedundant
            locationName: secondaryLocation!
          }
        ]
      : []
    enableMultipleWriteLocations: !empty(secondaryLocation)
    backupPolicyType: !empty(secondaryLocation) ? 'Periodic' : 'Continuous'
    backupStorageRedundancy: zoneRedundant ? 'Zone' : 'Local'
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuthentication: privateNetworking != null
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
      : []
    privateEndpoints: privateNetworking != null
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZoneResourceId
                }
              ]
            }
            service: 'Sql'
            subnetResourceId: privateNetworking.?subnetResourceId ?? ''
          }
        ]
      : []
    sqlDatabases: [
      {
        containers: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: batchContainerName
            paths: [
              '/batch_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: fileContainerName
            paths: [
              '/file_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: logContainerName
            paths: [
              '/log_id'
            ]
          }
        ]
        name: databaseName
      }
    ]
    dataPlaneRoleAssignments: [
      {
        principalId: dataAccessIdentityPrincipalId
        roleDefinitionId: sqlContributorRoleDefinition.id
      }
    ]
    roleAssignments: roleAssignments
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Cosmos DB Account resource.')
output name string = cosmosAccount.outputs.name

@secure() // marked secure to meet AVM validation requirements
@description('Resource ID of the Cosmos DB Account.')
output resourceId string = cosmosAccount.outputs.resourceId

@secure() // marked secure to meet AVM validation requirements
@description('Endpoint of the Cosmos DB Account.')
output endpoint string = cosmosAccount.outputs.endpoint

@description('Name of the Cosmos DB database.')
output databaseName string = databaseName

@description('Complex object containing the names of the Cosmos DB containers.')
output containerNames object = {
  batch: batchContainerName
  file: fileContainerName
  log: logContainerName
}
