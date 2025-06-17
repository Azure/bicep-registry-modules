using './main.bicep'

param solutionPrefix = 'macaewaf104'
param solutionLocation = 'australiaeast'
param azureOpenAILocation = 'australiaeast'
param enableMonitoring = true
param enablePrivateNetworking = true
param enableScalability = true
param enableRedundancy = true
param enableTelemetry = true
param virtualMachineAdminPassword = 'P@ssw0rd1234!P@ssw0rd1234!'
param virtualMachineAdminUsername = 'adminuser'
param backendContainerImageTag = 'hotfix_2025-06-17_704'
param frontendContainerImageTag = 'hotfix_2025-06-17_704'
