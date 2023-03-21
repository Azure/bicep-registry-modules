// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
// Azure Traffic Manager Profile

//                                                    Parameters
// ********************************************************************************************************************
param name string = 'traffic-mp-${uniqueString(resourceGroup().id, subscription().id)}'
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'
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

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'
// End Parameters

//                                                    Resources
// ********************************************************************************************************************
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
// End Resources

//                                                    Outputs
// ********************************************************************************************************************
output name string = newOrExisting == 'new' ? trafficManagerProfile.name : existingTrafficManagerProfile.name
// End Outputs
