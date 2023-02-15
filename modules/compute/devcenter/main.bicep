param location string
param repos array = []
param choco array = []
param tasks array = []

module devdeploy 'modules/common.bicep' = {
  name: '${deployment().name}-DevDeploy'
  params: {
    location: location
    repos: repos
    choco: choco
    tasks: tasks
  }
}
