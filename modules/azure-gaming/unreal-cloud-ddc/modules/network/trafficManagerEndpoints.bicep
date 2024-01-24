@description('Existing Traffic Manager Profile Resource Name')
param trafficManagerName string

@description('An array of objects that represent the endpoints in the Traffic Manager profile. {name: string, target: string, endpointStatus: string, endpointLocation: string}')
param endpoints array = []

resource existingTrafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' existing = { name: trafficManagerName }

resource trafficManagerEndpoints 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints@2018-08-01' = [for endpoint in endpoints: if (!empty(endpoint)) {
  parent: existingTrafficManagerProfile
  name: endpoint.name
  properties: {
    target: endpoint.target
    endpointStatus: contains(endpoint, 'endpointStatus') ? endpoint.endpointStatus : 'Enabled'
    endpointLocation: endpoint.endpointLocation
  }
}]
