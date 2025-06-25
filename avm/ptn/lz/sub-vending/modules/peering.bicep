param sourceVirtualNetworkName string
param destinationVirtualNetworkName string
param destinationVirtualNetworkResourceGroupName string

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${sourceVirtualNetworkName}/${sourceVirtualNetworkName}-to-${destinationVirtualNetworkName}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(
        destinationVirtualNetworkResourceGroupName,
        'Microsoft.Network/virtualNetworks',
        destinationVirtualNetworkName
      )
    }
  }
}
