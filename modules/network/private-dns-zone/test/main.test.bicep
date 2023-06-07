/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'
param name string = replace(take(deployment().name, 55), '.', '')
param location string = resourceGroup().location

param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
}

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs-${uniqueString(name)}'
  params: {
    location: location
    name: name
  }
}

module test0 '../main.bicep' = {
  name:  'test0-${uniqueString(name)}'
  params: {
    name: 'testweb.nuannet'
    tags: tags
    location: 'global'
    virtualNetworkLinks: [
      {
        name: 'link${replace(name, '-', '')}'
        virtualNetworkId: prereq.outputs.vnetId
        location: 'global'
        registrationEnabled: true
        tags: tags
      }
    ]
    aRecords: [
      {
        name: 'arecord1' //(The name of the DNS record to be created.  The name is relative to the zone, not the FQDN.)
        TTL: 3600 //(The TTL (time-to-live) of the records in the record set. type is 'int')
        ipv4Addresses: [
          //(The list of A records in the ipv4Addresses.)
          '1.0.0.6'
        ]
      }
      {
        name: 'arecord2'
        TTL: 3600
        ipv4Addresses: [
          '1.0.0.1'
          '1.0.0.2'
        ]
      }
    ]
    cnameRecords: [
      {
        name: 'cname1'
        TTL: 3600
        cname: 'nuaninc.test1.com'
      }
      {
        name: 'cname2'
        TTL: 3600
        cname: 'nuaninc.test2.com'
      }
      {
        name: 'cname3'
        TTL: 3600
        cname: 'nuaninc.test3.com'
      }
    ]
  }
}
