targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string = 'test'

@description('The location where the resources will be created.')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

// ------------------
// VARIABLES
// ------------------
var rgHubName = 'hub-${workloadName}-${environment}'
// ------------------
// RESOURCES
// ------------------
@description('The hub resource group. This would normally be already provisioned by your platform team.')
resource hubResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: rgHubName
  location: location
  tags: tags
}

module deps 'depoly.hub.deps.bicep' = {
  name: 'hub-deps'
  scope: hubResourceGroup
  params: {
    location: location
    tags: tags
    workloadName: workloadName
  }
}

// ------------------
// OUTPUTS
// ------------------
@description('The resource ID of hub virtual network.')
output hubVNetId string = deps.outputs.hubVNetId

@description('The private IP address of the Azure Firewall.')
output networkApplianceIpAddress string = deps.outputs.networkApplianceIpAddress
