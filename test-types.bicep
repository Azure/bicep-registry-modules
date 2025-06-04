// Test file to validate the new type definitions
param testBgpSettings bgpSettingsType = {
  asn: 65515
  peerWeight: 0
}

param testRoutingConfig routingConfigurationType = {
  associatedRouteTable: {
    id: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Network/virtualHubs/test-hub/hubRouteTables/defaultRouteTable'
  }
  propagatedRouteTables: {
    labels: ['default']
    ids: [
      {
        id: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Network/virtualHubs/test-hub/hubRouteTables/defaultRouteTable'
      }
    ]
  }
  vnetRoutes: {
    staticRoutes: []
  }
}

// Import the types from the VPN Gateway module
import { bgpSettingsType, routingConfigurationType } from './avm/res/network/vpn-gateway/main.bicep'

output bgpTest object = testBgpSettings
output routingTest object = testRoutingConfig
