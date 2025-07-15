@maxLength(24)
@description('Name of the Storage Account.')
param name string

@description('Specifies the location for the Storage Account.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Values to establish private networking for the Storage Account. If not provided, public access will be enabled.')
param privateNetworking storageAccountPrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var projUploadsContainerName = 'ai-foundry-proj-uploads'
var sysDataContainerName = 'ai-foundry-sys-data'

var networkIsolation = privateNetworking != null && !empty(privateNetworking) && !empty(privateNetworking!.privateEndpointSubnetId) && !empty(privateNetworking!.blobPrivateDnsZoneId) && !empty(privateNetworking!.filePrivateDnsZoneId)

module storageAccount 'br/public:avm/res/storage/storage-account:0.25.0' = {
  name: take('${name}-storage-account-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    accessTier: 'Hot'
    allowBlobPublicAccess: !networkIsolation
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    blobServices: {
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      containers: [
        {
          name: projUploadsContainerName
        }
        {
          name: sysDataContainerName
        }
      ]
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: networkIsolation ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
    supportsHttpsTrafficOnly: true
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateNetworking!.blobPrivateDnsZoneId
                }
              ]
            }
            service: 'blob'
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateNetworking!.filePrivateDnsZoneId
                }
              ]
            }
            service: 'file'
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
        ]
      : []
    roleAssignments: roleAssignments
  }
}

@description('Name of the Storage Account.')
output name string = storageAccount.outputs.name

@description('Resource ID of the Storage Account.')
output resourceId string = storageAccount.outputs.resourceId

@description('Name of the project uploads container.')
output projUploadsContainerName string = projUploadsContainerName

@description('Name of the system data container.')
output sysDataContainerName string = sysDataContainerName

@export()
@description('Values to establish private networking for resources that support creating private endpoints.')
type storageAccountPrivateNetworkingType = {
  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  privateEndpointSubnetId: string

  @description('Required. The Resource ID of an existing "file" Private DNS Zone Resource to link to the virtual network.')
  filePrivateDnsZoneId: string

  @description('Required. The Resource ID of an existing "blob" Private DNS Zone Resource to link to the virtual network.')
  blobPrivateDnsZoneId: string
}
