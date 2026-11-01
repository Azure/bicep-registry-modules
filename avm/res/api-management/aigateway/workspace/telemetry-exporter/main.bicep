metadata name = 'AI Gateway Telemetry Exporter'
metadata description = 'Configures runtime telemetry with payload capture disabled by default.'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. Parent workspace name.')
param workspaceName string
@description('Required. Exporter resource name.')
param name string
@description('Required. Export destination configuration.')
param properties telemetryExporterPropertiesType
@secure()
@description('Optional. Secure connection strings and OTLP headers.')
param secrets { *: string } = {}

#disable-next-line BCP081
resource workspace 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' existing = {
  name: '${aiGatewayName}/${workspaceName}'
}
#disable-next-line BCP081
resource exporter 'Microsoft.ApiManagement/aigateways/workspaces/telemetryExporters@2025-09-01-preview' = {
  name: name
  parent: workspace
  properties: union(
    {
      kind: properties.kind
      payloadCapture: properties.?payloadCapture ?? false
    },
    properties.kind == 'ApplicationInsights'
      ? {
          applicationInsights: {
            connectionString: secrets[properties.applicationInsights.connectionStringSecretName]
            resourceId: properties.applicationInsights.?resourceId
          }
        }
      : {
          openTelemetry: {
            metricsEndpoint: properties.openTelemetry.?metricsEndpoint
            logsEndpoint: properties.openTelemetry.?logsEndpoint
            tracesEndpoint: properties.openTelemetry.?tracesEndpoint
            managedIdentity: properties.openTelemetry.?managedIdentity
            headers: toObject(
              properties.openTelemetry.?headers ?? [],
              header => header.name,
              header => secrets[header.secretName]
            )
          }
        }
  )
}

@description('The exporter resource ID.')
output resourceId string = exporter.id
@description('The exporter name.')
output name string = exporter.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name

@export()
@sealed()
@description('Runtime telemetry exporter configuration.')
type telemetryExporterType = {
  name: string
  properties: telemetryExporterPropertiesType
}
@export()
@discriminator('kind')
@description('Exporter kind selects its destination.')
type telemetryExporterPropertiesType = applicationInsightsPropertiesType | openTelemetryPropertiesType
@sealed()
type applicationInsightsPropertiesType = {
  kind: 'ApplicationInsights'
  payloadCapture: bool?
  applicationInsights: {
    connectionStringSecretName: string
    resourceId: string?
  }
}
@sealed()
type openTelemetryPropertiesType = {
  kind: 'OpenTelemetry'
  payloadCapture: bool?
  openTelemetry: {
    metricsEndpoint: string?
    logsEndpoint: string?
    tracesEndpoint: string?
    managedIdentity: {
      resource: string?
      clientId: string?
    }?
    headers: {
      name: string
      secretName: string
    }[]?
  }
}
