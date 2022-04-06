/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param akvName string =  'akvtest${uniqueString(newGuid())}'

param certificateName string = 'myapplication'

var SecretsOfficerRoleDefinitionId='b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

module akvCertGen '../main.bicep' = {
  name: 'testAkvCertGen'
  params: {
    rbacRolesNeeded: array(SecretsOfficerRoleDefinitionId)
    akvName: akv.name
    certificateNames: array(certificateName)
    location: location
  }
}

resource akv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: akvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
}
