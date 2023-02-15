param nameseed string = 'dbox'
param location string = resourceGroup().location
param devcenterName string
param environmentName string = 'sandbox'
param projectTeamName string = 'developers'
param catalogName string = 'dcc'
param catalogRepoUri string = 'https://github.com/Gordonby/dev-center-catalog.git'

@secure()
@description('A PAT token is required, even for public repos')
param catalogRepoPat string

resource dc 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource project 'Microsoft.DevCenter/projects@2022-11-11-preview' existing = {
  name: projectTeamName
}

@description('A keyvault is required to store your pat token for the Catalog')
module kv 'keyvault.bicep' = {
  name: '${deployment().name}-keyvault'
  params: {
    resourceName: nameseed
    location: location
  }
}

@description('Keyvault secrect holds pat token')
module kvSecret 'keyvaultsecret.bicep' = if(!empty(catalogRepoPat)) {
  name: '${deployment().name}-keyvault-patSecret'
  params: {
    keyVaultName: kv.outputs.keyVaultName
    secretName: catalogName
    secretValue: catalogRepoPat
  }
}

module rbac 'devboxrbac.bicep' = {
  name: '${deployment().name}-managedId-rbac'
  params: {
    keyVaultName: kv.outputs.keyVaultName
    principalId: dc.identity.principalId
  }
}

resource env 'Microsoft.DevCenter/devcenters/environmentTypes@2022-11-11-preview' = {
  name: environmentName
  parent: dc
}

resource catalog 'Microsoft.DevCenter/devcenters/catalogs@2022-11-11-preview' = {
  name: catalogName
  parent: dc
  properties: {
    gitHub: {
      uri: catalogRepoUri
      branch: 'main'
      secretIdentifier: !empty(catalogRepoPat) ? kvSecret.outputs.secretUri : null
      path: '/Environments'
    }
  }
}

param environmentTypes array = ['Dev', 'Test', 'Staging']
resource envs 'Microsoft.DevCenter/devcenters/environmentTypes@2022-11-11-preview' = [for envType in environmentTypes :{
  name: envType
  parent: dc
}] 

//param deploymentTargetId string = '${subscription().id}/devcenter-deploy-bucket'
param deploymentTargetId string = subscription().id

var rbacRoleId = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}
output dti string = deploymentTargetId

resource projectAssign 'Microsoft.DevCenter/projects/environmentTypes@2022-11-11-preview' =  [for envType in environmentTypes : {
  name: envType
  parent: project
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    creatorRoleAssignment: {
      roles : {
        '${rbacRoleId.contributor}': {}
      }
    }
    status: 'Enabled'
    deploymentTargetId: deploymentTargetId
  }
}]
