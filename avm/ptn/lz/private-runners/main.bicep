param location string = resourceGroup().location

var imagePaths = [
  {
    platform: 'azuredevops-container-app'
    imagePath: 'container-images/azure-devops-agent-aca'
  }
  {
    platform: 'github-container-app'
    imagePath: 'container-images/github-runner-aca'
  }
  {
    platform: 'azuredevops-container-instance'
    imagePath: 'container-images/azure-devops-agent-aci'
  }
  {
    platform: 'github-container-instance'
    imagePath: 'container-images/github-runner-aci'
  }
]

/*
resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'managedEnv01'
  location: location
  properties: {
    workloadProfiles: [
      {
        workloadProfileType: 'D4'
        name: 'WorkloadProfile'
        minimumCount: 1
        maximumCount: 3
      }
    ]
  }
}

module aca 'br/public:avm/res/app/job:0.4.0' = {
  name: 'acaJOb'
  params: {
    name:
    containers:
    environmentResourceId:
    triggerType:
  }
}


  */

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: 'acrsdas'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource buildImages 'Microsoft.ContainerRegistry/registries/tasks@2019-06-01-preview' = [
  for (dockerFile, i) in imagePaths: {
    name: 'buildImages-${i}'
    identity: {
      type: 'SystemAssigned'
    }
    parent: acr
    location: location
    properties: {
      platform: {
        os: 'Linux'
      }
      step: {
        dockerFilePath: dockerFile.imagePath
        type: 'Docker'
        imageNames: [
          imagePaths[i].platform
        ]
      }
    }
  }
]
