// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
// Azure Storage Accounts

//                                                    Parameters
// ********************************************************************************************************************
param location string
param name string = uniqueString(resourceGroup().id)
param resourceGroupName string = resourceGroup().name
param subnetID string = ''
param enableVNET bool = false
param isZoneRedundant bool = false
param storageAccountType string = isZoneRedundant ? 'Standard_ZRS' : 'Standard_LRS'

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'
// End Parameters

//                                                    Variables
// ********************************************************************************************************************
var keys = newOrExisting == 'new' ? listKeys(newStorageAccount.id, newStorageAccount.apiVersion) : listKeys(storageAccount.id, storageAccount.apiVersion)
var blobStorageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${keys.keys[0].value}'
var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}
// End Variables

//                                                    Resources
// ********************************************************************************************************************
resource newStorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = if (newOrExisting == 'new') {
  name: name
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    networkAcls: networkAcls
    minimumTlsVersion: 'TLS1_2'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: name
}
// End Resources

//                                                    Outputs
// ********************************************************************************************************************
output id string = newOrExisting == 'new' ? newStorageAccount.id : storageAccount.id
output blobStorageConnectionString string = blobStorageConnectionString
// End Outputs
