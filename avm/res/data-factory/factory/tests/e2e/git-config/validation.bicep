metadata name = 'Data Factory Git repository configuration validation'
metadata description = 'Reads back the Git repository configuration of an already deployed Data Factory and fails the deployment if it was not persisted as requested.'

@description('Required. The name of the Data Factory to validate.')
param dataFactoryName string

@description('Required. The expected repository configuration type.')
@allowed([
  'FactoryVSTSConfiguration'
  'FactoryGitHubConfiguration'
])
param expectedRepoType string

@description('Required. The expected account name.')
param expectedAccountName string

@description('Optional. The expected project name. Only relevant for \'FactoryVSTSConfiguration\'.')
param expectedProjectName string = ''

@description('Required. The expected repository name.')
param expectedRepositoryName string

@description('Required. The expected collaboration branch.')
param expectedCollaborationBranch string

@description('Required. The expected root folder.')
param expectedRootFolder string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

var actualRepoConfiguration = dataFactory.properties.?repoConfiguration ?? {}

var isPersisted = !empty(actualRepoConfiguration)
  ? (actualRepoConfiguration.?type == expectedRepoType && actualRepoConfiguration.?accountName == expectedAccountName && actualRepoConfiguration.?repositoryName == expectedRepositoryName && actualRepoConfiguration.?collaborationBranch == expectedCollaborationBranch && actualRepoConfiguration.?rootFolder == expectedRootFolder && (expectedRepoType != 'FactoryVSTSConfiguration' || actualRepoConfiguration.?projectName == expectedProjectName))
  : fail('The Data Factory \'${dataFactoryName}\' has no Git repository configuration persisted, even though one was requested by the deployment.')

@description('The Git repository configuration that is persisted on the Data Factory.')
output persistedRepoConfiguration object = isPersisted
  ? actualRepoConfiguration
  : fail('The Git repository configuration persisted on the Data Factory \'${dataFactoryName}\' does not match the requested configuration.')
