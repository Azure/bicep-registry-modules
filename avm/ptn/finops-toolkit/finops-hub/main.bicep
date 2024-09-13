metadata name = 'Finops-hub'
metadata description = 'This module deploys a Finops hub from the Finops toolkit.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Name of the hub. Used to ensure unique resource names. Default: "finops-hub".')
param hubName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
])
@description('Optional. Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS.')
param storageSku string = 'Premium_LRS'

@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object?

@description('Optional. Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.')
param tagsByResource object = {}

@description('Optional. List of scope IDs to create exports for.')
param exportScopes array = []

@description('Optional. The name of the container used for configuration settings.')
param configContainer string = 'config'

@description('Optional. The name of the container used for Cost Management exports.')
param exportContainer string = 'exports'

@description('Optional. The name of the container used for normalized data ingestion.')
param ingestionContainer string = 'ingestion'

@description('Optional. Indicates whether ingested data should be converted to Parquet. Default: true.')
param convertToParquet bool = true

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

// Generate globally unique storage account name: 3-24 chars; lowercase letters/numbers only
var safeHubName = replace(replace(toLower(hubName), '-', ''), '_', '')
var storageAccountSuffix = uniqueSuffix
var storageAccountName = '${take(safeHubName, 24 - length(storageAccountSuffix))}${storageAccountSuffix}'
var ftkVersion = '0.3'

// Add cm-resource-parent to group resources in Cost Management
var resourceTags = union(tags ?? {}, {
  'cm-resource-parent': '${resourceGroup().id}/providers/Microsoft.Cloud/hubs/${hubName}'
  'ftk-version': ftkVersion
  'ftk-tool': 'FinOps hubs'
})

// Generate globally unique Data Factory name: 3-63 chars; letters, numbers, non-repeating dashes
var uniqueSuffix = uniqueString(hubName, resourceGroup().id)
var dataFactoryPrefix = '${replace(hubName, '_', '-')}-engine'
var dataFactorySuffix = '-${uniqueSuffix}'
var dataFactoryName = replace(
  '${take(dataFactoryPrefix, 63 - length(dataFactorySuffix))}${dataFactorySuffix}',
  '--',
  '-'
)

// The last segment of the telemetryId is used to identify this module
var telemetryId = '00f120b5-2007-6120-0000-40b000000000'

//==============================================================================
// Resources
//==============================================================================

//------------------------------------------------------------------------------
// ADLSv2 storage account for staging and archive
//------------------------------------------------------------------------------

module storage 'modules/storage.bicep' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    storageAccountName: storageAccountName
    sku: storageSku
    location: location
    tags: resourceTags
    tagsByResource: tagsByResource
    exportScopes: exportScopes
    configContainer: configContainer
    exportContainer: exportContainer
    ingestionContainer: ingestionContainer
    ftkVersion: ftkVersion
  }
}

//------------------------------------------------------------------------------
// Data Factory and pipelines
//------------------------------------------------------------------------------
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags: union(resourceTags, tagsByResource[?'Microsoft.DataFactory/factories'] ?? {})
  identity: { type: 'SystemAssigned' }
  properties: any(
    // Using any() to hide the error that gets surfaced because globalConfigurations is not in the ADF schema yet.
    {
      globalConfigurations: {
        PipelineBillingEnabled: 'true'
      }
    }
  )
}
module dataFactoryResources 'modules/dataFactory.bicep' = {
  name: '${uniqueString(deployment().name, location)}-dataFactoryResources'
  params: {
    dataFactoryName: dataFactoryName
    convertToParquet: convertToParquet
    keyVaultName: keyVault.outputs.name
    storageAccountName: storage.outputs.name
    exportContainerName: exportContainer
    ingestionContainerName: ingestionContainer
    location: location
    tags: resourceTags
    tagsByResource: tagsByResource
  }
}

//------------------------------------------------------------------------------
// Key Vault for storing secrets
//------------------------------------------------------------------------------

module keyVault 'modules/keyVault.bicep' = {
  name: '${uniqueString(deployment().name, location)}-keyVault'
  params: {
    hubName: hubName
    uniqueSuffix: uniqueSuffix
    location: location
    tags: resourceTags
    tagsByResource: tagsByResource
    storageAccountName: storage.outputs.name
    accessPolicies: [
      {
        objectId: dataFactory.identity.principalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.finopstoolkit-finopshub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

#disable-next-line no-deployments-resources
resource defaultTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: 'pid-${telemetryId}-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      metadata: {
        _generator: {
          name: 'FinOps toolkit'
          version: '0.3'
        }
      }
      resources: []
    }
  }
}

//==============================================================================
// Outputs
//==============================================================================

@description('The name of the resource group.')
output name string = hubName

@description('The location the resources wer deployed to.')
output location string = location

@description('Name of the Data Factory.')
output dataFactoryName string = dataFactoryName

@description('The resource group the finops hub was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed storage account.')
output storageAccountId string = storage.outputs.resourceId

@description('Name of the storage account created for the hub instance. This must be used when connecting FinOps toolkit Power BI reports to your data.')
output storageAccountName string = storage.outputs.name

@description('URL to use when connecting custom Power BI reports to your data.')
output storageUrlForPowerBi string = 'https://${storage.outputs.name}.dfs.${environment().suffixes.storage}/${ingestionContainer}'
