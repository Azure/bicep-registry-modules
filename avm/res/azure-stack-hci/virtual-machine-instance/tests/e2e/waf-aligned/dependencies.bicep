targetScope = 'resourceGroup'

metadata name = 'Using WAF-aligned config'
metadata description = 'This instance deploys the module with WAF aligned parameters.'

// ========== //
// Parameters //
// ========== //

@description('Required. The location to deploy resources to.')
param resourceLocation string

@description('Required. Resource ID of the associated custom location.')
param customLocation string

// ============ //
// Dependencies //
// ============ //

resource hciWinImage 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2024-01-01' = {
  name: 'winServer2022-01'
  location: resourceLocation
  extendedLocation: {
    name: customLocation
    type: 'CustomLocation'
  }
  properties: {
    containerId: null
    osType: 'Windows'
    hyperVGeneration: 'V2'
    identifier: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
    }
    version: {
      name: '20348.2113.231109'
      properties: {
        storageProfile: {
          osDiskImage: {}
        }
      }
    }
  }
}

output resourceId string = hciWinImage.id
