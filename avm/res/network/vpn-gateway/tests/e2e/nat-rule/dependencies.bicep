@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual WAN.')
param virtualWANName string

@description('Required. The name of the Virtual Hub.')
param virtualHubName string

@description('Required. The name of the VPN Site.')
param vpnSiteName string

// Create Virtual WAN
resource virtualWAN 'Microsoft.Network/virtualWans@2024-07-01' = {
  name: virtualWANName
  location: location
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    type: 'Standard'
  }
}

// Create Virtual Hub
resource virtualHub 'Microsoft.Network/virtualHubs@2024-07-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: '10.1.0.0/16'
    virtualWan: {
      id: virtualWAN.id
    }
  }
}

// Create VPN Site for testing
resource vpnSite 'Microsoft.Network/vpnSites@2024-07-01' = {
  name: vpnSiteName
  location: location
  properties: {
    virtualWan: {
      id: virtualWAN.id
    }
    deviceProperties: {
      deviceVendor: 'TestVendor'
      deviceModel: 'TestModel'
      linkSpeedInMbps: 100
    }
    vpnSiteLinks: [
      {
        name: 'test-site-link'
        properties: {
          ipAddress: '203.0.113.1'
          linkProperties: {
            linkProviderName: 'TestProvider'
            linkSpeedInMbps: 100
          }
          bgpProperties: {
            asn: 65001
            bgpPeeringAddress: '10.0.0.1'
          }
        }
      }
    ]
  }
}

// Outputs
@description('The resource ID of the Virtual WAN.')
output virtualWANResourceId string = virtualWAN.id

@description('The resource ID of the Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The resource ID of the VPN Site.')
output vpnSiteResourceId string = vpnSite.id

@description('The resource ID of the VPN Site Link.')
output vpnSiteLinkResourceId string = vpnSite.properties.vpnSiteLinks[0].id
