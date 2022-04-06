/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param acrName string =  'crtest${uniqueString(newGuid())}'

param imageName string = 'ghcr.io/kedacore/keda-metrics-apiserver:main'

var ContributorRoleDefinitionId='b24988ac-6180-42a0-ab88-20f7382dd24c'

module acrImport '../main.bicep' = {
  name: 'testAcrImport'
  params: {
    rbacRolesNeeded: array(ContributorRoleDefinitionId)
    acrName: acr.name
    location: location
    images: array(imageName)
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
}
