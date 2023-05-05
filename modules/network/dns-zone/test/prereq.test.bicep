param seed string = utcNow()

module trafficManager 'br/public:network/traffic-manager:2.2.1' = {
  name: 'traffic-manager-${uniqueString(resourceGroup().id)}'
  params: {
    prefix: 'trafdns${uniqueString(resourceGroup().id, subscription().id, seed)}'
    trafficManagerDnsName: 'tmp-${uniqueString(resourceGroup().id, subscription().id, seed)}'
  }
}

output trafficManagerId string = trafficManager.outputs.id
