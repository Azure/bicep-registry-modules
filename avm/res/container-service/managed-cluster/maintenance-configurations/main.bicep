metadata name = 'Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Maintenance window for the maintenance configuration.')
param maintenanceWindow object

@description('Conditional. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param managedClusterName string

@description('Optional. Name of the maintenance configuration.')
param name string = 'aksManagedAutoUpgradeSchedule'

resource managedCluster 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' existing = {
  name: managedClusterName
}

resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2023-10-01' = {
  name: name
  parent: managedCluster
  properties: {
    maintenanceWindow: maintenanceWindow
  }
}

@description('The name of the maintenance configuration.')
output name string = aksManagedAutoUpgradeSchedule.name

@description('The resource ID of the maintenance configuration.')
output resourceId string = aksManagedAutoUpgradeSchedule.id

@description('The resource group the agent pool was deployed into.')
output resourceGroupName string = resourceGroup().name
