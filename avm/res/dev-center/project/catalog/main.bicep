metadata name = 'Dev Center Project Catalog'
metadata description = 'This module deploys a Dev Center Project Catalog.'

// ================ //
// Parameters       //
// ================ //

@description('Required. The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.')
@minLength(3)
@maxLength(63)
param name string

@description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@description('Optional. GitHub repository configuration for the catalog.')
param gitHub sourceType?

@description('Optional. Azure DevOps Git repository configuration for the catalog.')
param adoGit sourceType?

@description('Optional. Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".')
@allowed([
  'Manual'
  'Scheduled'
])
param syncType string = 'Scheduled'

@description('Optional. Resource tags to apply to the catalog.')
param tags resourceInput<'Microsoft.DevCenter/projects/catalogs@2025-02-01'>.tags?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

// ============== //
// Resources      //
// ============== //

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName
}

resource catalog 'Microsoft.DevCenter/projects/catalogs@2025-02-01' = {
  parent: project
  name: name
  properties: {
    syncType: syncType
    tags: tags
    gitHub: gitHub
    adoGit: adoGit
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the catalog.')
output resourceId string = catalog.id

@description('The name of the catalog.')
output name string = catalog.name

@description('The name of the resource group the catalog was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

// ================ //
// Definitions      //
// ================ //

@description('The type for Git catalog configuration (common properties for both GitHub and Azure DevOps Git).')
@export()
type sourceType = {
  @description('Required. The Git repository URI.')
  uri: string

  @description('Optional. The Git branch to use. Defaults to "main".')
  branch: string?

  @description('Optional. The folder path within the repository. Defaults to "/".')
  path: string?

  @description('Optional. A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.')
  secretIdentifier: string?
}
