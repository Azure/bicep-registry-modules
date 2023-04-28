/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'

param name string = deployment().name
param location string = 'eastus'

param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
}

module test0 '../main.bicep' = {
  name: '${name}-test0'
  params: {
    name: 't1${replace(name, '-', '')}'
    location: location
    tags: tags
    prefixLength: 30
  }
}

module test1 '../main.bicep' = {
  name: '${name}-test1'
  params: {
    name: 't2${replace(name, '-', '')}'
    location: location
    tags: tags
    prefixLength: 30
    publicIPAddressVersion: 'IPv4'
    tier: 'Regional'
    availabilityZones: [
      1
      2
      3
    ]
  }
}
