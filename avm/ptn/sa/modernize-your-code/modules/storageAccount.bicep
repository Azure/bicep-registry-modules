@description('Required. Name of the Storage Account.')
param name string

@description('Required. Specifies the location for all the Azure resources.')
param location string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
@description('Optional. Storage Account Sku Name. Defaults to Standard_LRS.')
param skuName string = 'Standard_LRS'

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string?

@description('Optional. Values to establish private networking for the Storage Account.')
param privateNetworking storageAccountPrivateNetworkingType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. List of the blob storage containers to create in the Storage Account.')
param containers array?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var blobPrivateDnsZoneResourceId = privateNetworking != null
  ? privateNetworking.?blobPrivateDnsZoneResourceId ?? ''
  : ''
var filePrivateDnsZoneResourceId = privateNetworking != null
  ? privateNetworking.?filePrivateDnsZoneResourceId ?? ''
  : ''

module storageAccount 'br/public:avm/res/storage/storage-account:0.28.0' = {
  name: take('avm.res.storage.storage-account.${name}', 64)
  #disable-next-line no-unnecessary-dependson
  params: {
    name: name
    location: location
    kind: 'StorageV2'
    skuName: skuName
    accessTier: 'Hot'
    tags: tags
    publicNetworkAccess: privateNetworking != null ? 'Disabled' : 'Enabled'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    requireInfrastructureEncryption: false
    keyType: 'Service'
    enableHierarchicalNamespace: false
    enableNfsV3: false
    largeFileSharesState: 'Disabled'
    networkAcls: {
      defaultAction: privateNetworking != null ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
    supportsHttpsTrafficOnly: true
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspaceResourceId
          }
        ]
      : []
    privateEndpoints: privateNetworking != null
      ? [
          {
            name: 'pep-blob-${name}'
            customNetworkInterfaceName: 'nic-blob-${name}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: blobPrivateDnsZoneResourceId
                }
              ]
            }
            service: 'blob'
            subnetResourceId: privateNetworking.?subnetResourceId ?? ''
          }
          {
            name: 'pep-file-${name}'
            customNetworkInterfaceName: 'nic-file-${name}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: filePrivateDnsZoneResourceId
                }
              ]
            }
            service: 'file'
            subnetResourceId: privateNetworking.?subnetResourceId ?? ''
          }
        ]
      : []
    roleAssignments: roleAssignments
    blobServices: {
      containers: containers ?? []
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
    }
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Storage Account.')
output name string = storageAccount.outputs.name

@description('Resource ID of the Storage Account.')
output resourceId string = storageAccount.outputs.resourceId

@export()
@description('Values to establish private networking for resources that support createing private endpoints.')
type storageAccountPrivateNetworkingType = {
  @description('Required. The Resource ID of the virtual network.')
  virtualNetworkResourceId: string

  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  subnetResourceId: string

  @description('Optional. The Resource ID of an existing "file" Private DNS Zone Resource to link to the virtual network. If not provided, a new "file" Private DNS Zone(s) will be created.')
  filePrivateDnsZoneResourceId: string?

  @description('Optional. The Resource ID of an existing "blob" Private DNS Zone Resource to link to the virtual network. If not provided, a new "blob" Private DNS Zone(s) will be created.')
  blobPrivateDnsZoneResourceId: string?
}
