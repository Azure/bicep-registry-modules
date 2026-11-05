metadata name = 'AI Gateway Workspace'
metadata description = 'References the service-provisioned default workspace or writes workspace policies, then deploys child configuration.'

import { modelProviderType } from './model-provider/main.bicep'
import { policyType } from './model-provider/model/main.bicep'
import { aliasType } from './alias/main.bicep'
import { toolServerType } from './tool-server/main.bicep'
import { telemetryExporterType } from './telemetry-exporter/main.bicep'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Optional. The preview service provisions the default workspace automatically.')
param name 'default' = 'default'
@description('Optional. Inline workspace policies. Null leaves existing policies unchanged; an empty array clears policies.')
param policies policyType[]?
@description('Optional. Model providers and their models.')
param modelProviders modelProviderType[]?
@description('Optional. Model aliases.')
param aliases aliasType[]?
@description('Optional. Tool servers.')
param toolServers toolServerType[]?
@description('Optional. Runtime telemetry exporters.')
param telemetryExporters telemetryExporterType[]?
@secure()
@description('Optional. Secure values used by child resource configurations.')
param secrets { *: string } = {}

#disable-next-line BCP081
resource gateway 'Microsoft.ApiManagement/aigateways@2025-09-01-preview' existing = {
  name: aiGatewayName
}
#disable-next-line BCP081
resource workspace 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' existing = {
  name: name
  parent: gateway
}
#disable-next-line BCP081
resource workspacePolicies 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' = if (policies != null) {
  name: name
  parent: gateway
  properties: {
    policies: policies
  }
}

module workspace_modelProviders './model-provider/main.bicep' = [
  for (provider, index) in (modelProviders ?? []): {
    name: '${uniqueString(deployment().name)}-Provider-${index}'
    params: {
      aiGatewayName: aiGatewayName
      workspaceName: workspace.name
      name: provider.name
      properties: provider.properties
      models: provider.?models
      secrets: secrets
    }
    dependsOn: [
      workspacePolicies
    ]
  }
]
module workspace_aliases './alias/main.bicep' = [
  for (alias, index) in (aliases ?? []): {
    name: '${uniqueString(deployment().name)}-Alias-${index}'
    params: {
      aiGatewayName: aiGatewayName
      workspaceName: workspace.name
      name: alias.name
      properties: alias.properties
    }
    dependsOn: [
      workspacePolicies
      workspace_modelProviders
    ]
  }
]
module workspace_toolServers './tool-server/main.bicep' = [
  for (toolServer, index) in (toolServers ?? []): {
    name: '${uniqueString(deployment().name)}-ToolServer-${index}'
    params: {
      aiGatewayName: aiGatewayName
      workspaceName: workspace.name
      name: toolServer.name
      properties: toolServer.properties
      secrets: secrets
    }
    dependsOn: [
      workspacePolicies
    ]
  }
]
module workspace_telemetryExporters './telemetry-exporter/main.bicep' = [
  for (exporter, index) in (telemetryExporters ?? []): {
    name: '${uniqueString(deployment().name)}-Exporter-${index}'
    params: {
      aiGatewayName: aiGatewayName
      workspaceName: workspace.name
      name: exporter.name
      properties: exporter.properties
      secrets: secrets
    }
    dependsOn: [
      workspacePolicies
    ]
  }
]

@description('The workspace resource ID.')
output resourceId string = workspace.id
@description('The workspace name.')
output name string = workspace.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name
@description('The model provider resource IDs.')
output modelProviderResourceIds string[] = [
  for (provider, index) in (modelProviders ?? []): workspace_modelProviders[index].outputs.resourceId
]
@description('The alias resource IDs.')
output aliasResourceIds string[] = [for (alias, index) in (aliases ?? []): workspace_aliases[index].outputs.resourceId]
@description('The tool server resource IDs.')
output toolServerResourceIds string[] = [
  for (server, index) in (toolServers ?? []): workspace_toolServers[index].outputs.resourceId
]
@description('The runtime telemetry exporter resource IDs.')
output telemetryExporterResourceIds string[] = [
  for (exporter, index) in (telemetryExporters ?? []): workspace_telemetryExporters[index].outputs.resourceId
]

@export()
@sealed()
@description('Default workspace configuration. Additional named workspaces require preview RP support verification before extending this type.')
type workspaceType = {
  name: 'default'
  policies: policyType[]?
  modelProviders: modelProviderType[]?
  aliases: aliasType[]?
  toolServers: toolServerType[]?
  telemetryExporters: telemetryExporterType[]?
}
