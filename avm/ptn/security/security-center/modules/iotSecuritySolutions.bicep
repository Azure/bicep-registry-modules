@description('Optional. Security Solution data.')
param ioTSecuritySolutionProperties object = {}

resource iotSecuritySolutions 'Microsoft.Security/iotSecuritySolutions@2019-08-01' =
  if (!empty(ioTSecuritySolutionProperties)) {
    name: 'iotSecuritySolutions'
    properties: {
      workspace: ioTSecuritySolutionProperties.workspace
      displayName: ioTSecuritySolutionProperties.displayName
      status: ioTSecuritySolutionProperties.status
      export: ioTSecuritySolutionProperties.export
      disabledDataSources: ioTSecuritySolutionProperties.disabledDataSources
      iotHubs: ioTSecuritySolutionProperties.iotHubs
      userDefinedResources: ioTSecuritySolutionProperties.userDefinedResources
      recommendationsConfiguration: ioTSecuritySolutionProperties.recommendationsConfiguration
    }
  }
