@description('Name of Traffic Manager Profile Resource')
@minLength(1)
@maxLength(63)
param name string

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string

@description('Tags for the module resources.')
param tags object = {}

@description('The traffic routing method of the Traffic Manager profile. default is "Performance".')
@allowed([
  'Geographic'
  'MultiValue'
  'Performance'
  'Priority'
  'Subnet'
  'Weighted'
])
param trafficRoutingMethod string = 'Performance'

@description('The DNS Time-To-Live (TTL), in seconds. default is 30. ')
param ttl int = 30

@description('Optional. The status of the Traffic Manager profile. default is Enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param profileStatus string = 'Enabled'

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
  tags: tags
  properties: {
    profileStatus: profileStatus
    trafficRoutingMethod: trafficRoutingMethod
    dnsConfig: {
      relativeName: toLower(trafficManagerDnsName)
      ttl: ttl
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

resource trafficManagerEndpoints 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints@2018-08-01' = [for endpoint in endpoints: if (!empty(endpoint)) {
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
output name string = name
