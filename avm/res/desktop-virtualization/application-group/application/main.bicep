metadata name = 'Azure Virtual Desktop Application Group Application'
metadata description = 'This module deploys an Azure Virtual Desktop Application Group Application.'
metadata owner = 'Azure/module-maintainers'

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

resource appGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' existing = {
  name: applicationGroupName
}

resource application 'Microsoft.DesktopVirtualization/applicationGroups/applications@2023-09-05' = {
  name: name
  parent: appGroup
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

@sys.description('The resource ID of the application.')
output resourceId string = application.id

@sys.description('The name of the resource group the application was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the application.')
output name string = application.name
