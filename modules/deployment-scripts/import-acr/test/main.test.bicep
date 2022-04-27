param location string = resourceGroup().location
param acrName string =  'crtest${uniqueString(newGuid())}'

var ContributorRoleDefinitionId='b24988ac-6180-42a0-ab88-20f7382dd24c'

//Prerequisites
resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
}

//Test 1. Simple, 1 Image
var imageName = 'ghcr.io/kedacore/keda-metrics-apiserver:main'
module acrImportSingle '../main.bicep' = {
  name: 'testAcrImportSingle'
  params: {
    rbacRoleNeeded: ContributorRoleDefinitionId
    acrName: acr.name
    location: location
    images: array(imageName)
  }
}

//Test 2. Simple, multi Image
var imageNames = [
  'docker.io/bitnami/external-dns:latest'
  'quay.io/jetstack/cert-manager-cainjector:v1.7.2'
  'docker.io/bitnami/redis:latest'
]
module acrImportMulti '../main.bicep' = {
  name: 'testAcrImportMulti'
  params: {
    acrName: acr.name
    location: location
    images: imageNames
  }
}

//Test 3. Existing Managed Identity
param newManagedIdName string = 'id-${uniqueString(resourceGroup().id)}'
resource depScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: newManagedIdName
  location: location
}
module acrImportEID '../main.bicep' = {
  name: 'testAcrImportEID'
  params: {
    useExistingManagedIdentity: true
    managedIdentityName: depScriptId.name
    existingManagedIdentityResourceGroupName: resourceGroup().name
    existingManagedIdentitySubId: subscription().subscriptionId
    acrName: acr.name
    location: location
    images: array('ghcr.io/kedacore/keda:main')
  }
}

//Test 4. Different Azure CLI Version
module acrImportAZV '../main.bicep' = {
  name: 'testAcrImportAZV'
  params: {
    acrName: acr.name
    location: location
    images: array('mcr.microsoft.com/azuredocs/azure-vote-front:v1')
  }
}

//Test 5. Custom Script Delay
module acrImportCustomDelay '../main.bicep' = {
  name: 'testAcrImportDelay'
  params: {
    initialScriptDelay: '60s'
    acrName: acr.name
    location: location
    images: array('mcr.microsoft.com/mcr/hello-world:Canary-IngestionTest')
  }
}
