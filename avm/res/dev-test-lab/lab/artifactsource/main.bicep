metadata name = 'DevTest Lab Artifact Sources'
metadata description = '''This module deploys a DevTest Lab Artifact Source.

An artifact source allows you to create custom artifacts for the VMs in the lab, or use Azure Resource Manager templates to create a custom test environment. You must add a private Git repository for the artifacts or Resource Manager templates that your team creates. The repository can be hosted on GitHub or on Azure DevOps Services.'''

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@sys.description('Required. The name of the artifact source.')
param name string

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Optional. The artifact source\'s display name. Default is the name of the artifact source.')
param displayName string = name

@sys.description('Optional. The artifact source\'s branch reference (e.g. main or master).')
param branchRef string?

@sys.description('Conditional. The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty.')
param folderPath string?

@sys.description('Conditional. The folder containing Azure Resource Manager templates. Required if "folderPath" is empty.')
param armTemplateFolderPath string?

@sys.description('Optional. The security token to authenticate to the artifact source.')
@secure()
param securityToken string?

@allowed([
  'GitHub'
  'StorageAccount'
  'VsoGit'
])
@sys.description('Optional. The artifact source\'s type.')
param sourceType string?

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled".')
param status string = 'Enabled'

@sys.description('Required. The artifact source\'s URI.')
param uri string

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource artifactsource 'Microsoft.DevTestLab/labs/artifactsources@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    displayName: displayName
    branchRef: branchRef
    folderPath: folderPath
    armTemplateFolderPath: armTemplateFolderPath
    securityToken: securityToken
    sourceType: sourceType
    status: status
    uri: uri
  }
}

@sys.description('The name of the artifact source.')
output name string = artifactsource.name

@sys.description('The resource ID of the artifact source.')
output resourceId string = artifactsource.id

@sys.description('The name of the resource group the artifact source was created in.')
output resourceGroupName string = resourceGroup().name
