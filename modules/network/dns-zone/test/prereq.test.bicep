module trafficManager 'br/public:network/traffic-manager:2.2.1' = {
  name: 'traffic-manager-${uniqueString(resourceGroup().id)}'
  params: {
    prefix: 'trafdns'
  }
}

output trafficManagerId string = trafficManager.outputs.id
