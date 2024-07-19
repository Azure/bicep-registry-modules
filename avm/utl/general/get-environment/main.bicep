metadata name = 'general'
metadata description = 'This module provides you with several functions you can import into your template.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Definitions      //
// ================ //
//

type environmentType = 'AzureCloud' | 'AzureChinaCloud' | 'AzureUSGovernment'

@export()
@description('Get the graph endpoint for the given environment')
func getGraphEndpoint(environment environmentType) string =>
  {
    AzureCloud: az.environment().graph
    AzureChinaCloud: 'https://graph.chinacloudapi.cn'
    AzureUSGovernment: az.environment().graph
  }[environment]

@export()
@description('Get the Portal URL for the given environment')
func getPortalUrl(environment environmentType) string =>
  {
    AzureCloud: az.environment().portal
    AzureChinaCloud: 'https://portal.azure.cn'
    AzureUSGovernment: 'https://portal.azure.us'
  }[environment]
