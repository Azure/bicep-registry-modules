@description('Prefix of Traffic Manager Profile Name')
param prefix string = 'traf'

@description('Traffic Manager Profile Resource Name')
param name string = '${prefix}-${uniqueString(resourceGroup().id, subscription().id)}'

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@description('An array of objects that represent the endpoints in the Traffic Manager profile. {name: string, target: string, endpointStatus: string, endpointLocation: string}')
param endpoints array = []

@description('An object that represents the monitoring configuration for the Traffic Manager profile.')
param monitorConfig object = {
  protocol: 'HTTPS'
  port: 443
  path: '/'
  expectedStatusCodeRanges: [
    {
      min: 200
      max: 202
    }
    {
      min: 301
      max: 302
    }
  ]
}

resource trafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: name
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: toLower(trafficManagerDnsName)
      ttl: 30
    }
    monitorConfig: {
      protocol: contains(monitorConfig, 'protocol') ? monitorConfig.protocol : 'HTTPS'
      port: contains(monitorConfig, 'port') ? monitorConfig.port : 443
      path: contains(monitorConfig, 'path') ? monitorConfig.path : '/'
      expectedStatusCodeRanges: contains(monitorConfig, 'expectedStatusCodeRanges') ? monitorConfig.expectedStatusCodeRanges : [
        {
          min: 200
          max: 202
        }
        {
          min: 301
          max: 302
        }
      ]
    }
  }
}

resource trafficManagerEndpoints 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints@2018-08-01' = [for endpoint in endpoints: if (newOrExisting == 'new' && !empty(endpoint)) {
  parent: trafficManagerProfile
  name: endpoint.name
  properties: {
    target: endpoint.target
    endpointStatus: contains(endpoint, 'endpointStatus') ? endpoint.endpointStatus : 'Enabled'
    endpointLocation: endpoint.endpointLocation
  }
}]

@description('Traffic Manager Profile Resource ID')
output id string = trafficManagerProfile.id

@description('Traffic Manager Profile Resource Name')
output name string = trafficManagerProfile.name
