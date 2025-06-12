using './main.bicep'

param environmentName = readEnvironmentVariable('AZURE_ENV_NAME', 'cps')
param contentUnderstandingLocation = readEnvironmentVariable('AZURE_ENV_CU_LOCATION', 'WestUS')
param deploymentType = readEnvironmentVariable('AZURE_ENV_MODEL_DEPLOYMENT_TYPE', 'GlobalStandard')
param gptModelName = readEnvironmentVariable('AZURE_ENV_MODEL_NAME', 'gpt-4o')
param gptDeploymentCapacity = int(readEnvironmentVariable('AZURE_ENV_MODEL_CAPACITY', '30'))
param useLocalBuild = bool(readEnvironmentVariable('USE_LOCAL_BUILD', 'false'))
