@sys.description('Conditional. The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment.')
param applicationGroupName string

@sys.description('Required. Name of the Application to be created in the Application Group.')
param name string

@sys.description('Optional. Description of Application..')
param description string = ''

@sys.description('Required. Friendly name of Application..')
param friendlyName string

@sys.description('Required. Specifies a path for the executable file for the application.')
param filePath string

@allowed([
  'Allow'
  'DoNotAllow'
  'Require'
])
@sys.description('Optional. Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all.')
param commandLineSetting string = 'DoNotAllow'

@sys.description('Optional. Command-Line Arguments for Application.')
param commandLineArguments string = ''

@sys.description('Optional. Specifies whether to show the RemoteApp program in the RD Web Access server.')
param showInPortal bool = false

@sys.description('Optional. Path to icon.')
param iconPath string = ''

@sys.description('Optional. Index of the icon.')
param iconIndex int = 0

@sys.description('Optional. Enable telemetry.')
param enableTelemetry bool = true

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.destopvirtualization-aga.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' existing = {
  name: applicationGroupName
}

resource application 'Microsoft.DesktopVirtualization/applicationGroups/applications@2023-09-05' = {
  name: name
  parent: applicationGroup
  properties: {
    description: description
    friendlyName: friendlyName
    filePath: filePath
    commandLineSetting: commandLineSetting
    commandLineArguments: commandLineArguments
    showInPortal: showInPortal
    iconPath: iconPath
    iconIndex: iconIndex
  }
}

// =========== //
// Outputs     //
// =========== //

@sys.description('The resource ID of the application.')
output resourceId string = application.id

@sys.description('The name of the resource group the scaling plan was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the scaling plan.')
output name string = application.name
