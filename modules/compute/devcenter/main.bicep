param location string
param repos array = []
param choco array = []

@allowed(["en-us", "en-gb", "zh-cn", "es-es"])
param language string

module setSystemLanguage 'tasks/setSystemLanguage.bicep' = {
  name: '${deployment().name}-SetSystemLanguage'
  params: {
    language: language
  }
}

module devdeploy 'bicep/common.bicep' = {
  name: '${deployment().name}-DevDeploy'
  params: {
    location: location
    repos: repos
    choco: choco
    tasks: [
      setSystemLanguage.outputs.task
    ]
  }
}
