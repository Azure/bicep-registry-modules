@description('Required. The name of the Action Group to create.')
param actionGroupName string

@description('Required. The name of the Application Insights to create.')
param appInsightsName string

@description('Required. Location to deploy resources to.')
param resourceLocation string

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'global'

  properties: {
    enabled: true
    groupShortName: substring(actionGroupName, 0, 11)
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: resourceLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource pingTest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'PingTest-${toLower(appInsightsName)}'
  location: resourceLocation
  properties: {
    Name: 'PingTest-${toLower(appInsightsName)}'
    Description: 'Basic ping test'
    Enabled: true
    Frequency: 300
    Timeout: 120
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-il-ch1-azr'
      }
      {
        Id: 'latam-br-gru-edge'
      }
      {
        Id: 'us-fl-mia-edge'
      }
      {
        Id: 'apac-jp-kaw-edge'
      }
      {
        Id: 'emea-fr-pra-edge'
      }
    ]
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      SSLCheck: false
    }
    Request: {
      RequestUrl: 'https://www.microsoft.com'
      HttpVerb: 'GET'
      ParseDependentRequests: false
    }
    SyntheticMonitorId: 'PingTest-${toLower(appInsightsName)}'
  }
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
}

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id
@description('The resource ID of the created Application Insights.')
output appInsightsResourceId string = appInsights.id
@description('The resource ID of the webtest.')
output pingTestResourceId string = pingTest.id
