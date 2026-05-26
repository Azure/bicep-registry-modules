metadata name = 'Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Maintenance window for the maintenance configuration.')
param maintenanceWindow resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-10-01'>.properties.maintenanceWindow

@description('Optional. Time slots on which upgrade is not allowed.')
param notAllowedTime resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-10-01'>.properties.notAllowedTime?

@description('Optional. Time slots during the week when planned maintenance is allowed to proceed.')
param timeInWeek resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-10-01'>.properties.timeInWeek?

@description('Conditional. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param managedClusterName string

@description('Optional. Name of the maintenance configuration.')
param name string = 'aksManagedAutoUpgradeSchedule'

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.consvc-mgdcluster-maintenancecfg.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-10-01' existing = {
  name: managedClusterName
}

resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-10-01' = {
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
