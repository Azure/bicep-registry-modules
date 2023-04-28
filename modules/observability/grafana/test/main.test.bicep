/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

param prefix string = 'grafana'
@maxLength(60)
param name string = take('${prefix}-${uniqueString(resourceGroup().id, subscription().id)}', 60)
param location string = 'eastus'

// prereq
module prereq 'prereq.test.bicep' = {
  name: 'prereq0-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'grafana'
    location: location
    prefix: 'prereq-${name}'
  }
}

// Test 0
module test0 '../main.bicep' = {
  name: 'test0-${uniqueString(resourceGroup().id)}'
  params: {
    name: take('test0-${name}', 23)
    tags: {
      env: 'test'
    }
    location: location
  }
}

// Test 1
module test1 '../main.bicep' = {
  name: 'test1-${uniqueString(resourceGroup().id)}'
  params: {
    name: take('test1-${name}', 23)
    location: location
    tags: {
      env: 'test'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Grafana Admin'
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
      }
    ]
    azureMonitorWorkspaceResourceId: prereq.outputs.monitorId
    zoneRedundancy: 'Enabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prereq.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: prereq.outputs.subnetIds[1]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
    ]
    enableDiagnostics: true
    diagnosticWorkspaceId: prereq.outputs.workspaceId
  }
}
