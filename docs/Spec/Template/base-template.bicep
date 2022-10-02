// Required Parameters
@description('Deployment Location')
param location string
  
@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Deployment Name')
param name string = uniqueString(resourceGroup().id, subscription().id)

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'

// Optional Parameters
// @description('Enable Zonal Redunancy for supported regions (skipped for unsupported regions)')
// param isZoneRedundant bool = true

module nestedModlue 'nested-template.bicep' = if( newOrExisting != 'none' ) {
  name: 'nestedModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    resourceGroupName: resourceGroupName
    name: name
    newOrExisting: newOrExisting == 'new' ? 'new' : 'existing'
    // isZoneRedundant: isZoneRedundant
  }
}

// Required Outputs
@description('Deployed Location')
output location string = location

@description('Deployed Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Deployed Name')
output name string = name

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting

// Outputs required for optional parameters when used
// @description('Zone Redundancy')
// output isZoneRedundant string = isZoneRedundant

@description('Deployment Configuration')
output configuration object = nestedModlue.outputs.configuration
