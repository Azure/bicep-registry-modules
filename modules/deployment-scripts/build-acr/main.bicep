@description('The name of the Azure Container Registry')
param AcrName string

@description('The location of the ACR and where to deploy the module resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('Azure RoleId that are required for the DeploymentScript resource to import images')
param rbacRoleNeeded string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor is needed to build ACR tasks

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-ContainerRegistryBuild'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '30s'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

@description('The Git Repository URL, eg. https://github.com/YOURORG/YOURREPO.git')
param gitRepositoryUrl string

@description('The name of the repository branch to use')
param gitBranch string = 'main'

@description('The docker context working directory, change this when your Dockerfile and source files are ALL located in a repo subdirectory')
param buildWorkingDirectory string = '.'

@description('The subdirectory relative to the working directory that contains the Dockerfile')
param dockerfileDirectory string = ''

@description('The name of the dockerfile')
param dockerfileName string = 'Dockerfile'

@description('The image name/path you want to create in ACR')
param imageName string

@description('The image tag you want to create')
param imageTag string = string(dateTimeToEpoch(utcNow()))

@description('The ACR compute platform needed to build the image')
param acrBuildPlatform string = 'linux'

var repo = '${gitRepositoryUrl}#${gitBranch}:${buildWorkingDirectory}'
var cleanRepoName = last(split(gitRepositoryUrl, '/'))
var cleanImageName = replace(imageName,'/','')
var taggedImageName = '${imageName}:${imageTag}'
var dockerfilePath = !empty(dockerfileDirectory) ? '${dockerfileDirectory}/${dockerfileName}' : dockerfileName

resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' existing = {
  name: AcrName
}

resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(rbacRoleNeeded)) {
  name: guid(acr.id, rbacRoleNeeded, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: acr
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRoleNeeded)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource createImportImage 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'ACR-Build-${cleanImageName}-${cleanRepoName}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbac
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: '2.30.0'
    timeout: 'PT45M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'acrName'
        value: acr.name
      }
      {
        name: 'acrResourceGroup'
        value: resourceGroup().name
      }
      {
        name: 'taggedImageName'
        value: taggedImageName
      }
      {
        name: 'repo'
        value: repo
      }
      {
        name: 'dockerfilePath'
        value: dockerfilePath
      }
      {
        name: 'platform'
        value: acrBuildPlatform
      }
      {
        name: 'initialDelay'
        value: initialScriptDelay
      }
    ]
    scriptContent: loadTextContent('azAcrBuild.sh')
    cleanupPreference: cleanupPreference
  }
}

@description('The ACR uri the image can be accessed on if building was successful')
output acrImage string = '${acr.properties.loginServer}/${taggedImageName}'
