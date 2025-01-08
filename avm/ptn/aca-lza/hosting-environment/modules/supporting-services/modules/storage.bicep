targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The location where the resources will be created.')
param location string = resourceGroup().location

@description('The name of the storage account.')
param storageAccountName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

@description('The resource ID of the Hub Virtual Network.')
param hubVNetResourceId string

@description('The resource ID of the Key Vault.')
param keyVaultResourceId string

@description('The resource ID of the VNet to which the private endpoint will be connected.')
param spokeVNetResourceId string

@description('The resource id of the subnet in the VNet to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetResourceId string

@description('Optional. The name of the private endpoint to be created for Key Vault. If left empty, it defaults to "<resourceName>-pep')
param storagePrivateEndpointName string = 'storage-pep'

@description('Required. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace.')
param diagnosticWorkspaceId string

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = 'storage-diagnosticSettings'

@description('Any shares to be created on the storage account.')
param storageShares array = []

var storagePrivateDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'
var storageShare = 'smbfileshare'
var shares = concat(storageShares, [
  {
    enabledProtocols: 'SMB'
    name: storageShare
  }
])

//Storage account for the deployment script
module storage 'br/public:avm/res/storage/storage-account:0.15.0' = {
  name: '${take(uniqueString(deployment().name, location),4)}-ci-storage-deployment'
  params: {
    location: location
    kind: 'StorageV2'
    skuName: 'Standard_ZRS'
    enableTelemetry: enableTelemetry
    name: storageAccountName
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    secretsExportConfiguration: {
      keyVaultResourceId: keyVaultResourceId
      accessKey1: 'ciStorageAccessKey1'
    }
    fileServices: {
      shares: shares
    }
    privateEndpoints: [
      {
        name: storagePrivateEndpointName
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: storagePrivateDnsZone.outputs.resourceId
            }
          ]
        }
        service: 'file'
        subnetResourceId: spokePrivateEndpointSubnetResourceId
      }
    ]
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: diagnosticSettingsName
        workspaceResourceId: diagnosticWorkspaceId
      }
    ]
    tags: tags
  }
}
module storagePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: '${take(uniqueString(deployment().name, location),4)}-storagePrivateDnsZone-deployment'
  params: {
    location: 'global'
    name: storagePrivateDnsZoneName
    virtualNetworkLinks: !empty(hubVNetResourceId)
      ? [
          {
            virtualNetworkResourceId: spokeVNetResourceId
          }
          {
            virtualNetworkResourceId: hubVNetResourceId
          }
        ]
      : [
          {
            virtualNetworkResourceId: spokeVNetResourceId
          }
        ]
  }
}

output storageAccountResourceId string = storage.outputs.resourceId
output storageAccountName string = storage.outputs.name
output containerAppsEnvironmentStorage string = storageShare
