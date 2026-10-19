@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network.')
param virtualNetworkName string

@description('Required. The name of the Compute Gallery.')
param galleryName string

@description('Required. The name of the temporary package Storage Account.')
param storageAccountName string

@description('Required. The name of the package upload script.')
param deploymentScriptName string

@description('Required. The name of the script identity.')
param managedIdentityName string

@description('Required. The expiration time of the read-only package SAS.')
param packageSasExpiry string

var packageSasRequest = {
  canonicalizedResource: '/blob/${storageAccount.name}/${container.name}/marker.txt'
  signedResource: 'b'
  signedPermission: 'r'
  signedProtocol: 'https'
  signedExpiry: packageSasExpiry
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: blobService
  name: 'packages'
  properties: {
    publicAccess: 'None'
  }
}

resource scriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource uploadPackage 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: deploymentScriptName
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.67.0'
    retentionInterval: 'PT1H'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storageAccount.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccount.listKeys().keys[0].value
      }
    ]
    scriptContent: '''
      set -eu
      printf 'AVM VMSS gallery application test\n' > marker.txt
      az storage blob upload --container-name packages --name marker.txt --file marker.txt --overwrite --only-show-errors --output none
      '''
  }
  dependsOn: [
    container
  ]
}

resource gallery 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleryName
  location: location
  properties: {
    description: 'Temporary VMSS Gallery Applications test dependencies.'
  }
}

resource applications 'Microsoft.Compute/galleries/applications@2025-03-03' = [
  for name in ['first', 'second']: {
    parent: gallery
    name: name
    location: location
    properties: {
      supportedOSType: 'Linux'
    }
  }
]

resource versions 'Microsoft.Compute/galleries/applications/versions@2025-03-03' = [
  for (name, index) in ['first', 'second']: {
    parent: applications[index]
    name: '1.0.0'
    location: location
    properties: {
      publishingProfile: {
        manageActions: {
          install: 'mkdir -p /var/lib/avm-gallery-applications && cp marker.txt /var/lib/avm-gallery-applications/${name}'
          remove: 'rm -f /var/lib/avm-gallery-applications/${name}'
          update: 'mkdir -p /var/lib/avm-gallery-applications && cp marker.txt /var/lib/avm-gallery-applications/${name}'
        }
        source: {
          mediaLink: '${storageAccount.properties.primaryEndpoints.blob}${container.name}/marker.txt?${storageAccount.listServiceSAS('2025-01-01', packageSasRequest).serviceSasToken}'
        }
        settings: {
          packageFileName: 'marker.txt'
        }
        targetRegions: [
          {
            name: location
            regionalReplicaCount: 1
          }
        ]
      }
    }
    dependsOn: [
      uploadPackage
    ]
  }
]

@description('The resource ID of the subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource IDs of the application definitions. The versions are created before the outputs are returned.')
output applicationResourceIds string[] = [for (name, index) in ['first', 'second']: applications[index].id]

@description('The resource IDs of the published test application versions.')
output applicationVersionResourceIds string[] = [for (name, index) in ['first', 'second']: versions[index].id]
