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
  location: resourceGroup().location
}

module prereq './prereq.test.bicep' = {
  name: 'test'
  params: {
    ipPrefixes: [
      {
        name: 'ipprefixestest1'
        skuName: 'Standard'
        tier: 'Regional'
        location: location
      }
    ]
    resourceGroupId: resourceGroup().id
  }
}

module test0 '../main.bicep' = {
  name: 'test0-${name}'
  params: {
    location: location
    name: 'test0'
    domainNameLabel: 'sample0'
  }
}

module test1 '../main.bicep' = {
  name: 'test1-${name}'
  params: {
    domainNameLabel: 'sample1'
    location: location
    name: 'test1'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    skuName: 'Standard'
    skuTier: 'Regional'
  }
}

module test2 '../main.bicep' = {
  name: 'test2-${name}'
  dependsOn: [
    prereq
  ]
  params: {
    domainNameLabel: 'sample2'
    location: location
    name: 'test2'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    skuName: 'Standard'
    skuTier: 'Regional'
    tags: tags
    publicIPPrefixId: prereq.outputs.ipPrefixes[0].id
  }
}
