targetScope = 'subscription'

param maintenanceConfigResourceGroupName string
param maintenanceConfigName string
param maintenanceConfigAssignmentName string
param filter object
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

output maintenanceConfigAssignmentId string = maintenanceConfigAssignment.id
output maintenanceConfigAssignmentName string = maintenanceConfigAssignment.name
