@description('Name of the Storage Account.')
param storageName string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the Storage Account and link the private DNS zone.')
param networkIsolation bool = true

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

module blobPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-blob-deployment'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

module filePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-file-deployment'
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

var nameFormatted = take(toLower(storageName), 24)

module storageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: take('${nameFormatted}-storage-account-deployment', 64)
  dependsOn: [filePrivateDnsZone, blobPrivateDnsZone] // required due to optional flags that could change dependency
  params: {
    name: nameFormatted
    location: location
    tags: tags
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    blobServices: {
      containers: [
        {
          name: '${nameFormatted}projUploads'
          properties: {
            publicAccess: 'None'
            roleAssignments: [
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'Owner'
              }
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
              }
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
              }
            ]
          }
        }
        {
          name: '${nameFormatted}sysdata'
          properties: {
            publicAccess: 'None'
            roleAssignments: [
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'Owner'
              }
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
              }
              {
                principalId: userObjectId
                principalType: 'ServicePrincipal'
                roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
              }
            ]
          }
        }
      ]
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceResourceId
      }
    ]
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: blobPrivateDnsZone.outputs.resourceId
                }
              ]
            }
            service: 'blob'
            subnetResourceId: virtualNetworkSubnetResourceId
          }
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: filePrivateDnsZone.outputs.resourceId
                }
              ]
            }
            service: 'file'
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
    roleAssignments: roleAssignments
  }
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

output storageName string = storageAccount.outputs.name
output storageResourceId string = storageAccount.outputs.resourceId
