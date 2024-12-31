metadata name = 'SQL Server Instance Pool'
metadata description = 'This module deploys an Azure SQL Server Instance Pool.'

@description('Required. The name of the instance pool.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. The subnet resource ID for the instance pool.')
param subnetResourceId string

@description('Optional. The license type to apply for this database.')
@allowed([
  'BasePrice'
  'LicenseIncluded'
])
param licenseType string = 'BasePrice'

@description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param skuFamily string = 'Gen5'

@description('Optional. The number of vCores for the instance pool.')
@allowed([
  8
  16
  24
  32
  40
  64
  80
  96
  128
  160
  192
  224
  256
])
param vCores int = 8

@description('Optional. The vCore service tier for the instance pool.')
@allowed([
  'GeneralPurpose'
])
param tier string = 'GeneralPurpose'

@description('Optional. The SKU name for the instance pool.')
param skuName string = 'GP_Gen5'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource instancePool 'Microsoft.Sql/instancePools@2023-05-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    family: skuFamily
    name: skuName
    tier: tier
  }
  properties: {
    licenseType: licenseType
    subnetId: subnetResourceId
    vCores: vCores
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-instancepool.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

@description('The ID of the SQL instance pool.')
output resourceId string = instancePool.id

@description('The name of the SQL instance pool.')
output name string = instancePool.name

@description('The location of the SQL instance pool.')
output instancePoolLocation string = instancePool.location

@description('The resource group name of the SQL instance pool.')
output resourceGroupName string = resourceGroup().name
