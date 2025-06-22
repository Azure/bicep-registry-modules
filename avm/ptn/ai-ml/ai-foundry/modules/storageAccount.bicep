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

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the Storage Account and link the private DNS zone.')
param networkIsolation bool = true

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Resource ID of the Log Analytics workspace for diagnostic logs.')
param logAnalyticsWorkspaceResourceId string = ''

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
    enableTelemetry: enableTelemetry
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
    enableTelemetry: enableTelemetry
  }
}

var nameFormatted = take(toLower(storageName), 12)
var projUploadsContainerName = '${nameFormatted}projUploads'
var sysDataContainerName = '${nameFormatted}sysdata'

module storageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: take('${nameFormatted}-storage-account-deployment', 64)
  params: {
    name: nameFormatted
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    accessTier: 'Hot'
    allowBlobPublicAccess: toLower(aiFoundryType) != 'standardprivate'
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
              // {
              //   principalId: userObjectId
              //   principalType: 'ServicePrincipal'
              //   roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
              // }
            ]
          }
        }
        {
          name: sysDataContainerName
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
              // {
              //   principalId: userObjectId
              //   principalType: 'ServicePrincipal'
              //   roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
              // }
            ]
          }
        }
      ]
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: toLower(aiFoundryType) == 'standardprivate' ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
      // Optionally add ipRules or virtualNetworkRules here
    }
    supportsHttpsTrafficOnly: true
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [
          {
            name: 'default'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
      : []
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
output projUploadsContainerName string = projUploadsContainerName
output sysDataContainerName string = sysDataContainerName
