metadata name = 'Network Watchers Connection Monitors'
metadata description = 'This module deploys a Network Watcher Connection Monitor.'

@description('Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG.')
param networkWatcherName string = 'NetworkWatcher_${resourceGroup().location}'

@description('Required. Name of the resource.')
param name string

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.tags?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of connection monitor endpoints.')
param endpoints resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.endpoints = []

@description('Optional. List of connection monitor test configurations.')
param testConfigurations resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.testConfigurations = []

@description('Optional. List of connection monitor test groups.')
param testGroups resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.testGroups = []

@description('Optional. Specify the Log Analytics Workspace Resource ID.')
param workspaceResourceId string?

@description('Optional. Determines if the connection monitor will start automatically once created.')
param autoStart bool?

@description('Optional. Describes the destination of connection monitor.')
param destination resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.destination?

@description('Optional. Monitoring interval in seconds.')
@minValue(30)
@maxValue(1800)
param monitoringIntervalInSeconds int?

@description('Optional. Notes to be associated with the connection monitor.')
param notes string?

@description('Optional. Describes the source of connection monitor.')
param source resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.source?

resource networkWatcher 'Microsoft.Network/networkWatchers@2024-10-01' existing = {
  name: networkWatcherName
}

resource connectionMonitor 'Microsoft.Network/networkWatchers/connectionMonitors@2024-10-01' = {
  name: name
  parent: networkWatcher
  tags: tags
  location: location
  properties: {
    endpoints: endpoints
    testConfigurations: testConfigurations
    testGroups: testGroups
    autoStart: autoStart
    destination: destination
    monitoringIntervalInSeconds: monitoringIntervalInSeconds
    notes: notes
    source: source
    outputs: !empty(workspaceResourceId)
      ? [
          {
            type: 'Workspace'
            workspaceSettings: {
              workspaceResourceId: workspaceResourceId
            }
          }
        ]
      : null
  }
}

@description('The name of the deployed connection monitor.')
output name string = connectionMonitor.name

@description('The resource ID of the deployed connection monitor.')
output resourceId string = connectionMonitor.id

@description('The resource group the connection monitor was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = connectionMonitor.location
