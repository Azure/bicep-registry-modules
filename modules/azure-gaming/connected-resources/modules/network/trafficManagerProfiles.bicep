@description('Traffic Manager Profile Resource Name')
param name string = 'traffic-mp-${uniqueString(resourceGroup().id, subscription().id)}'

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

@description('An array of objects that represent the endpoints in the Traffic Manager profile. {name: string, target: string, endpointStatus: string, endpointLocation: string}')
param endpoints array = []
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

resource trafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = if (newOrExisting == 'new') {
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

resource existingTrafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' existing = { name: name }

output name string = newOrExisting == 'new' ? trafficManagerProfile.name : existingTrafficManagerProfile.name
