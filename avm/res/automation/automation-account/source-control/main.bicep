metadata name = 'Automation Account Source Controls'
metadata description = 'This module deploys an Azure Automation Account Source Control.'

@sys.description('Required. A friendly name for the source control. This name must contain only letters and numbers.')
param name string

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. Type of source control mechanism.')
param sourceType ('GitHub' | 'VsoGit' | 'VsoTfvc')

@sys.description('Optional. Setting that turns on or off automatic synchronization when a commit is made in the source control repository or GitHub repo. Defaults to `false`.')
param autoSync bool = false

@sys.description('Required. The repo url of the source control.')
@maxLength(2000)
param repoUrl string

@sys.description('Required. The repo branch of the source control. Include branch as empty string for VsoTfvc.')
@maxLength(255)
param branch string

@sys.description('Required. The folder path of the source control. Path must be relative.')
@maxLength(255)
param folderPath string

@sys.description('Optional. The auto publish of the source control. Defaults to `true`.')
param publishRunbook bool = true

@sys.description('Required. The user description of the source control.')
@maxLength(512)
param description string

@sys.description('Optional. The authorization token for the repo of the source control.')
param securityToken resourceInput<'Microsoft.Automation/automationAccounts/sourceControls@2024-10-23'>.properties.securityToken?

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource sourceControl 'Microsoft.Automation/automationAccounts/sourceControls@2024-10-23' = {
  name: name
  parent: automationAccount
  properties: {
    sourceType: sourceType
    autoSync: autoSync
    repoUrl: repoUrl
    branch: branch
    folderPath: folderPath
    publishRunbook: publishRunbook
    description: description
    securityToken: securityToken
  }
}

@sys.description('The name of the deployed source control.')
output name string = sourceControl.name

@sys.description('The resource ID of the deployed source control.')
output resourceId string = sourceControl.id

@sys.description('The resource group of the deployed source control.')
output resourceGroupName string = resourceGroup().name
