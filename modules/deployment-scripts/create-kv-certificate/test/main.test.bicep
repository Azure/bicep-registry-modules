param location string = resourceGroup().location
param akvName string =  'akvtest${uniqueString(resourceGroup().id)}'

@description('A short retention is good for test envs')
var shortRetention = 'PT1H'

//Prerequisites
resource akv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: akvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: false
    enableRbacAuthorization: true
    accessPolicies: []
  }
}
output akvName string = akv.name

//Test 1. Just a single certificate
module akvCertSingle '../main.bicep' = {
  name: 'akvCertSingle'
  params: {
    akvName: akv.name
    location: location
    certNames: array('myapp')
    retention: shortRetention
  }
}

//Test 2. Array of certificates
module akvCertMultiple '../main.bicep' = {
  name: 'akvCertMultiple'
  params: {
    akvName:  akv.name
    location: location
    certNames: [
      'myapp'
      'myotherapp'
    ]
    retention: shortRetention
  }
}
