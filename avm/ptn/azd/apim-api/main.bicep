metadata name = 'avm/ptn/azd/apim-api'
metadata description = '''Creates and configure an API within an API Management service instance.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. Name of the API Management service instance.')
param name string

@description('Required. Resource name to uniquely identify this API within the API Management service instance.')
@minLength(1)
param apiName string

@description('Required. The Display Name of the API.')
@minLength(1)
@maxLength(300)
param apiDisplayName string

@description('Required. Description of the API. May include HTML formatting tags.')
@minLength(1)
param apiDescription string

@description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
@minLength(1)
param apiPath string

@description('Required. Absolute URL of web frontend.')
param webFrontendUrl string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Absolute URL of the backend service implementing this API.')
param apiBackendUrl string

@description('Optional. Resource name for backend Web App or Function App.')
param apiAppName string = ''

// ============== //
// Variables      //
// ============== //

var apiPolicyContent = replace(loadTextContent('modules/apim-api-policy.xml'), '{origin}', webFrontendUrl)

// Necessary due to https://github.com/Azure/bicep/issues/9594
// placeholderName is never deployed, it is merely used to make the child name validation pass
var appNameForBicep = !empty(apiAppName) ? apiAppName : 'placeholderName'

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-apimapi.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource restApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: apiName
  parent: apimService
  properties: {
    description: apiDescription
    displayName: apiDisplayName
    path: apiPath
    protocols: ['https']
    subscriptionRequired: false
    type: 'http'
    format: 'openapi'
    serviceUrl: apiBackendUrl
    value: loadTextContent('modules/openapi.yaml')
  }
}

resource apiPolicy 'Microsoft.ApiManagement/service/apis/policies@2022-08-01' = {
  name: 'policy'
  parent: restApi
  properties: {
    format: 'rawxml'
    value: apiPolicyContent
  }
}

resource apiDiagnostics 'Microsoft.ApiManagement/service/apis/diagnostics@2022-08-01' = {
  name: 'applicationinsights'
  parent: restApi
  properties: {
    alwaysLog: 'allErrors'
    backend: {
      request: {
        body: {
          bytes: 1024
        }
      }
      response: {
        body: {
          bytes: 1024
        }
      }
    }
    frontend: {
      request: {
        body: {
          bytes: 1024
        }
      }
      response: {
        body: {
          bytes: 1024
        }
      }
    }
    httpCorrelationProtocol: 'W3C'
    logClientIp: true
    loggerId: apimLogger.id
    metrics: true
    sampling: {
      percentage: 100
      samplingType: 'fixed'
    }
    verbosity: 'verbose'
  }
}

resource apimService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: name
}

resource apiAppProperties 'Microsoft.Web/sites/config@2022-09-01' = if (!empty(apiAppName)) {
  name: '${appNameForBicep}/web'
  kind: 'string'
  properties: {
    apiManagementConfig: {
      id: '${apimService.id}/apis/${apiName}'
    }
  }
}

resource apimLogger 'Microsoft.ApiManagement/service/loggers@2022-08-01' existing = {
  name: 'app-insights-logger'
  parent: apimService
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group.')
output resourceGroupName string = resourceGroup().name

@description('The complete URL for accessing the API.')
output serviceApiUri string = '${apimService.properties.gatewayUrl}/${apiPath}'
