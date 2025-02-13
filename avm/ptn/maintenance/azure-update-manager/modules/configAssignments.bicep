targetScope = 'subscription'
@description('Required. The name of the resource group containing the maintenance configuration.')
param maintenanceConfigResourceGroupName string

@description('Required. The name of the maintenance configuration.')
param maintenanceConfigName string

@description('Required. The name of the maintenance configuration assignment.')
param maintenanceConfigAssignmentName string

@description('Required. The filter object which contains details of the filter to be applied.')
param filter object

@description('Required. The id of the subscription where assignment is to be created.')
param subscriptionId string = subscription().id

resource maintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' existing = {
  scope: resourceGroup(maintenanceConfigResourceGroupName)
  name: maintenanceConfigName
}

resource maintenanceConfigAssignment 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = {
  name: maintenanceConfigAssignmentName
  properties: {
    filter: filter
    maintenanceConfigurationId: maintenanceConfig.id
    resourceId: subscriptionId
  }
}

@description('The name of the maintenance configuration assignment.')
output name string = maintenanceConfigAssignment.name
@description('The id of the maintenance configuration assignment.')
output maintenanceConfigAssignmentId string = maintenanceConfigAssignment.id
