metadata name = 'API Management Service APIs Diagnostics'
metadata description = 'This module deploys an API Management Service API Diagnostics.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Conditional. The name of the logger. Required if the template is used in a standalone deployment.')
param loggerName string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }

  resource logger 'apis@2021-08-01' existing = {
    name: loggerName
  }
}

resource apiDiagnostics 'Microsoft.ApiManagement/service/apis/diagnostics@2021-12-01-preview' = {
  name: 'applicationinsights'
  parent: service::api
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
    loggerId: service::logger.id
    metrics: true
    sampling: {
      percentage: 100
      samplingType: 'fixed'
    }
    verbosity: 'verbose'
  }
}
