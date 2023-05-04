param location string
param name string
param prefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: '${name}-${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${name}-subnet-0'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: '${name}-subnet-1'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azconfig.io'
  location: 'global'
  properties: {}
}

resource virtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDNSZone
  name: '${name}-${prefix}-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

resource managedIdentity_01 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${name}-${prefix}-mi01'
  location: location
}

resource managedIdentity_02 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${name}-${prefix}-mi02'
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: '${name}-${prefix}-kv'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    softDeleteRetentionInDays: 7
    enablePurgeProtection: true
    accessPolicies: [
      {
        objectId: managedIdentity_01.properties.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
          secrets: [
            'get'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
  }
}

resource keyVaultKey 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: keyVault
  name: 'testkey'
  properties: {
    kty: 'RSA'
    keySize: 2048
    keyOps: [
      'encrypt'
      'decrypt'
      'sign'
      'verify'
      'wrapKey'
      'unwrapKey'
    ]
    attributes: {
      enabled: true
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${name}-${prefix}-law'
  location: location
}

output vnetId string = virtualNetwork.id
output subnetIds array = [
  virtualNetwork.properties.subnets[0].id
  virtualNetwork.properties.subnets[1].id
]
output privateDNSZoneId string = privateDNSZone.id

output identityPrincipalIds array = [
  managedIdentity_01.properties.principalId
  managedIdentity_02.properties.principalId
]

output identityClientIds array = [
  managedIdentity_01.properties.clientId
  managedIdentity_02.properties.clientId
]

output identityIds array = [
  managedIdentity_01.id
  managedIdentity_02.id
]

output keyVaultId string = keyVault.id
output keyVaultKeyUri string = keyVaultKey.properties.keyUriWithVersion

output workspaceId string = logAnalyticsWorkspace.id
