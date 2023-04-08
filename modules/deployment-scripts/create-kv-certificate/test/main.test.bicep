targetScope = 'resourceGroup'

param location string = resourceGroup().location
param akvName string = 'akvtest${uniqueString(resourceGroup().id, deployment().name)}'

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
    enableSoftDelete: false //! contains(resourceGroup().tags,'kvSoftDelete')
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
    certificateNames: [ 'mysingleapp' ]
    certificateCommonNames: [ 'mysingleapp.mydomain.local' ]
    validity: 11
    disabled: true
  }
}
output singleSecretId string = akvCertSingle.outputs.certificateSecretIds[0][0]
output singleThumbprint string = akvCertSingle.outputs.certificateThumbprintHexs[0][0]

//Test 2. Array of certificates
var certificateNames = [
  'myapp'
  'myotherapp'
]

module akvCertMultiple '../main.bicep' = {
  name: 'akvCertMultiple-${uniqueString(akv.name)}'
  params: {
    akvName: akv.name
    location: location
    certificateNames: certificateNames
    initialScriptDelay: '0'
    managedIdentityName: 'aDifferentIdentity'
    validity: 24
  }
}

// Test 3. Test a signed cert
// module akvCertSigned '../main.bicep' = {
//   name: 'akvCertSigned'
//   params: {
//     akvName: akv.name
//     location: location
//     certificateName: 'mysignedcert'
//     certificateCommonName: 'sample-cert.gaming.azure.com'
//     issuerName: 'Signed'
//     issuerProvider: 'OneCertV2-PublicCA'
//   }
// }

@description('Array of info from each Certificate')
output createdCertificates array = [for (certificateName, i) in certificateNames: {
  certificateName: certificateName
  certificateSecretId: akvCertMultiple.outputs.certificateSecretIds[i]
  certificateThumbprint: akvCertMultiple.outputs.certificateThumbprintHexs[i]
}]
