// ============================================================================
// Dependencies for WAF-aligned test
// Creates VNet, subnet, and private DNS zones required for private endpoints
// ============================================================================

@description('Required. The location to deploy resources to.')
param location string

@description('Required. The name prefix for resources.')
param namePrefix string

@description('Optional. Secondary location for Log Analytics workspace replication (WAF: AZR-000425).')
param secondaryLocation string = 'westeurope'

// ============================================================================
// Network Security Group for Private Endpoint Subnet
// WAF: AZR-000263 (UseNSGs), AZR-000447 (PrivateSubnet - deny direct Internet)
// ============================================================================
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: '${namePrefix}-nsg'
  location: location
  tags: {
    SecurityControl: 'Ignore'
    Environment: 'Test'
    'hidden-title': 'FinOps Hub Test Dependencies - NSG'
  }
  properties: {
    securityRules: [
      {
        name: 'AllowVnetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
        }
      }
      {
        name: 'DenyInternetOutbound'
        properties: {
          priority: 4096
          direction: 'Outbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// ============================================================================
// Virtual Network with Private Endpoint Subnet
// WAF: AZR-000166 (UseTags) - resources must be tagged
// ============================================================================
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: '${namePrefix}-vnet'
  location: location
  tags: {
    SecurityControl: 'Ignore'
    Environment: 'Test'
    'hidden-title': 'FinOps Hub Test Dependencies - VNet'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

// ============================================================================
// Log Analytics Workspace for Diagnostic Settings
// WAF: AZR-000119 (KeyVault.Logs) - audit diagnostics require a destination
// ============================================================================
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: '${namePrefix}-law'
  location: location
  tags: {
    SecurityControl: 'Ignore'
    Environment: 'Test'
    'hidden-title': 'FinOps Hub Test Dependencies - LAW'
  }
  properties: {
    replication: {
      enabled: true
      location: secondaryLocation
    }
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// ============================================================================
// Private DNS Zones for Azure Services
// ============================================================================

// Blob Storage Private DNS Zone
resource blobPrivateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
}

resource blobVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: blobPrivateDnsZone
  name: '${namePrefix}-blob-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

// DFS Storage Private DNS Zone
resource dfsPrivateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.dfs.${environment().suffixes.storage}'
  location: 'global'
}

resource dfsVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: dfsPrivateDnsZone
  name: '${namePrefix}-dfs-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

// Key Vault Private DNS Zone
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
}

resource keyVaultVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: keyVaultPrivateDnsZone
  name: '${namePrefix}-kv-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

// Data Factory Private DNS Zone
resource dataFactoryPrivateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.datafactory.azure.net'
  location: 'global'
}

resource dataFactoryVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: dataFactoryPrivateDnsZone
  name: '${namePrefix}-adf-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('The resource ID of the private endpoint subnet.')
output privateEndpointSubnetId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the blob storage private DNS zone.')
output storageBlobPrivateDnsZoneId string = blobPrivateDnsZone.id

@description('The resource ID of the DFS storage private DNS zone.')
output storageDfsPrivateDnsZoneId string = dfsPrivateDnsZone.id

@description('The resource ID of the Key Vault private DNS zone.')
output keyVaultPrivateDnsZoneId string = keyVaultPrivateDnsZone.id

@description('The resource ID of the Data Factory private DNS zone.')
output dataFactoryPrivateDnsZoneId string = dataFactoryPrivateDnsZone.id

@description('The resource ID of the Log Analytics workspace for diagnostic settings.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
