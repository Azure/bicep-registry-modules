metadata name = 'Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.'

@description('Required. Maintenance window for the maintenance configuration.')
param maintenanceWindow resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.maintenanceWindow

@description('Optional. Time slots on which upgrade is not allowed.')
param notAllowedTime resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.notAllowedTime?

@description('Optional. Time slots during the week when planned maintenance is allowed to proceed.')
param timeInWeek resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.timeInWeek?

@description('Conditional. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param managedClusterName string

@description('Optional. Name of the maintenance configuration.')
param name string = 'aksManagedAutoUpgradeSchedule'

resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-09-01' existing = {
  name: managedClusterName
}

resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01' = {
  name: name
  parent: managedCluster
  properties: {
    maintenanceWindow: maintenanceWindow
    notAllowedTime: notAllowedTime
    timeInWeek: timeInWeek
  }
}

@description('The name of the maintenance configuration.')
output name string = aksManagedAutoUpgradeSchedule.name

@description('The resource ID of the maintenance configuration.')
output resourceId string = aksManagedAutoUpgradeSchedule.id

@description('The resource group the agent pool was deployed into.')
output resourceGroupName string = resourceGroup().name
