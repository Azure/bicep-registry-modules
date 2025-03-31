@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the managed disk to create.')
param diskName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

// @description('Required. The name of the storage account to create.')
// param storageAccountName2 string

@description('Required. List of the containers to be protected')
param storageAccountContainerList string[]

// resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: managedIdentityName
//   location: location
// }

// resource computeDisk 'Microsoft.Compute/disks@2020-12-01' = {
//   name: diskName
//   location: location
//   properties: {
//     creationData: {
//       createOption: 'Empty'
//     }
//     diskSizeGB: 200
//   }
// }

// resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   name: storageAccountName
//   location: location
//   kind: 'StorageV2'
//   sku: {
//     name: 'Standard_LRS'
//   }
//   properties: {
//     allowBlobPublicAccess: false
//   }

//   resource blobServices 'blobServices@2022-09-01' = {
//     name: 'default'

//     resource container 'containers@2022-09-01' = {
//       name: 'container001'
//       properties: {
//         publicAccess: 'None'
//       }
//     }
//   }
// }

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_RAGRS'
    // tier: 'Standard'
  }
  resource blobServices 'blobServices@2024-01-01' = {
    name: 'default'
    resource container 'containers@2024-01-01' = [
      for item in storageAccountContainerList: {
        name: item
      }
    ]
  }
}

// resource storageContainerList 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [
//   for item in storageAccountContainerList: {
//     name: '${storageAccount.name}/default/${item}'
//   }
// ]

// resource storageAccount2 'Microsoft.Storage/storageAccounts@2023-01-01' = {
//   name: storageAccountName2
//   location: location
//   kind: 'StorageV2'
//   sku: {
//     name: 'Standard_RAGRS'
//     tier: 'Standard'
//   }
// }

// resource storageContainerList2 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [
//   for item in containerList: {
//     name: '${storageAccount2.name}/default/${item}'
//   }
// ]

// @description('The principal ID of the created Managed Identity.')
// output managedIdentityPrincipalId string = managedIdentity.properties.principalId

// @description('The resource ID of the created Managed Identity.')
// output managedIdentityResourceId string = managedIdentity.id

// @description('The resource ID of the created Managed Disk.')
// output diskResourceId string = computeDisk.id

// @description('The resource ID of the created Managed Disk.')
// output diskName string = computeDisk.name

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.name

// @description('The resource ID of the created Storage Account.')
// output storageAccountResourceId2 string = storageAccount2.id

// @description('The name of the created Storage Account.')
// output storageAccountName2 string = storageAccount2.name
