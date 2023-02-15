param location string
param repos array = []
param choco array = []
param tasks array = []

param nameseed string = 'dbox'
param devcenterName string
param environmentName string = 'sandbox'
param projectTeamName string = 'developers'
param catalogName string = 'dcc'
param catalogRepoUri string = 'https://github.com/Gordonby/dev-center-catalog.git'

module devdeploy 'modules/ade.bicep' = {
  name: '${deployment().name}-DevCenter'
  params: {
    location: location
//    repos: repos
//    choco: choco
//    tasks: tasks
    nameseed: nameseed
    devcenterName: devcenterName
    environmentName: environmentName
    projectTeamName: projectTeamName
    catalogName: catalogName
    catalogRepoUri: catalogRepoUri
  }
}
