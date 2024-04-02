metadata name = 'Hosting Environment Network Configuration'
metadata description = 'This module deploys a Hosting Environment Network Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Hosting Environment. Required if the template is used in a standalone deployment.')
param hostingEnvironmentName string

@description('Optional. Property to enable and disable new private endpoint connection creation on ASE.')
param allowNewPrivateEndpointConnections bool = false

@description('Optional. Property to enable and disable FTP on ASEV3.')
param ftpEnabled bool = false

@description('Optional. Customer provided Inbound IP Address. Only able to be set on Ase create.')
param inboundIpAddressOverride string = ''

@description('Optional. Property to enable and disable Remote Debug on ASEv3.')
param remoteDebugEnabled bool = false

resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2022-03-01' existing = {
  name: hostingEnvironmentName
}

resource configuration 'Microsoft.Web/hostingEnvironments/configurations@2022-03-01' = {
  name: 'networking'
  parent: appServiceEnvironment
  properties: {
    allowNewPrivateEndpointConnections: allowNewPrivateEndpointConnections
    ftpEnabled: ftpEnabled
    inboundIpAddressOverride: inboundIpAddressOverride
    remoteDebugEnabled: remoteDebugEnabled
  }
}

@description('The name of the configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
