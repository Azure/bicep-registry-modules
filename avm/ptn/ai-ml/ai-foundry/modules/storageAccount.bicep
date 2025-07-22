@maxLength(24)
@description('Name of the Storage Account. This is ignored if existingResourceId is provided.')
param name string

@description('Optional. Resource Id of an existing Storage Account. If provided, the module will not create a new AI Search resource but will use the existing one.')
param existingResourceId string?

@description('Specifies the location for the Storage Account. Defaults to the location of the resource group.')
param location string = resourceGroup().location

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Values to establish private networking for the Storage Account. If not provided, public access will be enabled.')
param privateNetworking storageAccountPrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module parsedResourceId 'parseResourceId.bicep' = if (!empty(existingResourceId)) {
  name: take('${name}-storage-account-parse-resource-id', 64)
  params: {
    resourceIdOrName: existingResourceId!
  }
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = if (!empty(existingResourceId)) {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

var projUploadsContainerName = 'ai-foundry-proj-uploads'
var sysDataContainerName = 'ai-foundry-sys-data'

var networkIsolation = !empty(privateNetworking) && !empty(privateNetworking!.privateEndpointSubnetId) && !empty(privateNetworking!.blobPrivateDnsZoneId) && !empty(privateNetworking!.filePrivateDnsZoneId)

module storageAccount 'br/public:avm/res/storage/storage-account:0.25.1' = if (empty(existingResourceId)) {
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

var outputResourceId = empty(existingResourceId) ? storageAccount!.outputs.resourceId : existingStorageAccount.id
var outputName = empty(existingResourceId) ? storageAccount!.outputs.name : existingStorageAccount.name
var outputLocation = empty(existingResourceId) ? storageAccount!.outputs.location : existingStorageAccount!.location
var outputBlobEndpoint = empty(existingResourceId)
  ? storageAccount!.outputs.primaryBlobEndpoint
  : existingStorageAccount!.properties.primaryEndpoints.blob

@description('Name of the Storage Account.')
output name string = outputName

@description('Resource ID of the Storage Account.')
output resourceId string = outputResourceId

@description('Blob endpoint of the Storage Account.')
output blobEndpoint string = outputBlobEndpoint

@description('Location of the Storage Account.')
output location string = outputLocation

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
