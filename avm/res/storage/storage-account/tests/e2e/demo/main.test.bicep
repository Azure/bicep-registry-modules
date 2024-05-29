param storageAccountName string = uniqueString('stg', resourceGroup().id)
param location string = resourceGroup().location
param skuName string = 'Standard_LRS'
param managedIdentityName string = 'mi-${uniqueString(resourceGroup().id)}'

/////////////////// Use Bicep resources to build dependant resources for demo, using native to not hide anything :)

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource stgBlobDataContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing= {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: tenant()
}

resource blobPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-eag-demo-avm-bicep'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.99.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-pep'
        properties: {
          addressPrefix: '10.99.255.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource dnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: blobPrivateDNSZone
  name: 'dnsZoneLink'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

/////////////////// DIY Approach ///////////////////

resource stg 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
}

resource stgBlobDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, 'stgBlobDataContributorRoleAssignment')
  scope: stg
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: stgBlobDataContributor.id
  }
}

resource blobPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'blobPrivateEndpoint'
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[0].id
    }
    privateLinkServiceConnections: [
      {
        name: 'blobPrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: stg.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource blobPrivateEndpointZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: blobPrivateEndpoint
  name: 'zoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'zoneConfig'
        properties: {
          privateDnsZoneId: blobPrivateDNSZone.id
        }
      }
    ]
  }
}

/////////////////// Using AVM module ///////////////////

module avmStg 'br/public:avm/res/storage/storage-account:0.9.0' = {
  name: '${storageAccountName}-deployment'
  params: {
    name: 'avm${storageAccountName}'
    location: location
    skuName: skuName
    kind: 'StorageV2'
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: stgBlobDataContributor.id
      }
    ]
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: virtualNetwork.properties.subnets[0].id
        privateDnsZoneGroupName: 'zoneGroup'
        privateDnsZoneResourceIds: [
          blobPrivateDNSZone.id
        ]
      }
    ]
  }
}
