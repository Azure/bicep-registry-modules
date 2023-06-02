@description('Prefix of traffic manager profile resource name. This param is ignored when name is provided.')
param prefix string = 'traf'

@description('Name of Traffic Manager Profile Resource')
@minLength(1)
@maxLength(63)
param name string = take('${prefix}${uniqueString(resourceGroup().id, subscription().id)}', 63)

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id, name)}'

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

@description('The status of the Traffic Manager profile. default is Enabled.')
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

@description('Enable Diagnostic Capture . default is false')
param enableDiagnostics bool = false

@description('Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. default is 365.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('The name of logs that will be streamed. default is allLogs.')
@allowed([
  'allLogs'
  'ProbeHealthStatusEvents'
])
param logsToEnable string = 'allLogs'

var metricsToEnable = [
  'AllMetrics'
]

var diagnosticsLogs = [ {
    category: logsToEnable == 'allLogs' ? null : logsToEnable
    categoryGroup: logsToEnable == 'allLogs' ? logsToEnable : null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  } ]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

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

resource trafficManagerdiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  name: '${trafficManagerProfile.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: trafficManagerProfile
}

@description('Traffic Manager Profile Resource ID')
output id string = trafficManagerProfile.id

@description('Traffic Manager Profile Resource Name')
output name string = name
