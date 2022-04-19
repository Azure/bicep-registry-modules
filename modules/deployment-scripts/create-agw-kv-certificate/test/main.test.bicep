param location string = resourceGroup().location
param akvName string =  'akvtest${uniqueString(resourceGroup().id)}'
param agwName string = 'agw-${uniqueString(resourceGroup().id)}'

@description('A short retention is good for test envs')
var shortRetention = 'PT1H'

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    location: location
    agwName: agwName
    akvName: akvName
  }
}

//Test 1. Just a single certificate, no AppGw
module akvCertSingle '../main.bicep' = {
  name: 'akvCertSingle'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    certNames: array('myapp')
    retention: shortRetention
  }
}

//Test 2. Array of certificates, no AppGw
module akvCertMultiple '../main.bicep' = {
  name: 'akvCertMultiple'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    certNames: [
      'myapp'
      'myotherapp'
    ]
    retention: shortRetention
  }
}

/*
AppGw tests
*/

//Test 3. AppGw Single FrontEnd Cert
module AgwSingleAkvCert '../main.bicep' = {
  name: 'AgwSingleAkvFeCert'
  params: {
    location: location
    akvName: prereq.outputs.akvName
    agwName: prereq.outputs.agwName
    agwIdName: prereq.outputs.agwIdName
    certNames: array('appGwSingleSSL')
    agwCertType: 'ssl-cert'
    //managedIdentityName: 'id-justtesting1'
    initialScriptDelay: '60s'
    retention: shortRetention
  }
}

//Test 4. AppGw Multi FrontEnd Cert
module AgwMultiAkvFeCert '../main.bicep' = {
  name: 'AgwMultiAkvFeCert'
  params: {
    location: location
    akvName: prereq.outputs.akvName
    agwName: prereq.outputs.agwName
    agwIdName: prereq.outputs.agwIdName
    certNames: [
      'AgwMultiAkvFeCert1'
      'AgwMultiAkvFeCert2'
    ]
    agwCertType: 'ssl-cert'
    initialScriptDelay: '60s'
    retention: shortRetention
  }
}

//Test 5. AppGw Single Backend Cert
module AgwSingleAkvBeCert '../main.bicep' = {
  name: 'AgwSingleAkvBeCert'
  params: {
    location: location
    akvName: prereq.outputs.akvName
    agwName: prereq.outputs.agwName
    agwIdName: prereq.outputs.agwIdName
    certNames: array('appGwSingleRoot')
    agwCertType: 'root-cert'
    //managedIdentityName: 'id-justtesting1'
    initialScriptDelay: '60s'
    retention: shortRetention
  }
}
