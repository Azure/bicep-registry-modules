// ============================================================================
// Module: SQL Database
// Description: AVM wrapper for Azure SQL Server and Database
// AVM Module: avm/res/sql/server:0.21.1
// WAF: https://learn.microsoft.com/azure/well-architected/service-guides/azure-sql-database
// ============================================================================

@description('Solution name suffix used to derive the resource name.')
param solutionName string

@description('Name of the SQL Server.')
param name string = 'sql-${solutionName}'

@description('Name of the SQL Database.')
param databaseName string = 'sqldb-${solutionName}'

@description('Azure region for the resource.')
param location string

@description('Tags to apply to the resource.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Principal ID of the deployer for admin access.')
param deployerPrincipalId string

@description('SKU name for the database.')
param skuName string = 'GP_S_Gen5'

@description('SKU tier for the database.')
param skuTier string = 'GeneralPurpose'

@description('SKU family.')
param skuFamily string = 'Gen5'

@description('vCore capacity.')
param skuCapacity int = 2

@description('Auto-pause delay in minutes.')
param autoPauseDelay int = 60

@description('Minimum capacity (vCores).')
param minCapacity int = 1

// --- WAF: Private Networking ---
@description('Public network access setting.')
param publicNetworkAccess string = 'Enabled'

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Managed identities for the resource.')
param managedIdentities object = { systemAssigned: true }

// ============================================================================
// AVM Module Deployment
// ============================================================================
module sqlServer 'br/public:avm/res/sql/server:0.21.1' = {
  name: take('avm.res.sql.server.${name}', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccess
    restrictOutboundNetworkAccess: 'Disabled'
    managedIdentities: managedIdentities
    administrators: {
      azureADOnlyAuthentication: true
      login: deployerPrincipalId
      principalType: 'User'
      sid: deployerPrincipalId
      tenantId: subscription().tenantId
    }
    databases: [
      {
        name: databaseName
        availabilityZone: -1
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        autoPauseDelay: autoPauseDelay
        minCapacity: '${minCapacity}'
        zoneRedundant: false
        sku: {
          name: skuName
          tier: skuTier
          family: skuFamily
          capacity: skuCapacity
        }
      }
    ]
    firewallRules: publicNetworkAccess == 'Enabled' ? [
      {
        name: 'AllowSpecificRange'
        startIpAddress: '0.0.0.0'
        endIpAddress: '255.255.255.255'
      }
      {
        name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
      }
    ] : []
    privateEndpoints: privateEndpoints
  }
}

// ============================================================================
// Outputs
// ============================================================================
@description('Fully qualified domain name of the SQL Server.')
output serverFqdn string = '${name}.database.windows.net'

@description('Name of the SQL Database.')
output databaseName string = databaseName

@description('Resource ID of the SQL Server.')
output serverResourceId string = sqlServer.outputs.resourceId

@description('Name of the SQL Server.')
output name string = sqlServer.outputs.name
