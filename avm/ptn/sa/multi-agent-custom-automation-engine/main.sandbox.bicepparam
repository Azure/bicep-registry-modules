using './main.bicep'

param solutionPrefix = 'macaesbx102'
param solutionLocation = 'australiaeast'
param azureOpenAILocation = 'australiaeast'
param backendContainerRegistryHostname = 'camanregistry.azurecr.io'
param backendContainerImageName = 'fdp-ma-cae'
param backendContainerImageTag = 'cd'
