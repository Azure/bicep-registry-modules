/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'

param name string = deployment().name
param location string = resourceGroup().location
param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: location
}

module prereq 'prereq.test.bicep' = {
  name: '${name}-prereq'
}

module minimalTest '../main.bicep' = {
  name: '${name}-minimal'
  params: {
    name: 'myendpoint1.example.com'
  }
}

module simpleTest '../main.bicep' = {
  name: '${name}-simple'
  params: {
    name: 'myendpoint2.example.com'
    zoneType: 'Public'
    tags: tags
    aRecords: [
      {
        name: 'aRecord1'
        aliasRecordSet: true
        targetResource: prereq.outputs.trafficManagerId
      }
      {
        name: 'aRecord2'
        ttl: 3600
        aliasRecordSet: false
        aRecord: [
          {
            ipv4Address: '1.0.0.9'
          }
        ]
      }
      {
        name: '@'
        aliasRecordSet: true
        targetResource: prereq.outputs.trafficManagerId
      }
    ]
    cnameRecords: [
      {
        name: 'cNameRecord1'
        TTL: 3600
        cname: 'myendpoint2.example.com'
        aliasRecordSet: false
      }
    ]
    AAAARecords: [
      {
        name: 'AAAA1'
        TTL: 300
        aliasRecordSet: false
        aaaaRecord: [
          {
            ipv6Address: '2001:db8:3333:4444:5555:6666:7777:8888'
          }
        ]
      }
    ]
  }
}
