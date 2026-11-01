metadata name = 'AI Gateway Tool Server'
metadata description = 'Configures MCP and OpenAPI upstream endpoints.'

import { policyType } from '../model-provider/model/main.bicep'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. Parent workspace name.')
param workspaceName string
@description('Required. Tool server resource name.')
param name string
@description('Required. Tool server configuration.')
param properties toolServerPropertiesType
@secure()
@description('Optional. Secure upstream header values.')
param secrets { *: string } = {}

#disable-next-line BCP081
resource workspace 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' existing = {
  name: '${aiGatewayName}/${workspaceName}'
}
#disable-next-line BCP081
resource toolServer 'Microsoft.ApiManagement/aigateways/workspaces/toolServers@2025-09-01-preview' = {
  name: name
  parent: workspace
  properties: {
    displayName: properties.?displayName
    description: properties.?description
    type: properties.type
    failureMode: properties.?failureMode
    accessState: properties.?accessState
    path: properties.?path
    subscriptionRequired: properties.?subscriptionRequired ?? true
    allowList: properties.?allowList
    blocked: properties.?blocked
    policies: properties.?policies
    endpoints: [
      for endpoint in properties.endpoints: union(
        {
          id: endpoint.?id
          namespace: endpoint.?namespace
          tools: endpoint.?tools
          required: endpoint.?required ?? false
          kind: endpoint.kind
          credentials: endpoint.?credentials == null
            ? {
                type: 'none'
              }
            : (endpoint.credentials!.type == 'header'
                ? {
                    type: 'header'
                    headers: toObject(
                      endpoint.credentials!.headers,
                      header => header.name,
                      header => [
                        header.?secretName != null ? secrets[header.secretName!] : (header.?value ?? '')
                      ]
                    )
                  }
                : endpoint.credentials!)
        },
        endpoint.kind == 'mcp'
          ? {
              mcp: endpoint.mcp
            }
          : {
              openApi: endpoint.openApi
            }
      )
    ]
  }
}

@description('The tool server resource ID.')
output resourceId string = toolServer.id
@description('The tool server name.')
output name string = toolServer.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name

@export()
@sealed()
@description('Tool server resource configuration.')
type toolServerType = {
  name: string
  properties: toolServerPropertiesType
}
@export()
@sealed()
@description('Tool server wire properties. Connector-backed servers are deliberately excluded.')
type toolServerPropertiesType = {
  displayName: string?
  description: string?
  type: 'mcp' | 'openApi'
  failureMode: ('failClosed' | 'failOpen')?
  accessState: ('active' | 'blocked')?
  path: string?
  subscriptionRequired: bool?
  allowList: string[]?
  blocked: string[]?
  policies: policyType[]?
  @minLength(1)
  endpoints: toolEndpointType[]
}
@export()
@discriminator('kind')
@description('MCP or URL-based OpenAPI upstream endpoint.')
type toolEndpointType = mcpEndpointType | openApiEndpointType
@sealed()
type mcpEndpointType = {
  id: string?
  namespace: string?
  kind: 'mcp'
  mcp: {
    url: string
    transport: 'streamableHttp'?
  }
  credentials: toolCredentialsType?
  tools: string[]?
  required: bool?
}
@sealed()
type openApiEndpointType = {
  id: string?
  namespace: string?
  kind: 'openApi'
  openApi: {
    specSource: {
      type: 'url'
      url: string
    }
  }
  credentials: toolCredentialsType?
  tools: string[]?
  required: bool?
}
@discriminator('type')
type toolCredentialsType = anonymousCredentialsType | headerCredentialsType | managedIdentityCredentialsType
@sealed()
type anonymousCredentialsType = {
  type: 'none'
}
@sealed()
type headerCredentialsType = {
  type: 'header'
  @minLength(1)
  headers: {
    name: string
    secretName: string?
    value: string?
  }[]
}
@sealed()
type managedIdentityCredentialsType = {
  type: 'managedIdentity'
  managedIdentity: {
    resource: string
    clientId: string?
  }
}
